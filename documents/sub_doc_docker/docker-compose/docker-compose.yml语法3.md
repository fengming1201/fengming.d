# docker-compose.yml 关键字与语法参考

> 基于 Compose Specification（Docker Compose V2，`docker compose` 命令）。
> 文末附本项目 `docker_compiler_template/docker-compose.yml` 的逐行对照解析。

## 0. 文件整体结构

```yaml
name: myproject          # 可选，项目名（等价于 COMPOSE_PROJECT_NAME）

services:                # 必填，定义各个容器
  app:
    image: ...
    build: ...

networks:                # 可选，自定义网络
  frontend: {}

volumes:                 # 可选，命名卷
  data: {}

configs:                 # 可选，配置文件注入（Swarm 语义，compose 也可挂载到容器）
secrets:                 # 可选，密钥注入
```

**关于 `version:`**：Compose V2 已将其废弃，写了会提示 `the attribute 'version' is obsolete`。V1（`docker-compose` 命令）才需要 `version: "3.8"` 之类。建议直接不写。

---

## 1. services 下的关键字

### 1.1 镜像与构建

| 关键字 | 作用 | 示例 |
|---|---|---|
| `image` | 指定镜像名:tag。与 `build` 同时存在时，作为构建产物的名字 | `image: harbor.cn:14743/ipcs/compiler/image4_x:26.9.3` |
| `build` | 构建配置。短语法给 context 路径；长语法见下 | `build: .` |
| `build.context` | 构建上下文目录 | `context: .` |
| `build.dockerfile` | 指定 Dockerfile 文件名（默认 `Dockerfile`） | `dockerfile: Dockerfile.dev` |
| `build.args` | 传递 ARG 构建参数（对应 Dockerfile 的 `ARG`） | `args: {ARG_VERSION: "26.9.3"}` 或列表形式 |
| `build.target` | 多阶段构建时只构建到某个阶段 | `target: builder` |
| `build.cache_from` / `cache_to` | 指定构建缓存来源/去向 | `cache_from: ["myimg:cache"]` |
| `build.network` | 构建时 RUN 使用的网络（如需要访问内网源） | `network: host` |
| `build.no_cache` / `pull` | 禁用缓存 / 构建前拉取最新基础镜像 | `no_cache: true` |
| `pull_policy` | 拉取策略：`always` / `never` / `missing`(默认) / `build` | `pull_policy: always` |
| `platform` | 强制运行平台（跨架构时用） | `platform: linux/amd64` |

### 1.2 容器身份与启动命令

| 关键字 | 作用 | 示例 |
|---|---|---|
| `container_name` | 固定容器名。**注意**：写死后同一份 compose 无法 `up` 出第二个实例，也无法 `--scale` | `container_name: container4_fh885x_compiler` |
| `command` | 覆盖镜像的 CMD。字符串或列表 | `command: ["python3", "app.py"]` |
| `entrypoint` | 覆盖镜像的 ENTRYPOINT | `entrypoint: ["/entrypoint.sh"]` |
| `user` | 容器内运行用户（`uid[:gid]` 或用户名） | `user: "1000:1000"` |
| `working_dir` | 容器内工作目录 | `working_dir: /opt` |
| `hostname` | 容器主机名（影响 shell 提示符 `user@HOST`） | `hostname: fh885x` |
| `domainname` | 容器域名 | `domainname: local` |
| `init` | 在容器内运行 tini 作为 PID 1，回收僵尸进程、转发信号 | `init: true` |
| `stop_signal` | 停止容器时发的信号（默认 SIGTERM） | `stop_signal: SIGINT` |
| `stop_grace_period` | stop 后等待多久再 SIGKILL | `stop_grace_period: 30s` |

### 1.3 环境变量

```yaml
environment:
  - USER_ID=1000            # 列表形式
  - TZ                      # 不带值 = 从宿主机环境取同名变量
# 或
environment:
  USER_ID: "1000"           # 字典形式（注意数字、y/n 要加引号）

env_file:
  - .env                    # 注入容器的环境变量文件
  - path: ./override.env    # 长语法
    required: false         # 文件不存在也不报错
```

- `env_file`：把文件里的 `KEY=VALUE` **注入容器**。
- 顶级 `.env`：compose 默认读取它来做 **yml 里的 `${VAR}` 变量替换**（不会自动注入容器）。
- 优先级（高→低）：shell 环境变量 > `environment:` > `env_file:` > Dockerfile `ENV`。

**yml 内的变量插值语法**：

| 写法 | 含义 |
|---|---|
| `$VAR` 或 `${VAR}` | 取值；未定义则为空并告警 |
| `${VAR:-default}` | 未定义或为空时用 default |
| `${VAR-default}` | 仅未定义时用 default |
| `${VAR:?err msg}` | 未定义或为空则报错退出 |
| `${VAR:+alt}` | 有值时用 alt，否则为空 |
| `$${VAR}` | 转义，输出字面量 `${VAR}`（容器内需要时） |

