
QEMU 常用命令及实验演示--从零开始的虚拟机之旅 


这是一份实验文档，以最通俗的方式，带你一步步掌握 QEMU 的核心命令。每个知识点都配有可直接运行的实验，照着敲就能看到效果。

一、QEMU 是什么？

QEMU 是一个开源的模拟器 + 虚拟机管理器。简单来说，它能让你在一台电脑上"虚拟"出另一台电脑，在上面跑各种操作系统——就像在电脑里再开一台电脑。它和 VMware、VirtualBox 是同一类工具，但更轻量、更灵活，而且命令行驱动，特别适合开发者和极客。

二、安装 QEMU在 Ubuntu / Debian 系统上，
一条命令搞定：
sudo apt updatesudo apt install qemu-system qemu-utils

安装完成后，验证一下：
qemu-system-x86_64 --version

如果输出版本号（比如 QEMU emulator version 8.x.x），就说明装好了。 

小贴士：qemu-system-x86_64 是用来模拟 x86_64 架构虚拟机的命令。
QEMU 支持多种架构，比如 qemu-system-arm、qemu-system-aarch64 等，按需安装。 

三、实验 1：创建一个虚拟磁盘镜像虚拟机需要"硬盘"，我们用 qemu-img 命令来创建。
命令：
qemu-img create
qemu-img create -f qcow2 my_disk.qcow2 20G

拆解说明：
参数             含义
create	        创建一个新的磁盘镜像
-f qcow2	    磁盘格式选 qcow2（推荐，支持快照、按需分配空间）
my_disk.qcow2	镜像文件名
20G	            最大容量 20GB（实际文件很小，按需增长）

验证镜像信息：qemu-img info
qemu-img info my_disk.qcow2
输出类似：
image: my_disk.qcow2
file format: qcow2
virtual size: 20 GiB (21474836480 bytes)
disk size: 196 KiB
cluster_size: 65536
Format specific information:
    compat: 1.1
    compression type: zlib
    lazy refcounts: false
    refcount bits: 16
    corrupt: false
    extended l2: false
注意看 virtual size 是 20GB，但 disk size 只有几百 KB——这就是 qcow2 的妙处：用多少占多少。

四、实验 2：启动你的第一个虚拟机
现在我们有了"硬盘"，接下来装系统。先下载一个轻量级 Linux 镜像（推荐 Alpine Linux，只有几十 MB）：# 
下载 Alpine Linux 虚拟版（约 50MB，下载飞快）
wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.0-x86_64.iso

命令：qemu-system-x86_64
qemu-system-x86_64 -m 1024  -smp 2 -hda my_disk.qcow2  -cdrom alpine-virt-3.19.0-x86_64.iso  -boot d  -nographic

逐行拆解：
参数                   含义
-m 1024	              分配 1024MB（1GB）内存给虚拟机
-smp 2	              分配 2 个 CPU 核心
-hda my_disk.qcow2	  第一块硬盘用我们刚创建的镜像
-cdrom xxx.iso	      把 ISO 镜像当作光驱插入
-boot d	              从光驱（cdrom）启动（d 代表 disc）
-nographic	          不弹图形窗口，一切在终端里完成

如果不想用 -nographic，去掉这个参数，QEMU 会弹出一个图形窗口显示虚拟机的屏幕，像这样操作更直观。

启动成功后
你会看到 Alpine Linux 的启动日志在终端里滚动。等它启动完毕，会出现登录提示。
Alpine 默认用户是 root，没有密码，直接回车就能进去。

进入系统后，试着跑几个命令感受一下：

uname  -a          # 查看系统信息
cat  /proc/cpuinfo # 看看"虚拟"的 CPU
df  -h             # 看看磁盘

玩完了？按 Ctrl-A 然后按 x 退出虚拟机（这是 QEMU 的快捷键）。

五、实验 3：QEMU Monitor —— 虚拟机的"遥控器"
QEMU 有一个内置的控制台叫 Monitor，可以实时控制虚拟机。启动时加上 Monitor

qemu-system-x86_64  -m 512  -hda my_disk.qcow2  -nographic  -monitor stdio

