
## （1）[可选]安装最新的node 
已经安装则跳过。官网：https://nodejs.org/zh-cn/download

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash

. "$HOME/.nvm/nvm.sh"

nvm install 24

node -v # Should print "v24.19.0".

npm -v # Should print "11.17.0".
```

## （2）安装最新的kimi code

要全局安装。
```
npm install -g @moonshot-ai/kimi-code

```
第一次启动
```
cd your-project
kimi

```
首次启动时需要配置 API 来源。在交互界面中输入 /login 进入登录流程：

/login

选择Kimi Platform (API key · platform.kimi.com)
输入kimi api key