### 1.4 网络

| 关键字 | 作用 | 示例 |
|---|---|---|
| `ports` | 端口映射 `宿主:容器`。短语法 | `- "8080:80"`、`- "127.0.0.1:8080:80"` |
| `ports` 长语法 | 可指定 protocol / mode | 见下 |
| `expose` | 仅对同网络其他容器暴露，不映射到宿主 | `expose: ["3000"]` |
| `networks` | 指定加入的网络及别名/固定 IP | 见下 |
| `network_mode` | 特殊网络模式：`host` / `none` / `service:xxx` / `container:xxx` | `network_mode: host` |
| `dns` / `dns_search` | 自定义 DNS 服务器 / 搜索域 | `dns: [8.8.8.8]` |
| `extra_hosts` | 往 /etc/hosts 追加记录 | `- "gitea.local:192.168.1.10"` |
| `links` | 老式容器互联（已不建议用，自定义网络自带 DNS 解析服务名） | — |

```yaml
ports:                       # 长语法
  - target: 80               # 容器端口
    published: 8080          # 宿主端口
    host_ip: 127.0.0.1
    protocol: tcp
    mode: host

networks:
  frontend:
    aliases: ["web"]         # 同网络内可用 web 名字访问
    ipv4_address: 172.20.0.5 # 固定 IP（需要 ipam 配合）
```

### 1.5 存储

| 关键字 | 作用 | 示例 |
|---|---|---|
| `volumes` | 挂载。短语法 `源:目标[:模式]`；模式 `ro`(只读) / `rw` / `cached` / `delegated` | `- ./workdir:/home/duser/workdir` |
| `volumes` 长语法 | 区分 bind / volume / tmpfs，可控制传播 | 见下 |
| `tmpfs` | 挂载内存盘到容器路径 | `tmpfs: [/tmp]` |

```yaml
volumes:
  - type: bind               # 宿主机路径
    source: ./workdir
    target: /home/duser/workdir
    bind:
      propagation: rshared
  - type: volume             # docker 命名卷（需在顶层 volumes 声明）
    source: volume4_fjk_sigtool
    target: /opt/sigtool
    volume:
      nocopy: true           # 不用镜像内容初始化卷
```

### 1.6 依赖、健康与生命周期

| 关键字 | 作用 | 示例 |
|---|---|---|
| `depends_on` | 控制启动顺序。短语法仅排序；长语法可等健康检查 | 见下 |
| `healthcheck` | 健康检查（覆盖 Dockerfile 的 HEALTHCHECK） | 见下 |
| `restart` | 重启策略：`no`(默认) / `always` / `unless-stopped` / `on-failure[:N]` | `restart: always` |

```yaml
depends_on:
  db:
    condition: service_healthy      # 等 db 健康检查通过
    restart: true                   # db 重启后也重启本服务
  redis:
    condition: service_started

healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### 1.7 资源限制与部署

```yaml
deploy:
  mode: replicated            # replicated(默认) / global —— Swarm 语义
  replicas: 2
  resources:
    limits:   {cpus: '0.5', memory: 512M}
    reservations: {memory: 128M}
  restart_policy:
    condition: on-failure     # any(默认) / on-failure / none
    delay: 5s
    max_attempts: 3
  placement:
    constraints: ["node.role==worker"]
  update_config: {parallelism: 1, delay: 10s, order: start-first}
```

注意：`deploy` 除 `resources` 外大部分只在 **Swarm 模式**生效；单机 compose 主要靠 `restart`、`mem_limit`（v2 旧字段）、`cpus` 等。

| 关键字 | 作用 | 示例 |
|---|---|---|
| `ulimits` | 调整 ulimit | `ulimits: {nofile: {soft: 65536, hard: 65536}}` |
| `sysctls` | 修改内核参数 | `sysctls: ["net.core.somaxconn=1024"]` |
| `shm_size` | /dev/shm 大小（默认 64MB） | `shm_size: 256m` |

### 1.8 安全与权限

| 关键字 | 作用 | 示例 |
|---|---|---|
| `privileged` | 完全特权模式（慎用） | `privileged: true` |
| `cap_add` / `cap_drop` | 增删 Linux capability（比 privileged 精细） | `cap_add: [SYS_ADMIN]` |
| `security_opt` | SELinux/AppArmor/seccomp 配置 | `security_opt: [seccomp:unconfined]` |
| `devices` | 映射宿主机设备进容器 | `- /dev/ttyUSB0:/dev/ttyUSB0` |
| `read_only` | 根文件系统只读 | `read_only: true` |
| `userns_mode` | 用户命名空间 | `userns_mode: host` |
| `pid` / `ipc` | 共享 PID / IPC 命名空间 | `pid: host` |
| `cgroup` | cgroup 规则 | `cgroup: host` |

### 1.9 其他常用

| 关键字 | 作用 | 示例 |
|---|---|---|
| `tty` | 分配伪终端（交互容器必须，配合 bash） | `tty: true` |
| `stdin_open` | 保持 STDIN 打开（交互容器必须） | `stdin_open: true` |
| `logging` | 日志驱动与选项 | 见下 |
| `labels` | 容器元数据标签 | `labels: {container_run4_who: fh885x}` |
| `profiles` | 按需启动分组：`--profile debug` 才启动 | `profiles: [debug]` |
| `extends` | 继承另一个文件/服务的配置 | 见下 |
| `configs` / `secrets` | 把顶层定义的配置/密钥挂进容器 | 见第 4 节 |

```yaml
logging:
  driver: json-file
  options:
    max-size: "10m"
    max-file: "3"

