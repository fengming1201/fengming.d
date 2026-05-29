# Docker Compose 子命令用法与示例

Docker Compose 用于定义并运行多容器应用。基本调用形式：

```
docker compose [全局选项] 子命令 [子命令选项] [参数]
```

下文假设项目根目录存在 `docker-compose.yml`（或通过 `-f` 指定配置文件）。

---

## 全局常用选项

| 选项 | 说明 |
|------|------|
| `-f, --file` | 指定 Compose 配置文件，可多次使用 |
| `-p, --project-name` | 指定项目名称（影响容器、网络、卷的命名前缀） |
| `--env-file` | 指定环境变量文件 |
| `--profile` | 启用指定 profile 的服务 |
| `--project-directory` | 指定项目工作目录 |
| `--dry-run` | 试运行，不实际执行 |

```bash
# 使用多个配置文件
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# 指定项目名
docker compose -p myapp up -d

# 启用 debug profile
docker compose --profile debug up -d
```

---

## attach — 附加到运行中容器

将本地终端的 stdin/stdout/stderr 连接到服务的运行中容器，类似 `docker attach`。

```bash
# 附加到 web 服务容器
docker compose attach web

# 不附加标准输入（只读观察）
docker compose attach --no-stdin web

# 服务有多个副本时，指定第 2 个实例（索引从 1 开始）
docker compose attach --index 2 web
```

> 分离快捷键默认 `Ctrl+P Ctrl+Q`，可用 `--detach-keys` 覆盖。

---

## build — 构建镜像

根据 Compose 文件中的 `build` 段构建或重新构建服务镜像。

```bash
# 构建所有需要构建的服务
docker compose build

# 只构建 web 和 api
docker compose build web api

# 不使用缓存重新构建
docker compose build --no-cache

# 构建时传入构建参数
docker compose build --build-arg NODE_ENV=production web

# 构建并同时构建依赖服务
docker compose build --with-dependencies web
```

---

## commit — 从容器变更创建镜像

将服务容器内的文件系统变更提交为新镜像（类似 `docker commit`）。

```bash
# 将 web 容器当前状态提交为镜像
docker compose commit web myregistry/web:snapshot

# 带提交说明
docker compose commit -m "hotfix config" web myregistry/web:hotfix
```

---

## config — 验证并渲染配置

解析、插值环境变量、消解依赖，输出规范化后的 Compose 配置。

```bash
# 检查配置是否正确并打印合并后的 YAML
docker compose config

# 输出 JSON 格式
docker compose config --format json

# 仅验证，不输出内容
docker compose config -q

# 列出所有服务名
docker compose config --services

# 将解析结果保存到文件
docker compose config -o resolved-compose.yml

# 将镜像标签固定为 digest
docker compose config --resolve-image-digests
```

---

## cp — 容器与主机间复制文件

```bash
# 从容器复制到主机
docker compose cp web:/app/logs/error.log ./error.log

# 从主机复制到容器
docker compose cp ./config.yml web:/app/config.yml

# 复制整个目录
docker compose cp web:/var/log/nginx ./nginx-logs

# 多副本服务指定实例
docker compose cp --index 1 web:/tmp/data.json ./data.json
```

---

## create — 创建容器（不启动）

```bash
# 为所有服务创建容器
docker compose create

# 创建前先构建镜像
docker compose create --build

# 强制重新创建（即使配置未变）
docker compose create --force-recreate web
```

---

## down — 停止并清理

停止容器、移除容器和网络。是最常用的「关停」命令。

```bash
# 停止并移除容器、网络
docker compose down

# 同时删除命名卷和匿名卷（数据会丢失！）
docker compose down -v

# 同时删除本地构建的镜像
docker compose down --rmi local

# 设置停止超时（秒）
docker compose down -t 30

# 只关停指定服务
docker compose down web db
```

---

## events — 实时事件流

```bash
# 监听所有服务事件
docker compose events

# JSON 格式输出
docker compose events --json

# 只监听 web 服务
docker compose events web

# 只看最近 10 分钟的事件
docker compose events --since 10m
```

---

## exec — 在运行中容器执行命令

在**已运行**的容器内执行命令，是最常用的调试手段之一。