-monitor stdio 把 Monitor 绑定到终端。虚拟机启动后，按 Ctrl-A 然后按 c 就能切换到 Monitor 模式。

常用 Monitor 命令
(qemu) info status          # 查看虚拟机状态（running / paused）
(qemu) info cpus            # 查看 CPU 信息(qemu) info block           # 查看磁盘信息
(qemu) stop                 # 暂停虚拟机
(qemu) cont                 # 恢复运行
(qemu) system_powerdown     # 优雅关机（相当于按电源键）
(qemu) quit                 # 直接退出 QEMU

试试看：先 stop 暂停，再 cont 恢复——虚拟机就像被按了暂停键一样，无缝继续。

六、实验 4：磁盘快照 —— 时光机
快照可以保存虚拟机某一时刻的完整状态，随时回滚，非常适合实验和调试。
创建快照：qemu-img snapshot
# 先确保虚拟机已关机
qemu-img snapshot -c "clean_state" my_disk.qcow2

-c 代表 create，"clean_state" 是你给快照取的名字。

查看快照列表
qemu-img snapshot -l my_disk.qcow2
输出类似：
ID        TAG         VM SIZE      DATE
1      clean_state       0         2026-07-01 10:30:00

恢复到快照
qemu-img snapshot -a "clean_state" my_disk.qcow2
-a 代表 apply（应用快照），磁盘会回到创建快照时的状态。

删除快照
qemu-img snapshot -d "clean_state" my_disk.qcow2
-d 代表 delete。

实战场景： 在装系统之前打个快照，装坏了随时回滚，比重新创建镜像快得多。

七、实验 5：磁盘格式转换
qemu-img convert 能在不同磁盘格式之间转换。常见场景：qcow2 转 raw
qemu-img convert -f qcow2 -O raw my_disk.qcow2 my_disk.raw

参数          含义
-f qcow2	  输入格式
-O raw	      输出格式（注意是大写的 O）

其他支持的格式
# 转成 VMDK（VMware 格式）qemu-img convert -f qcow2 -O vmdk my_disk.qcow2 my_disk.vmdk# 转成 VDI（VirtualBox 格式）qemu-img convert -f qcow2 -O vdi my_disk.qcow2 my_disk.vdi# 转成 VHD（Hyper-V 格式）qemu-img convert -f qcow2 -O vpc my_disk.qcow2 my_disk.vhd
实用价值： 在 QEMU 里调试好的镜像，可以轻松导出给 VMware 或 VirtualBox 用。

八、实验 6：网络配置
让虚拟机能上网是很多场景的刚需。QEMU 提供了几种网络模式。
模式一：用户模式网络（最简单）
qemu-system-x86_64  -m 1024  -hda my_disk.qcow2  -nographic  -netdev user,id=net0  -device e1000,netdev=net0

-netdev user 是 QEMU 内置的 NAT 网络，开箱即用，虚拟机能上网但外部无法主动访问它。
就像手机连了 WiFi 能上网，但别人不能直接连你的手机。

模式二：端口转发
如果你需要从外部访问虚拟机里的服务（比如 SSH），可以加端口转发：

qemu-system-x86_64  -m 1024  -hda my_disk.qcow2  -nographic  -netdev user,id=net0,hostfwd=tcp::2222-:22  -device e1000,netdev=net0
hostfwd=tcp::2222-:22 的意思是：把宿主机的 2222 端口转发到虚拟机的 22 端口。

然后在宿主机上就可以用 SSH 连进去了：
ssh  -p 2222 root@localhost

模式三：网桥模式（高级，虚拟机和宿主机在同一网段）
# 需要先创建网桥（需要 root 权限）
sudo ip link add name br0 type bridge
sudo ip addr add 192.168.100.1/24 dev br0
sudo ip link set br0 up   # 启动虚拟机并接入网桥

qemu-system-x86_64  -m 1024  -hda my_disk.qcow2  -nographic  -netdev bridge,id=net0,br=br0  -device e1000,netdev=net0
这种模式下，虚拟机就像直接插在你的路由器上一样，拥有独立 IP。


