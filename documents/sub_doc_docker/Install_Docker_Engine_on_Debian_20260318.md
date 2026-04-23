# 在 Debian 上安装 Docker Engine


要开始在 Debian 上使用 Docker Engine，请确保你满足 [前提条件](#prerequisites)，然后按照 [安装步骤](#installation-methods) 进行操作。

## 前提条件

### 防火墙限制

> [!WARNING]
>
> 在安装 Docker 之前，请确保你考虑以下安全影响和防火墙不兼容性问题。

- 如果你使用 ufw 或 firewalld 管理防火墙设置，请注意，当你使用 Docker 暴露容器端口时，这些端口会绕过你的防火墙规则。有关更多信息，请参阅 [Docker 和 ufw](/engine/network/packet-filtering-firewalls/#docker-and-ufw)。
- Docker 仅与 `iptables-nft` 和 `iptables-legacy` 兼容。在安装了 Docker 的系统上，不支持使用 `nft` 创建的防火墙规则。确保你使用的任何防火墙规则集都是使用 `iptables` 或 `ip6tables` 创建的，并且你将它们添加到 `DOCKER-USER` 链中，请参阅 [数据包过滤和防火墙](/engine/network/packet-filtering-firewalls/)。

### 操作系统要求

要安装 Docker Engine，你需要以下 Debian 版本之一：

- Debian Trixie 13（稳定版）
- Debian Bookworm 12（旧稳定版）
- Debian Bullseye 11（更旧的稳定版）

适用于 Debian 的 Docker Engine 兼容 x86_64（或 amd64）、armhf（arm/v7）、arm64 和 ppc64le（ppc64el）架构。

### 卸载旧版本

在安装 Docker Engine 之前，你需要卸载任何冲突的软件包。

你的 Linux 发行版可能提供非官方的 Docker 软件包，这些软件包可能与 Docker 提供的官方软件包冲突。在安装 Docker Engine 的官方版本之前，你必须卸载这些软件包。

需要卸载的非官方软件包包括：

- `docker.io`
- `docker-compose`
- `docker-doc`
- `podman-docker`

此外，Docker Engine 依赖于 `containerd` 和 `runc`。Docker Engine 将这些依赖项捆绑为一个包：`containerd.io`。如果你之前安装了 `containerd` 或 `runc`，请卸载它们以避免与 Docker Engine 捆绑的版本发生冲突。

运行以下命令卸载所有冲突的软件包：

```console
$ sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
```

`apt` 可能会报告你没有安装这些软件包中的任何一个。

存储在 `/var/lib/docker/` 中的镜像、容器、卷和网络在卸载 Docker 时不会自动删除。如果你想从头开始安装，并希望清理任何现有数据，请阅读 [卸载 Docker Engine](#uninstall-docker-engine) 部分。

## 安装方法

你可以根据自己的需求以不同方式安装 Docker Engine：

- Docker Engine 与 [Docker Desktop for Linux](/desktop/setup/install/linux/) 捆绑在一起。这是最简单快捷的入门方式。

- 从 [Docker 的 `apt` 仓库](#install-using-the-repository) 设置和安装 Docker Engine。

- [手动安装](#install-from-a-package) 并手动管理升级。

- 使用 [便捷脚本](#install-using-the-convenience-script)。仅推荐用于测试和开发环境。



Apache License, Version 2.0。有关完整许可证，请参阅 [LICENSE](https://github.com/moby/moby/blob/master/LICENSE)。

### 使用 `apt` 仓库安装 {#install-using-the-repository}

在新主机上首次安装 Docker Engine 之前，你需要设置 Docker `apt` 仓库。之后，你可以从仓库安装和更新 Docker。

1. 设置 Docker 的 `apt` 仓库。

   ```bash
   # 添加 Docker 的官方 GPG 密钥：
   sudo apt update
   sudo apt install ca-certificates curl
   sudo install -m 0755 -d /etc/apt/keyrings
   sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
   sudo chmod a+r /etc/apt/keyrings/docker.asc

   # 将仓库添加到 Apt 源：
   sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
   Types: deb
   URIs: https://download.docker.com/linux/debian
   Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
   Components: stable
   Signed-By: /etc/apt/keyrings/docker.asc
   EOF

   sudo apt update
   ```

   > [!NOTE]
   >
   > 如果你使用衍生发行版，如 Kali Linux，
   > 你可能需要替换此命令中预期打印版本代号的部分：
   >
   > ```console
   > $(. /etc/os-release && echo "$VERSION_CODENAME")
   > ```
   >
   > 将此部分替换为相应 Debian 版本的代号，
   > 例如 `bookworm`。

2. 安装 Docker 软件包。

   **最新版本**



   要安装最新版本，请运行：

   ```console
   $ sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

   **特定版本**



   要安装特定版本的 Docker Engine，请首先列出仓库中的可用版本：

   ```console
   $ apt list --all-versions docker-ce

   docker-ce/bookworm 5:29.2.1-1~debian.12~bookworm <arch>
   docker-ce/bookworm 5:29.2.0-1~debian.12~bookworm <arch>
   ...
   ```

   选择所需的版本并安装：

   ```console
   $ VERSION_STRING=5:29.2.1-1~debian.12~bookworm
   $ sudo apt install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin
   ```

   

    > [!NOTE]
    >
    > Docker 服务在安装后会自动启动。要验证 Docker 是否正在运行，请使用：
    > 
    > ```console
    > $ sudo systemctl status docker
    > ```
    >
    > 某些系统可能禁用了此行为，需要手动启动：
    >
    > ```console
    > $ sudo systemctl start docker
    > ```

3. 通过运行 `hello-world` 镜像验证安装是否成功：

   ```console
   $ sudo docker run hello-world
   ```

   此命令下载测试镜像并在容器中运行。当容器运行时，它会打印确认消息并退出。

你现在已成功安装并启动了 Docker Engine。



> [!TIP]
> 
> 尝试在没有 root 权限的情况下运行时收到错误？
>
> `docker` 用户组存在但不包含任何用户，这就是为什么你需要使用 `sudo` 来运行 Docker 命令的原因。请继续阅读 [Linux 安装后步骤](/engine/install/linux-postinstall) 以允许非特权用户运行 Docker 命令以及其他可选配置步骤。



#### 升级 Docker Engine

要升级 Docker Engine，请按照 [安装说明](#install-using-the-repository) 的步骤 2 操作，选择你想要安装的新版本。

### 从包安装

如果你无法使用 Docker 的 `apt` 仓库来安装 Docker Engine，你可以下载适用于你的版本的 `deb` 文件并手动安装。每次想要升级 Docker Engine 时，你都需要下载一个新文件。

<!-- markdownlint-disable-next-line -->
1. 前往 [`https://download.docker.com/linux/debian/dists/`](https://download.docker.com/linux/debian/dists/)。

2. 在列表中选择你的 Debian 版本。

3. 前往 `pool/stable/` 并选择适用的架构（`amd64`、`armhf`、`arm64` 或 `s390x`）。

4. 下载以下用于 Docker Engine、CLI、containerd 和 Docker Compose 软件包的 `deb` 文件：

   - `containerd.io_<version>_<arch>.deb`
   - `docker-ce_<version>_<arch>.deb`
   - `docker-ce-cli_<version>_<arch>.deb`
   - `docker-buildx-plugin_<version>_<arch>.deb`
   - `docker-compose-plugin_<version>_<arch>.deb`

5. 安装 `.deb` 软件包。更新以下示例中的路径以指向你下载 Docker 软件包的位置。

   ```console
   $ sudo dpkg -i ./containerd.io_<version>_<arch>.deb \
     ./docker-ce_<version>_<arch>.deb \
     ./docker-ce-cli_<version>_<arch>.deb \
     ./docker-buildx-plugin_<version>_<arch>.deb \
     ./docker-compose-plugin_<version>_<arch>.deb
   ```

    > [!NOTE]
    >
    > Docker 服务在安装后会自动启动。要验证 Docker 是否正在运行，请使用：
    > 
    > ```console
    > $ sudo systemctl status docker
    > ```
    >
    > 某些系统可能禁用了此行为，需要手动启动：
    >
    > ```console
    > $ sudo systemctl start docker
    > ```

6. 通过运行 `hello-world` 镜像验证安装是否成功：

   ```console
   $ sudo docker run hello-world
   ```

   此命令下载测试镜像并在容器中运行。当容器运行时，它会打印确认消息并退出。

你现在已成功安装并启动了 Docker Engine。



> [!TIP]
> 
> 尝试在没有 root 权限的情况下运行时收到错误？
>
> `docker` 用户组存在但不包含任何用户，这就是为什么你需要使用 `sudo` 来运行 Docker 命令的原因。请继续阅读 [Linux 安装后步骤](/engine/install/linux-postinstall) 以允许非特权用户运行 Docker 命令以及其他可选配置步骤。



#### 升级 Docker Engine

要升级 Docker Engine，请下载更新的软件包文件并重复 [安装过程](#install-from-a-package)，指向新文件。



### 使用便捷脚本安装

Docker 在 [https://get.docker.com/](https://get.docker.com/) 提供了一个便捷脚本，用于非交互式地将 Docker 安装到开发环境中。便捷脚本不推荐用于生产环境，但它对于创建适合你需求的配置脚本很有用。另请参阅 [使用仓库安装](#install-using-the-repository) 步骤，了解使用软件包仓库安装的安装步骤。该脚本的源代码是开源的，你可以在 GitHub 上的 [`docker-install` 仓库](https://github.com/docker/docker-install) 中找到它。

<!-- prettier-ignore -->
在本地运行从互联网下载的脚本之前，务必检查它们。在安装之前，让自己熟悉便捷脚本的潜在风险和限制：

- 该脚本需要 `root` 或 `sudo` 权限才能运行。
- 该脚本尝试检测你的 Linux 发行版和版本，并为你配置包管理系统。
- 该脚本不允许你自定义大多数安装参数。
- 该脚本安装依赖项和建议，而不要求确认。根据主机当前的配置，这可能会安装大量软件包。
- 默认情况下，该脚本安装 Docker、containerd 和 runc 的最新稳定版本。当使用此脚本配置机器时，这可能会导致 Docker 意外的主要版本升级。在部署到生产系统之前，务必在测试环境中测试升级。
- 该脚本不是为升级现有 Docker 安装而设计的。当使用该脚本更新现有安装时，依赖项可能不会更新到预期版本，导致版本过时。

> [!TIP]
>
> 在运行前预览脚本步骤。你可以使用 `--dry-run` 选项运行脚本，以了解脚本在调用时将运行哪些步骤：
>
> ```console
> $ curl -fsSL https://get.docker.com -o get-docker.sh
> $ sudo sh ./get-docker.sh --dry-run
> ```

此示例从 [https://get.docker.com/](https://get.docker.com/) 下载脚本并运行它，以在 Linux 上安装 Docker 的最新稳定版本：

```console
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
Executing docker install script, commit: 7cae5f8b0decc17d6571f9f52eb840fbc13b2737
<...>
```

你现在已成功安装并启动了 Docker Engine。在基于 Debian 的发行版上，`docker` 服务会自动启动。在基于 `RPM` 的发行版上，如 CentOS、Fedora 或 RHEL，你需要使用适当的 `systemctl` 或 `service` 命令手动启动它。如消息所示，默认情况下非 root 用户无法运行 Docker 命令。

> **以非特权用户身份使用 Docker，或在无根模式下安装？**
>
> 安装脚本需要 `root` 或 `sudo` 权限才能安装和使用 Docker。如果你想授予非 root 用户访问 Docker 的权限，请参阅 [Linux 安装后步骤](/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)。你也可以在没有 `root` 权限的情况下安装 Docker，或者配置为在无根模式下运行。有关在无根模式下运行 Docker 的说明，请参阅 [以非 root 用户身份运行 Docker 守护进程（无根模式）](/engine/security/rootless/)。

#### 安装预发布版本

Docker 还在 [https://test.docker.com/](https://test.docker.com/) 提供了一个便捷脚本，用于在 Linux 上安装 Docker 的预发布版本。此脚本与 `get.docker.com` 上的脚本相同，但它将你的包管理器配置为使用 Docker 包仓库的测试通道。测试通道包括 Docker 的稳定版和预发布版（beta 版本、发布候选版）。使用此脚本可以提前访问新版本，并在它们作为稳定版发布之前在测试环境中对其进行评估。

要从测试通道安装 Linux 上最新版本的 Docker，请运行：

```console
$ curl -fsSL https://test.docker.com -o test-docker.sh
$ sudo sh test-docker.sh
```

#### 使用便捷脚本后升级 Docker

如果你使用便捷脚本安装了 Docker，则应直接使用包管理器升级 Docker。重新运行便捷脚本没有任何优势。重新运行它可能会导致问题，因为它会尝试重新安装主机上已经存在的仓库。


## 卸载 Docker Engine

1. 卸载 Docker Engine、CLI、containerd 和 Docker Compose 软件包：

   ```console
   $ sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
   ```

2. 主机上的镜像、容器、卷或自定义配置文件不会自动删除。要删除所有镜像、容器和卷：

   ```console
   $ sudo rm -rf /var/lib/docker
   $ sudo rm -rf /var/lib/containerd
   ```

3. 删除源列表和密钥环

   ```console
   $ sudo rm /etc/apt/sources.list.d/docker.sources
   $ sudo rm /etc/apt/keyrings/docker.asc
   ```

你必须手动删除任何编辑过的配置文件。

## 后续步骤

- 继续阅读 [Linux 安装后步骤](/engine/install/debian/linux-postinstall/)。