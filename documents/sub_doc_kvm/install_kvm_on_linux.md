## Linux下安装KVM

简介：

KVM（Kernel-based Virtual Machine）是 Linux 上的一个开源虚拟化解决方案，它允许你在 Linux 主机上创建和管理虚拟机（VM）。以下是 KVM 的安装和使用指南：

---

### **1. 检查硬件支持**

KVM 需要 CPU 支持硬件虚拟化技术（Intel VT-x 或 AMD-V）。运行以下命令检查是否支持：

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

- 如果输出大于`0`，则表示 CPU 支持虚拟化。
- 如果输出为`0`，需要在 BIOS 中启用虚拟化支持。

---

### **2. 安装 KVM 和相关工具**

#### **Ubuntu/Debian**

1. 安装 KVM 和工具：
   ```bash
   sudo apt update
   sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
   ```
2. 将当前用户添加到`libvirt` 和`kvm` 组：
   ```bash
   sudo usermod -aG libvirt $USER
   sudo usermod -aG kvm $USER
   ```
3. 重启系统或重新登录以应用组更改。

#### **CentOS/RHEL**

1. 安装 KVM 和工具：
   ```bash
   sudo yum install qemu-kvm libvirt libvirt-python libguestfs-tools virt-install virt-manager
   ```
2. 启动并启用`libvirtd` 服务：
   ```bash
   sudo systemctl start libvirtd
   sudo systemctl enable libvirtd
   ```
3. 将当前用户添加到`libvirt` 组：
   ```bash
   sudo usermod -aG libvirt $USER
   ```

---

### **3. 配置网络**

KVM 默认使用 NAT 网络，虚拟机可以通过主机的网络访问外部网络。如果需要桥接网络，可以配置网桥。

#### **配置桥接网络**

1. 安装桥接工具：

   ```bash
   sudo apt install bridge-utils  # Ubuntu/Debian
   sudo yum install bridge-utils  # CentOS/RHEL
   ```
2. 编辑网络配置文件（以 Ubuntu 为例）：

   ```bash
   sudo vi /etc/netplan/01-netcfg.yaml
   ```

   添加以下内容：
   ```yaml
   network:
     version: 2
     renderer: networkd
     ethernets:
       enp0s3:  # 替换为你的网卡名称
         dhcp4: no
     bridges:
       br0:
         interfaces: [enp0s3]
         dhcp4: yes
   ```
3. 应用配置：

   ```bash
   sudo netplan apply
   ```

---

### **4. 创建虚拟机**

#### **使用 `virt-manager`（图形界面）**

1. 启动`virt-manager`：
   ```bash
   virt-manager
   ```
2. 点击“新建虚拟机”，按照向导选择 ISO 镜像、配置 CPU、内存、磁盘等。

#### **使用 `virt-install`（命令行）**

1. 创建虚拟机：
   ```bash
   sudo virt-install \
     --name myvm \
     --ram 2048 \
     --vcpus 2 \
     --disk path=/var/lib/libvirt/images/myvm.qcow2,size=20 \
     --os-type linux \
     --os-variant ubuntu20.04 \
     --network bridge=br0 \
     --graphics spice \
     --cdrom /path/to/ubuntu.iso
   ```

   - `--name`：虚拟机名称。
   - `--ram`：内存大小（MB）。
   - `--vcpus`：虚拟 CPU 数量。
   - `--disk`：磁盘路径和大小（GB）。
   - `--os-type` 和`--os-variant`：操作系统类型和版本。
   - `--network`：网络配置（如桥接网络）。
   - `--graphics`：图形界面类型（如`spice` 或`vnc`）。
   - `--cdrom`：ISO 镜像路径。

---

### **5. 管理虚拟机**

#### **启动虚拟机**

```bash
sudo virsh start myvm
```

#### **停止虚拟机**

```bash
sudo virsh shutdown myvm
```

#### **重启虚拟机**

```bash
sudo virsh reboot myvm
```

#### **删除虚拟机**

```bash
sudo virsh destroy myvm  # 强制关闭
sudo virsh undefine myvm  # 删除配置
```

#### **查看虚拟机列表**

```bash
sudo virsh list --all
```

---

### **6. 其他常用命令**

#### **查看虚拟机信息**

```bash
sudo virsh dominfo myvm
```

#### **连接到虚拟机控制台**

```bash
sudo virsh console myvm
```

#### **克隆虚拟机**

```bash
sudo virt-clone --original myvm --name myvm-clone --file /var/lib/libvirt/images/myvm-clone.qcow2
```

#### **导出虚拟机**

```bash
sudo virsh dumpxml myvm > myvm.xml
```

#### **导入虚拟机**

```bash
sudo virsh define myvm.xml
```

---

### **7. 常见问题**

#### **虚拟机无法启动**

- 检查日志：
  ```bash
  sudo virsh console myvm
  ```
- 确保 ISO 镜像路径正确。

#### **网络无法连接**

- 检查桥接网络配置。
- 确保防火墙允许流量：
  ```bash
  sudo ufw allow out on br0
  ```

---

### **总结**

KVM 是一个强大的虚拟化工具，适合在 Linux 上创建和管理虚拟机。通过 `virt-manager` 或 `virt-install` 可以轻松创建虚拟机，并通过 `virsh` 进行管理。根据需求配置网络和存储，确保虚拟机高效运行。
