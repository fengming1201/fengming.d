# ========== 工具类命令 ==========

qemu-img                      # 磁盘镜像工具：创建/转换/检查/调整大小（qcow2、raw、vmdk 等）
qemu-io                       # 磁盘 I/O 调试工具：对镜像做底层读写测试、分析性能
qemu-nbd                      # 把 QEMU 磁盘镜像导出为 NBD 块设备，供本机挂载或网络访问
qemu-pr-helper                # Persistent Reservation 辅助进程：配合 SCSI PR，用于共享磁盘/集群场景
qemu-storage-daemon           # 独立存储守护进程：在不启动完整虚拟机的情况下提供块设备、NBD、导出等存储服务

# ========== 系统仿真器（按架构）==========
# 格式：qemu-system-<架构> —— 启动对应 CPU 架构的完整系统虚拟机

qemu-system-aarch64           # ARM 64 位（ARMv8），常见服务器/手机/嵌入式
qemu-system-alpha             # DEC Alpha 架构（历史 RISC 工作站/服务器）
qemu-system-arm               # ARM 32 位
qemu-system-avr               # AVR 微控制器（Arduino 等 8 位 MCU）
qemu-system-cris              # Axis ETRAX CRIS（嵌入式网络设备用历史架构）
qemu-system-hppa              # HP PA-RISC（惠普历史工作站/服务器）
qemu-system-i386              # x86 32 位 PC
qemu-system-loongarch64       # 龙芯 LoongArch 64 位
qemu-system-m68k              # Motorola 68000 系列（经典 Mac、Amiga 等）
qemu-system-microblaze        # Xilinx MicroBlaze（大端），FPGA 软核
qemu-system-microblazeel      # Xilinx MicroBlaze（小端）
qemu-system-mips              # MIPS 32 位大端
qemu-system-mips64            # MIPS 64 位大端
qemu-system-mips64el          # MIPS 64 位小端
qemu-system-mipsel            # MIPS 32 位小端
qemu-system-nios2             # Intel/Altera Nios II（FPGA 软核）
qemu-system-or1k              # OpenRISC 1000 开源 RISC
qemu-system-ppc               # PowerPC 32 位
qemu-system-ppc64             # PowerPC 64 位（大端）
qemu-system-ppc64le           # PowerPC 64 位（小端），如 POWER 服务器
qemu-system-riscv32           # RISC-V 32 位
qemu-system-riscv64           # RISC-V 64 位
qemu-system-rx                # Renesas RX 微控制器
qemu-system-s390x             # IBM Z / s390x 大型机架构
qemu-system-sh4               # SuperH SH4（小端），如梦梦、部分嵌入式
qemu-system-sh4eb             # SuperH SH4（大端）
qemu-system-sparc             # SPARC 32 位（Sun 工作站等）
qemu-system-sparc64           # SPARC 64 位
qemu-system-tricore           # Infineon TriCore（汽车/工业 MCU）
qemu-system-x86_64            # x86_64 64 位 PC（最常用的桌面/服务器虚拟机）
qemu-system-x86_64-microvm    # x86_64 轻量 MicroVM 变体：启动更快、设备更精简，偏云/无服务器场景
qemu-system-xtensa            # Tensilica Xtensa（小端），ESP8266/ESP32 等常用
qemu-system-xtensaeb          # Tensilica Xtensa（大端）
