下面是一套用 QEMU 模拟 ARM 开发板、使用 NOR Flash 烧写 U-Boot，再由 U-Boot 加载 Linux 内核的完整流程。我们以 **ARM Versatile Express (Cortex-A9)** 平台为例，这个平台在 QEMU 中支持 NOR Flash（pflash），且 U-Boot 和 Linux 都有现成的支持。

---

## 1. 环境准备

### 安装依赖
```bash
sudo apt update
sudo apt install -y gcc-arm-linux-gnueabihf   # 交叉编译工具链
sudo apt install -y qemu-system-arm            # QEMU
sudo apt install -y build-essential flex bison libssl-dev bc
```
> 如果用 64 位 ARM（aarch64），可改用 `gcc-aarch64-linux-gnu`，相应板型选 vexpress-aemv8a，但这里先用 32 位举例。

---

## 2. 编译 U-Boot（支持 NOR Flash 启动）

```bash
git clone https://source.denx.de/u-boot/u-boot.git -b v2024.01 --depth 1
cd u-boot
export CROSS_COMPILE=arm-linux-gnueabihf-
make vexpress_ca9x4_defconfig
```

**关键配置调整**（非必须，但建议让 U-Boot 直接支持 QEMU 的 pflash）：
```bash
make menuconfig
# 进入 Boot options → Boot media → 勾选 "Support for booting from NOR flash"
# 一般默认已勾选
```
然后编译：
```bash
make -j$(nproc)
```
最终得到 `u-boot` 和 `u-boot.bin`。我们主要使用 `u-boot.bin`。

---

## 3. 制作 NOR Flash 镜像并烧写 U-Boot

QEMU 的 `-pflash` 要求镜像大小正好是 Flash 芯片大小。vexpress-a9 的 NOR Flash 大小是 **64 MB**（0x4000000 字节）。

```bash
# 创建一个 64MB 的全0文件
dd if=/dev/zero of=flash.img bs=1M count=64

# 将 u-boot.bin 写入镜像开头
dd if=u-boot.bin of=flash.img conv=notrunc
```

> 如果需要后续保存 U-Boot 环境变量，U-Boot 默认环境存储在 Flash 的某个扇区，`flash.img` 会保留这些修改。

---

## 4. 编译 Linux 内核

```bash
git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git -b v6.6 --depth 1
cd linux
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make vexpress_defconfig
```

可选：为了快速验证，我们可以使用 **initramfs** 作为根文件系统，省去制作 SD 卡镜像的麻烦。
```bash
# 打开配置，启用 initramfs 支持
make menuconfig
# General setup → 勾选 "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
# 然后在下面设置 Initramfs source file(s) 为一个目录路径（之后创建）
```
先编译内核：
```bash
make -j$(nproc)
```
得到 `arch/arm/boot/zImage` 和 `arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb`。

---

## 5. 制作一个极简 initramfs

创建一个简单的根文件系统目录，并在其中放一个 init 脚本：

```bash
mkdir -p rootfs/{bin,dev,proc,sys,etc}
# 静态编译 busybox
wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2
tar xf busybox-1.36.1.tar.bz2
cd busybox-1.36.1
make defconfig
make menuconfig
# Settings → Build static binary (no shared libs) 勾选
make -j$(nproc) CROSS_COMPILE=arm-linux-gnueabihf-
make install CONFIG_PREFIX=../rootfs CROSS_COMPILE=arm-linux-gnueabihf-
cd ..
```

在 `rootfs/init` 中写入：
```bash
#!/bin/sh
mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t devtmpfs dev /dev
exec /bin/sh
```
加上执行权限并打包成 cpio 归档：
```bash
chmod +x rootfs/init
cd rootfs
find . | cpio -o --format=newc > ../initramfs.cpio
cd ..
```

回到 Linux 内核目录，配置 initramfs 路径：
```bash
make ARCH=arm menuconfig
# General setup → Initramfs source file(s) 填写绝对路径: /your/path/initramfs.cpio
```
重新编译内核：
```bash
make -j$(nproc)
```
现在 `zImage` 内嵌了 initramfs，无需额外传入根文件系统。

---

## 6. 用 QEMU 启动（只从 NOR Flash 运行 U-Boot）

启动命令：
```bash
qemu-system-arm \
    -M vexpress-a9 \
    -m 1024M \
    -drive file=flash.img,if=pflash,format=raw \
    -kernel /path/to/linux/arch/arm/boot/zImage \
    -dtb /path/to/linux/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb \
    -nographic
```

