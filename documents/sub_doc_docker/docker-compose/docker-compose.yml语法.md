下面是 Docker Compose（v2 / Compose Specification）完整的关键字参考，按层级整理。

---

## 一、顶层关键字

一个 `docker-compose.yml` 的顶层结构只有这几个 key：

```yaml
name: myproject        # 项目名称，影响容器/网络/卷名前缀
include: []            # 引入其他 compose 文件
services: {}           # 核心，定义服务
networks: {}           # 定义网络
volumes: {}            # 定义卷
configs: {}            # 配置文件（Swarm 特性，Compose 也支持）
secrets: {}            # 机密文件（Swarm 特性，Compose 也支持）
```

`name` 不设置时默认取**目录名**，所以容器名会是 `<目录名>-<服务名>-1`。

---

## 二、services 关键字（重点）

```yaml
services:
  web:
    image: nginx:alpine          # 使用现成镜像
    build: .                     # 或 ./dir 构建镜像
    container_name: my-nginx     # 自定义容器名（会失去 scale 能力）
    command: nginx -g "daemon off;"   # 覆盖 CMD
    entrypoint: /bin/sh          # 覆盖 ENTRYPOINT
    restart: unless-stopped      # no|always|on-failure|unless-stopped
```

### 构建相关 `build`

```yaml
    build:
      context: ./app             # 构建上下文目录
      dockerfile: Dockerfile.dev # 指定 Dockerfile 名
      target: builder            # 多阶段构建到某个阶段
      args:                      # 构建参数
        ENV: production
      cache_from:
        - myimage:latest         # 构建缓存
```

> `image` 和 `build` 可以同时写：有 `build` 时会构建，`image` 指定构建出来的镜像名。

### 环境变量 `environment` / `env_file`

```yaml
    environment:                 # 直接写
      - KEY=value
      - KEY                      # 只写名字=从宿主机取值
    env_file:                    # 从文件加载
      - ./app/.env
      - ./app/.env.local
```

**优先级**（高→低）：`environment` > shell 环境变量 > `env_file` > `.env` 文件。

### 网络端口 `ports` / `expose`

```yaml
    ports:                       # 宿主机:容器 映射，会发布到外部
      - "80:80"                  # 短语法
      - target: 80               # 长语法
        published: 8080
        protocol: tcp
        mode: host
    expose:                      # 仅容器间可见，不映射到宿主机
      - "3306"
```

### 存储 `volumes`

```yaml
    volumes:
      - ./html:/usr/share/nginx/html:ro     # 绑定挂载（宿主机路径）
      - data:/var/lib/mysql                 # 命名卷
      - type: bind                           # 长语法
        source: ./conf
        target: /etc/nginx/conf.d
        read_only: true
```

第三段是选项：`ro`（只读）、`rw`、`z`/`Z`（SELinux 标签）。

### 网络 `networks`

```yaml
    networks:
      - frontend
      - backend:
          aliases:               # 网络内别名
            - db.internal
          ipv4_address: 172.20.0.5   # 需网络配置了 ipam
```

### 依赖与启动顺序 `depends_on`

```yaml
    depends_on:
      db:
        condition: service_healthy   # service_started|service_healthy|service_completed_successfully
      redis:
        condition: service_started
```

注意：只保证启动顺序，不保证服务"就绪"，就绪要靠 healthcheck。

### 健康检查 `healthcheck`

```yaml
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s        # 检查间隔
      timeout: 10s         # 单次超时
      retries: 3           # 失败重试次数
      start_period: 40s    # 启动宽限期，期间失败不计数
      start_interval: 5s   # 启动期间检查间隔（较新版本）
```

### 资源限制 `deploy`（单机 compose 可用的子集）

```yaml
    deploy:
      replicas: 2                      # 副本数（compose 下也生效）
      resources:
        limits:
          cpus: "0.5"
          memory: 512M
        reservations:
          memory: 256M
      restart_policy:
        condition: on-failure
      mode: replicated                 # replicated|global
```

### 日志 `logging`