extends:
  file: common.yml
  service: base
```

---

## 2. 顶层 networks

```yaml
networks:
  frontend:
    name: network4_fh885x     # 实际网络名（不加项目名前缀）
    driver: bridge            # bridge(默认) / host / overlay / macvlan / none
    driver_opts: {com.docker.network.bridge.name: br-fh885x}
    internal: false           # true = 无外网访问
    attachable: true          # 允许 docker run 的容器手动加入
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/16
          gateway: 172.20.0.1
  external_net:
    external: true            # 使用已存在的网络，compose 不创建不删除
    name: my_preexisting_net
```

服务不声明 `networks` 时，全部加入名为 `<项目名>_default` 的默认网络，且同网络内可直接用 **服务名** 互相解析。

## 3. 顶层 volumes

```yaml
volumes:
  data: {}                            # 最简单，docker 自动管理
  volume4_fjk_sigtool:
    name: volume4_fjk_sigtool         # 固定卷名（不加项目前缀）
    driver: local
    driver_opts:                      # 例如挂 NFS
      type: nfs
      o: addr=192.168.1.1,rw
      device: ":/exports/sigtool"
  existing_vol:
    external: true                    # 使用已存在的卷
```

## 4. 顶层 configs / secrets

```yaml
configs:
  nginx_conf:
    file: ./nginx.conf
secrets:
  db_password:
    file: ./db_password.txt

services:
  web:
    configs:
      - source: nginx_conf
        target: /etc/nginx/nginx.conf
    secrets:
      - source: db_password
        target: /run/secrets/db_password   # secrets 默认挂到这里
```

---

## 5. 本项目模板对照解析

`docker_compiler/docker_compiler_template/docker-compose.yml` 用到的关键字：

```yaml
services:
  cross_compiler:
    container_name: ${CONTAINERR_NAME}   # 固定容器名（CONTAINERR_NAME 双 R 是仓库约定）
    env_file: [.env]                     # 把 .env 的变量注入容器
    build:
      context: .
      args:                              # 传入 Dockerfile 的 ARG，用于 LABEL 和 4who 信息
        ARG_VERSION: ${VERSION}
    image: ${REPOSITORY_URL}${IMAGE_NAME}:${VERSION}   # 构建产物名（REPOSITORY_URL 必须以 / 结尾）
    tty: true                            # 交互式编译容器：必须
    stdin_open: true                     # 同上
    hostname: ${FOR_WHO}                 # shell 提示符 user@FOR_WHO，方便辨识容器
    #restart: always                     # 编译容器一般不开自启
    labels:
      container_run4_who: ${FOR_WHO}     # docker inspect 可查的元数据
    environment:
      - USER_ID=${HOST_USER_ID}          # 传给 entrypoint.sh 创建 duser
      - GROUP_ID=${HOST_USER_ID}
    volumes:
      - ${HOST_WORK_DIR}:/root/workdir       # 宿主机工作目录双挂载
      - ${HOST_WORK_DIR}:/home/duser/workdir

networks:
  default:                              # 覆盖默认网络
    name: network4_${FOR_WHO}           # 固定网络名，避免不同项目冲突
```

要点回顾：

- `${VAR}` 全部来自 `.env`（或 shell 环境），compose 先做文本替换再解析 yml。
- `tty` + `stdin_open` 是编译型（交互 bash）容器的标配；服务型容器（httpd/tftp）通常不需要。
- `container_name` 写死后，同一台机器要跑第二个实例必须改名。
- 顶层 `networks.default.name` 固定了网络名，这正是 `.env` 中 `COMPOSE_PROJECT_NAME` 之外又一层防冲突手段。

## 6. 常用命令速查

```bash
docker compose config          # 校验并打印变量替换后的完整配置（改 .env 后必跑）
docker compose build           # 构建
docker compose up -d           # 创建并后台启动
docker compose up -d --build   # 强制重新构建后启动
docker compose down            # 停止并删除容器+默认网络（不删卷，-v 才删卷）
docker compose exec <service> bash
docker compose logs -f <service>
docker compose pull / push     # 拉取 / 推送（配合 image 字段推镜像到 registry）
```
