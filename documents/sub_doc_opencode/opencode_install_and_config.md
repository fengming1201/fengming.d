# 安装

OpenCode 终端
```
[不好卸载]
curl -fsSL https://opencode.ai/install | bash

[推荐]
npm i -g opencode-ai

bun add -g opencode-ai

brew install anomalyco/tap/opencode

paru -S opencode

#使用 Docker
docker run -it --rm ghcr.io/anomalyco/opencode

```

# 配置
通过 OpenCode，你可以配置 API 密钥来使用任意 LLM 提供商。
在 TUI 中运行 /connect 命令，选择 deepseek,
```
/connect
```
登录并添加账单信息，然后复制你的 API 密钥。

粘贴你的 API 密钥。

┌ API key
│
│
└ enter


# 初级使用

## 初始化
配置好提供商后，导航到你想要处理的项目目录。

Terminal window
cd /path/to/project

然后运行 OpenCode。

Terminal window
opencode

接下来，运行以下命令为项目初始化 OpenCode。

/init

OpenCode 会分析你的项目并在项目根目录创建一个 AGENTS.md 文件。

提示

你应该将项目的 AGENTS.md 文件提交到 Git。

这有助于 OpenCode 理解项目结构和编码规范。


## 提问
你可以让 OpenCode 为你讲解代码库。

提示

使用 @ 键可以模糊搜索项目中的文件。

How is authentication handled in @packages/functions/src/api/index.ts

当你遇到不熟悉的代码时，这个功能非常有用。

## 添加功能
你可以让 OpenCode 为项目添加新功能。不过我们建议先让它制定一个计划。

制定计划

OpenCode 有一个计划模式，该模式下它不会进行任何修改，而是建议如何实现该功能。

使用 Tab 键切换到计划模式。你会在右下角看到模式指示器。

<TAB>

接下来描述你希望它做什么。

你需要提供足够的细节，让 OpenCode 理解你的需求。可以把它当作团队中的一名初级开发者来沟通。

提示

为 OpenCode 提供充足的上下文和示例，帮助它理解你的需求。

迭代计划

当它给出计划后，你可以提供反馈或补充更多细节。


提示

将图片拖放到终端中即可将其添加到提示词中。

OpenCode 可以扫描你提供的图片并将其添加到提示词中。只需将图片拖放到终端窗口即可。

构建功能

当你对计划满意后，再次按 Tab 键切换回构建模式。

<TAB>

然后让它开始实施。

直接修改
对于比较简单的修改，你可以直接让 OpenCode 实施，无需先审查计划。