九、实验 7：KVM 硬件加速
前面的实验都是纯软件模拟，速度较慢。如果你的 CPU 支持虚拟化（大多数现代 CPU 都支持），可以启用 KVM 加速，性能提升巨大。
检查 KVM 是否可用
ls  /dev/kvm
如果输出 /dev/kvm 就说明可用。如果没有，运行：

sudo modprobe kvmsudo modprobe kvm_intel # Intel CPU# 或sudo modprobe kvm_amd  # AMD CPU
启用 KVM 加速
只需加一个参数 -enable-kvm：

qemu-system-x86_64  -enable-kvm  -m 2048  -smp 4  -hda my_disk.qcow2   -cdrom alpine-virt-3.19.0-x86_64.iso   -boot d  -nographic

你会明显感觉到启动速度变快了——因为 CPU 指令不再需要模拟，而是直接在硬件上执行。

速度对比： 不加 KVM 启动 Alpine 可能要等 30 秒以上，加了 KVM 后通常 5 秒内就能进系统。


十、实验 8：磁盘扩容
磁盘空间不够了？QEMU 支持在线扩容。命令：qemu-img resize
# 把磁盘增加 10GBqemu-img resize my_disk.qcow2 +10G
验证一下：

qemu-img info my_disk.qcow2  # virtual size 应该变成了 30 GiB
进入虚拟机后，还需要用 fdisk 或 parted 扩展分区，再用 resize2fs 扩展文件系统才能真正用上多出来的空间：

# 在虚拟机里执行

fdisk /dev/sda        # 删除旧分区，重建更大的分区（不格式化）
resize2fs /dev/sda1   # 扩展文件系统
df -h                 # 确认空间增加了


十一、实验 9：USB 设备直通
你可以把真实的 USB 设备"插"到虚拟机里。先查看 USB 设备列表
lsusb
输出类似：

Bus 001 Device 003: ID 0781:5581 SanDisk Corp. Ultra
把 U 盘直通给虚拟机
qemu-system-x86_64  -enable-kvm  -m 1024  -hda my_disk.qcow2  -nographic  -usb  -device usb-host,vendorid=0x0781,productid=0x5581
vendorid 和 productid 从 lsusb 的输出里取。虚拟机里就能看到你的 U 盘了。

十二、命令速查表
命令                   用途            快速示例 
qemu-img create       创建磁盘镜像     qemu-img create -f qcow2 disk.qcow2 20G 
qemu-img info         查看镜像信息     qemu-img info disk.qcow2 
qemu-img snapshot -c  创建快照         qemu-img snapshot -c "v1" disk.qcow2 
qemu-img snapshot -l  列出快照         qemu-img snapshot -l disk.qcow2 
qemu-img snapshot -a  恢复快照         qemu-img snapshot -a "v1" disk.qcow2 
qemu-img convert      格式转换         qemu-img convert -f qcow2 -O raw a.qcow2 a.raw 
qemu-img resize       磁盘扩容         qemu-img resize disk.qcow2 +10G 
qemu-system-x86_64    启动虚拟机       见各实验
QEMU Monitor          实时控制         Ctrl-A  然后 c 进入 


十三、QEMU 快捷键速查
在 -nographic 模式下，所有快捷键都以 Ctrl-A 开头（先按 Ctrl+A，松开，再按下一个键）： 
快捷键               功能 
Ctrl-A 然后 x        退出QEMU 
Ctrl-A 然后 c        切换到 Monitor 
Ctrl-A 然后 Ctrl-A   发送一个真正的 Ctrl-A 到虚拟机 
Ctrl-A 然后 h        显示所有快捷键帮助 

写在最后
QEMU 的核心就是这几件事：创建磁盘、启动虚拟机、管理快照、配置网络。把上面 9 个实验都跑一遍，基本就入门了。
记住一条学习路线：先用 qemu-img 管理磁盘 → 再用 qemu-system-x86_64 启动虚拟机 → 然后学网络和快照 → 最后尝试 KVM 加速。循序渐进，每次只加一个新参数，就不会被复杂的选项搞晕。“祝你玩的开心快乐。”