```bash
# 进入容器 shell
docker compose exec web bash
docker compose exec web sh          # Alpine 等精简镜像

# 执行单条命令
docker compose exec web ls -la /app
docker compose exec db psql -U postgres -c "SELECT 1"

# 以指定用户运行
docker compose exec -u www-data web whoami

# 设置环境变量
docker compose exec -e DEBUG=1 web python manage.py shell

# 非交互场景（脚本中），禁用 TTY
docker compose exec -T web cat /app/config.yml

# 多副本时指定实例
docker compose exec --index 2 web hostname
```

> `exec` 要求容器已在运行；若容器未启动，用 `run` 代替。

---

## export — 导出容器文件系统

```bash
# 导出 web 容器文件系统到 tar
docker compose export web > web-backup.tar

# 直接写入文件
docker compose export -o web-backup.tar web
```

---

## images — 列出使用的镜像

```bash
# 表格列出镜像
docker compose images

# 只看 web 服务
docker compose images web

# JSON 输出
docker compose images --format json

# 只显示镜像 ID
docker compose images -q
```

---

## kill — 强制停止

向容器发送信号强制终止（默认 SIGKILL）。

```bash
# 强制停止所有服务
docker compose kill

# 只停止 web
docker compose kill web

# 发送 SIGTERM 而非 SIGKILL
docker compose kill -s SIGTERM web
```

---

## logs — 查看日志

```bash
# 查看所有服务日志
docker compose logs

# 持续跟踪（类似 tail -f）
docker compose logs -f

# 只看 web 和 db
docker compose logs -f web db

# 最近 100 行
docker compose logs --tail 100 web

# 带时间戳
docker compose logs -t web

# 最近 1 小时的日志
docker compose logs --since 1h web
```

---

## ls — 列出 Compose 项目

```bash
# 列出运行中的项目
docker compose ls

# 包含已停止的项目
docker compose ls -a

# JSON 输出
docker compose ls --format json
```

---

## pause / unpause — 暂停与恢复

暂停容器内所有进程（不释放资源，与 stop 不同）。

```bash
# 暂停 web 服务
docker compose pause web

# 恢复
docker compose unpause web
```

---

## port — 查询端口映射

```bash
# 查看 web 服务容器内 80 端口映射到主机的哪个端口
docker compose port web 80

# 查询 UDP 端口
docker compose port --protocol udp dns 53
```

---

## ps — 列出容器状态

```bash
# 列出运行中的容器
docker compose ps

# 包含已停止的容器
docker compose ps -a

# 按状态过滤
docker compose ps --status running
docker compose ps --status exited

# 只显示容器 ID
docker compose ps -q
```

---

## publish — 发布 Compose 应用

将 Compose 应用（含引用的镜像）发布为 OCI 制品。

```bash
# 发布到镜像仓库
docker compose publish myregistry/myapp:latest

# 包含环境变量
docker compose publish --with-env myregistry/myapp:latest

# 固定镜像 digest 后发布
docker compose publish --resolve-image-digests myregistry/myapp:v1.0
```

---

## pull — 拉取镜像

```bash
# 拉取所有服务镜像
docker compose pull

# 只拉取 web
docker compose pull web

# 静默拉取（不显示进度）
docker compose pull -q

# 同时拉取依赖服务镜像
docker compose pull --include-deps web
```

---

## push — 推送镜像

```bash
# 推送所有服务镜像
docker compose push

# 推送指定服务
docker compose push web api
```

---

## restart — 重启服务

```bash
# 重启所有服务
docker compose restart

# 重启 web 和 db
docker compose restart web db

# 设置停止超时
docker compose restart -t 10 web
```

---

## rm — 删除已停止的容器

```bash
# 删除所有已停止的服务容器（交互确认）
docker compose rm

# 强制删除，不确认
docker compose rm -f

# 删除时同时移除匿名卷
docker compose rm -fv web
```

---

## run — 运行一次性命令

启动一个**新**容器执行命令后退出，适合迁移、测试、临时任务。

```bash
# 在 web 服务环境中运行一次性命令（会自动启动依赖服务）
docker compose run web python manage.py migrate

# 不启动依赖服务
docker compose run --no-deps web ./scripts/seed.sh

# 交互式运行（进入 shell）
docker compose run --rm web bash

# 运行后自动删除容器
docker compose run --rm web npm test

# 覆盖 entrypoint
docker compose run --entrypoint "redis-cli" redis ping

# 临时映射端口
docker compose run -p 8080:80 web

# 使用服务定义的全部端口映射
docker compose run --service-ports web
```

