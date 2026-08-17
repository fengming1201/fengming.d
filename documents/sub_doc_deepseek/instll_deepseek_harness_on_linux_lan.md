

# 第一阶段：后端

## [可选]安装最新的node 
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash

. "$HOME/.nvm/nvm.sh"

nvm install 24

node -v # Should print "v24.19.0".

npm -v # Should print "11.17.0".
```

## 安装deepseek harness 
```
npm install -g  @deepseek-ai/dsh

dsh --version
0.1.0-rc.6
```

## 配置局域网访问

```
~/.dsh/profiles/web/cordis.patch.yml

# ── LAN 服务 ──────────────────────────────────────────────────────────────
# 把 Web UI 绑到所有网卡，让任意局域网机器都能访问。
# 之后 dsh web 会在 http://<本机局域网IP>:3080 提供服务，/api 栅栏会自动
# 信任本机所有局域网 IP 字面量，局域网客户端即可驱动 agent。
#
# 安全注意：绑定 0.0.0.0 会把本机的 agent（远程代码执行）暴露给能到达本机
# 非回环地址的所有机器。settings / credentials / 模型目录 / 特权 host 端点
# 仍是 loopback-only，但 agent 本身已局域网可达。建议用防火墙收窄
# （如 ufw allow from <局域网网段> to any port 3080），用完即停。
- id: webserver
  config:
    host: 0.0.0.0
    port: !!js ctx.webStartup.port ?? 3080

```

## 启动
dsh web
dsh web: http://127.0.0.1:3080 (LAN: http://192.168.137.12:3080)


# 第二阶段：前端反代

## 安装反向
```
git clone https://gitee.com/kill-life/dsh-lan-access.git

cd dsh-lan-access/

#1， 完整模式，:3443 -> 127.0.0.1:3080
node dsh-lan-tls-proxy.mjs

,2，或 自定义前端端口
node dsh-lan-tls-proxy.mjs --port 4443

,3，或  安全透传模式（保持配置/凭据本机独占）
TRUST_LOCAL=false node dsh-lan-tls-proxy.mjs
```

## web访问
https://IP:3080


