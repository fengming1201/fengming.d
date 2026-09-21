   当然，Kimi 已准备好提供帮助！只需发送一条消息即可开始。

键盘快捷键
     Shift-Tab             切换计划模式
     Ctrl-G                在外部编辑器中编辑（$VISUAL / $EDITOR）
     Ctrl-O                切换工具输出 / 压缩摘要的展开状态
     Ctrl-T                展开 / 折叠待办列表（当被截断时）
     Ctrl-S                引导（Steer）—— 在流式输出期间注入后续指令
     Shift-Enter / Ctrl-J  插入换行
     Ctrl-C                中断流式输出 / 清空输入
     Ctrl-D                退出（在输入为空时）
     Esc                   关闭对话框 / 中断流式输出
     ↑ / ↓                 浏览输入历史
     Enter                 提交

斜杠命令
     /add-dir                            添加或列出额外的工作区目录
     /auto                               永不询问模式：绝不打断你；一切自动运行并自动决定。
     /btw                                向一个派生出的旁路代理提问
     /check-kimi-code-docs               使用官方文档回答关于 Kimi Code 产品的问题 —— CLI 用法、配置、斜杠命令、功能、会员与配额、API 接入...
     /compact                            压缩对话上下文
     /copy                               将最后一条助手消息复制到剪贴板
     /custom-theme                       创建或编辑 kimi-code 自定义配色主题 —— 位于解析后的 KIMI_CODE_HOME 数据目录下的一个 JSON 文件，用于重新着色 TUI。当用户想要自己...
     /editor                             设置用于 Ctrl-G 的外部编辑器
     /effort (/thinking)                 切换思考强度
     /exit (/quit, /q)                   退出应用程序
     /experiments (/experimental)        管理实验性功能
     /export-debug-zip                   将当前会话导出为调试 ZIP 压缩包
     /export-md (/export)                将当前会话导出为 Markdown 文件
     /feedback (/bug)                    发送反馈，让 Kimi Code 变得更好
     /fork                               将当前会话派生为一个副本，但不切换到该副本
     /goal                               启动或管理一个自主目标
     /help (/h, /?)                      显示可用命令和快捷键
     /import-from-cc-codex               将 Claude Code 和 Codex 的指令、技能及 MCP 设置导入到 Kimi Code。
     /init                               分析代码库并生成 AGENTS.md
     /login                              选择平台并进行身份验证
     /logout (/disconnect)               登出已配置的提供方
     /mcp                                显示 MCP 服务器状态
     /mcp-config                         配置 MCP 服务器并处理 MCP OAuth 登录。
     /model                              切换 LLM 模型
     /new (/clear)                       在当前工作区中开始一个新会话
     /permission                         选择权限模式
     /plan                               切换计划模式
     /plugins                            管理插件
     /provider (/providers)              管理 AI 提供方（添加 / 删除 / 刷新）
     /reload                             重新加载会话并应用 config.toml 设置及 tui.toml 界面偏好
     /reload-tui                         仅重新加载 tui.toml 界面偏好
     /remote-control (/rc)               通过 Kimi 远程控制打开当前会话
     /secondary-model (/subagent-model)  为子代理配置次级模型
     /sessions (/resume)                 浏览并恢复会话
     /settings (/config)                 打开 TUI 设置
     /status                             显示当前会话和运行时状态
     /sub-skill                          发现并重组技能清单为分层级的子技能包。当用户要求审查、分组或将技能整合为一个父级包时使用。
     /sub-skill.consolidate              应用已批准的技能分组，将用户指定的技能移入一个父级包，并对每个被修改的目录进行带时间戳的备份。
     /sub-skill.review                   分析可用的技能集，并推荐可整合为子技能包的候选分组。只读 —— 仅提出方案，不移动文件。
     /swarm                              切换蜂群模式，或以蜂群模式运行一个任务
     /tasks (/task)                      浏览后台任务
     /theme                              设置终端界面主题
     /title (/rename)                    设置或显示会话标题
     /undo                               从对话记录中撤回上一条提示
     /update-config                      查看或编辑 kimi-code 自身的配置 —— `config.toml`（模型、提供方、权限、钩子）和 `tui.toml`（主题、编辑器、通知、自动更新）。当...
     /usage                              显示会话 token + 上下文窗口 + 套餐配额
     /version                            显示版本信息
     /web                                通过启动一个新服务器在 Web UI 中打开当前会话
     /write-goal                         帮助用户为 goal 模式精心制定一个定义明确的 `/goal` 目标 —— 将粗略的意图转化为一份完成契约，包含清晰的终点、证明、边界...
     /yolo (/yes)                        按需询问模式：常规编辑和命令自动运行；高风险操作、提问和计划仍会询问。