> `run` vs `exec`：`run` 创建新容器；`exec` 在已有容器中执行。

---

## scale — 扩展副本数

```bash
# 将 web 扩展到 3 个实例
docker compose scale web=3

# 同时扩展多个服务
docker compose scale web=3 worker=5
```

> 新版 Compose 更推荐在 `deploy.replicas` 或 `docker compose up --scale` 中设置副本数。

---

## start / stop — 启动与停止

```bash
# 启动已创建但未运行的容器
docker compose start

# 启动指定服务
docker compose start web db

# 启动并等待健康检查通过
docker compose start --wait web

# 优雅停止（默认 SIGTERM，超时后 SIGKILL）
docker compose stop

# 停止指定服务，10 秒超时
docker compose stop -t 10 web
```

---

## stats — 资源使用统计

```bash
# 实时显示所有运行中容器的 CPU/内存/网络/磁盘 IO
docker compose stats

# 只看 web
docker compose stats web

# 只输出一次快照（不持续刷新）
docker compose stats --no-stream
```

---

## top — 查看容器内进程

```bash
# 显示所有服务容器内的进程
docker compose top

# 只看 web
docker compose top web
```

---

## up — 创建并启动（最常用）

```bash
# 前台启动所有服务（Ctrl+C 停止）
docker compose up

# 后台启动（生产环境常用）
docker compose up -d

# 启动前先构建镜像
docker compose up -d --build

# 只启动 web 和 db
docker compose up -d web db

# 强制重新创建容器
docker compose up -d --force-recreate

# 扩展 web 为 3 个副本
docker compose up -d --scale web=3

# 启动并等待健康检查通过
docker compose up -d --wait

# 拉取最新镜像后启动
docker compose up -d --pull always

# 开发模式：监视文件变更自动重建
docker compose up --watch

# 移除孤立容器（不在 compose 文件中定义的旧容器）
docker compose up -d --remove-orphans
```

---

## version — 查看版本

```bash
# 完整版本信息
docker compose version

# 只显示版本号
docker compose version --short

# JSON 格式
docker compose version --format json
```

---

## volumes — 列出卷

```bash
# 列出项目使用的卷
docker compose volumes

# 只看 web 服务相关卷
docker compose volumes web

# 只显示卷名
docker compose volumes -q
```

---

## wait — 等待容器退出

阻塞直到指定服务（或全部服务）的容器停止，常用于脚本编排。

```bash
# 等待所有服务容器退出
docker compose wait

# 等待 web 退出
docker compose wait web

# 第一个容器退出时销毁整个项目
docker compose wait --down-project web worker
```

---

## watch — 监视源码自动重建

开发时监视构建上下文，文件变更后自动重建并刷新容器。

```bash
# 启动监视（会先 up，再 watch）
docker compose watch

# 只监视 web 服务
docker compose watch web

# 不先启动服务，仅监视
docker compose watch --no-up web
```

也可在 `up` 时直接启用：

```bash
docker compose up --watch
```

---

## 典型工作流示例

### 开发环境

```bash
docker compose up --build --watch          # 构建 + 启动 + 热重载
docker compose logs -f web                 # 跟踪日志
docker compose exec web bash               # 进入容器调试
docker compose down                        # 结束开发
```

### 生产部署

```bash
docker compose pull                        # 拉取最新镜像
docker compose up -d --wait                # 后台启动并等待健康
docker compose ps                          # 确认状态
docker compose logs --tail 50 web          # 检查启动日志
```

### 数据库迁移

```bash
docker compose run --rm web python manage.py migrate
docker compose run --rm web python manage.py createsuperuser
```

### 故障排查

```bash
docker compose ps -a                         # 查看退出容器
docker compose logs --tail 200 web           # 查看最近日志
docker compose exec web cat /app/config.yml  # 检查配置
docker compose top web                       # 查看进程
docker compose stats web                     # 查看资源占用
```

---

## 命令速查

| 场景 | 命令 |
|------|------|
| 启动应用 | `docker compose up -d` |
| 停止并清理 | `docker compose down` |
| 查看状态 | `docker compose ps` |
| 查看日志 | `docker compose logs -f` |
| 进入容器 | `docker compose exec SERVICE bash` |
| 一次性任务 | `docker compose run --rm SERVICE CMD` |
| 重新构建 | `docker compose build` / `up -d --build` |
| 拉取镜像 | `docker compose pull` |
| 验证配置 | `docker compose config` |