```yaml
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

可选 driver：`json-file`、`syslog`、`journald`、`fluentd`、`none` 等。

### 其他常用关键字

```yaml
    user: "1000:1000"          # 运行用户
    working_dir: /app          # 工作目录
    hostname: web-01
    dns: [8.8.8.8, 114.114.114.114]
    extra_hosts:               # 写入 /etc/hosts
      - "example.com:192.168.1.10"
    cap_add: [NET_ADMIN]       # 添加 Linux capability
    cap_drop: [ALL]
    privileged: true           # 特权模式（危险）
    read_only: true            # 容器根文件系统只读
    tmpfs: /run                # 临时文件系统
    devices:                   # 设备映射
      - "/dev/ttyUSB0:/dev/ttyUSB0"
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    sysctls:
      net.core.somaxconn: 1024
    stdin_open: true           # 等价 docker run -i
    tty: true                  # 等价 docker run -t
    init: true                 # 使用 tini 作为 PID 1
    stop_grace_period: 30s     # 停止前等待优雅退出的时间
    stop_signal: SIGTERM       # 停止信号
    profiles: [debug]          # 按需启动：docker compose --profile debug up
    pull_policy: always        # 拉取策略
    platform: linux/amd64      # 指定平台
    labels:                    # 容器元数据
      - "com.example.description=web"
    extends:                   # 继承其他服务的配置
      file: common.yml
      service: web-base
```

### 已废弃/不推荐

| 关键字 | 状态 | 替代方案 |
|--------|------|---------|
| `links` | 废弃 | `networks`（容器间用服务名互访） |
| `mem_limit`、`memswap_limit`、`cpus` | v2 遗留 | `deploy.resources` |
| `version` | 顶层字段已废弃 | 直接删掉即可 |
| `container_name` | 功能受限 | 一般不需要 |

---

## 三、networks 关键字

```yaml
networks:
  frontend:
    driver: bridge             # bridge|overlay|host|none
    name: my-frontend          # 自定义网络名（不随项目名变化）
    attachable: true           # 允许手动 docker network connect
    internal: true             # 禁止外部访问（隔离网络）
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/16
    labels:
      - "env=prod"
  external-net:
    external: true             # 使用已存在的外部网络
    name: existing-net
```

---

## 四、volumes 关键字

```yaml
volumes:
  data:
    driver: local
    name: my-data              # 自定义卷名
    external: true             # 使用外部已存在的卷
  bind-mount:
    driver_opts:
      type: none
      device: /srv/data
      o: bind
```

---

## 五、configs / secrets

```yaml
configs:
  nginx_conf:
    file: ./nginx.conf         # 从文件创建

secrets:
  db_password:
    file: ./secrets/password.txt
  env_secret:
    environment: "SECRET_ENV"  # 从环境变量创建
```

服务中引用：

```yaml
    configs:
      - source: nginx_conf
        target: /etc/nginx/nginx.conf
    secrets:
      - source: db_password
        target: /run/secrets/db_password
```

Secrets 会以文件形式挂载到容器内，避免明文出现在 `environment` 中。

---

## 六、一个完整示例

```yaml
name: demo

services:
  web:
    build:
      context: ./web
      args:
        ENV: dev
    ports:
      - "8080:80"
    volumes:
      - ./web/src:/app/src
    environment:
      - DB_HOST=db
    depends_on:
      db:
        condition: service_healthy
    networks: [frontend, backend]

  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/pg_pass
    secrets: [pg_pass]
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5
    networks: [backend]

networks:
  frontend:
  backend:
    internal: true

volumes:
  pgdata:

secrets:
  pg_pass:
    file: ./secrets/pg_password.txt
```

---

## 记忆要点

1. **服务间互访直接用服务名**（如 `db:5432`），不需要 IP
2. **相对路径全部基于 compose 文件所在目录**（build context、bind mount、env_file）
3. **变量插值**：`${VAR}` 从 shell / `.env` / `env_file` 取值，`${VAR:-default}` 提供默认值
4. **调试合并结果**：`docker compose config` 永远是最可靠的验证方式

需要哪个关键字的更深入用法（比如 healthcheck 实战、多阶段构建、profiles 场景）可以继续问。