**参数解释**：
- `-M vexpress-a9`：模拟的开发板。
- `-m 1024M`：内存大小。
- `-drive file=flash.img,if=pflash,format=raw`：将 `flash.img` 挂载为 NOR Flash，CPU 从 0x00000000（Flash 基址）启动，会直接运行 U-Boot。
- `-kernel` 和 `-dtb`：QEMU 会把这些文件加载到内存固定地址，并把内核地址、DTB 地址通过 r0、r1 寄存器或设备树传递给 U-Boot 吗？**注意：当使用 `-kernel` 时，QEMU 会直接把内核加载到内存并直接启动，而不会运行 Flash 中的 U-Boot。** 我们需要换一种方式让 U-Boot 来加载内核。

### **真正让 U-Boot 作为第一级引导的方式**：
**不能**同时使用 `-kernel`，否则 QEMU 会跳过 Flash 启动。我们需要将内核和 DTB 放到 U-Boot 能访问的介质上，比如另一个 pflash、SD 卡或者网络。这里用**第二个 NOR Flash**（或同一 Flash 的不同分区）来存放内核镜像。

#### 方案：将内核和 DTB 也放入 Flash 镜像
vexpress-a9 还有第二个 NOR Flash（`if=pflash` 可以指定两个，第二个对应 `-drive file=...,if=pflash,index=1`），但 U-Boot 可能没有默认支持。更简单的方法：**使用 SD 卡镜像**。

#### 使用 SD 卡存放内核和 DTB
创建 SD 卡镜像并格式化：
```bash
dd if=/dev/zero of=sd.img bs=1M count=128
mkfs.vfat sd.img
# 挂载并复制内核与 DTB
sudo mkdir /mnt/sd
sudo mount -o loop sd.img /mnt/sd
sudo cp linux/arch/arm/boot/zImage /mnt/sd/
sudo cp linux/arch/arm/boot/dts/arm/vexpress-v2p-ca9.dtb /mnt/sd/
sudo umount /mnt/sd
```

然后启动 QEMU：
```bash
qemu-system-arm \
    -M vexpress-a9 \
    -m 1024M \
    -drive file=flash.img,if=pflash,format=raw \
    -sd sd.img \
    -nographic
```

#### U-Boot 启动后手动加载内核
在 U-Boot 命令行中执行：
```
fatload mmc 0:0 0x60008000 zImage
fatload mmc 0:0 0x61000000 vexpress-v2p-ca9.dtb
setenv bootargs console=ttyAMA0,115200
bootz 0x60008000 - 0x61000000
```
系统就会启动到 initramfs 里的 shell。

---

## 7. 自动化：让 U-Boot 自动启动内核

可以在 U-Boot 源码里修改默认环境变量，或者在制作 `flash.img` 后，通过 QEMU 运行一次 U-Boot 并执行 `saveenv` 将环境保存到 Flash 中。但更简单的是在 U-Boot 编译前修改 `include/configs/vexpress_common.h`（或对应的头文件）中的 `CONFIG_BOOTCOMMAND`。

例如，在 U-Boot 配置文件中可以设置默认 bootcmd：
```
#define CONFIG_BOOTCOMMAND "fatload mmc 0:0 0x60008000 zImage; fatload mmc 0:0 0x61000000 vexpress-v2p-ca9.dtb; setenv bootargs console=ttyAMA0,115200; bootz 0x60008000 - 0x61000000"
```
重新编译 U-Boot 并重新写入 `flash.img`，开机即会自动加载内核。

---

## 8. 扩展：完全从 NOR Flash 启动 Linux（XIP 或复制）

如果不使用 SD 卡，可以把内核镜像也烧录到 NOR Flash 的某个偏移地址（例如 2MB 位置），然后在 U-Boot 中用 `cp.b` 命令将其复制到内存再启动。但需要注意 Flash 的大小和布局，以防覆盖 U-Boot 自身。

---

## 常见问题
- **串口无输出**：确认 `-nographic` 和 `console=ttyAMA0,115200`。
- **U-Boot 找不到 mmc**：检查 `-sd sd.img` 是否正确，以及 U-Boot 是否编译了 MMC 驱动（vexpress 默认已支持）。
- **内核 panic 因为根文件系统**：确保 initramfs 正确内嵌，或使用 `root=/dev/mmcblk0p1` 等参数。
- **工具链问题**：务必安装正确的交叉编译器，并设置 `CROSS_COMPILE` 和 `ARCH`。

这套流程完整覆盖了从零开始搭建 QEMU + NOR Flash + U-Boot + Linux 的模拟环境，你可以根据实际需要调整板型（如 vexpress-aemv8a 64位）或存储介质。如果有具体报错，欢迎继续提问。