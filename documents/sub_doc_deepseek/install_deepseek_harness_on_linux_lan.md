# linux下安装deepseek harness并配置区域网内反向代理。

## 第一阶段：后端

### （1）[可选]安装最新的node 
已经安装则跳过。

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash

. "$HOME/.nvm/nvm.sh"

nvm install 24

node -v # Should print "v24.19.0".

npm -v # Should print "11.17.0".
```

### （2）安装deepseek harness 
有别于官网安装方式，要全局安装。
```
npm install -g  @deepseek-ai/dsh

added 522 packages in 46s

66 packages are looking for funding
  run `npm fund` for details
#查看版本
dsh --version
0.1.0-rc.6
```

卸载方法：
```
npm uninstall -g @deepseek-ai/dsh

removed 522 packages in 543ms
```

### （3）配置局域网访问
DSH 出于安全考虑禁止 --host 0.0.0.0，默认只监听 127.0.0.1
修改一下文件，注意格式和缩进对齐。
```
~/.dsh/profiles/web/cordis.patch.yml

# ────────────────────────LAN 服务───────────────────────────────
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

### （4）启动，并放后台
```
dsh web &
dsh web: http://127.0.0.1:3080 (LAN: http://192.168.137.12:3080)
```

此时虽然能局域网访问，但仍有一部分终于功能因安全受限，需要完全的反向代理。


## 第二阶段：前端反向代理

### （1）安装反向
```
#原始仓库（git clone https://gitee.com/kill-life/dsh-lan-access.git）因dsh版本更新后没有及时适配，
#我在此库基础上做了适当修改，上传到我司的gitlab。如下：
git clone https://gitlab.fujikam.com:13671/device/ipc/dsh-lan-access.git

cd dsh-lan-access/

#1， 完整模式，并放后台:3443 -> 127.0.0.1:3080
node dsh-lan-tls-proxy.mjs &

,2，或 自定义前端端口
node dsh-lan-tls-proxy.mjs --port 4443 &

,3，或  安全透传模式（保持配置/凭据本机独占）
TRUST_LOCAL=false node dsh-lan-tls-proxy.mjs &
```

### （2）web访问
https://IP:3443

会提示警告，证书信任两种方法：一次性“继续访问”，或把cert.pem装进各机器信任库消除告警。

