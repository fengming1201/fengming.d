# GDB 命令帮助

## 命令类别列表

- **aliases** — 其他命令的别名。
- **breakpoints** — 使程序在特定位置停止。
- **data** — 检查数据。
- **files** — 指定并检查文件。
- **internals** — 维护命令。
- **obscure** — 晦涩功能。
- **running** — 运行程序。
- **stack** — 检查栈。
- **status** — 状态查询。
- **support** — 支持设施。
- **tracepoints** — 在不停止程序的情况下跟踪程序执行。
- **user-defined** — 用户自定义命令。
输入 "help" 加类别名可查看该类中的命令列表。
输入 "help all" 可查看所有命令列表。
输入 "help" 加命令名可查看完整文档。
输入 "apropos word" 可搜索与 "word" 相关的命令。
输入 "apropos -v word" 可查看与 "word" 相关命令的完整文档。
若缩写无歧义，则允许使用命令名缩写。

## `(gdb) help all`

==============================================================================================================

> 完整可跳转索引见文末 [目录](#目录)。

---

<h2 id="cat-aliases">命令类别：aliases（别名）</h2>

<h4 id="cmd-ni"><code>ni</code></h4>

单步执行一条指令，但会穿过子程序调用。

<h4 id="cmd-rc"><code>rc</code></h4>

继续运行被调试程序，但以反向方式执行。

<h4 id="cmd-rni"><code>rni</code></h4>

向后单步一条指令，但会穿过被调用的子程序。

<h4 id="cmd-rsi"><code>rsi</code></h4>

精确向后单步一条指令。

<h4 id="cmd-si"><code>si</code></h4>

精确单步执行一条指令。

<h4 id="cmd-stepping"><code>stepping</code></h4>

指定跟踪点处的单步行为。

<h4 id="cmd-tp"><code>tp</code></h4>

在指定位置设置跟踪点。

<h4 id="cmd-tty"><code>tty</code></h4>

为被调试程序今后的运行设置终端。

<h4 id="cmd-where"><code>where</code></h4>

打印所有栈帧的回溯，或最内层 COUNT 个栈帧。

<h4 id="cmd-ws"><code>ws</code></h4>

指定跟踪点处的单步行为。


---



[↑ 返回目录](#目录)

<h2 id="cat-breakpoints">命令类别：breakpoints（断点）</h2>

<h4 id="cmd-awatch"><code>awatch</code></h4>

为表达式设置监视点（访问时触发）。

<h4 id="cmd-break"><code>break</code></h4>

在指定位置设置断点。

<h4 id="cmd-break-range"><code>break-range</code></h4>

为地址范围设置断点。

<h4 id="cmd-catch"><code>catch</code></h4>

设置捕获点以捕获事件。

<p id="cmd-catch-assert"><code>catch assert</code> — 在 Ada 断言失败被抛出时捕获。</p>

<p id="cmd-catch-catch"><code>catch catch</code> — 在异常被捕获时捕获。</p>

<p id="cmd-catch-exception"><code>catch exception</code> — 在 Ada 异常被抛出时捕获。</p>

<p id="cmd-catch-exec"><code>catch exec</code> — 捕获对 exec 的调用。</p>

<p id="cmd-catch-fork"><code>catch fork</code> — 捕获对 fork 的调用。</p>

<p id="cmd-catch-handlers"><code>catch handlers</code> — 在 Ada 异常被处理时捕获。</p>

<p id="cmd-catch-load"><code>catch load</code> — 捕获共享库的加载。</p>

<p id="cmd-catch-rethrow"><code>catch rethrow</code> — 在异常被重新抛出时捕获。</p>

<p id="cmd-catch-signal"><code>catch signal</code> — 按名称和/或编号捕获信号。</p>

<p id="cmd-catch-syscall"><code>catch syscall</code> — 按名称、分组和/或编号捕获系统调用。</p>

<p id="cmd-catch-throw"><code>catch throw</code> — 在异常被抛出时捕获。</p>

<p id="cmd-catch-unload"><code>catch unload</code> — 捕获共享库的卸载。</p>

<p id="cmd-catch-vfork"><code>catch vfork</code> — 捕获对 vfork 的调用。</p>

<h4 id="cmd-clear"><code>clear</code></h4>

清除指定位置的断点。

<h4 id="cmd-commands"><code>commands</code></h4>

设置在给定断点命中时要执行的命令。

<h4 id="cmd-condition"><code>condition</code></h4>

指定断点编号 N 仅在 COND 为真时中断。

<h4 id="cmd-delete"><code>delete</code></h4>

删除全部或部分断点。

<p id="cmd-delete-bookmark"><code>delete bookmark</code> — 从书签列表中删除书签。</p>

<p id="cmd-delete-breakpoints"><code>delete breakpoints</code> — 删除全部或部分断点或自动显示表达式。</p>

<p id="cmd-delete-display"><code>delete display</code> — 取消程序停止时要显示的部分表达式。</p>

<p id="cmd-delete-mem"><code>delete mem</code> — 删除内存区域。</p>

<p id="cmd-delete-tracepoints"><code>delete tracepoints</code> — 删除指定的跟踪点。</p>

<p id="cmd-delete-tvariable"><code>delete tvariable</code> — 删除一个或多个跟踪状态变量。</p>

<h4 id="cmd-disable"><code>disable</code></h4>

禁用全部或部分断点。

<p id="cmd-disable-breakpoints"><code>disable breakpoints</code> — 禁用全部或部分断点。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-disable-display"><code>disable display</code> — 禁用程序停止时要显示的部分表达式。</p>

<p id="cmd-disable-mem"><code>disable mem</code> — 禁用内存区域。</p>

<p id="cmd-disable-probes"><code>disable probes</code> — 禁用探针。</p>

<h4 id="cmd-dprintf"><code>dprintf</code></h4>

在指定位置设置动态 printf。

<h4 id="cmd-enable"><code>enable</code></h4>

启用全部或部分断点。

<p id="cmd-enable-breakpoints"><code>enable breakpoints</code> — 启用全部或部分断点。</p>

<p id="cmd-enable-breakpoints-count"><code>enable breakpoints count</code> — 启用部分断点，命中 COUNT 次后失效。</p>

<p id="cmd-enable-breakpoints-delete"><code>enable breakpoints delete</code> — 启用部分断点，命中后删除。</p>

<p id="cmd-enable-breakpoints-once"><code>enable breakpoints once</code> — 启用部分断点，仅命中一次。</p>

<p id="cmd-enable-count"><code>enable count</code> — 启用部分断点，命中 COUNT 次后失效。</p>

<p id="cmd-enable-delete"><code>enable delete</code> — 启用部分断点，命中后删除。</p>

<p id="cmd-enable-display"><code>enable display</code> — 启用程序停止时要显示的部分表达式。</p>

<p id="cmd-enable-mem"><code>enable mem</code> — 启用内存区域。</p>

<p id="cmd-enable-once"><code>enable once</code> — 启用部分断点，仅命中一次。</p>

<p id="cmd-enable-probes"><code>enable probes</code> — 启用探针。</p>

<h4 id="cmd-ftrace"><code>ftrace</code></h4>

在指定位置设置快速跟踪点。

<h4 id="cmd-hbreak"><code>hbreak</code></h4>

设置硬件辅助断点。

<h4 id="cmd-ignore"><code>ignore</code></h4>

将断点编号 N 的忽略计数设为 COUNT。

<h4 id="cmd-rbreak"><code>rbreak</code></h4>

为所有匹配 REGEXP 的函数设置断点。

<h4 id="cmd-rwatch"><code>rwatch</code></h4>

为表达式设置读监视点。

<h4 id="cmd-save"><code>save</code></h4>

将断点定义保存为脚本。

<p id="cmd-save-breakpoints"><code>save breakpoints</code> — 将当前断点定义保存为脚本。</p>

<p id="cmd-save-gdb-index"><code>save gdb-index</code> — 保存 gdb-index 文件。</p>

<p id="cmd-save-tracepoints"><code>save tracepoints</code> — 将当前跟踪点定义保存为脚本。</p>

<h4 id="cmd-skip"><code>skip</code></h4>

单步时忽略某个函数。

<p id="cmd-skip-delete"><code>skip delete</code> — 删除 skip 条目。</p>

<p id="cmd-skip-disable"><code>skip disable</code> — 禁用 skip 条目。</p>

<p id="cmd-skip-enable"><code>skip enable</code> — 启用 skip 条目。</p>

<p id="cmd-skip-file"><code>skip file</code> — 单步时忽略某个文件。</p>

<p id="cmd-skip-function"><code>skip function</code> — 单步时忽略某个函数。</p>

<h4 id="cmd-strace"><code>strace</code></h4>

在位置或标记处设置静态跟踪点。

<h4 id="cmd-tbreak"><code>tbreak</code></h4>

设置临时断点。

<h4 id="cmd-tcatch"><code>tcatch</code></h4>

设置临时捕获点以捕获事件。

<p id="cmd-tcatch-assert"><code>tcatch assert</code> — 在 Ada 断言失败被抛出时捕获。</p>

<p id="cmd-tcatch-catch"><code>tcatch catch</code> — 在异常被捕获时捕获。</p>

<p id="cmd-tcatch-exception"><code>tcatch exception</code> — 在 Ada 异常被抛出时捕获。</p>

<p id="cmd-tcatch-exec"><code>tcatch exec</code> — 捕获对 exec 的调用。</p>

<p id="cmd-tcatch-fork"><code>tcatch fork</code> — 捕获对 fork 的调用。</p>

<p id="cmd-tcatch-handlers"><code>tcatch handlers</code> — 在 Ada 异常被处理时捕获。</p>

<p id="cmd-tcatch-load"><code>tcatch load</code> — 捕获共享库的加载。</p>

<p id="cmd-tcatch-rethrow"><code>tcatch rethrow</code> — 在异常被重新抛出时捕获。</p>

<p id="cmd-tcatch-signal"><code>tcatch signal</code> — 按名称和/或编号捕获信号。</p>

<p id="cmd-tcatch-syscall"><code>tcatch syscall</code> — 按名称、分组和/或编号捕获系统调用。</p>

<p id="cmd-tcatch-throw"><code>tcatch throw</code> — 在异常被抛出时捕获。</p>

<p id="cmd-tcatch-unload"><code>tcatch unload</code> — 捕获共享库的卸载。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-tcatch-vfork"><code>tcatch vfork</code> — 捕获对 vfork 的调用。</p>

<h4 id="cmd-thbreak"><code>thbreak</code></h4>

设置临时硬件辅助断点。

<h4 id="cmd-trace"><code>trace</code></h4>

在指定位置设置跟踪点。

<h4 id="cmd-watch"><code>watch</code></h4>

为表达式设置监视点。


---



[↑ 返回目录](#目录)

<h2 id="cat-data">命令类别：data（数据）</h2>

<h4 id="cmd-agent-printf"><code>agent-printf</code></h4>

仅由目标 agent 执行的格式化打印，类似 C 的 "printf" 函数。

<h4 id="cmd-append"><code>append</code></h4>

将目标代码/数据追加到本地文件。

<p id="cmd-append-binary"><code>append binary</code> — 将目标代码/数据追加到原始二进制文件。</p>

<p id="cmd-append-binary-memory"><code>append binary memory</code> — 将内存内容追加到原始二进制文件。</p>

<p id="cmd-append-binary-value"><code>append binary value</code> — 将表达式的值追加到原始二进制文件。</p>

<p id="cmd-append-memory"><code>append memory</code> — 将内存内容追加到原始二进制文件。</p>

<p id="cmd-append-value"><code>append value</code> — 将表达式的值追加到原始二进制文件。</p>

<h4 id="cmd-call"><code>call</code></h4>

调用程序中的函数。

<h4 id="cmd-disassemble"><code>disassemble</code></h4>

反汇编指定的内存段。

<h4 id="cmd-display"><code>display</code></h4>

每次程序停止时打印表达式 EXP 的值。

<h4 id="cmd-dump"><code>dump</code></h4>

将目标代码/数据转储到本地文件。

<p id="cmd-dump-binary"><code>dump binary</code> — 将目标代码/数据写入原始二进制文件。</p>

<p id="cmd-dump-binary-memory"><code>dump binary memory</code> — 将内存内容写入原始二进制文件。</p>

<p id="cmd-dump-binary-value"><code>dump binary value</code> — 将表达式的值写入原始二进制文件。</p>

<p id="cmd-dump-ihex"><code>dump ihex</code> — 将目标代码/数据写入 Intel hex 文件。</p>

<p id="cmd-dump-ihex-memory"><code>dump ihex memory</code> — 将内存内容写入 ihex 文件。</p>

<p id="cmd-dump-ihex-value"><code>dump ihex value</code> — 将表达式的值写入 ihex 文件。</p>

<p id="cmd-dump-memory"><code>dump memory</code> — 将内存内容写入原始二进制文件。</p>

<p id="cmd-dump-srec"><code>dump srec</code> — 将目标代码/数据写入 srec 文件。</p>

<p id="cmd-dump-srec-memory"><code>dump srec memory</code> — 将内存内容写入 srec 文件。</p>

<p id="cmd-dump-srec-value"><code>dump srec value</code> — 将表达式的值写入 srec 文件。</p>

<p id="cmd-dump-tekhex"><code>dump tekhex</code> — 将目标代码/数据写入 tekhex 文件。</p>

<p id="cmd-dump-tekhex-memory"><code>dump tekhex memory</code> — 将内存内容写入 tekhex 文件。</p>

<p id="cmd-dump-tekhex-value"><code>dump tekhex value</code> — 将表达式的值写入 tekhex 文件。</p>

<p id="cmd-dump-value"><code>dump value</code> — 将表达式的值写入原始二进制文件。</p>

<p id="cmd-dump-verilog"><code>dump verilog</code> — 将目标代码/数据写入 Verilog hex 文件。</p>

<p id="cmd-dump-verilog-memory"><code>dump verilog memory</code> — 将内存内容写入 Verilog hex 文件。</p>

<p id="cmd-dump-verilog-value"><code>dump verilog value</code> — 将表达式的值写入 Verilog hex 文件。</p>

<h4 id="cmd-find"><code>find</code></h4>

在内存中搜索字节序列。

<h4 id="cmd-init-if-undefined"><code>init-if-undefined</code></h4>

如有必要则初始化便利变量。

<h4 id="cmd-mem"><code>mem</code></h4>

定义内存区域属性，或将内存区域处理重置为基于目标的方式。

<h4 id="cmd-output"><code>output</code></h4>

类似 "print"，但不记入值历史且不换行。

<h4 id="cmd-print"><code>print</code></h4>

打印表达式 EXP 的值。

<h4 id="cmd-print-object"><code>print-object</code></h4>

让 Objective-C 对象自行打印。

<h4 id="cmd-printf"><code>printf</code></h4>

格式化打印，类似 C 的 "printf" 函数。

<h4 id="cmd-ptype"><code>ptype</code></h4>

打印类型 TYPE 的定义。

<h4 id="cmd-restore"><code>restore</code></h4>

将 FILE 的内容恢复到目标内存。

<h4 id="cmd-set"><code>set</code></h4>

求值表达式 EXP 并将结果赋给变量 VAR。


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-ada"><code>set ada</code> — 用于修改 Ada 相关设置的前缀命令。</p>

<p id="cmd-set-ada-print-signatures"><code>set ada print-signatures</code> — 启用或禁用在重载选择菜单中输出函数的形式参数和返回类型。</p>

<p id="cmd-set-ada-trust-pad-over-xvs"><code>set ada trust-PAD-over-XVS</code> — 启用或禁用信任 PAD 类型优于 XVS 类型的优化。</p>

<p id="cmd-set-agent"><code>set agent</code> — 设置调试器是否愿意使用 agent 作为辅助。</p>

<p id="cmd-set-annotate"><code>set annotate</code> — 设置 annotation_level。</p>

<p id="cmd-set-architecture"><code>set architecture</code> — 设置目标架构。</p>

<p id="cmd-set-args"><code>set args</code> — 设置被调试程序启动时传入的参数列表。</p>

<p id="cmd-set-arm"><code>set arm</code> — 各种 ARM 相关命令。</p>

<p id="cmd-set-arm-abi"><code>set arm abi</code> — 设置 ABI。</p>

<p id="cmd-set-arm-apcs32"><code>set arm apcs32</code> — 设置 ARM 32 位模式的使用。</p>

<p id="cmd-set-arm-disassembler"><code>set arm disassembler</code> — 设置反汇编风格。</p>

<p id="cmd-set-arm-fallback-mode"><code>set arm fallback-mode</code> — 设置符号不可用时的假定模式。</p>

<p id="cmd-set-arm-force-mode"><code>set arm force-mode</code> — 设置即使符号可用时也假定的模式。</p>

<p id="cmd-set-arm-fpu"><code>set arm fpu</code> — 设置浮点类型。</p>

<p id="cmd-set-auto-connect-native-target"><code>set auto-connect-native-target</code> — 设置 GDB 是否可自动连接到本机目标。</p>

<p id="cmd-set-auto-load"><code>set auto-load</code> — 自动加载相关设置。</p>

<p id="cmd-set-auto-load-gdb-scripts"><code>set auto-load gdb-scripts</code> — 启用或禁用自动加载预制命令序列脚本。</p>

<p id="cmd-set-auto-load-local-gdbinit"><code>set auto-load local-gdbinit</code> — 启用或禁用自动加载当前目录中的 .gdbinit 脚本。</p>

<p id="cmd-set-auto-load-safe-path"><code>set auto-load safe-path</code> — 设置可安全自动加载的文件和目录列表。</p>

<p id="cmd-set-auto-load-scripts-directory"><code>set auto-load scripts-directory</code> — 设置从中加载自动脚本的目录列表。</p>

<p id="cmd-set-auto-solib-add"><code>set auto-solib-add</code> — 设置共享库符号的自动加载。</p>

<p id="cmd-set-backtrace"><code>set backtrace</code> — 设置回溯相关变量。</p>

<p id="cmd-set-backtrace-limit"><code>set backtrace limit</code> — 设置回溯层数的上限。</p>

<p id="cmd-set-backtrace-past-entry"><code>set backtrace past-entry</code> — 设置回溯是否应越过程序入口点继续。</p>

<p id="cmd-set-backtrace-past-main"><code>set backtrace past-main</code> — 设置回溯是否应越过 "main" 继续。</p>

<p id="cmd-set-basenames-may-differ"><code>set basenames-may-differ</code> — 设置源文件是否可有多个基本名。</p>

<p id="cmd-set-breakpoint"><code>set breakpoint</code> — 断点相关设置。</p>

<p id="cmd-set-breakpoint-always-inserted"><code>set breakpoint always-inserted</code> — 设置插入断点的模式。</p>

<p id="cmd-set-breakpoint-auto-hw"><code>set breakpoint auto-hw</code> — 设置是否自动使用硬件断点。</p>

<p id="cmd-set-breakpoint-condition-evaluation"><code>set breakpoint condition-evaluation</code> — 设置断点条件求值模式。</p>

<p id="cmd-set-breakpoint-pending"><code>set breakpoint pending</code> — 设置调试器对待决断点的行为。</p>

<p id="cmd-set-can-use-hw-watchpoints"><code>set can-use-hw-watchpoints</code> — 设置调试器是否愿意使用监视点硬件。</p>

<p id="cmd-set-case-sensitive"><code>set case-sensitive</code> — 设置名称搜索的大小写敏感性（on/off/auto）。</p>

<p id="cmd-set-charset"><code>set charset</code> — 设置主机和目标字符集。</p>

<p id="cmd-set-check"><code>set check</code> — 设置类型/范围检查器的状态。</p>

<p id="cmd-set-check-range"><code>set check range</code> — 设置范围检查（on/warn/off/auto）。</p>

<p id="cmd-set-check-type"><code>set check type</code> — 设置严格类型检查。</p>

<p id="cmd-set-circular-trace-buffer"><code>set circular-trace-buffer</code> — 设置目标是否使用环形跟踪缓冲区。</p>

<p id="cmd-set-code-cache"><code>set code-cache</code> — 设置代码段访问的缓存使用。</p>

<p id="cmd-set-coerce-float-to-double"><code>set coerce-float-to-double</code> — 设置调用函数时是否将 float 强制转换为 double。</p>

<p id="cmd-set-compile-args"><code>set compile-args</code> — 设置编译命令的 GCC 命令行参数。</p>

<p id="cmd-set-compile-gcc"><code>set compile-gcc</code> — 设置编译命令的 GCC 驱动程序文件名。</p>

<p id="cmd-set-complaints"><code>set complaints</code> — 设置关于错误符号的最大抱怨次数。</p>

<p id="cmd-set-confirm"><code>set confirm</code> — 设置是否确认潜在危险操作。</p>

<p id="cmd-set-cp-abi"><code>set cp-abi</code> — 设置用于检查 C++ 对象的 ABI。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-cwd"><code>set cwd</code> — 设置 inferior 启动时使用的当前工作目录。</p>

<p id="cmd-set-data-directory"><code>set data-directory</code> — 设置 GDB 的数据目录。</p>

<p id="cmd-set-dcache"><code>set dcache</code> — 使用此命令设置 dcache 的行数和行大小。</p>

<p id="cmd-set-dcache-line-size"><code>set dcache line-size</code> — 设置 dcache 行大小（字节，必须为 2 的幂）。</p>

<p id="cmd-set-dcache-size"><code>set dcache size</code> — 设置 dcache 行数。</p>

<p id="cmd-set-debug"><code>set debug</code> — 用于设置 gdb 调试标志的通用命令。</p>

<p id="cmd-set-debug-arch"><code>set debug arch</code> — 设置架构调试。</p>

<p id="cmd-set-debug-arm"><code>set debug arm</code> — 设置 ARM 调试。</p>

<p id="cmd-set-debug-auto-load"><code>set debug auto-load</code> — 设置自动加载验证调试。</p>

<p id="cmd-set-debug-bfd-cache"><code>set debug bfd-cache</code> — 设置 bfd 缓存调试。</p>

<p id="cmd-set-debug-check-physname"><code>set debug check-physname</code> — 设置 "physname" 代码与 demangler 的交叉检查。</p>

<p id="cmd-set-debug-coff-pe-read"><code>set debug coff-pe-read</code> — 设置 coff PE 读取调试。</p>

<p id="cmd-set-debug-compile"><code>set debug compile</code> — 设置编译命令调试。</p>

<p id="cmd-set-debug-compile-cplus-scopes"><code>set debug compile-cplus-scopes</code> — 设置 C++ 编译作用域调试。</p>

<p id="cmd-set-debug-compile-cplus-types"><code>set debug compile-cplus-types</code> — 设置 C++ 编译类型转换调试。</p>

<p id="cmd-set-debug-displaced"><code>set debug displaced</code> — 设置 displaced stepping 调试。</p>

<p id="cmd-set-debug-dwarf-die"><code>set debug dwarf-die</code> — 设置 DWARF DIE 读取器调试。</p>

<p id="cmd-set-debug-dwarf-line"><code>set debug dwarf-line</code> — 设置 dwarf 行读取器调试。</p>

<p id="cmd-set-debug-dwarf-read"><code>set debug dwarf-read</code> — 设置 DWARF 读取器调试。</p>

<p id="cmd-set-debug-entry-values"><code>set debug entry-values</code> — 设置入口值和尾调用帧调试。</p>

<p id="cmd-set-debug-expression"><code>set debug expression</code> — 设置表达式调试。</p>

<p id="cmd-set-debug-frame"><code>set debug frame</code> — 设置帧调试。</p>

<p id="cmd-set-debug-index-cache"><code>set debug index-cache</code> — 设置是否显示 index-cache 调试消息。</p>

<p id="cmd-set-debug-infrun"><code>set debug infrun</code> — 设置 inferior 调试。</p>

<p id="cmd-set-debug-jit"><code>set debug jit</code> — 设置 JIT 调试。</p>

<p id="cmd-set-debug-notification"><code>set debug notification</code> — 设置异步远程通知调试。</p>

<p id="cmd-set-debug-observer"><code>set debug observer</code> — 设置 observer 调试。</p>

<p id="cmd-set-debug-overload"><code>set debug overload</code> — 设置 C++ 重载调试。</p>

<p id="cmd-set-debug-parser"><code>set debug parser</code> — 设置解析器调试。</p>

<p id="cmd-set-debug-record"><code>set debug record</code> — 设置 record/replay 功能调试。</p>

<p id="cmd-set-debug-remote"><code>set debug remote</code> — 设置远程协议调试。</p>

<p id="cmd-set-debug-remote-packet-max-chars"><code>set debug remote-packet-max-chars</code> — 设置每个远程包显示的最大字符数。</p>

<p id="cmd-set-debug-separate-debug-file"><code>set debug separate-debug-file</code> — 设置是否打印独立调试信息文件搜索的调试输出。</p>

<p id="cmd-set-debug-serial"><code>set debug serial</code> — 设置串口调试。</p>

<p id="cmd-set-debug-skip"><code>set debug skip</code> — 设置是否打印关于跳过文件和函数的调试输出。</p>

<p id="cmd-set-debug-stap-expression"><code>set debug stap-expression</code> — 设置 SystemTap 表达式调试。</p>

<p id="cmd-set-debug-symbol-lookup"><code>set debug symbol-lookup</code> — 设置符号查找调试。</p>

<p id="cmd-set-debug-symfile"><code>set debug symfile</code> — 设置 symfile 函数调试。</p>

<p id="cmd-set-debug-symtab-create"><code>set debug symtab-create</code> — 设置符号表创建调试。</p>

<p id="cmd-set-debug-target"><code>set debug target</code> — 设置目标调试。</p>

<p id="cmd-set-debug-timestamp"><code>set debug timestamp</code> — 设置是否为调试消息添加时间戳。</p>

<p id="cmd-set-debug-varobj"><code>set debug varobj</code> — 设置 varobj 调试。</p>

<p id="cmd-set-debug-xml"><code>set debug xml</code> — 设置 XML 解析器调试。</p>

<p id="cmd-set-debug-file-directory"><code>set debug-file-directory</code> — 设置搜索独立调试符号的目录。</p>

<p id="cmd-set-default-collect"><code>set default-collect</code> — 设置默认要收集的表达式列表。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-demangle-style"><code>set demangle-style</code> — 设置当前 C++ 还原符号风格。</p>

<p id="cmd-set-detach-on-fork"><code>set detach-on-fork</code> — 设置 gdb 是否在 fork 后分离子进程。</p>

<p id="cmd-set-directories"><code>set directories</code> — 设置查找源文件的搜索路径。</p>

<p id="cmd-set-disable-randomization"><code>set disable-randomization</code> — 设置是否禁用被调试进程的虚拟地址空间随机化。</p>

<p id="cmd-set-disassemble-next-line"><code>set disassemble-next-line</code> — 设置执行停止时是否反汇编下一条源行或指令。</p>

<p id="cmd-set-disassembler-options"><code>set disassembler-options</code> — 设置反汇编器选项。</p>

<p id="cmd-set-disconnected-dprintf"><code>set disconnected-dprintf</code> — 设置 GDB 断开后 dprintf 是否继续。</p>

<p id="cmd-set-disconnected-tracing"><code>set disconnected-tracing</code> — 设置 GDB 断开后跟踪是否继续。</p>

<p id="cmd-set-displaced-stepping"><code>set displaced-stepping</code> — 设置调试器是否愿意使用 displaced stepping。</p>

<p id="cmd-set-dprintf-channel"><code>set dprintf-channel</code> — 设置动态 printf 使用的通道。</p>

<p id="cmd-set-dprintf-function"><code>set dprintf-function</code> — 设置动态 printf 使用的函数。</p>

<p id="cmd-set-dprintf-style"><code>set dprintf-style</code> — 设置动态 printf 的使用风格。</p>

<p id="cmd-set-dump-excluded-mappings"><code>set dump-excluded-mappings</code> — 设置 gcore 是否转储带 VM_DONTDUMP 标志的映射。</p>

<p id="cmd-set-editing"><code>set editing</code> — 设置是否在输入时编辑命令行。</p>

<p id="cmd-set-endian"><code>set endian</code> — 设置目标字节序。</p>

<p id="cmd-set-environment"><code>set environment</code> — 设置传给程序的环境变量值。</p>

<p id="cmd-set-exec-direction"><code>set exec-direction</code> — 设置执行方向。</p>

<p id="cmd-set-exec-done-display"><code>set exec-done-display</code> — 设置异步执行命令完成时的通知。</p>

<p id="cmd-set-extension-language"><code>set extension-language</code> — 设置文件名扩展名与源语言的映射。</p>

<p id="cmd-set-filename-display"><code>set filename-display</code> — 设置如何显示文件名。</p>

<p id="cmd-set-follow-exec-mode"><code>set follow-exec-mode</code> — 设置调试器对程序调用 exec 的响应。</p>

<p id="cmd-set-follow-fork-mode"><code>set follow-fork-mode</code> — 设置调试器对程序调用 fork 或 vfork 的响应。</p>

<p id="cmd-set-gnutarget"><code>set gnutarget</code> — 设置当前 BFD 目标。</p>

<p id="cmd-set-guile"><code>set guile</code> — Guile 偏好设置的前缀命令。</p>

<p id="cmd-set-guile-print-stack"><code>set guile print-stack</code> — 设置出错时 Guile 异常打印模式。</p>

<p id="cmd-set-height"><code>set height</code> — 设置 GDB 输出分页时每页行数。</p>

<p id="cmd-set-history"><code>set history</code> — 用于设置命令历史参数的通用命令。</p>

<p id="cmd-set-history-expansion"><code>set history expansion</code> — 设置命令输入的历史展开。</p>

<p id="cmd-set-history-filename"><code>set history filename</code> — 设置记录命令历史的文件名。</p>

<p id="cmd-set-history-remove-duplicates"><code>set history remove-duplicates</code> — 设置在历史中向后查找并删除重复条目的范围。</p>

<p id="cmd-set-history-save"><code>set history save</code> — 设置退出时是否保存历史记录。</p>

<p id="cmd-set-history-size"><code>set history size</code> — 设置命令历史大小。</p>

<p id="cmd-set-host-charset"><code>set host-charset</code> — 设置主机字符集。</p>

<p id="cmd-set-index-cache"><code>set index-cache</code> — 设置 index-cache 选项。</p>

<p id="cmd-set-index-cache-directory"><code>set index-cache directory</code> — 设置 index cache 的目录。</p>

<p id="cmd-set-index-cache-off"><code>set index-cache off</code> — 禁用 index cache。</p>

<p id="cmd-set-index-cache-on"><code>set index-cache on</code> — 启用 index cache。</p>

<p id="cmd-set-inferior-tty"><code>set inferior-tty</code> — 为被调试程序今后的运行设置终端。</p>

<p id="cmd-set-input-radix"><code>set input-radix</code> — 设置输入数字的默认进制。</p>

<p id="cmd-set-interactive-mode"><code>set interactive-mode</code> — 设置 GDB 标准输入是否为终端。</p>

<p id="cmd-set-language"><code>set language</code> — 设置当前源语言。</p>

<p id="cmd-set-listsize"><code>set listsize</code> — 设置 gdb 默认列出的源行数。</p>

<p id="cmd-set-logging"><code>set logging</code> — 设置日志选项。</p>

<p id="cmd-set-logging-debugredirect"><code>set logging debugredirect</code> — 设置日志调试输出模式。</p>

<p id="cmd-set-logging-file"><code>set logging file</code> — 设置当前日志文件。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-logging-off"><code>set logging off</code> — 禁用日志。</p>

<p id="cmd-set-logging-on"><code>set logging on</code> — 启用日志。</p>

<p id="cmd-set-logging-overwrite"><code>set logging overwrite</code> — 设置日志是覆盖还是追加到日志文件。</p>

<p id="cmd-set-logging-redirect"><code>set logging redirect</code> — 设置日志输出模式。</p>

<p id="cmd-set-max-completions"><code>set max-completions</code> — 设置补全候选的最大数量。</p>

<p id="cmd-set-max-user-call-depth"><code>set max-user-call-depth</code> — 设置非 python/scheme 用户自定义命令的最大调用深度。</p>

<p id="cmd-set-max-value-size"><code>set max-value-size</code> — 设置 gdb 从 inferior 加载的值的最大尺寸。</p>

<p id="cmd-set-may-call-functions"><code>set may-call-functions</code> — 设置是否允许调用程序中的函数。</p>

<p id="cmd-set-may-insert-breakpoints"><code>set may-insert-breakpoints</code> — 设置是否允许在目标中插入断点。</p>

<p id="cmd-set-may-insert-fast-tracepoints"><code>set may-insert-fast-tracepoints</code> — 设置是否允许在目标中插入快速跟踪点。</p>

<p id="cmd-set-may-insert-tracepoints"><code>set may-insert-tracepoints</code> — 设置是否允许在目标中插入跟踪点。</p>

<p id="cmd-set-may-interrupt"><code>set may-interrupt</code> — 设置是否允许中断或向目标发信号。</p>

<p id="cmd-set-may-write-memory"><code>set may-write-memory</code> — 设置是否允许写入目标内存。</p>

<p id="cmd-set-may-write-registers"><code>set may-write-registers</code> — 设置是否允许写入寄存器。</p>

<p id="cmd-set-mem"><code>set mem</code> — 内存区域设置。</p>

<p id="cmd-set-mem-inaccessible-by-default"><code>set mem inaccessible-by-default</code> — 设置未知内存区域的处理方式。</p>

<p id="cmd-set-mi-async"><code>set mi-async</code> — 设置是否启用 MI 异步模式。</p>

<p id="cmd-set-multiple-symbols"><code>set multiple-symbols</code> — 设置调试器如何处理表达式中的歧义。</p>

<p id="cmd-set-non-stop"><code>set non-stop</code> — 设置 gdb 是否以 non-stop 模式控制 inferior。</p>

<p id="cmd-set-observer"><code>set observer</code> — 设置 gdb 是否以 observer 模式控制 inferior。</p>

<p id="cmd-set-opaque-type-resolution"><code>set opaque-type-resolution</code> — 设置不透明 struct/class/union 类型的解析（须在加载符号前设置）。</p>

<p id="cmd-set-osabi"><code>set osabi</code> — 设置目标的 OS ABI。</p>

<p id="cmd-set-output-radix"><code>set output-radix</code> — 设置打印值的默认输出进制。</p>

<p id="cmd-set-overload-resolution"><code>set overload-resolution</code> — 设置求值 C++ 函数时的重载解析。</p>

<p id="cmd-set-pagination"><code>set pagination</code> — 设置 GDB 输出分页状态。</p>

<p id="cmd-set-print"><code>set print</code> — 用于设置打印方式的通用命令。</p>

<p id="cmd-set-print-address"><code>set print address</code> — 设置是否打印地址。</p>

<p id="cmd-set-print-array"><code>set print array</code> — 设置数组的美化格式。</p>

<p id="cmd-set-print-array-indexes"><code>set print array-indexes</code> — 设置是否打印数组下标。</p>

<p id="cmd-set-print-asm-demangle"><code>set print asm-demangle</code> — 设置反汇编列表中 C++/ObjC 名称的还原。</p>

<p id="cmd-set-print-demangle"><code>set print demangle</code> — 设置显示符号时是否还原编码的 C++/ObjC 名称。</p>

<p id="cmd-set-print-elements"><code>set print elements</code> — 设置字符串字符或数组元素打印的上限。</p>

<p id="cmd-set-print-entry-values"><code>set print entry-values</code> — 设置是否在函数入口打印函数参数。</p>

<p id="cmd-set-print-finish"><code>set print finish</code> — 设置 `finish' 是否打印返回值。</p>

<p id="cmd-set-print-frame-arguments"><code>set print frame-arguments</code> — 设置是否打印非标量帧参数。</p>

<p id="cmd-set-print-frame-info"><code>set print frame-info</code> — 设置是否打印帧信息。</p>

<p id="cmd-set-print-inferior-events"><code>set print inferior-events</code> — 设置是否打印 inferior 事件（如启动和退出）。</p>

<p id="cmd-set-print-max-depth"><code>set print max-depth</code> — 设置嵌套结构体、联合体和数组的最大打印深度。</p>

<p id="cmd-set-print-max-symbolic-offset"><code>set print max-symbolic-offset</code> — 设置以 <SYMBOL+1234> 形式打印的最大偏移。</p>

<p id="cmd-set-print-null-stop"><code>set print null-stop</code> — 设置字符数组是否在首个空字符处停止打印。</p>

<p id="cmd-set-print-object"><code>set print object</code> — 设置是否打印 C++ 虚函数表。</p>

<p id="cmd-set-print-pascal-static-members"><code>set print pascal_static-members</code> — 设置是否打印 Pascal 静态成员。</p>

<p id="cmd-set-print-pretty"><code>set print pretty</code> — 设置结构体的美化格式。</p>

<p id="cmd-set-print-raw-frame-arguments"><code>set print raw-frame-arguments</code> — 设置是否以原始形式打印帧参数。</p>

<p id="cmd-set-print-raw-values"><code>set print raw-values</code> — 设置是否以原始形式打印值。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-print-repeats"><code>set print repeats</code> — 设置重复打印元素的阈值。</p>

<p id="cmd-set-print-sevenbit-strings"><code>set print sevenbit-strings</code> — 设置字符串中 8 位字符是否以 \nnn 形式打印。</p>

<p id="cmd-set-print-static-members"><code>set print static-members</code> — 设置是否打印 C++ 静态成员。</p>

<p id="cmd-set-print-symbol"><code>set print symbol</code> — 设置打印指针时是否打印符号名。</p>

<p id="cmd-set-print-symbol-filename"><code>set print symbol-filename</code> — 设置是否在 <SYMBOL> 旁打印源文件名和行号。</p>

<p id="cmd-set-print-symbol-loading"><code>set print symbol-loading</code> — 设置是否打印符号加载消息。</p>

<p id="cmd-set-print-thread-events"><code>set print thread-events</code> — 设置是否打印线程事件（如线程启动和退出）。</p>

<p id="cmd-set-print-type"><code>set print type</code> — 用于设置类型打印方式的通用命令。</p>

<p id="cmd-set-print-type-methods"><code>set print type methods</code> — 设置是否打印类中定义的方法。</p>

<p id="cmd-set-print-type-nested-type-limit"><code>set print type nested-type-limit</code> — 设置要打印的递归嵌套类型定义数量（"unlimited" 或 -1 表示全部）。</p>

<p id="cmd-set-print-type-typedefs"><code>set print type typedefs</code> — 设置是否打印类中定义的 typedef。</p>

<p id="cmd-set-print-union"><code>set print union</code> — 设置是否打印结构体内部的联合体。</p>

<p id="cmd-set-print-vtbl"><code>set print vtbl</code> — 设置是否打印 C++ 虚函数表。</p>

<p id="cmd-set-prompt"><code>set prompt</code> — 设置 gdb 提示符。</p>

<p id="cmd-set-python"><code>set python</code> — Python 偏好设置的前缀命令。</p>

<p id="cmd-set-python-print-stack"><code>set python print-stack</code> — 设置出错时 Python 栈转储模式。</p>

<p id="cmd-set-radix"><code>set radix</code> — 设置默认输入和输出数字进制。</p>

<p id="cmd-set-range-stepping"><code>set range-stepping</code> — 启用或禁用范围单步。</p>

<p id="cmd-set-record"><code>set record</code> — 设置 record 选项。</p>

<p id="cmd-set-record-btrace"><code>set record btrace</code> — 设置 record 选项。</p>

<p id="cmd-set-record-btrace-bts"><code>set record btrace bts</code> — 设置 record btrace bts 选项。</p>

<p id="cmd-set-record-btrace-bts-buffer-size"><code>set record btrace bts buffer-size</code> — 设置 record/replay bts 缓冲区大小。</p>

<p id="cmd-set-record-btrace-cpu"><code>set record btrace cpu</code> — 设置用于跟踪解码的 CPU。</p>

<p id="cmd-set-record-btrace-cpu-auto"><code>set record btrace cpu auto</code> — 自动确定用于跟踪解码的 CPU。</p>

<p id="cmd-set-record-btrace-cpu-none"><code>set record btrace cpu none</code> — 不为跟踪解码启用勘误表变通。</p>

<p id="cmd-set-record-btrace-pt"><code>set record btrace pt</code> — 设置 record btrace pt 选项。</p>

<p id="cmd-set-record-btrace-pt-buffer-size"><code>set record btrace pt buffer-size</code> — 设置 record/replay pt 缓冲区大小。</p>

<p id="cmd-set-record-btrace-replay-memory-access"><code>set record btrace replay-memory-access</code> — 设置回放期间允许的内存访问。</p>

<p id="cmd-set-record-full"><code>set record full</code> — 设置 record 选项。</p>

<p id="cmd-set-record-full-insn-number-max"><code>set record full insn-number-max</code> — 设置 record/replay 缓冲区上限。</p>

<p id="cmd-set-record-full-memory-query"><code>set record full memory-query</code> — 设置若 PREC 无法记录下一条指令的内存变化时是否查询。</p>

<p id="cmd-set-record-full-stop-at-limit"><code>set record full stop-at-limit</code> — 设置 record/replay 缓冲区满时是否停止。</p>

<p id="cmd-set-record-function-call-history-size"><code>set record function-call-history-size</code> — 设置 "record function-call-history" 中打印的函数数量。</p>

<p id="cmd-set-record-instruction-history-size"><code>set record instruction-history-size</code> — 设置 "record instruction-history" 中打印的指令数量。</p>

<p id="cmd-set-remote"><code>set remote</code> — 远程协议相关变量。</p>

<p id="cmd-set-remote-p-packet"><code>set remote P-packet</code> — 设置是否使用远程协议 `P' (set-register) 包。</p>

<p id="cmd-set-remote-tracepointsource-packet"><code>set remote TracepointSource-packet</code> — 设置是否使用远程协议 `TracepointSource' (TracepointSource) 包。</p>

<p id="cmd-set-remote-x-packet"><code>set remote X-packet</code> — 设置是否使用远程协议 `X' (binary-download) 包。</p>

<p id="cmd-set-remote-z-packet"><code>set remote Z-packet</code> — 设置是否使用远程协议 `Z' packets.</p>

<p id="cmd-set-remote-access-watchpoint-packet"><code>set remote access-watchpoint-packet</code> — 设置是否使用远程协议 `Z4' (access-watchpoint) 包。</p>

<p id="cmd-set-remote-agent-packet"><code>set remote agent-packet</code> — 设置是否使用远程协议 `QAgent' (agent) 包。</p>

<p id="cmd-set-remote-allow-packet"><code>set remote allow-packet</code> — 设置是否使用远程协议 `QAllow' (allow) 包。</p>

<p id="cmd-set-remote-attach-packet"><code>set remote attach-packet</code> — 设置是否使用远程协议 `vAttach' (attach) 包。</p>

<p id="cmd-set-remote-binary-download-packet"><code>set remote binary-download-packet</code> — 设置是否使用远程协议 `X' (binary-download) 包。</p>

<p id="cmd-set-remote-breakpoint-commands-packet"><code>set remote breakpoint-commands-packet</code> — 设置是否使用远程协议 `BreakpointCommands' (breakpoint-commands) 包。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-remote-btrace-conf-bts-size-packet"><code>set remote btrace-conf-bts-size-packet</code> — 设置是否使用远程协议 `Qbtrace-conf:bts:size' (btrace-conf-bts-size) 包。</p>

<p id="cmd-set-remote-btrace-conf-pt-size-packet"><code>set remote btrace-conf-pt-size-packet</code> — 设置是否使用远程协议 `Qbtrace-conf:pt:size' (btrace-conf-pt-size) 包。</p>

<p id="cmd-set-remote-catch-syscalls-packet"><code>set remote catch-syscalls-packet</code> — 设置是否使用远程协议 `QCatchSyscalls' (catch-syscalls) 包。</p>

<p id="cmd-set-remote-conditional-breakpoints-packet"><code>set remote conditional-breakpoints-packet</code> — 设置是否使用远程协议 `ConditionalBreakpoints' (conditional-breakpoints) 包。</p>

<p id="cmd-set-remote-conditional-tracepoints-packet"><code>set remote conditional-tracepoints-packet</code> — 设置是否使用远程协议 `ConditionalTracepoints' (conditional-tracepoints) 包。</p>

<p id="cmd-set-remote-ctrl-c-packet"><code>set remote ctrl-c-packet</code> — 设置是否使用远程协议 `vCtrlC' (ctrl-c) 包。</p>

<p id="cmd-set-remote-disable-btrace-packet"><code>set remote disable-btrace-packet</code> — 设置是否使用远程协议 `Qbtrace:off' (disable-btrace) 包。</p>

<p id="cmd-set-remote-disable-randomization-packet"><code>set remote disable-randomization-packet</code> — 设置是否使用远程协议 `QDisableRandomization' (disable-randomization) 包。</p>

<p id="cmd-set-remote-enable-btrace-bts-packet"><code>set remote enable-btrace-bts-packet</code> — 设置是否使用远程协议 `Qbtrace:bts' (enable-btrace-bts) 包。</p>

<p id="cmd-set-remote-enable-btrace-pt-packet"><code>set remote enable-btrace-pt-packet</code> — 设置是否使用远程协议 `Qbtrace:pt' (enable-btrace-pt) 包。</p>

<p id="cmd-set-remote-environment-hex-encoded-packet"><code>set remote environment-hex-encoded-packet</code> — 设置是否使用远程协议 `QEnvironmentHexEncoded' (environment-hex-encoded) 包。</p>

<p id="cmd-set-remote-environment-reset-packet"><code>set remote environment-reset-packet</code> — 设置是否使用远程协议 `QEnvironmentReset' (environment-reset) 包。</p>

<p id="cmd-set-remote-environment-unset-packet"><code>set remote environment-unset-packet</code> — 设置是否使用远程协议 `QEnvironmentUnset' (environment-unset) 包。</p>

<p id="cmd-set-remote-exec-event-feature-packet"><code>set remote exec-event-feature-packet</code> — 设置是否使用远程协议 `exec-event-feature' (exec-event-feature) 包。</p>

<p id="cmd-set-remote-exec-file"><code>set remote exec-file</code> — 设置 "run" 的远程路径名。</p>

<p id="cmd-set-remote-fast-tracepoints-packet"><code>set remote fast-tracepoints-packet</code> — 设置是否使用远程协议 `FastTracepoints' (fast-tracepoints) 包。</p>

<p id="cmd-set-remote-fetch-register-packet"><code>set remote fetch-register-packet</code> — 设置是否使用远程协议 `p' (fetch-register) 包。</p>

<p id="cmd-set-remote-fork-event-feature-packet"><code>set remote fork-event-feature-packet</code> — 设置是否使用远程协议 `fork-event-feature' (fork-event-feature) 包。</p>

<p id="cmd-set-remote-get-thread-information-block-address-packet"><code>set remote get-thread-information-block-address-packet</code> — 设置是否使用远程协议 `qGetTIBAddr' (get-thread-information-block-address) 包。</p>

<p id="cmd-set-remote-get-thread-local-storage-address-packet"><code>set remote get-thread-local-storage-address-packet</code> — 设置是否使用远程协议 `qGetTLSAddr' (get-thread-local-storage-address) 包。</p>

<p id="cmd-set-remote-hardware-breakpoint-limit"><code>set remote hardware-breakpoint-limit</code> — 设置目标硬件断点的最大数量。</p>

<p id="cmd-set-remote-hardware-breakpoint-packet"><code>set remote hardware-breakpoint-packet</code> — 设置是否使用远程协议 `Z1' (hardware-breakpoint) 包。</p>

<p id="cmd-set-remote-hardware-watchpoint-length-limit"><code>set remote hardware-watchpoint-length-limit</code> — 设置目标硬件监视点的最大长度（字节）。</p>

<p id="cmd-set-remote-hardware-watchpoint-limit"><code>set remote hardware-watchpoint-limit</code> — 设置目标硬件监视点的最大数量。</p>

<p id="cmd-set-remote-hostio-close-packet"><code>set remote hostio-close-packet</code> — 设置是否使用远程协议 `vFile:close' (hostio-close) 包。</p>

<p id="cmd-set-remote-hostio-fstat-packet"><code>set remote hostio-fstat-packet</code> — 设置是否使用远程协议 `vFile:fstat' (hostio-fstat) 包。</p>

<p id="cmd-set-remote-hostio-open-packet"><code>set remote hostio-open-packet</code> — 设置是否使用远程协议 `vFile:open' (hostio-open) 包。</p>

<p id="cmd-set-remote-hostio-pread-packet"><code>set remote hostio-pread-packet</code> — 设置是否使用远程协议 `vFile:pread' (hostio-pread) 包。</p>

<p id="cmd-set-remote-hostio-pwrite-packet"><code>set remote hostio-pwrite-packet</code> — 设置是否使用远程协议 `vFile:pwrite' (hostio-pwrite) 包。</p>

<p id="cmd-set-remote-hostio-readlink-packet"><code>set remote hostio-readlink-packet</code> — 设置是否使用远程协议 `vFile:readlink' (hostio-readlink) 包。</p>

<p id="cmd-set-remote-hostio-setfs-packet"><code>set remote hostio-setfs-packet</code> — 设置是否使用远程协议 `vFile:setfs' (hostio-setfs) 包。</p>

<p id="cmd-set-remote-hostio-unlink-packet"><code>set remote hostio-unlink-packet</code> — 设置是否使用远程协议 `vFile:unlink' (hostio-unlink) 包。</p>

<p id="cmd-set-remote-hwbreak-feature-packet"><code>set remote hwbreak-feature-packet</code> — 设置是否使用远程协议 `hwbreak-feature' (hwbreak-feature) 包。</p>

<p id="cmd-set-remote-install-in-trace-packet"><code>set remote install-in-trace-packet</code> — 设置是否使用远程协议 `InstallInTrace' (install-in-trace) 包。</p>

<p id="cmd-set-remote-interrupt-on-connect"><code>set remote interrupt-on-connect</code> — 设置 gdb 连接时是否向远程目标发送中断序列。</p>

<p id="cmd-set-remote-interrupt-sequence"><code>set remote interrupt-sequence</code> — 设置发往远程目标的中断序列。</p>

<p id="cmd-set-remote-kill-packet"><code>set remote kill-packet</code> — 设置是否使用远程协议 `vKill' (kill) 包。</p>

<p id="cmd-set-remote-library-info-packet"><code>set remote library-info-packet</code> — 设置是否使用远程协议 `qXfer:libraries:read' (library-info) 包。</p>

<p id="cmd-set-remote-library-info-svr4-packet"><code>set remote library-info-svr4-packet</code> — 设置是否使用远程协议 `qXfer:libraries-svr4:read' (library-info-svr4) 包。</p>

<p id="cmd-set-remote-memory-map-packet"><code>set remote memory-map-packet</code> — 设置是否使用远程协议 `qXfer:memory-map:read' (memory-map) 包。</p>

<p id="cmd-set-remote-memory-read-packet-size"><code>set remote memory-read-packet-size</code> — 设置每个内存读包的最大字节数。</p>

<p id="cmd-set-remote-memory-write-packet-size"><code>set remote memory-write-packet-size</code> — 设置每个内存写包的最大字节数。</p>

<p id="cmd-set-remote-multiprocess-feature-packet"><code>set remote multiprocess-feature-packet</code> — 设置是否使用远程协议 `multiprocess-feature' (multiprocess-feature) 包。</p>

<p id="cmd-set-remote-no-resumed-stop-reply-packet"><code>set remote no-resumed-stop-reply-packet</code> — 设置是否使用远程协议 `N stop reply' (no-resumed-stop-reply) 包。</p>

<p id="cmd-set-remote-noack-packet"><code>set remote noack-packet</code> — 设置是否使用远程协议 `QStartNoAckMode' (noack) 包。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-remote-osdata-packet"><code>set remote osdata-packet</code> — 设置是否使用远程协议 `qXfer:osdata:read' (osdata) 包。</p>

<p id="cmd-set-remote-p-packet-2"><code>set remote p-packet</code> — 设置是否使用远程协议 `p' (fetch-register) 包。</p>

<p id="cmd-set-remote-pass-signals-packet"><code>set remote pass-signals-packet</code> — 设置是否使用远程协议 `QPassSignals' (pass-signals) 包。</p>

<p id="cmd-set-remote-pid-to-exec-file-packet"><code>set remote pid-to-exec-file-packet</code> — 设置是否使用远程协议 `qXfer:exec-file:read' (pid-to-exec-file) 包。</p>

<p id="cmd-set-remote-program-signals-packet"><code>set remote program-signals-packet</code> — 设置是否使用远程协议 `QProgramSignals' (program-signals) 包。</p>

<p id="cmd-set-remote-query-attached-packet"><code>set remote query-attached-packet</code> — 设置是否使用远程协议 `qAttached' (query-attached) 包。</p>

<p id="cmd-set-remote-read-aux-vector-packet"><code>set remote read-aux-vector-packet</code> — 设置是否使用远程协议 `qXfer:auxv:read' (read-aux-vector) 包。</p>

<p id="cmd-set-remote-read-btrace-conf-packet"><code>set remote read-btrace-conf-packet</code> — 设置是否使用远程协议 `qXfer:btrace-conf' (read-btrace-conf) 包。</p>

<p id="cmd-set-remote-read-btrace-packet"><code>set remote read-btrace-packet</code> — 设置是否使用远程协议 `qXfer:btrace' (read-btrace) 包。</p>

<p id="cmd-set-remote-read-fdpic-loadmap-packet"><code>set remote read-fdpic-loadmap-packet</code> — 设置是否使用远程协议 `qXfer:fdpic:read' (read-fdpic-loadmap) 包。</p>

<p id="cmd-set-remote-read-sdata-object-packet"><code>set remote read-sdata-object-packet</code> — 设置是否使用远程协议 `qXfer:statictrace:read' (read-sdata-object) 包。</p>

<p id="cmd-set-remote-read-siginfo-object-packet"><code>set remote read-siginfo-object-packet</code> — 设置是否使用远程协议 `qXfer:siginfo:read' (read-siginfo-object) 包。</p>

<p id="cmd-set-remote-read-watchpoint-packet"><code>set remote read-watchpoint-packet</code> — 设置是否使用远程协议 `Z3' (read-watchpoint) 包。</p>

<p id="cmd-set-remote-reverse-continue-packet"><code>set remote reverse-continue-packet</code> — 设置是否使用远程协议 `bc' (reverse-continue) 包。</p>

<p id="cmd-set-remote-reverse-step-packet"><code>set remote reverse-step-packet</code> — 设置是否使用远程协议 `bs' (reverse-step) 包。</p>

<p id="cmd-set-remote-run-packet"><code>set remote run-packet</code> — 设置是否使用远程协议 `vRun' (run) 包。</p>

<p id="cmd-set-remote-search-memory-packet"><code>set remote search-memory-packet</code> — 设置是否使用远程协议 `qSearch:memory' (search-memory) 包。</p>

<p id="cmd-set-remote-set-register-packet"><code>set remote set-register-packet</code> — 设置是否使用远程协议 `P' (set-register) 包。</p>

<p id="cmd-set-remote-set-working-dir-packet"><code>set remote set-working-dir-packet</code> — 设置是否使用远程协议 `QSetWorkingDir' (set-working-dir) 包。</p>

<p id="cmd-set-remote-software-breakpoint-packet"><code>set remote software-breakpoint-packet</code> — 设置是否使用远程协议 `Z0' (software-breakpoint) 包。</p>

<p id="cmd-set-remote-startup-with-shell-packet"><code>set remote startup-with-shell-packet</code> — 设置是否使用远程协议 `QStartupWithShell' (startup-with-shell) 包。</p>

<p id="cmd-set-remote-static-tracepoints-packet"><code>set remote static-tracepoints-packet</code> — 设置是否使用远程协议 `StaticTracepoints' (static-tracepoints) 包。</p>

<p id="cmd-set-remote-supported-packets-packet"><code>set remote supported-packets-packet</code> — 设置是否使用远程协议 `qSupported' (supported-packets) 包。</p>

<p id="cmd-set-remote-swbreak-feature-packet"><code>set remote swbreak-feature-packet</code> — 设置是否使用远程协议 `swbreak-feature' (swbreak-feature) 包。</p>

<p id="cmd-set-remote-symbol-lookup-packet"><code>set remote symbol-lookup-packet</code> — 设置是否使用远程协议 `qSymbol' (symbol-lookup) 包。</p>

<p id="cmd-set-remote-system-call-allowed"><code>set remote system-call-allowed</code> — 设置是否允许目标使用主机的 system(3) 调用。</p>

<p id="cmd-set-remote-target-features-packet"><code>set remote target-features-packet</code> — 设置是否使用远程协议 `qXfer:features:read' (target-features) 包。</p>

<p id="cmd-set-remote-thread-events-packet"><code>set remote thread-events-packet</code> — 设置是否使用远程协议 `QThreadEvents' (thread-events) 包。</p>

<p id="cmd-set-remote-threads-packet"><code>set remote threads-packet</code> — 设置是否使用远程协议 `qXfer:threads:read' (threads) 包。</p>

<p id="cmd-set-remote-trace-buffer-size-packet"><code>set remote trace-buffer-size-packet</code> — 设置是否使用远程协议 `QTBuffer:size' (trace-buffer-size) 包。</p>

<p id="cmd-set-remote-trace-status-packet"><code>set remote trace-status-packet</code> — 设置是否使用远程协议 `qTStatus' (trace-status) 包。</p>

<p id="cmd-set-remote-traceframe-info-packet"><code>set remote traceframe-info-packet</code> — 设置是否使用远程协议 `qXfer:traceframe-info:read' (traceframe-info) 包。</p>

<p id="cmd-set-remote-unwind-info-block-packet"><code>set remote unwind-info-block-packet</code> — 设置是否使用远程协议 `qXfer:uib:read' (unwind-info-block) 包。</p>

<p id="cmd-set-remote-verbose-resume-packet"><code>set remote verbose-resume-packet</code> — 设置是否使用远程协议 `vCont' (verbose-resume) 包。</p>

<p id="cmd-set-remote-verbose-resume-supported-packet"><code>set remote verbose-resume-supported-packet</code> — 设置是否使用远程协议 `vContSupported' (verbose-resume-supported) 包。</p>

<p id="cmd-set-remote-vfork-event-feature-packet"><code>set remote vfork-event-feature-packet</code> — 设置是否使用远程协议 `vfork-event-feature' (vfork-event-feature) 包。</p>

<p id="cmd-set-remote-write-siginfo-object-packet"><code>set remote write-siginfo-object-packet</code> — 设置是否使用远程协议 `qXfer:siginfo:write' (write-siginfo-object) 包。</p>

<p id="cmd-set-remote-write-watchpoint-packet"><code>set remote write-watchpoint-packet</code> — 设置是否使用远程协议 `Z2' (write-watchpoint) 包。</p>

<p id="cmd-set-remoteaddresssize"><code>set remoteaddresssize</code> — 设置内存包中地址的最大位数。</p>

<p id="cmd-set-remotecache"><code>set remotecache</code> — 设置远程目标的缓存使用。</p>

<p id="cmd-set-remoteflow"><code>set remoteflow</code> — 设置远程串口 I/O 是否使用硬件流控。</p>

<p id="cmd-set-remotelogbase"><code>set remotelogbase</code> — 设置远程会话日志的数字进制。</p>

<p id="cmd-set-remotelogfile"><code>set remotelogfile</code> — 设置远程会话记录的文件名。</p>

<p id="cmd-set-remotetimeout"><code>set remotetimeout</code> — 设置等待目标响应的超时限制。</p>

<p id="cmd-set-remotewritesize"><code>set remotewritesize</code> — 设置每个内存写包的最大字节数（已弃用）。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-schedule-multiple"><code>set schedule-multiple</code> — 设置恢复所有进程线程的模式。</p>

<p id="cmd-set-scheduler-locking"><code>set scheduler-locking</code> — 设置执行期间锁定调度器的模式。</p>

<p id="cmd-set-script-extension"><code>set script-extension</code> — 设置脚本文件名扩展名识别模式。</p>

<p id="cmd-set-serial"><code>set serial</code> — 设置默认串口/并口配置。</p>

<p id="cmd-set-serial-baud"><code>set serial baud</code> — 设置远程串口 I/O 的波特率。</p>

<p id="cmd-set-serial-parity"><code>set serial parity</code> — 设置远程串口 I/O 的奇偶校验。</p>

<p id="cmd-set-solib-absolute-prefix"><code>set solib-absolute-prefix</code> — 设置备用系统根目录。</p>

<p id="cmd-set-solib-search-path"><code>set solib-search-path</code> — 设置加载非绝对路径共享库符号文件的搜索路径。</p>

<p id="cmd-set-stack-cache"><code>set stack-cache</code> — 设置栈访问的缓存使用。</p>

<p id="cmd-set-step-mode"><code>set step-mode</code> — 设置 step 操作的模式。</p>

<p id="cmd-set-stop-on-solib-events"><code>set stop-on-solib-events</code> — 设置是否在共享库事件处停止。</p>

<p id="cmd-set-style"><code>set style</code> — 样式相关设置。</p>

<p id="cmd-set-style-address"><code>set style address</code> — 地址显示样式。</p>

<p id="cmd-set-style-address-background"><code>set style address background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-address-foreground"><code>set style address foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-address-intensity"><code>set style address intensity</code> — 设置此属性的显示强度。</p>

<p id="cmd-set-style-enabled"><code>set style enabled</code> — 设置是否启用 CLI 样式。</p>

<p id="cmd-set-style-filename"><code>set style filename</code> — 文件名显示样式。</p>

<p id="cmd-set-style-filename-background"><code>set style filename background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-filename-foreground"><code>set style filename foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-filename-intensity"><code>set style filename intensity</code> — 设置此属性的显示强度。</p>

<p id="cmd-set-style-function"><code>set style function</code> — 函数名显示样式。</p>

<p id="cmd-set-style-function-background"><code>set style function background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-function-foreground"><code>set style function foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-function-intensity"><code>set style function intensity</code> — 设置此属性的显示强度。</p>

<p id="cmd-set-style-highlight"><code>set style highlight</code> — 高亮显示样式。</p>

<p id="cmd-set-style-highlight-background"><code>set style highlight background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-highlight-foreground"><code>set style highlight foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-highlight-intensity"><code>set style highlight intensity</code> — 设置此属性的显示强度。</p>

<p id="cmd-set-style-metadata"><code>set style metadata</code> — 元数据显示样式。</p>

<p id="cmd-set-style-metadata-background"><code>set style metadata background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-metadata-foreground"><code>set style metadata foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-metadata-intensity"><code>set style metadata intensity</code> — 设置此属性的显示强度。</p>

<p id="cmd-set-style-sources"><code>set style sources</code> — 设置是否启用源代码样式。</p>

<p id="cmd-set-style-title"><code>set style title</code> — 标题显示样式。</p>

<p id="cmd-set-style-title-background"><code>set style title background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-title-foreground"><code>set style title foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-title-intensity"><code>set style title intensity</code> — 设置此属性的显示强度。</p>

<p id="cmd-set-style-tui-active-border"><code>set style tui-active-border</code> — TUI 活动边框显示样式。</p>

<p id="cmd-set-style-tui-active-border-background"><code>set style tui-active-border background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-tui-active-border-foreground"><code>set style tui-active-border foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-tui-border"><code>set style tui-border</code> — TUI 边框显示样式。</p>

<p id="cmd-set-style-tui-border-background"><code>set style tui-border background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-tui-border-foreground"><code>set style tui-border foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-variable"><code>set style variable</code> — 变量名显示样式。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-set-style-variable-background"><code>set style variable background</code> — 设置此属性的背景色。</p>

<p id="cmd-set-style-variable-foreground"><code>set style variable foreground</code> — 设置此属性的前景色。</p>

<p id="cmd-set-style-variable-intensity"><code>set style variable intensity</code> — 设置此属性的显示强度。</p>

<p id="cmd-set-substitute-path"><code>set substitute-path</code> — 添加用于重写源目录的替换规则。</p>

<p id="cmd-set-sysroot"><code>set sysroot</code> — 设置备用系统根目录。</p>

<p id="cmd-set-target-charset"><code>set target-charset</code> — 设置目标字符集。</p>

<p id="cmd-set-target-file-system-kind"><code>set target-file-system-kind</code> — 设置目标报告文件名所假定的文件系统类型。</p>

<p id="cmd-set-target-wide-charset"><code>set target-wide-charset</code> — 设置目标宽字符集。</p>

<p id="cmd-set-tcp"><code>set tcp</code> — TCP 协议相关变量。</p>

<p id="cmd-set-tcp-auto-retry"><code>set tcp auto-retry</code> — 设置套接字连接是否自动重试。</p>

<p id="cmd-set-tcp-connect-timeout"><code>set tcp connect-timeout</code> — 设置套接字连接的超时限制（秒）。</p>

<p id="cmd-set-tdesc"><code>set tdesc</code> — 目标描述相关变量。</p>

<p id="cmd-set-tdesc-filename"><code>set tdesc filename</code> — 设置用于读取 XML 目标描述的文件。</p>

<p id="cmd-set-trace-buffer-size"><code>set trace-buffer-size</code> — 设置请求的跟踪缓冲区大小。</p>

<p id="cmd-set-trace-commands"><code>set trace-commands</code> — 设置是否跟踪 GDB CLI 命令。</p>

<p id="cmd-set-trace-notes"><code>set trace-notes</code> — 设置当前及今后跟踪运行使用的备注字符串。</p>

<p id="cmd-set-trace-stop-notes"><code>set trace-stop-notes</code> — 设置今后 tstop 命令使用的备注字符串。</p>

<p id="cmd-set-trace-user"><code>set trace-user</code> — 设置当前及今后跟踪运行使用的用户名。</p>

<p id="cmd-set-trust-readonly-sections"><code>set trust-readonly-sections</code> — 设置从只读段读取的模式。</p>

<p id="cmd-set-tui"><code>set tui</code> — TUI 配置变量。</p>

<p id="cmd-set-tui-active-border-mode"><code>set tui active-border-mode</code> — 设置活动 TUI 窗口边框使用的属性模式。</p>

<p id="cmd-set-tui-border-kind"><code>set tui border-kind</code> — 设置 TUI 窗口边框类型。</p>

<p id="cmd-set-tui-border-mode"><code>set tui border-mode</code> — 设置 TUI 窗口边框使用的属性模式。</p>

<p id="cmd-set-tui-compact-source"><code>set tui compact-source</code> — 设置 TUI 源窗口是否紧凑。</p>

<p id="cmd-set-tui-tab-width"><code>set tui tab-width</code> — 设置 TUI 的制表符宽度（字符数）。</p>

<p id="cmd-set-unwind-on-terminating-exception"><code>set unwind-on-terminating-exception</code> — 设置在 call dummy 中调用 std::terminate 时是否展开栈。</p>

<p id="cmd-set-unwindonsignal"><code>set unwindonsignal</code> — 设置在 call dummy 中收到信号时是否展开栈。</p>

<p id="cmd-set-use-coredump-filter"><code>set use-coredump-filter</code> — 设置 gcore 是否考虑 /proc/PID/coredump_filter。</p>

<p id="cmd-set-use-deprecated-index-sections"><code>set use-deprecated-index-sections</code> — 设置是否使用已弃用的 gdb_index 段。</p>

<p id="cmd-set-var"><code>set var</code> — 求值表达式 EXP 并将结果赋给变量 VAR。</p>

<p id="cmd-set-variable"><code>set variable</code> — 求值表达式 EXP 并将结果赋给变量 VAR。</p>

<p id="cmd-set-varsize-limit"><code>set varsize-limit</code> — 设置可变大小对象允许的最大字节数。</p>

<p id="cmd-set-verbose"><code>set verbose</code> — 设置详细程度。</p>

<p id="cmd-set-watchdog"><code>set watchdog</code> — 设置看门狗定时器。</p>

<p id="cmd-set-width"><code>set width</code> — 设置 GDB 输出换行的字符数。</p>

<p id="cmd-set-write"><code>set write</code> — 设置是否写入可执行文件和 core 文件。</p>

<h4 id="cmd-undisplay"><code>undisplay</code></h4>

取消程序停止时要显示的部分表达式。

<h4 id="cmd-whatis"><code>whatis</code></h4>

打印表达式 EXP 的数据类型。

<h4 id="cmd-with"><code>with</code></h4>

临时将 SETTING 设为 VALUE，运行 COMMAND，然后恢复 SETTING。

<h4 id="cmd-x"><code>x</code></h4>

检查内存：x/FMT ADDRESS。


---



[↑ 返回目录](#目录)

<h2 id="cat-files">命令类别：files（文件）</h2>

<h4 id="cmd-add-symbol-file"><code>add-symbol-file</code></h4>

从 FILE 加载符号，假定 FILE 已被动态加载。

<h4 id="cmd-add-symbol-file-from-memory"><code>add-symbol-file-from-memory</code></h4>

从动态加载的目标文件的内存中加载符号。


*--Type <RET> for more, q to quit, c to continue without paging--*

<h4 id="cmd-cd"><code>cd</code></h4>

为调试器将工作目录设为 DIR。

<h4 id="cmd-core-file"><code>core-file</code></h4>

使用 FILE 作为 core 转储以检查内存和寄存器。

<h4 id="cmd-directory"><code>directory</code></h4>

将目录 DIR 添加到源文件搜索路径开头。

<h4 id="cmd-edit"><code>edit</code></h4>

编辑指定文件或函数。

<h4 id="cmd-exec-file"><code>exec-file</code></h4>

使用 FILE 作为获取纯内存内容的程序。

<h4 id="cmd-file"><code>file</code></h4>

使用 FILE 作为要调试的程序。

<h4 id="cmd-forward-search"><code>forward-search</code></h4>

从上次列出的行起向前搜索正则表达式（见 regex(3)）。

<h4 id="cmd-generate-core-file"><code>generate-core-file</code></h4>

保存包含被调试进程当前状态的 core 文件。

<h4 id="cmd-list"><code>list</code></h4>

列出指定函数或行。

<h4 id="cmd-load"><code>load</code></h4>

将 FILE 动态加载到运行中的程序。

<h4 id="cmd-nosharedlibrary"><code>nosharedlibrary</code></h4>

卸载所有共享对象库符号。

<h4 id="cmd-path"><code>path</code></h4>

将目录 DIR(s) 添加到目标文件搜索路径开头。

<h4 id="cmd-pwd"><code>pwd</code></h4>

打印工作目录。

<h4 id="cmd-remote"><code>remote</code></h4>

操作远程系统上的文件。

<p id="cmd-remote-delete"><code>remote delete</code> — 删除远程文件。</p>

<p id="cmd-remote-get"><code>remote get</code> — 将远程文件复制到本地系统。</p>

<p id="cmd-remote-put"><code>remote put</code> — 将本地文件复制到远程系统。</p>

<h4 id="cmd-remove-symbol-file"><code>remove-symbol-file</code></h4>

移除通过 add-symbol-file 命令添加的符号文件。

<h4 id="cmd-reverse-search"><code>reverse-search</code></h4>

从上次列出的行起向后搜索正则表达式（见 regex(3)）。

<h4 id="cmd-search"><code>search</code></h4>

从上次列出的行起搜索正则表达式（见 regex(3)）。

<h4 id="cmd-section"><code>section</code></h4>

将可执行文件段 SECTION 的基址改为 ADDR。

<h4 id="cmd-sharedlibrary"><code>sharedlibrary</code></h4>

为匹配 REGEXP 的文件加载共享对象库符号。

<h4 id="cmd-symbol-file"><code>symbol-file</code></h4>

从可执行文件 FILE 加载符号表。


---



[↑ 返回目录](#目录)

<h2 id="cat-internals">命令类别：internals（内部）</h2>

<h4 id="cmd-flushregs"><code>flushregs</code></h4>

强制 gdb 刷新其寄存器缓存（维护者命令）。

<h4 id="cmd-maintenance"><code>maintenance</code></h4>

供 GDB 维护者使用的命令。

<p id="cmd-maintenance-agent"><code>maintenance agent</code> — 将表达式转换为用于跟踪的远程 agent 字节码。</p>

<p id="cmd-maintenance-agent-eval"><code>maintenance agent-eval</code> — 将表达式转换为用于求值的远程 agent 字节码。</p>

<p id="cmd-maintenance-agent-printf"><code>maintenance agent-printf</code> — 将表达式转换为用于求值的远程 agent 字节码并显示字节码。</p>

<p id="cmd-maintenance-btrace"><code>maintenance btrace</code> — 分支跟踪维护命令。</p>

<p id="cmd-maintenance-btrace-clear"><code>maintenance btrace clear</code> — 清除分支跟踪数据。</p>

<p id="cmd-maintenance-btrace-clear-packet-history"><code>maintenance btrace clear-packet-history</code> — 清除分支跟踪包历史。</p>

<p id="cmd-maintenance-btrace-packet-history"><code>maintenance btrace packet-history</code> — 打印原始分支跟踪数据。</p>

<p id="cmd-maintenance-check"><code>maintenance check</code> — 用于检查 gdb 内部状态的命令。</p>

<p id="cmd-maintenance-check-xml-descriptions"><code>maintenance check xml-descriptions</code> — 检查 GDB 目标描述与 XML 创建描述是否一致。</p>

<p id="cmd-maintenance-check-psymtabs"><code>maintenance check-psymtabs</code> — 检查当前已展开 psymtab 与 symtab 的一致性。</p>

<p id="cmd-maintenance-check-symtabs"><code>maintenance check-symtabs</code> — 检查当前已展开 symtab 的一致性。</p>

<p id="cmd-maintenance-cplus"><code>maintenance cplus</code> — C++ 维护命令。</p>

<p id="cmd-maintenance-cplus-first-component"><code>maintenance cplus first_component</code> — 打印 NAME 的第一个类/命名空间组件。</p>

<p id="cmd-maintenance-demangler-warning"><code>maintenance demangler-warning</code> — 向 GDB 发出 demangler 警告。</p>

<p id="cmd-maintenance-deprecate"><code>maintenance deprecate</code> — 弃用命令（用于测试）。</p>

<p id="cmd-maintenance-dump-me"><code>maintenance dump-me</code> — 触发致命错误；使调试器转储其 core。</p>

<p id="cmd-maintenance-expand-symtabs"><code>maintenance expand-symtabs</code> — 展开符号表。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-maintenance-flush-symbol-cache"><code>maintenance flush-symbol-cache</code> — 刷新每个程序空间的符号缓存。</p>

<p id="cmd-maintenance-info"><code>maintenance info</code> — 用于显示被调试程序内部信息的命令。</p>

<p id="cmd-maintenance-info-bfds"><code>maintenance info bfds</code> — 列出当前打开的 BFD。</p>

<p id="cmd-maintenance-info-breakpoints"><code>maintenance info breakpoints</code> — 所有断点的状态，或断点编号 NUMBER。</p>

<p id="cmd-maintenance-info-btrace"><code>maintenance info btrace</code> — 关于分支跟踪数据的信息。</p>

<p id="cmd-maintenance-info-line-table"><code>maintenance info line-table</code> — 列出所有符号表中行表的内容。</p>

<p id="cmd-maintenance-info-program-spaces"><code>maintenance info program-spaces</code> — 关于当前已知程序空间的信息。</p>

<p id="cmd-maintenance-info-psymtabs"><code>maintenance info psymtabs</code> — 列出所有目标文件的部分符号表。</p>

<p id="cmd-maintenance-info-sections"><code>maintenance info sections</code> — 列出可执行文件和 core 文件的 BFD 段。</p>

<p id="cmd-maintenance-info-selftests"><code>maintenance info selftests</code> — 列出已注册的自测项。</p>

<p id="cmd-maintenance-info-symtabs"><code>maintenance info symtabs</code> — 列出所有目标文件的完整符号表。</p>

<p id="cmd-maintenance-internal-error"><code>maintenance internal-error</code> — 向 GDB 发出内部错误。</p>

<p id="cmd-maintenance-internal-warning"><code>maintenance internal-warning</code> — 向 GDB 发出内部警告。</p>

<p id="cmd-maintenance-packet"><code>maintenance packet</code> — 向远程目标发送任意包。</p>

<p id="cmd-maintenance-print"><code>maintenance print</code> — 用于打印 GDB 内部状态的维护命令。</p>

<p id="cmd-maintenance-print-architecture"><code>maintenance print architecture</code> — 打印内部架构配置。</p>

<p id="cmd-maintenance-print-c-tdesc"><code>maintenance print c-tdesc</code> — 将当前目标描述打印为 C 源文件。</p>

<p id="cmd-maintenance-print-cooked-registers"><code>maintenance print cooked-registers</code> — 打印内部寄存器配置（含 cooked 值）。</p>

<p id="cmd-maintenance-print-dummy-frames"><code>maintenance print dummy-frames</code> — 打印内部 dummy 帧栈内容。</p>

<p id="cmd-maintenance-print-msymbols"><code>maintenance print msymbols</code> — 打印当前最小符号定义的转储。</p>

<p id="cmd-maintenance-print-objfiles"><code>maintenance print objfiles</code> — 打印当前目标文件定义的转储。</p>

<p id="cmd-maintenance-print-psymbols"><code>maintenance print psymbols</code> — 打印当前部分符号定义的转储。</p>

<p id="cmd-maintenance-print-raw-registers"><code>maintenance print raw-registers</code> — 打印内部寄存器配置（含 raw 值）。</p>

<p id="cmd-maintenance-print-reggroups"><code>maintenance print reggroups</code> — 打印内部寄存器组名。</p>

<p id="cmd-maintenance-print-register-groups"><code>maintenance print register-groups</code> — 打印内部寄存器配置（含各寄存器所属组）。</p>

<p id="cmd-maintenance-print-registers"><code>maintenance print registers</code> — 打印内部寄存器配置。</p>

<p id="cmd-maintenance-print-remote-registers"><code>maintenance print remote-registers</code> — 打印内部寄存器配置（含远程寄存器编号及 g/G 包偏移）。</p>

<p id="cmd-maintenance-print-statistics"><code>maintenance print statistics</code> — 打印关于 gdb 内部状态的统计信息。</p>

<p id="cmd-maintenance-print-symbol-cache"><code>maintenance print symbol-cache</code> — 转储每个程序空间的符号缓存。</p>

<p id="cmd-maintenance-print-symbol-cache-statistics"><code>maintenance print symbol-cache-statistics</code> — 打印每个程序空间的符号缓存统计。</p>

<p id="cmd-maintenance-print-symbols"><code>maintenance print symbols</code> — 打印当前符号定义的转储。</p>

<p id="cmd-maintenance-print-target-stack"><code>maintenance print target-stack</code> — 打印内部目标栈各层名称。</p>

<p id="cmd-maintenance-print-type"><code>maintenance print type</code> — 打印给定符号的类型链。</p>

<p id="cmd-maintenance-print-user-registers"><code>maintenance print user-registers</code> — 列出当前用户寄存器名称。</p>

<p id="cmd-maintenance-selftest"><code>maintenance selftest</code> — 运行 gdb 单元测试。</p>

<p id="cmd-maintenance-set"><code>maintenance set</code> — 设置 GDB 维护者使用的内部变量。</p>

<p id="cmd-maintenance-set-ada"><code>maintenance set ada</code> — 设置 Ada 维护相关变量。</p>

<p id="cmd-maintenance-set-ada-ignore-descriptive-types"><code>maintenance set ada ignore-descriptive-types</code> — 设置是否忽略 GNAT 生成的描述性类型。</p>

<p id="cmd-maintenance-set-bfd-sharing"><code>maintenance set bfd-sharing</code> — 设置 gdb 是否共享看似相同的 bfd 文件。</p>

<p id="cmd-maintenance-set-btrace"><code>maintenance set btrace</code> — 设置分支跟踪相关变量。</p>

<p id="cmd-maintenance-set-btrace-pt"><code>maintenance set btrace pt</code> — 设置 Intel Processor Trace 相关变量。</p>

<p id="cmd-maintenance-set-btrace-pt-skip-pad"><code>maintenance set btrace pt skip-pad</code> — 设置是否在 btrace 包历史中跳过 PAD 包。</p>

<p id="cmd-maintenance-set-catch-demangler-crashes"><code>maintenance set catch-demangler-crashes</code> — 设置是否尝试捕获 demangler 崩溃。</p>

<p id="cmd-maintenance-set-demangler-warning"><code>maintenance set demangler-warning</code> — 配置检测到 demangler-warning 时 GDB 的行为。</p>

<p id="cmd-maintenance-set-demangler-warning-quit"><code>maintenance set demangler-warning quit</code> — 设置检测到 demangler-warning 时 GDB 是否退出。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-maintenance-set-dwarf"><code>maintenance set dwarf</code> — 设置 DWARF 相关变量。</p>

<p id="cmd-maintenance-set-dwarf-always-disassemble"><code>maintenance set dwarf always-disassemble</code> — 设置 `info address' 是否总是反汇编 DWARF 表达式。</p>

<p id="cmd-maintenance-set-dwarf-max-cache-age"><code>maintenance set dwarf max-cache-age</code> — 设置缓存的 DWARF 编译单元年龄上限。</p>

<p id="cmd-maintenance-set-dwarf-unwinders"><code>maintenance set dwarf unwinders</code> — 设置是否使用 DWARF 栈帧展开器。</p>

<p id="cmd-maintenance-set-internal-error"><code>maintenance set internal-error</code> — 配置检测到 internal-error 时 GDB 的行为。</p>

<p id="cmd-maintenance-set-internal-error-corefile"><code>maintenance set internal-error corefile</code> — 设置检测到 internal-error 时 GDB 是否生成自身的 core 文件。</p>

<p id="cmd-maintenance-set-internal-error-quit"><code>maintenance set internal-error quit</code> — 设置检测到 internal-error 时 GDB 是否退出。</p>

<p id="cmd-maintenance-set-internal-warning"><code>maintenance set internal-warning</code> — 配置检测到 internal-warning 时 GDB 的行为。</p>

<p id="cmd-maintenance-set-internal-warning-corefile"><code>maintenance set internal-warning corefile</code> — 设置检测到 internal-warning 时 GDB 是否生成自身的 core 文件。</p>

<p id="cmd-maintenance-set-internal-warning-quit"><code>maintenance set internal-warning quit</code> — 设置检测到 internal-warning 时 GDB 是否退出。</p>

<p id="cmd-maintenance-set-per-command"><code>maintenance set per-command</code> — 每条命令的统计设置。</p>

<p id="cmd-maintenance-set-per-command-space"><code>maintenance set per-command space</code> — 设置是否显示每条命令的空间占用。</p>

<p id="cmd-maintenance-set-per-command-symtab"><code>maintenance set per-command symtab</code> — 设置是否显示每条命令的 symtab 统计。</p>

<p id="cmd-maintenance-set-per-command-time"><code>maintenance set per-command time</code> — 设置是否显示每条命令的执行时间。</p>

<p id="cmd-maintenance-set-profile"><code>maintenance set profile</code> — 设置内部性能分析。</p>

<p id="cmd-maintenance-set-symbol-cache-size"><code>maintenance set symbol-cache-size</code> — 设置符号缓存大小。</p>

<p id="cmd-maintenance-set-target-async"><code>maintenance set target-async</code> — 设置 gdb 是否以异步模式控制 inferior。</p>

<p id="cmd-maintenance-set-target-non-stop"><code>maintenance set target-non-stop</code> — 设置 gdb 是否始终以 non-stop 模式控制 inferior。</p>

<p id="cmd-maintenance-set-test-settings"><code>maintenance set test-settings</code> — 设置用于 set/show 命令基础设施测试的 GDB 内部变量。</p>

<p id="cmd-maintenance-set-test-settings-auto-boolean"><code>maintenance set test-settings auto-boolean</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-boolean"><code>maintenance set test-settings boolean</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-enum"><code>maintenance set test-settings enum</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-filename"><code>maintenance set test-settings filename</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-integer"><code>maintenance set test-settings integer</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-optional-filename"><code>maintenance set test-settings optional-filename</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-string"><code>maintenance set test-settings string</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-string-noescape"><code>maintenance set test-settings string-noescape</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-uinteger"><code>maintenance set test-settings uinteger</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-zinteger"><code>maintenance set test-settings zinteger</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-zuinteger"><code>maintenance set test-settings zuinteger</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-test-settings-zuinteger-unlimited"><code>maintenance set test-settings zuinteger-unlimited</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-set-tui-resize-message"><code>maintenance set tui-resize-message</code> — 设置 TUI 调整大小消息。</p>

<p id="cmd-maintenance-set-worker-threads"><code>maintenance set worker-threads</code> — 设置 GDB 可使用的工作线程数。</p>

<p id="cmd-maintenance-show"><code>maintenance show</code> — 显示 GDB 维护者使用的内部变量。</p>

<p id="cmd-maintenance-show-ada"><code>maintenance show ada</code> — 显示 Ada 维护相关变量。</p>

<p id="cmd-maintenance-show-ada-ignore-descriptive-types"><code>maintenance show ada ignore-descriptive-types</code> — 显示是否忽略 GNAT 生成的描述性类型。</p>

<p id="cmd-maintenance-show-bfd-sharing"><code>maintenance show bfd-sharing</code> — 显示 gdb 是否共享看似相同的 bfd 文件。</p>

<p id="cmd-maintenance-show-btrace"><code>maintenance show btrace</code> — 显示分支跟踪相关变量。</p>

<p id="cmd-maintenance-show-btrace-pt"><code>maintenance show btrace pt</code> — 显示 Intel Processor Trace 相关变量。</p>

<p id="cmd-maintenance-show-btrace-pt-skip-pad"><code>maintenance show btrace pt skip-pad</code> — 显示是否在 btrace 包历史中跳过 PAD 包。</p>

<p id="cmd-maintenance-show-catch-demangler-crashes"><code>maintenance show catch-demangler-crashes</code> — 显示是否尝试捕获 demangler 崩溃。</p>

<p id="cmd-maintenance-show-demangler-warning"><code>maintenance show demangler-warning</code> — 显示检测到 demangler-warning 时 GDB 的行为。</p>

<p id="cmd-maintenance-show-demangler-warning-quit"><code>maintenance show demangler-warning quit</code> — 显示检测到 demangler-warning 时 GDB 是否会退出。</p>

<p id="cmd-maintenance-show-dwarf"><code>maintenance show dwarf</code> — 显示 DWARF 相关变量。</p>

<p id="cmd-maintenance-show-dwarf-always-disassemble"><code>maintenance show dwarf always-disassemble</code> — 显示 `info address' 是否总是反汇编 DWARF 表达式。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-maintenance-show-dwarf-max-cache-age"><code>maintenance show dwarf max-cache-age</code> — 显示缓存的 DWARF 编译单元年龄上限。</p>

<p id="cmd-maintenance-show-dwarf-unwinders"><code>maintenance show dwarf unwinders</code> — 显示是否使用 DWARF 栈帧展开器。</p>

<p id="cmd-maintenance-show-internal-error"><code>maintenance show internal-error</code> — 显示检测到 internal-error 时 GDB 的行为。</p>

<p id="cmd-maintenance-show-internal-error-corefile"><code>maintenance show internal-error corefile</code> — 显示检测到 internal-error 时 GDB 是否会生成自身的 core 文件。</p>

<p id="cmd-maintenance-show-internal-error-quit"><code>maintenance show internal-error quit</code> — 显示检测到 internal-error 时 GDB 是否会退出。</p>

<p id="cmd-maintenance-show-internal-warning"><code>maintenance show internal-warning</code> — 显示检测到 internal-warning 时 GDB 的行为。</p>

<p id="cmd-maintenance-show-internal-warning-corefile"><code>maintenance show internal-warning corefile</code> — 显示检测到 internal-warning 时 GDB 是否会生成自身的 core 文件。</p>

<p id="cmd-maintenance-show-internal-warning-quit"><code>maintenance show internal-warning quit</code> — 显示检测到 internal-warning 时 GDB 是否会退出。</p>

<p id="cmd-maintenance-show-per-command"><code>maintenance show per-command</code> — 显示每条命令的统计设置。</p>

<p id="cmd-maintenance-show-per-command-space"><code>maintenance show per-command space</code> — 显示是否显示每条命令的空间占用。</p>

<p id="cmd-maintenance-show-per-command-symtab"><code>maintenance show per-command symtab</code> — 显示是否显示每条命令的 symtab 统计。</p>

<p id="cmd-maintenance-show-per-command-time"><code>maintenance show per-command time</code> — 显示是否显示每条命令的执行时间。</p>

<p id="cmd-maintenance-show-profile"><code>maintenance show profile</code> — 显示内部性能分析。</p>

<p id="cmd-maintenance-show-symbol-cache-size"><code>maintenance show symbol-cache-size</code> — 显示符号缓存大小。</p>

<p id="cmd-maintenance-show-target-async"><code>maintenance show target-async</code> — 显示 gdb 是否以异步模式控制 inferior。</p>

<p id="cmd-maintenance-show-target-non-stop"><code>maintenance show target-non-stop</code> — 显示 gdb 是否始终以 non-stop 模式控制 inferior。</p>

<p id="cmd-maintenance-show-test-options-completion-result"><code>maintenance show test-options-completion-result</code> — 显示 maintenance test-options 补全结果。</p>

<p id="cmd-maintenance-show-test-settings"><code>maintenance show test-settings</code> — 显示用于 set/show 命令基础设施测试的 GDB 内部变量。</p>

<p id="cmd-maintenance-show-test-settings-auto-boolean"><code>maintenance show test-settings auto-boolean</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-boolean"><code>maintenance show test-settings boolean</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-enum"><code>maintenance show test-settings enum</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-filename"><code>maintenance show test-settings filename</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-integer"><code>maintenance show test-settings integer</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-optional-filename"><code>maintenance show test-settings optional-filename</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-string"><code>maintenance show test-settings string</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-string-noescape"><code>maintenance show test-settings string-noescape</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-uinteger"><code>maintenance show test-settings uinteger</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-zinteger"><code>maintenance show test-settings zinteger</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-zuinteger"><code>maintenance show test-settings zuinteger</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-test-settings-zuinteger-unlimited"><code>maintenance show test-settings zuinteger-unlimited</code> — 用于内部测试的命令。</p>

<p id="cmd-maintenance-show-tui-resize-message"><code>maintenance show tui-resize-message</code> — 显示 TUI 调整大小消息。</p>

<p id="cmd-maintenance-show-worker-threads"><code>maintenance show worker-threads</code> — 显示 GDB 可使用的工作线程数。</p>

<p id="cmd-maintenance-space"><code>maintenance space</code> — 设置空间占用的显示。</p>

<p id="cmd-maintenance-test-options"><code>maintenance test-options</code> — 用于测试选项基础设施的通用命令。</p>

<p id="cmd-maintenance-test-options-require-delimiter"><code>maintenance test-options require-delimiter</code> — 用于测试选项处理的命令。</p>

<p id="cmd-maintenance-test-options-unknown-is-error"><code>maintenance test-options unknown-is-error</code> — 用于测试选项处理的命令。</p>

<p id="cmd-maintenance-test-options-unknown-is-operand"><code>maintenance test-options unknown-is-operand</code> — 用于测试选项处理的命令。</p>

<p id="cmd-maintenance-time"><code>maintenance time</code> — 设置时间占用的显示。</p>

<p id="cmd-maintenance-translate-address"><code>maintenance translate-address</code> — 将段名和地址转换为符号。</p>

<p id="cmd-maintenance-undeprecate"><code>maintenance undeprecate</code> — 取消弃用命令（用于测试）。</p>

<p id="cmd-maintenance-with"><code>maintenance with</code> — 类似 "with"，但适用于 "maintenance set" 变量。</p>


---



[↑ 返回目录](#目录)

<h2 id="cat-obscure">命令类别：obscure（晦涩）</h2>

<h4 id="cmd-compare-sections"><code>compare-sections</code></h4>

将目标上的段数据与可执行文件比较。


*--Type <RET> for more, q to quit, c to continue without paging--*

<h4 id="cmd-compile"><code>compile</code></h4>

编译源代码并注入 inferior 的命令。

<p id="cmd-compile-code-2"><code>compile code</code> — 编译、注入并执行代码。</p>

<p id="cmd-compile-file-2"><code>compile file</code> — 求值包含源代码的文件。</p>

<p id="cmd-compile-print-2"><code>compile print</code> — 使用编译器求值 EXPR 并打印结果。</p>

<h4 id="cmd-complete"><code>complete</code></h4>

列出该行剩余部分作为命令的补全项。

<h4 id="cmd-expression"><code>expression</code></h4>

编译源代码并注入 inferior 的命令。

<p id="cmd-compile-code-2"><code>compile code</code> — 编译、注入并执行代码。</p>

<p id="cmd-compile-file-2"><code>compile file</code> — 求值包含源代码的文件。</p>

<p id="cmd-compile-print-2"><code>compile print</code> — 使用编译器求值 EXPR 并打印结果。</p>

<h4 id="cmd-guile"><code>guile</code></h4>

求值 Guile 表达式。

<h4 id="cmd-guile-repl"><code>guile-repl</code></h4>

启动 Guile 交互提示符。

<h4 id="cmd-monitor"><code>monitor</code></h4>

向远程监视器发送命令（仅远程目标）。

<h4 id="cmd-python"><code>python</code></h4>

求值 Python 命令。

<h4 id="cmd-python-interactive"><code>python-interactive</code></h4>

启动 Python 交互提示符。

<h4 id="cmd-record"><code>record</code></h4>

开始记录。

<p id="cmd-record-btrace"><code>record btrace</code> — 开始分支跟踪记录。</p>

<p id="cmd-record-btrace-bts"><code>record btrace bts</code> — 以 Branch Trace Store (BTS) 格式开始分支跟踪记录。</p>

<p id="cmd-record-btrace-pt"><code>record btrace pt</code> — 以 Intel Processor Trace 格式开始分支跟踪记录。</p>

<p id="cmd-record-delete"><code>record delete</code> — 删除执行日志的剩余部分并重新开始记录。</p>

<p id="cmd-record-full"><code>record full</code> — 开始完整执行记录。</p>

<p id="cmd-record-full-restore"><code>record full restore</code> — 从文件恢复执行日志。</p>

<p id="cmd-record-function-call-history"><code>record function-call-history</code> — 以函数粒度打印执行历史。</p>

<p id="cmd-record-goto"><code>record goto</code> — 将程序恢复到指令编号 N 处的状态。</p>

<p id="cmd-record-goto-begin"><code>record goto begin</code> — 转到执行日志开头。</p>

<p id="cmd-record-goto-end"><code>record goto end</code> — 转到执行日志末尾。</p>

<p id="cmd-record-instruction-history"><code>record instruction-history</code> — 打印执行日志中存储的反汇编指令。</p>

<p id="cmd-record-save"><code>record save</code> — 将执行日志保存到文件。</p>

<p id="cmd-record-stop"><code>record stop</code> — 停止 record/replay 目标。</p>

<h4 id="cmd-stop"><code>stop</code></h4>

没有 `stop' 命令，但可在 `stop' 上设置 hook。


---



[↑ 返回目录](#目录)

<h2 id="cat-running">命令类别：running（运行）</h2>

<h4 id="cmd-advance"><code>advance</code></h4>

继续运行程序直至给定位置（参数形式与 break 命令相同）。

<h4 id="cmd-attach"><code>attach</code></h4>

附加到 GDB 外的进程或文件。

<h4 id="cmd-continue"><code>continue</code></h4>

在信号或断点后继续运行被调试程序。

<h4 id="cmd-detach"><code>detach</code></h4>

分离先前附加的进程或文件。

<p id="cmd-detach-inferiors"><code>detach inferiors</code> — 从 inferior ID（或 ID 列表）分离。</p>

<h4 id="cmd-disconnect"><code>disconnect</code></h4>

断开与目标的连接。

<h4 id="cmd-finish"><code>finish</code></h4>

执行直至所选栈帧返回。

<h4 id="cmd-handle"><code>handle</code></h4>

指定如何处理信号。

<h4 id="cmd-inferior"><code>inferior</code></h4>

使用此命令在多个 inferior 之间切换。

<h4 id="cmd-interrupt"><code>interrupt</code></h4>

中断被调试程序的执行。

<h4 id="cmd-jump"><code>jump</code></h4>

在被调试程序的指定行或地址处继续执行。

<h4 id="cmd-kill"><code>kill</code></h4>

终止被调试程序的执行。

<p id="cmd-kill-inferiors"><code>kill inferiors</code> — 终止 inferior ID（或 ID 列表）。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<h4 id="cmd-next"><code>next</code></h4>

单步执行程序，穿过子程序调用。

<h4 id="cmd-nexti"><code>nexti</code></h4>

单步一条指令，但穿过子程序调用。

<h4 id="cmd-queue-signal"><code>queue-signal</code></h4>

将信号加入队列，在线程恢复时传递给当前线程。

<h4 id="cmd-reverse-continue"><code>reverse-continue</code></h4>

继续运行被调试程序，但以反向方式执行。

<h4 id="cmd-reverse-finish"><code>reverse-finish</code></h4>

向后执行直至所选栈帧即将被调用之前。

<h4 id="cmd-reverse-next"><code>reverse-next</code></h4>

向后单步执行程序，穿过子程序调用。

<h4 id="cmd-reverse-nexti"><code>reverse-nexti</code></h4>

向后单步一条指令，但穿过被调用的子程序。

<h4 id="cmd-reverse-step"><code>reverse-step</code></h4>

向后单步执行程序直至到达另一条源行开头。

<h4 id="cmd-reverse-stepi"><code>reverse-stepi</code></h4>

精确向后单步一条指令。

<h4 id="cmd-run"><code>run</code></h4>

启动被调试程序。

<h4 id="cmd-signal"><code>signal</code></h4>

以指定信号继续运行程序。

<h4 id="cmd-start"><code>start</code></h4>

启动被调试程序并在 main 过程开头停止。

<h4 id="cmd-starti"><code>starti</code></h4>

启动被调试程序并在第一条指令处停止。

<h4 id="cmd-step"><code>step</code></h4>

单步执行程序直至到达不同的源行。

<h4 id="cmd-stepi"><code>stepi</code></h4>

精确单步执行一条指令。

<h4 id="cmd-taas"><code>taas</code></h4>

对所有线程应用命令（忽略错误和空输出）。

<h4 id="cmd-target"><code>target</code></h4>

连接到目标机或进程。

<p id="cmd-target-core"><code>target core</code> — 使用 core 文件作为目标。</p>

<p id="cmd-target-exec"><code>target exec</code> — 使用可执行文件作为目标。</p>

<p id="cmd-target-extended-remote"><code>target extended-remote</code> — 通过串口使用 gdb 专用协议连接远程计算机。</p>

<p id="cmd-target-record-btrace"><code>target record-btrace</code> — 收集控制流跟踪并提供执行历史。</p>

<p id="cmd-target-record-core"><code>target record-core</code> — 在执行时记录程序并从日志回放执行。</p>

<p id="cmd-target-record-full"><code>target record-full</code> — 在执行时记录程序并从日志回放执行。</p>

<p id="cmd-target-remote"><code>target remote</code> — 通过串口使用 gdb 专用协议连接远程计算机。</p>

<p id="cmd-target-tfile"><code>target tfile</code> — 使用跟踪文件作为目标。</p>

<h4 id="cmd-task"><code>task</code></h4>

使用此命令在 Ada 任务之间切换。

<h4 id="cmd-tfaas"><code>tfaas</code></h4>

对所有线程的所有帧应用命令（忽略错误和空输出）。

<h4 id="cmd-thread"><code>thread</code></h4>

使用此命令在线程之间切换。

<p id="cmd-thread-apply"><code>thread apply</code> — 对线程列表应用命令。</p>

<p id="cmd-thread-apply-all"><code>thread apply all</code> — 对所有线程应用命令。</p>

<p id="cmd-thread-find"><code>thread find</code> — 查找匹配正则表达式的线程。</p>

<p id="cmd-thread-name"><code>thread name</code> — 设置当前线程的名称。</p>

<h4 id="cmd-until"><code>until</code></h4>

执行直至越过当前行或越过 LOCATION。


---



[↑ 返回目录](#目录)

<h2 id="cat-stack">命令类别：stack（栈）</h2>

<h4 id="cmd-backtrace"><code>backtrace</code></h4>

打印所有栈帧的回溯，或最内层 COUNT 个栈帧。

<h4 id="cmd-bt"><code>bt</code></h4>

打印所有栈帧的回溯，或最内层 COUNT 个栈帧。

<h4 id="cmd-down"><code>down</code></h4>

选择并打印调用当前帧的栈帧。

<h4 id="cmd-faas"><code>faas</code></h4>

对所有帧应用命令（忽略错误和空输出）。

<h4 id="cmd-frame"><code>frame</code></h4>

选择并打印栈帧。

<p id="cmd-frame-address"><code>frame address</code> — 按栈地址选择并打印栈帧。</p>

<p id="cmd-frame-apply"><code>frame apply</code> — 对若干帧应用命令。</p>

<p id="cmd-frame-apply-all"><code>frame apply all</code> — 对所有帧应用命令。</p>

<p id="cmd-frame-apply-level"><code>frame apply level</code> — 对帧列表应用命令。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-frame-function"><code>frame function</code> — 按函数名选择并打印栈帧。</p>

<p id="cmd-frame-level"><code>frame level</code> — 按层级选择并打印栈帧。</p>

<p id="cmd-frame-view"><code>frame view</code> — 查看可能位于当前回溯之外的栈帧。</p>

<h4 id="cmd-return"><code>return</code></h4>

使所选栈帧返回到其调用者。

<h4 id="cmd-select-frame"><code>select-frame</code></h4>

选择栈帧但不打印任何内容。

<p id="cmd-select-frame-address"><code>select-frame address</code> — 按栈地址选择栈帧。</p>

<p id="cmd-select-frame-function"><code>select-frame function</code> — 按函数名选择栈帧。</p>

<p id="cmd-select-frame-level"><code>select-frame level</code> — 按层级选择栈帧。</p>

<p id="cmd-select-frame-view"><code>select-frame view</code> — 选择可能位于当前回溯之外的栈帧。</p>

<h4 id="cmd-up"><code>up</code></h4>

选择并打印调用当前帧的栈帧。


---



[↑ 返回目录](#目录)

<h2 id="cat-status">命令类别：status（状态）</h2>

<h4 id="cmd-info"><code>info</code></h4>

用于显示被调试程序相关信息的通用命令。

<p id="cmd-info-address"><code>info address</code> — 描述符号 SYM 的存储位置。</p>

<p id="cmd-info-all-registers"><code>info all-registers</code> — 列出所选栈帧的所有寄存器及其内容。</p>

<p id="cmd-info-args"><code>info args</code> — 当前栈帧的所有参数变量，或匹配 REGEXP 的变量。</p>

<p id="cmd-info-auto-load"><code>info auto-load</code> — 打印自动加载文件的当前状态。</p>

<p id="cmd-info-auto-load-gdb-scripts"><code>info auto-load gdb-scripts</code> — 打印自动加载的命令序列列表。</p>

<p id="cmd-info-auto-load-local-gdbinit"><code>info auto-load local-gdbinit</code> — 打印是否已加载当前目录的 .gdbinit 文件。</p>

<p id="cmd-info-auxv"><code>info auxv</code> — 显示 inferior 的辅助向量。</p>

<p id="cmd-info-bookmarks"><code>info bookmarks</code> — 用户可设书签的状态。</p>

<p id="cmd-info-breakpoints"><code>info breakpoints</code> — 指定断点的状态（无参数时为所有用户可设断点）。</p>

<p id="cmd-info-classes"><code>info classes</code> — 所有 Objective-C 类，或匹配 REGEXP 的类。</p>

<p id="cmd-info-common"><code>info common</code> — 打印 Fortran COMMON 块中的值。</p>

<p id="cmd-info-copying"><code>info copying</code> — 再分发 GDB 副本的条件。</p>

<p id="cmd-info-dcache"><code>info dcache</code> — 打印 dcache 性能信息。</p>

<p id="cmd-info-display"><code>info display</code> — 程序停止时要显示的表达式及编号。</p>

<p id="cmd-info-exceptions"><code>info exceptions</code> — 列出所有 Ada 异常名。</p>

<p id="cmd-info-extensions"><code>info extensions</code> — 与源语言关联的所有文件名扩展名。</p>

<p id="cmd-info-files"><code>info files</code> — 目标和被调试文件的名称。</p>

<p id="cmd-info-float"><code>info float</code> — 打印浮点单元状态。</p>

<p id="cmd-info-frame"><code>info frame</code> — 关于所选栈帧的全部信息。</p>

<p id="cmd-info-frame-address"><code>info frame address</code> — 打印按栈地址所选栈帧的信息。</p>

<p id="cmd-info-frame-function"><code>info frame function</code> — 打印按函数名所选栈帧的信息。</p>

<p id="cmd-info-frame-level"><code>info frame level</code> — 打印按层级所选栈帧的信息。</p>

<p id="cmd-info-frame-view"><code>info frame view</code> — 打印当前回溯之外栈帧的信息。</p>

<p id="cmd-info-functions"><code>info functions</code> — 所有函数名，或匹配 REGEXP 的函数名。</p>

<p id="cmd-info-guile"><code>info guile</code> — Guile 信息显示的前缀命令。</p>

<p id="cmd-info-handle"><code>info handle</code> — 程序收到各种信号时调试器的行为。</p>

<p id="cmd-info-inferiors"><code>info inferiors</code> — 打印正在管理的 inferior 列表。</p>

<p id="cmd-info-line"><code>info line</code> — 源行代码的核心地址。</p>

<p id="cmd-info-locals"><code>info locals</code> — 当前栈帧的所有局部变量，或匹配 REGEXP 的变量。</p>

<p id="cmd-info-macro"><code>info macro</code> — 显示宏 MACRO 的定义及其源位置。</p>

<p id="cmd-info-macros"><code>info macros</code> — 显示 LINESPEC 处或当前源位置的所有宏定义。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-info-mem"><code>info mem</code> — 内存区域属性。</p>

<p id="cmd-info-module"><code>info module</code> — 打印模块信息。</p>

<p id="cmd-info-module-functions"><code>info module functions</code> — 按模块显示函数。</p>

<p id="cmd-info-module-variables"><code>info module variables</code> — 按模块显示变量。</p>

<p id="cmd-info-modules"><code>info modules</code> — 所有模块名，或匹配 REGEXP 的模块名。</p>

<p id="cmd-info-os"><code>info os</code> — 显示 OS 数据 ARG。</p>

<p id="cmd-info-probes"><code>info probes</code> — 显示可用的静态探针。</p>

<p id="cmd-info-probes-all"><code>info probes all</code> — 显示所有类型探针的信息。</p>

<p id="cmd-info-probes-dtrace"><code>info probes dtrace</code> — 显示 DTrace 静态探针的信息。</p>

<p id="cmd-info-probes-stap"><code>info probes stap</code> — 显示 SystemTap 静态探针的信息。</p>

<p id="cmd-info-proc"><code>info proc</code> — 显示进程的附加信息。</p>

<p id="cmd-info-proc-all"><code>info proc all</code> — 列出指定进程的所有可用信息。</p>

<p id="cmd-info-proc-cmdline"><code>info proc cmdline</code> — 列出指定进程的命令行参数。</p>

<p id="cmd-info-proc-cwd"><code>info proc cwd</code> — 列出指定进程的当前工作目录。</p>

<p id="cmd-info-proc-exe"><code>info proc exe</code> — 列出指定进程可执行文件的绝对路径。</p>

<p id="cmd-info-proc-files"><code>info proc files</code> — 列出指定进程打开的文件。</p>

<p id="cmd-info-proc-mappings"><code>info proc mappings</code> — 列出指定进程映射的内存区域。</p>

<p id="cmd-info-proc-stat"><code>info proc stat</code> — 列出来自 /proc/PID/stat 的进程信息。</p>

<p id="cmd-info-proc-status"><code>info proc status</code> — 列出来自 /proc/PID/status 的进程信息。</p>

<p id="cmd-info-program"><code>info program</code> — 程序的执行状态。</p>

<p id="cmd-info-record"><code>info record</code> — record 选项信息。</p>

<p id="cmd-info-registers"><code>info registers</code> — 列出所选栈帧的整数寄存器及其内容。</p>

<p id="cmd-info-scope"><code>info scope</code> — 列出作用域内的局部变量。</p>

<p id="cmd-info-selectors"><code>info selectors</code> — 所有 Objective-C 选择器，或匹配 REGEXP 的选择器。</p>

<p id="cmd-info-set"><code>info set</code> — 显示所有 GDB 设置。</p>

<p id="cmd-info-sharedlibrary"><code>info sharedlibrary</code> — 已加载共享对象库的状态。</p>

<p id="cmd-info-signals"><code>info signals</code> — 程序收到各种信号时调试器的行为。</p>

<p id="cmd-info-skip"><code>info skip</code> — 显示 skip 的状态。</p>

<p id="cmd-info-source"><code>info source</code> — 关于当前源文件的信息。</p>

<p id="cmd-info-sources"><code>info sources</code> — 程序中所有源文件，或匹配 REGEXP 的源文件。</p>

<p id="cmd-info-stack"><code>info stack</code> — 栈的回溯，或最内层 COUNT 个帧。</p>

<p id="cmd-info-static-tracepoint-markers"><code>info static-tracepoint-markers</code> — 列出目标静态跟踪点标记。</p>

<p id="cmd-info-symbol"><code>info symbol</code> — 描述地址 ADDR 处的符号。</p>

<p id="cmd-info-target"><code>info target</code> — 目标和被调试文件的名称。</p>

<p id="cmd-info-tasks"><code>info tasks</code> — 提供所有已知 Ada 任务的信息。</p>

<p id="cmd-info-terminal"><code>info terminal</code> — 打印 inferior 保存的终端状态。</p>

<p id="cmd-info-threads"><code>info threads</code> — 显示当前已知线程。</p>

<p id="cmd-info-tracepoints"><code>info tracepoints</code> — 指定跟踪点的状态（无参数时为所有跟踪点）。</p>

<p id="cmd-info-tvariables"><code>info tvariables</code> — 跟踪状态变量及其值的状态。</p>

<p id="cmd-info-types"><code>info types</code> — 所有类型名，或匹配 REGEXP 的类型名。</p>

<p id="cmd-info-variables"><code>info variables</code> — 所有全局和静态变量名，或匹配 REGEXP 的变量名。</p>

<p id="cmd-info-vector"><code>info vector</code> — 打印向量单元状态。</p>

<p id="cmd-info-vtbl"><code>info vtbl</code> — 显示 C++ 对象的虚函数表。</p>

<p id="cmd-info-warranty"><code>info warranty</code> — 您并不拥有的各种保修条款。</p>

<p id="cmd-info-watchpoints"><code>info watchpoints</code> — 指定监视点的状态（无参数时为所有监视点）。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-info-win"><code>info win</code> — 列出所有已显示窗口。</p>

<h4 id="cmd-macro"><code>macro</code></h4>

处理 C 预处理器宏的命令前缀。

<p id="cmd-macro-define"><code>macro define</code> — 定义新的 C/C++ 预处理器宏。</p>

<p id="cmd-macro-expand"><code>macro expand</code> — 完全展开 EXPRESSION 中的 C/C++ 预处理器宏调用。</p>

<p id="cmd-macro-expand-once"><code>macro expand-once</code> — 展开 EXPRESSION 中直接出现的 C/C++ 预处理器宏调用。</p>

<p id="cmd-macro-list"><code>macro list</code> — 列出使用 `macro define' 命令定义的所有宏。</p>

<p id="cmd-macro-undef"><code>macro undef</code> — 移除给定名称的 C/C++ 预处理器宏定义。</p>

<h4 id="cmd-show"><code>show</code></h4>

用于显示调试器相关信息的通用命令。

<p id="cmd-show-ada"><code>show ada</code> — 用于显示 Ada 相关设置的通用命令。</p>

<p id="cmd-show-ada-print-signatures"><code>show ada print-signatures</code> — 启用或禁用在重载选择菜单中输出函数的形式参数和返回类型。</p>

<p id="cmd-show-ada-trust-pad-over-xvs"><code>show ada trust-PAD-over-XVS</code> — 启用或禁用信任 PAD 类型优于 XVS 类型的优化。</p>

<p id="cmd-show-agent"><code>show agent</code> — 显示调试器是否愿意使用 agent 作为辅助。</p>

<p id="cmd-show-annotate"><code>show annotate</code> — 显示 annotation_level。</p>

<p id="cmd-show-architecture"><code>show architecture</code> — 显示目标架构。</p>

<p id="cmd-show-args"><code>show args</code> — 显示被调试程序启动时传入的参数列表。</p>

<p id="cmd-show-arm"><code>show arm</code> — 各种 ARM 相关命令。</p>

<p id="cmd-show-arm-abi"><code>show arm abi</code> — 显示 ABI.</p>

<p id="cmd-show-arm-apcs32"><code>show arm apcs32</code> — 显示 ARM 32 位模式的使用。</p>

<p id="cmd-show-arm-disassembler"><code>show arm disassembler</code> — 显示反汇编风格。</p>

<p id="cmd-show-arm-fallback-mode"><code>show arm fallback-mode</code> — 显示符号不可用时的假定模式。</p>

<p id="cmd-show-arm-force-mode"><code>show arm force-mode</code> — 显示即使符号可用时也假定的模式。</p>

<p id="cmd-show-arm-fpu"><code>show arm fpu</code> — 显示浮点类型。</p>

<p id="cmd-show-auto-connect-native-target"><code>show auto-connect-native-target</code> — 显示 GDB 是否可自动连接到本机目标。</p>

<p id="cmd-show-auto-load"><code>show auto-load</code> — 自动加载相关设置。</p>

<p id="cmd-show-auto-load-gdb-scripts"><code>show auto-load gdb-scripts</code> — 启用或禁用自动加载预制命令序列脚本。</p>

<p id="cmd-show-auto-load-local-gdbinit"><code>show auto-load local-gdbinit</code> — 启用或禁用自动加载当前目录中的 .gdbinit 脚本。</p>

<p id="cmd-show-auto-load-safe-path"><code>show auto-load safe-path</code> — 显示可安全自动加载的文件和目录列表。</p>

<p id="cmd-show-auto-load-scripts-directory"><code>show auto-load scripts-directory</code> — 显示从中加载自动脚本的目录列表。</p>

<p id="cmd-show-auto-solib-add"><code>show auto-solib-add</code> — 显示共享库符号的自动加载。</p>

<p id="cmd-show-backtrace"><code>show backtrace</code> — 显示回溯相关变量。</p>

<p id="cmd-show-backtrace-limit"><code>show backtrace limit</code> — 显示回溯层数的上限。</p>

<p id="cmd-show-backtrace-past-entry"><code>show backtrace past-entry</code> — 显示回溯是否应越过程序入口点继续。</p>

<p id="cmd-show-backtrace-past-main"><code>show backtrace past-main</code> — 显示回溯是否应越过 "main" 继续。</p>

<p id="cmd-show-basenames-may-differ"><code>show basenames-may-differ</code> — 显示源文件是否可有多个基本名。</p>

<p id="cmd-show-breakpoint"><code>show breakpoint</code> — 断点相关设置。</p>

<p id="cmd-show-breakpoint-always-inserted"><code>show breakpoint always-inserted</code> — 显示插入断点的模式。</p>

<p id="cmd-show-breakpoint-auto-hw"><code>show breakpoint auto-hw</code> — 显示是否自动使用硬件断点。</p>

<p id="cmd-show-breakpoint-condition-evaluation"><code>show breakpoint condition-evaluation</code> — 显示断点条件求值模式。</p>

<p id="cmd-show-breakpoint-pending"><code>show breakpoint pending</code> — 显示调试器对待决断点的行为。</p>

<p id="cmd-show-can-use-hw-watchpoints"><code>show can-use-hw-watchpoints</code> — 显示调试器是否愿意使用监视点硬件。</p>

<p id="cmd-show-case-sensitive"><code>show case-sensitive</code> — 显示名称搜索的大小写敏感性（on/off/auto）。</p>

<p id="cmd-show-charset"><code>show charset</code> — 显示主机和目标字符集。</p>

<p id="cmd-show-check"><code>show check</code> — 显示类型/范围检查器的状态。</p>

<p id="cmd-show-check-range"><code>show check range</code> — 显示范围检查（on/warn/off/auto）。</p>

<p id="cmd-show-check-type"><code>show check type</code> — 显示严格类型检查。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-circular-trace-buffer"><code>show circular-trace-buffer</code> — 显示目标是否使用环形跟踪缓冲区。</p>

<p id="cmd-show-code-cache"><code>show code-cache</code> — 显示代码段访问的缓存使用。</p>

<p id="cmd-show-coerce-float-to-double"><code>show coerce-float-to-double</code> — 显示调用函数时是否将 float 强制转换为 double。</p>

<p id="cmd-show-commands"><code>show commands</code> — 显示 history of commands you typed.</p>

<p id="cmd-show-compile-args"><code>show compile-args</code> — 显示编译命令的 GCC 命令行参数。</p>

<p id="cmd-show-compile-gcc"><code>show compile-gcc</code> — 显示编译命令的 GCC 驱动程序文件名。</p>

<p id="cmd-show-complaints"><code>show complaints</code> — 显示关于错误符号的最大抱怨次数。</p>

<p id="cmd-show-configuration"><code>show configuration</code> — 显示 how GDB was configured at build time.</p>

<p id="cmd-show-confirm"><code>show confirm</code> — 显示是否确认潜在危险操作。</p>

<p id="cmd-show-convenience"><code>show convenience</code> — 调试器便利（"$foo"）变量和函数。</p>

<p id="cmd-show-copying"><code>show copying</code> — 再分发 GDB 副本的条件。</p>

<p id="cmd-show-cp-abi"><code>show cp-abi</code> — 显示用于检查 C++ 对象的 ABI。</p>

<p id="cmd-show-cwd"><code>show cwd</code> — 显示 inferior 启动时使用的当前工作目录。</p>

<p id="cmd-show-data-directory"><code>show data-directory</code> — 显示 GDB 的数据目录。</p>

<p id="cmd-show-dcache"><code>show dcache</code> — 使用此命令设置 dcache 的行数和行大小。</p>

<p id="cmd-show-dcache-line-size"><code>show dcache line-size</code> — 显示 dcache 行大小（字节，必须为 2 的幂）。</p>

<p id="cmd-show-dcache-size"><code>show dcache size</code> — 显示 dcache 行数。</p>

<p id="cmd-show-debug"><code>show debug</code> — 用于设置 gdb 调试标志的通用命令。</p>

<p id="cmd-show-debug-arch"><code>show debug arch</code> — 显示架构调试。</p>

<p id="cmd-show-debug-arm"><code>show debug arm</code> — 显示 ARM 调试。</p>

<p id="cmd-show-debug-auto-load"><code>show debug auto-load</code> — 显示自动加载验证调试。</p>

<p id="cmd-show-debug-bfd-cache"><code>show debug bfd-cache</code> — 显示 bfd 缓存调试。</p>

<p id="cmd-show-debug-check-physname"><code>show debug check-physname</code> — 显示 "physname" 代码与 demangler 的交叉检查。</p>

<p id="cmd-show-debug-coff-pe-read"><code>show debug coff-pe-read</code> — 显示 coff PE 读取调试。</p>

<p id="cmd-show-debug-compile"><code>show debug compile</code> — 显示编译命令调试。</p>

<p id="cmd-show-debug-compile-cplus-scopes"><code>show debug compile-cplus-scopes</code> — 显示 C++ 编译作用域调试。</p>

<p id="cmd-show-debug-compile-cplus-types"><code>show debug compile-cplus-types</code> — 显示 C++ 编译类型转换调试。</p>

<p id="cmd-show-debug-displaced"><code>show debug displaced</code> — 显示 displaced stepping 调试。</p>

<p id="cmd-show-debug-dwarf-die"><code>show debug dwarf-die</code> — 显示 DWARF DIE 读取器调试。</p>

<p id="cmd-show-debug-dwarf-line"><code>show debug dwarf-line</code> — 显示 dwarf 行读取器调试。</p>

<p id="cmd-show-debug-dwarf-read"><code>show debug dwarf-read</code> — 显示 DWARF 读取器调试。</p>

<p id="cmd-show-debug-entry-values"><code>show debug entry-values</code> — 显示入口值和尾调用帧调试。</p>

<p id="cmd-show-debug-expression"><code>show debug expression</code> — 显示表达式调试。</p>

<p id="cmd-show-debug-frame"><code>show debug frame</code> — 显示帧调试。</p>

<p id="cmd-show-debug-index-cache"><code>show debug index-cache</code> — 显示是否显示 index-cache 调试消息。</p>

<p id="cmd-show-debug-infrun"><code>show debug infrun</code> — 显示 inferior 调试。</p>

<p id="cmd-show-debug-jit"><code>show debug jit</code> — 显示 JIT 调试。</p>

<p id="cmd-show-debug-notification"><code>show debug notification</code> — 显示异步远程通知调试。</p>

<p id="cmd-show-debug-observer"><code>show debug observer</code> — 显示 observer 调试。</p>

<p id="cmd-show-debug-overload"><code>show debug overload</code> — 显示 C++ 重载调试。</p>

<p id="cmd-show-debug-parser"><code>show debug parser</code> — 显示解析器调试。</p>

<p id="cmd-show-debug-record"><code>show debug record</code> — 显示 record/replay 功能调试。</p>

<p id="cmd-show-debug-remote"><code>show debug remote</code> — 显示远程协议调试。</p>

<p id="cmd-show-debug-remote-packet-max-chars"><code>show debug remote-packet-max-chars</code> — 显示每个远程包显示的最大字符数。</p>

<p id="cmd-show-debug-separate-debug-file"><code>show debug separate-debug-file</code> — 显示是否打印独立调试信息文件搜索的调试输出。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-debug-serial"><code>show debug serial</code> — 显示串口调试。</p>

<p id="cmd-show-debug-skip"><code>show debug skip</code> — 显示是否打印关于跳过文件和函数的调试输出。</p>

<p id="cmd-show-debug-stap-expression"><code>show debug stap-expression</code> — 显示 SystemTap 表达式调试。</p>

<p id="cmd-show-debug-symbol-lookup"><code>show debug symbol-lookup</code> — 显示符号查找调试。</p>

<p id="cmd-show-debug-symfile"><code>show debug symfile</code> — 显示 symfile 函数调试。</p>

<p id="cmd-show-debug-symtab-create"><code>show debug symtab-create</code> — 显示符号表创建调试。</p>

<p id="cmd-show-debug-target"><code>show debug target</code> — 显示目标调试。</p>

<p id="cmd-show-debug-timestamp"><code>show debug timestamp</code> — 显示是否为调试消息添加时间戳。</p>

<p id="cmd-show-debug-varobj"><code>show debug varobj</code> — 显示 varobj 调试。</p>

<p id="cmd-show-debug-xml"><code>show debug xml</code> — 显示 XML 解析器调试。</p>

<p id="cmd-show-debug-file-directory"><code>show debug-file-directory</code> — 显示搜索独立调试符号的目录。</p>

<p id="cmd-show-default-collect"><code>show default-collect</code> — 显示默认要收集的表达式列表。</p>

<p id="cmd-show-demangle-style"><code>show demangle-style</code> — 显示当前 C++ 还原符号风格。</p>

<p id="cmd-show-detach-on-fork"><code>show detach-on-fork</code> — 显示 gdb 是否在 fork 后分离子进程。</p>

<p id="cmd-show-directories"><code>show directories</code> — 显示查找源文件的搜索路径。</p>

<p id="cmd-show-disable-randomization"><code>show disable-randomization</code> — 显示是否禁用被调试进程的虚拟地址空间随机化。</p>

<p id="cmd-show-disassemble-next-line"><code>show disassemble-next-line</code> — 显示执行停止时是否反汇编下一条源行或指令。</p>

<p id="cmd-show-disassembler-options"><code>show disassembler-options</code> — 显示反汇编器选项。</p>

<p id="cmd-show-disconnected-dprintf"><code>show disconnected-dprintf</code> — 显示 GDB 断开后 dprintf 是否继续。</p>

<p id="cmd-show-disconnected-tracing"><code>show disconnected-tracing</code> — 显示 GDB 断开后跟踪是否继续。</p>

<p id="cmd-show-displaced-stepping"><code>show displaced-stepping</code> — 显示调试器是否愿意使用 displaced stepping。</p>

<p id="cmd-show-dprintf-channel"><code>show dprintf-channel</code> — 显示动态 printf 使用的通道。</p>

<p id="cmd-show-dprintf-function"><code>show dprintf-function</code> — 显示动态 printf 使用的函数。</p>

<p id="cmd-show-dprintf-style"><code>show dprintf-style</code> — 显示动态 printf 的使用风格。</p>

<p id="cmd-show-dump-excluded-mappings"><code>show dump-excluded-mappings</code> — 显示 gcore 是否转储带 VM_DONTDUMP 标志的映射。</p>

<p id="cmd-show-editing"><code>show editing</code> — 显示是否在输入时编辑命令行。</p>

<p id="cmd-show-endian"><code>show endian</code> — 显示目标字节序。</p>

<p id="cmd-show-environment"><code>show environment</code> — 显示传给程序的环境变量值。</p>

<p id="cmd-show-exec-direction"><code>show exec-direction</code> — 显示执行方向。</p>

<p id="cmd-show-exec-done-display"><code>show exec-done-display</code> — 显示异步执行命令完成时的通知。</p>

<p id="cmd-show-extension-language"><code>show extension-language</code> — 显示文件名扩展名与源语言的映射。</p>

<p id="cmd-show-filename-display"><code>show filename-display</code> — 显示如何显示文件名。</p>

<p id="cmd-show-follow-exec-mode"><code>show follow-exec-mode</code> — 显示调试器对程序调用 exec 的响应。</p>

<p id="cmd-show-follow-fork-mode"><code>show follow-fork-mode</code> — 显示调试器对程序调用 fork 或 vfork 的响应。</p>

<p id="cmd-show-gnutarget"><code>show gnutarget</code> — 显示当前 BFD 目标。</p>

<p id="cmd-show-guile"><code>show guile</code> — Guile 偏好设置的前缀命令。</p>

<p id="cmd-show-guile-print-stack"><code>show guile print-stack</code> — 显示出错时 Guile 异常打印模式。</p>

<p id="cmd-show-height"><code>show height</code> — 显示 GDB 输出分页时每页行数。</p>

<p id="cmd-show-history"><code>show history</code> — 用于设置命令历史参数的通用命令。</p>

<p id="cmd-show-history-expansion"><code>show history expansion</code> — 显示命令输入的历史展开。</p>

<p id="cmd-show-history-filename"><code>show history filename</code> — 显示记录命令历史的文件名。</p>

<p id="cmd-show-history-remove-duplicates"><code>show history remove-duplicates</code> — 显示在历史中向后查找并删除重复条目的范围。</p>

<p id="cmd-show-history-save"><code>show history save</code> — 显示退出时是否保存历史记录。</p>

<p id="cmd-show-history-size"><code>show history size</code> — 显示命令历史大小。</p>

<p id="cmd-show-host-charset"><code>show host-charset</code> — 显示主机字符集。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-index-cache"><code>show index-cache</code> — 显示 index-cache 选项。</p>

<p id="cmd-show-index-cache-directory"><code>show index-cache directory</code> — 显示 index cache 的目录。</p>

<p id="cmd-show-index-cache-stats"><code>show index-cache stats</code> — 显示 some stats about the index cache.</p>

<p id="cmd-show-inferior-tty"><code>show inferior-tty</code> — 为被调试程序今后的运行设置终端。</p>

<p id="cmd-show-input-radix"><code>show input-radix</code> — 显示输入数字的默认进制。</p>

<p id="cmd-show-interactive-mode"><code>show interactive-mode</code> — 显示 GDB 标准输入是否为终端。</p>

<p id="cmd-show-language"><code>show language</code> — 显示当前源语言。</p>

<p id="cmd-show-listsize"><code>show listsize</code> — 显示 gdb 默认列出的源行数。</p>

<p id="cmd-show-logging"><code>show logging</code> — 显示日志选项。</p>

<p id="cmd-show-logging-debugredirect"><code>show logging debugredirect</code> — 显示日志调试输出模式。</p>

<p id="cmd-show-logging-file"><code>show logging file</code> — 显示当前日志文件。</p>

<p id="cmd-show-logging-overwrite"><code>show logging overwrite</code> — 显示日志是覆盖还是追加到日志文件。</p>

<p id="cmd-show-logging-redirect"><code>show logging redirect</code> — 显示日志输出模式。</p>

<p id="cmd-show-max-completions"><code>show max-completions</code> — 显示补全候选的最大数量。</p>

<p id="cmd-show-max-user-call-depth"><code>show max-user-call-depth</code> — 显示非 python/scheme 用户自定义命令的最大调用深度。</p>

<p id="cmd-show-max-value-size"><code>show max-value-size</code> — 显示 gdb 从 inferior 加载的值的最大尺寸。</p>

<p id="cmd-show-may-call-functions"><code>show may-call-functions</code> — 显示是否允许调用程序中的函数。</p>

<p id="cmd-show-may-insert-breakpoints"><code>show may-insert-breakpoints</code> — 显示是否允许在目标中插入断点。</p>

<p id="cmd-show-may-insert-fast-tracepoints"><code>show may-insert-fast-tracepoints</code> — 显示是否允许在目标中插入快速跟踪点。</p>

<p id="cmd-show-may-insert-tracepoints"><code>show may-insert-tracepoints</code> — 显示是否允许在目标中插入跟踪点。</p>

<p id="cmd-show-may-interrupt"><code>show may-interrupt</code> — 显示是否允许中断或向目标发信号。</p>

<p id="cmd-show-may-write-memory"><code>show may-write-memory</code> — 显示是否允许写入目标内存。</p>

<p id="cmd-show-may-write-registers"><code>show may-write-registers</code> — 显示是否允许写入寄存器。</p>

<p id="cmd-show-mem"><code>show mem</code> — 内存区域设置。</p>

<p id="cmd-show-mem-inaccessible-by-default"><code>show mem  inaccessible-by-default</code> — 显示 handling of unknown memory regions.</p>

<p id="cmd-show-mi-async"><code>show mi-async</code> — 显示是否启用 MI 异步模式。</p>

<p id="cmd-show-multiple-symbols"><code>show multiple-symbols</code> — 显示调试器如何处理表达式中的歧义。</p>

<p id="cmd-show-non-stop"><code>show non-stop</code> — 显示 gdb 是否以 non-stop 模式控制 inferior。</p>

<p id="cmd-show-observer"><code>show observer</code> — 显示 gdb 是否以 observer 模式控制 inferior。</p>

<p id="cmd-show-opaque-type-resolution"><code>show opaque-type-resolution</code> — 显示不透明 struct/class/union 类型的解析（须在加载符号前设置）。</p>

<p id="cmd-show-osabi"><code>show osabi</code> — 显示目标的 OS ABI。</p>

<p id="cmd-show-output-radix"><code>show output-radix</code> — 显示打印值的默认输出进制。</p>

<p id="cmd-show-overload-resolution"><code>show overload-resolution</code> — 显示求值 C++ 函数时的重载解析。</p>

<p id="cmd-show-pagination"><code>show pagination</code> — 显示 GDB 输出分页状态。</p>

<p id="cmd-show-paths"><code>show paths</code> — 查找目标文件的当前搜索路径。</p>

<p id="cmd-show-print"><code>show print</code> — 用于设置打印方式的通用命令。</p>

<p id="cmd-show-print-address"><code>show print address</code> — 显示是否打印地址。</p>

<p id="cmd-show-print-array"><code>show print array</code> — 显示数组的美化格式。</p>

<p id="cmd-show-print-array-indexes"><code>show print array-indexes</code> — 显示是否打印数组下标。</p>

<p id="cmd-show-print-asm-demangle"><code>show print asm-demangle</code> — 显示反汇编列表中 C++/ObjC 名称的还原。</p>

<p id="cmd-show-print-demangle"><code>show print demangle</code> — 显示显示符号时是否还原编码的 C++/ObjC 名称。</p>

<p id="cmd-show-print-elements"><code>show print elements</code> — 显示字符串字符或数组元素打印的上限。</p>

<p id="cmd-show-print-entry-values"><code>show print entry-values</code> — 显示是否在函数入口打印函数参数。</p>

<p id="cmd-show-print-finish"><code>show print finish</code> — 显示 `finish' 是否打印返回值。</p>

<p id="cmd-show-print-frame-arguments"><code>show print frame-arguments</code> — 显示是否打印非标量帧参数。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-print-frame-info"><code>show print frame-info</code> — 显示是否打印帧信息。</p>

<p id="cmd-show-print-inferior-events"><code>show print inferior-events</code> — 显示是否打印 inferior 事件（如启动和退出）。</p>

<p id="cmd-show-print-max-depth"><code>show print max-depth</code> — 显示嵌套结构体、联合体和数组的最大打印深度。</p>

<p id="cmd-show-print-max-symbolic-offset"><code>show print max-symbolic-offset</code> — 显示以 <SYMBOL+1234> 形式打印的最大偏移。</p>

<p id="cmd-show-print-null-stop"><code>show print null-stop</code> — 显示字符数组是否在首个空字符处停止打印。</p>

<p id="cmd-show-print-object"><code>show print object</code> — 显示是否打印 C++ 虚函数表。</p>

<p id="cmd-show-print-pascal-static-members"><code>show print pascal_static-members</code> — 显示是否打印 Pascal 静态成员。</p>

<p id="cmd-show-print-pretty"><code>show print pretty</code> — 显示结构体的美化格式。</p>

<p id="cmd-show-print-raw-frame-arguments"><code>show print raw-frame-arguments</code> — 显示是否以原始形式打印帧参数。</p>

<p id="cmd-show-print-raw-values"><code>show print raw-values</code> — 显示是否以原始形式打印值。</p>

<p id="cmd-show-print-repeats"><code>show print repeats</code> — 显示重复打印元素的阈值。</p>

<p id="cmd-show-print-sevenbit-strings"><code>show print sevenbit-strings</code> — 显示字符串中 8 位字符是否以 \nnn 形式打印。</p>

<p id="cmd-show-print-static-members"><code>show print static-members</code> — 显示是否打印 C++ 静态成员。</p>

<p id="cmd-show-print-symbol"><code>show print symbol</code> — 显示打印指针时是否打印符号名。</p>

<p id="cmd-show-print-symbol-filename"><code>show print symbol-filename</code> — 显示是否在 <SYMBOL> 旁打印源文件名和行号。</p>

<p id="cmd-show-print-symbol-loading"><code>show print symbol-loading</code> — 显示是否打印符号加载消息。</p>

<p id="cmd-show-print-thread-events"><code>show print thread-events</code> — 显示是否打印线程事件（如线程启动和退出）。</p>

<p id="cmd-show-print-type"><code>show print type</code> — 用于设置类型打印方式的通用命令。</p>

<p id="cmd-show-print-type-methods"><code>show print type methods</code> — 显示是否打印类中定义的方法。</p>

<p id="cmd-show-print-type-nested-type-limit"><code>show print type nested-type-limit</code> — 显示要打印的递归嵌套类型定义数量（"unlimited" 或 -1 表示全部）。</p>

<p id="cmd-show-print-type-typedefs"><code>show print type typedefs</code> — 显示是否打印类中定义的 typedef。</p>

<p id="cmd-show-print-union"><code>show print union</code> — 显示是否打印结构体内部的联合体。</p>

<p id="cmd-show-print-vtbl"><code>show print vtbl</code> — 显示是否打印 C++ 虚函数表。</p>

<p id="cmd-show-prompt"><code>show prompt</code> — 显示 gdb 提示符。</p>

<p id="cmd-show-python"><code>show python</code> — Python 偏好设置的前缀命令。</p>

<p id="cmd-show-python-print-stack"><code>show python print-stack</code> — 显示出错时 Python 栈转储模式。</p>

<p id="cmd-show-radix"><code>show radix</code> — 显示默认输入和输出数字进制。</p>

<p id="cmd-show-range-stepping"><code>show range-stepping</code> — 启用或禁用范围单步。</p>

<p id="cmd-show-record"><code>show record</code> — 显示 record 选项。</p>

<p id="cmd-show-record-btrace"><code>show record btrace</code> — 显示 record 选项。</p>

<p id="cmd-show-record-btrace-bts"><code>show record btrace bts</code> — 显示 record btrace bts 选项。</p>

<p id="cmd-show-record-btrace-bts-buffer-size"><code>show record btrace bts buffer-size</code> — 显示 record/replay bts 缓冲区大小。</p>

<p id="cmd-show-record-btrace-cpu"><code>show record btrace cpu</code> — 显示用于跟踪解码的 CPU。</p>

<p id="cmd-show-record-btrace-pt"><code>show record btrace pt</code> — 显示 record btrace pt 选项。</p>

<p id="cmd-show-record-btrace-pt-buffer-size"><code>show record btrace pt buffer-size</code> — 显示 record/replay pt 缓冲区大小。</p>

<p id="cmd-show-record-btrace-replay-memory-access"><code>show record btrace replay-memory-access</code> — 显示回放期间允许的内存访问。</p>

<p id="cmd-show-record-full"><code>show record full</code> — 显示 record 选项。</p>

<p id="cmd-show-record-full-insn-number-max"><code>show record full insn-number-max</code> — 显示 record/replay 缓冲区上限。</p>

<p id="cmd-show-record-full-memory-query"><code>show record full memory-query</code> — 显示若 PREC 无法记录下一条指令的内存变化时是否查询。</p>

<p id="cmd-show-record-full-stop-at-limit"><code>show record full stop-at-limit</code> — 显示 record/replay 缓冲区满时是否停止。</p>

<p id="cmd-show-record-function-call-history-size"><code>show record function-call-history-size</code> — 显示 "record function-call-history" 中打印的函数数量。</p>

<p id="cmd-show-record-instruction-history-size"><code>show record instruction-history-size</code> — 显示 "record instruction-history" 中打印的指令数量。</p>

<p id="cmd-show-remote"><code>show remote</code> — 远程协议相关变量。</p>

<p id="cmd-show-remote-p-packet"><code>show remote P-packet</code> — 显示是否使用远程协议 `P' (set-register) 包。</p>

<p id="cmd-show-remote-tracepointsource-packet"><code>show remote TracepointSource-packet</code> — 显示是否使用远程协议 `TracepointSource' (TracepointSource) 包。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-remote-x-packet"><code>show remote X-packet</code> — 显示是否使用远程协议 `X' (binary-download) 包。</p>

<p id="cmd-show-remote-z-packet"><code>show remote Z-packet</code> — 显示是否使用远程协议 `Z' packets.</p>

<p id="cmd-show-remote-access-watchpoint-packet"><code>show remote access-watchpoint-packet</code> — 显示是否使用远程协议 `Z4' (access-watchpoint) 包。</p>

<p id="cmd-show-remote-agent-packet"><code>show remote agent-packet</code> — 显示是否使用远程协议 `QAgent' (agent) 包。</p>

<p id="cmd-show-remote-allow-packet"><code>show remote allow-packet</code> — 显示是否使用远程协议 `QAllow' (allow) 包。</p>

<p id="cmd-show-remote-attach-packet"><code>show remote attach-packet</code> — 显示是否使用远程协议 `vAttach' (attach) 包。</p>

<p id="cmd-show-remote-binary-download-packet"><code>show remote binary-download-packet</code> — 显示是否使用远程协议 `X' (binary-download) 包。</p>

<p id="cmd-show-remote-breakpoint-commands-packet"><code>show remote breakpoint-commands-packet</code> — 显示是否使用远程协议 `BreakpointCommands' (breakpoint-commands) 包。</p>

<p id="cmd-show-remote-btrace-conf-bts-size-packet"><code>show remote btrace-conf-bts-size-packet</code> — 显示是否使用远程协议 `Qbtrace-conf:bts:size' (btrace-conf-bts-size) 包。</p>

<p id="cmd-show-remote-btrace-conf-pt-size-packet"><code>show remote btrace-conf-pt-size-packet</code> — 显示是否使用远程协议 `Qbtrace-conf:pt:size' (btrace-conf-pt-size) 包。</p>

<p id="cmd-show-remote-catch-syscalls-packet"><code>show remote catch-syscalls-packet</code> — 显示是否使用远程协议 `QCatchSyscalls' (catch-syscalls) 包。</p>

<p id="cmd-show-remote-conditional-breakpoints-packet"><code>show remote conditional-breakpoints-packet</code> — 显示是否使用远程协议 `ConditionalBreakpoints' (conditional-breakpoints) 包。</p>

<p id="cmd-show-remote-conditional-tracepoints-packet"><code>show remote conditional-tracepoints-packet</code> — 显示是否使用远程协议 `ConditionalTracepoints' (conditional-tracepoints) 包。</p>

<p id="cmd-show-remote-ctrl-c-packet"><code>show remote ctrl-c-packet</code> — 显示是否使用远程协议 `vCtrlC' (ctrl-c) 包。</p>

<p id="cmd-show-remote-disable-btrace-packet"><code>show remote disable-btrace-packet</code> — 显示是否使用远程协议 `Qbtrace:off' (disable-btrace) 包。</p>

<p id="cmd-show-remote-disable-randomization-packet"><code>show remote disable-randomization-packet</code> — 显示是否使用远程协议 `QDisableRandomization' (disable-randomization) 包。</p>

<p id="cmd-show-remote-enable-btrace-bts-packet"><code>show remote enable-btrace-bts-packet</code> — 显示是否使用远程协议 `Qbtrace:bts' (enable-btrace-bts) 包。</p>

<p id="cmd-show-remote-enable-btrace-pt-packet"><code>show remote enable-btrace-pt-packet</code> — 显示是否使用远程协议 `Qbtrace:pt' (enable-btrace-pt) 包。</p>

<p id="cmd-show-remote-environment-hex-encoded-packet"><code>show remote environment-hex-encoded-packet</code> — 显示是否使用远程协议 `QEnvironmentHexEncoded' (environment-hex-encoded) 包。</p>

<p id="cmd-show-remote-environment-reset-packet"><code>show remote environment-reset-packet</code> — 显示是否使用远程协议 `QEnvironmentReset' (environment-reset) 包。</p>

<p id="cmd-show-remote-environment-unset-packet"><code>show remote environment-unset-packet</code> — 显示是否使用远程协议 `QEnvironmentUnset' (environment-unset) 包。</p>

<p id="cmd-show-remote-exec-event-feature-packet"><code>show remote exec-event-feature-packet</code> — 显示是否使用远程协议 `exec-event-feature' (exec-event-feature) 包。</p>

<p id="cmd-show-remote-exec-file"><code>show remote exec-file</code> — 显示 "run" 的远程路径名。</p>

<p id="cmd-show-remote-fast-tracepoints-packet"><code>show remote fast-tracepoints-packet</code> — 显示是否使用远程协议 `FastTracepoints' (fast-tracepoints) 包。</p>

<p id="cmd-show-remote-fetch-register-packet"><code>show remote fetch-register-packet</code> — 显示是否使用远程协议 `p' (fetch-register) 包。</p>

<p id="cmd-show-remote-fork-event-feature-packet"><code>show remote fork-event-feature-packet</code> — 显示是否使用远程协议 `fork-event-feature' (fork-event-feature) 包。</p>

<p id="cmd-show-remote-get-thread-information-block-address-packet"><code>show remote get-thread-information-block-address-packet</code> — 显示是否使用远程协议 `qGetTIBAddr' (get-thread-information-block-address) 包。</p>

<p id="cmd-show-remote-get-thread-local-storage-address-packet"><code>show remote get-thread-local-storage-address-packet</code> — 显示是否使用远程协议 `qGetTLSAddr' (get-thread-local-storage-address) 包。</p>

<p id="cmd-show-remote-hardware-breakpoint-limit"><code>show remote hardware-breakpoint-limit</code> — 显示目标硬件断点的最大数量。</p>

<p id="cmd-show-remote-hardware-breakpoint-packet"><code>show remote hardware-breakpoint-packet</code> — 显示是否使用远程协议 `Z1' (hardware-breakpoint) 包。</p>

<p id="cmd-show-remote-hardware-watchpoint-length-limit"><code>show remote hardware-watchpoint-length-limit</code> — 显示目标硬件监视点的最大长度（字节）。</p>

<p id="cmd-show-remote-hardware-watchpoint-limit"><code>show remote hardware-watchpoint-limit</code> — 显示目标硬件监视点的最大数量。</p>

<p id="cmd-show-remote-hostio-close-packet"><code>show remote hostio-close-packet</code> — 显示是否使用远程协议 `vFile:close' (hostio-close) 包。</p>

<p id="cmd-show-remote-hostio-fstat-packet"><code>show remote hostio-fstat-packet</code> — 显示是否使用远程协议 `vFile:fstat' (hostio-fstat) 包。</p>

<p id="cmd-show-remote-hostio-open-packet"><code>show remote hostio-open-packet</code> — 显示是否使用远程协议 `vFile:open' (hostio-open) 包。</p>

<p id="cmd-show-remote-hostio-pread-packet"><code>show remote hostio-pread-packet</code> — 显示是否使用远程协议 `vFile:pread' (hostio-pread) 包。</p>

<p id="cmd-show-remote-hostio-pwrite-packet"><code>show remote hostio-pwrite-packet</code> — 显示是否使用远程协议 `vFile:pwrite' (hostio-pwrite) 包。</p>

<p id="cmd-show-remote-hostio-readlink-packet"><code>show remote hostio-readlink-packet</code> — 显示是否使用远程协议 `vFile:readlink' (hostio-readlink) 包。</p>

<p id="cmd-show-remote-hostio-setfs-packet"><code>show remote hostio-setfs-packet</code> — 显示是否使用远程协议 `vFile:setfs' (hostio-setfs) 包。</p>

<p id="cmd-show-remote-hostio-unlink-packet"><code>show remote hostio-unlink-packet</code> — 显示是否使用远程协议 `vFile:unlink' (hostio-unlink) 包。</p>

<p id="cmd-show-remote-hwbreak-feature-packet"><code>show remote hwbreak-feature-packet</code> — 显示是否使用远程协议 `hwbreak-feature' (hwbreak-feature) 包。</p>

<p id="cmd-show-remote-install-in-trace-packet"><code>show remote install-in-trace-packet</code> — 显示是否使用远程协议 `InstallInTrace' (install-in-trace) 包。</p>

<p id="cmd-show-remote-interrupt-on-connect"><code>show remote interrupt-on-connect</code> — 显示 gdb 连接时是否向远程目标发送中断序列。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-remote-interrupt-sequence"><code>show remote interrupt-sequence</code> — 显示发往远程目标的中断序列。</p>

<p id="cmd-show-remote-kill-packet"><code>show remote kill-packet</code> — 显示是否使用远程协议 `vKill' (kill) 包。</p>

<p id="cmd-show-remote-library-info-packet"><code>show remote library-info-packet</code> — 显示是否使用远程协议 `qXfer:libraries:read' (library-info) 包。</p>

<p id="cmd-show-remote-library-info-svr4-packet"><code>show remote library-info-svr4-packet</code> — 显示是否使用远程协议 `qXfer:libraries-svr4:read' (library-info-svr4) 包。</p>

<p id="cmd-show-remote-memory-map-packet"><code>show remote memory-map-packet</code> — 显示是否使用远程协议 `qXfer:memory-map:read' (memory-map) 包。</p>

<p id="cmd-show-remote-memory-read-packet-size"><code>show remote memory-read-packet-size</code> — 显示每个内存读包的最大字节数。</p>

<p id="cmd-show-remote-memory-write-packet-size"><code>show remote memory-write-packet-size</code> — 显示每个内存写包的最大字节数。</p>

<p id="cmd-show-remote-multiprocess-feature-packet"><code>show remote multiprocess-feature-packet</code> — 显示是否使用远程协议 `multiprocess-feature' (multiprocess-feature) 包。</p>

<p id="cmd-show-remote-no-resumed-stop-reply-packet"><code>show remote no-resumed-stop-reply-packet</code> — 显示是否使用远程协议 `N stop reply' (no-resumed-stop-reply) 包。</p>

<p id="cmd-show-remote-noack-packet"><code>show remote noack-packet</code> — 显示是否使用远程协议 `QStartNoAckMode' (noack) 包。</p>

<p id="cmd-show-remote-osdata-packet"><code>show remote osdata-packet</code> — 显示是否使用远程协议 `qXfer:osdata:read' (osdata) 包。</p>

<p id="cmd-show-remote-p-packet-2"><code>show remote p-packet</code> — 显示是否使用远程协议 `p' (fetch-register) 包。</p>

<p id="cmd-show-remote-pass-signals-packet"><code>show remote pass-signals-packet</code> — 显示是否使用远程协议 `QPassSignals' (pass-signals) 包。</p>

<p id="cmd-show-remote-pid-to-exec-file-packet"><code>show remote pid-to-exec-file-packet</code> — 显示是否使用远程协议 `qXfer:exec-file:read' (pid-to-exec-file) 包。</p>

<p id="cmd-show-remote-program-signals-packet"><code>show remote program-signals-packet</code> — 显示是否使用远程协议 `QProgramSignals' (program-signals) 包。</p>

<p id="cmd-show-remote-query-attached-packet"><code>show remote query-attached-packet</code> — 显示是否使用远程协议 `qAttached' (query-attached) 包。</p>

<p id="cmd-show-remote-read-aux-vector-packet"><code>show remote read-aux-vector-packet</code> — 显示是否使用远程协议 `qXfer:auxv:read' (read-aux-vector) 包。</p>

<p id="cmd-show-remote-read-btrace-conf-packet"><code>show remote read-btrace-conf-packet</code> — 显示是否使用远程协议 `qXfer:btrace-conf' (read-btrace-conf) 包。</p>

<p id="cmd-show-remote-read-btrace-packet"><code>show remote read-btrace-packet</code> — 显示是否使用远程协议 `qXfer:btrace' (read-btrace) 包。</p>

<p id="cmd-show-remote-read-fdpic-loadmap-packet"><code>show remote read-fdpic-loadmap-packet</code> — 显示是否使用远程协议 `qXfer:fdpic:read' (read-fdpic-loadmap) 包。</p>

<p id="cmd-show-remote-read-sdata-object-packet"><code>show remote read-sdata-object-packet</code> — 显示是否使用远程协议 `qXfer:statictrace:read' (read-sdata-object) 包。</p>

<p id="cmd-show-remote-read-siginfo-object-packet"><code>show remote read-siginfo-object-packet</code> — 显示是否使用远程协议 `qXfer:siginfo:read' (read-siginfo-object) 包。</p>

<p id="cmd-show-remote-read-watchpoint-packet"><code>show remote read-watchpoint-packet</code> — 显示是否使用远程协议 `Z3' (read-watchpoint) 包。</p>

<p id="cmd-show-remote-reverse-continue-packet"><code>show remote reverse-continue-packet</code> — 显示是否使用远程协议 `bc' (reverse-continue) 包。</p>

<p id="cmd-show-remote-reverse-step-packet"><code>show remote reverse-step-packet</code> — 显示是否使用远程协议 `bs' (reverse-step) 包。</p>

<p id="cmd-show-remote-run-packet"><code>show remote run-packet</code> — 显示是否使用远程协议 `vRun' (run) 包。</p>

<p id="cmd-show-remote-search-memory-packet"><code>show remote search-memory-packet</code> — 显示是否使用远程协议 `qSearch:memory' (search-memory) 包。</p>

<p id="cmd-show-remote-set-register-packet"><code>show remote set-register-packet</code> — 显示是否使用远程协议 `P' (set-register) 包。</p>

<p id="cmd-show-remote-set-working-dir-packet"><code>show remote set-working-dir-packet</code> — 显示是否使用远程协议 `QSetWorkingDir' (set-working-dir) 包。</p>

<p id="cmd-show-remote-software-breakpoint-packet"><code>show remote software-breakpoint-packet</code> — 显示是否使用远程协议 `Z0' (software-breakpoint) 包。</p>

<p id="cmd-show-remote-startup-with-shell-packet"><code>show remote startup-with-shell-packet</code> — 显示是否使用远程协议 `QStartupWithShell' (startup-with-shell) 包。</p>

<p id="cmd-show-remote-static-tracepoints-packet"><code>show remote static-tracepoints-packet</code> — 显示是否使用远程协议 `StaticTracepoints' (static-tracepoints) 包。</p>

<p id="cmd-show-remote-supported-packets-packet"><code>show remote supported-packets-packet</code> — 显示是否使用远程协议 `qSupported' (supported-packets) 包。</p>

<p id="cmd-show-remote-swbreak-feature-packet"><code>show remote swbreak-feature-packet</code> — 显示是否使用远程协议 `swbreak-feature' (swbreak-feature) 包。</p>

<p id="cmd-show-remote-symbol-lookup-packet"><code>show remote symbol-lookup-packet</code> — 显示是否使用远程协议 `qSymbol' (symbol-lookup) 包。</p>

<p id="cmd-show-remote-system-call-allowed"><code>show remote system-call-allowed</code> — 显示是否允许目标使用主机的 system(3) 调用。</p>

<p id="cmd-show-remote-target-features-packet"><code>show remote target-features-packet</code> — 显示是否使用远程协议 `qXfer:features:read' (target-features) 包。</p>

<p id="cmd-show-remote-thread-events-packet"><code>show remote thread-events-packet</code> — 显示是否使用远程协议 `QThreadEvents' (thread-events) 包。</p>

<p id="cmd-show-remote-threads-packet"><code>show remote threads-packet</code> — 显示是否使用远程协议 `qXfer:threads:read' (threads) 包。</p>

<p id="cmd-show-remote-trace-buffer-size-packet"><code>show remote trace-buffer-size-packet</code> — 显示是否使用远程协议 `QTBuffer:size' (trace-buffer-size) 包。</p>

<p id="cmd-show-remote-trace-status-packet"><code>show remote trace-status-packet</code> — 显示是否使用远程协议 `qTStatus' (trace-status) 包。</p>

<p id="cmd-show-remote-traceframe-info-packet"><code>show remote traceframe-info-packet</code> — 显示是否使用远程协议 `qXfer:traceframe-info:read' (traceframe-info) 包。</p>

<p id="cmd-show-remote-unwind-info-block-packet"><code>show remote unwind-info-block-packet</code> — 显示是否使用远程协议 `qXfer:uib:read' (unwind-info-block) 包。</p>

<p id="cmd-show-remote-verbose-resume-packet"><code>show remote verbose-resume-packet</code> — 显示是否使用远程协议 `vCont' (verbose-resume) 包。</p>

<p id="cmd-show-remote-verbose-resume-supported-packet"><code>show remote verbose-resume-supported-packet</code> — 显示是否使用远程协议 `vContSupported' (verbose-resume-supported) 包。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-remote-vfork-event-feature-packet"><code>show remote vfork-event-feature-packet</code> — 显示是否使用远程协议 `vfork-event-feature' (vfork-event-feature) 包。</p>

<p id="cmd-show-remote-write-siginfo-object-packet"><code>show remote write-siginfo-object-packet</code> — 显示是否使用远程协议 `qXfer:siginfo:write' (write-siginfo-object) 包。</p>

<p id="cmd-show-remote-write-watchpoint-packet"><code>show remote write-watchpoint-packet</code> — 显示是否使用远程协议 `Z2' (write-watchpoint) 包。</p>

<p id="cmd-show-remoteaddresssize"><code>show remoteaddresssize</code> — 显示内存包中地址的最大位数。</p>

<p id="cmd-show-remotecache"><code>show remotecache</code> — 显示远程目标的缓存使用。</p>

<p id="cmd-show-remoteflow"><code>show remoteflow</code> — 显示远程串口 I/O 是否使用硬件流控。</p>

<p id="cmd-show-remotelogbase"><code>show remotelogbase</code> — 显示远程会话日志的数字进制。</p>

<p id="cmd-show-remotelogfile"><code>show remotelogfile</code> — 显示远程会话记录的文件名。</p>

<p id="cmd-show-remotetimeout"><code>show remotetimeout</code> — 显示等待目标响应的超时限制。</p>

<p id="cmd-show-remotewritesize"><code>show remotewritesize</code> — 显示每个内存写包的最大字节数（已弃用）。</p>

<p id="cmd-show-schedule-multiple"><code>show schedule-multiple</code> — 显示恢复所有进程线程的模式。</p>

<p id="cmd-show-scheduler-locking"><code>show scheduler-locking</code> — 显示执行期间锁定调度器的模式。</p>

<p id="cmd-show-script-extension"><code>show script-extension</code> — 显示脚本文件名扩展名识别模式。</p>

<p id="cmd-show-serial"><code>show serial</code> — 显示默认串口/并口配置。</p>

<p id="cmd-show-serial-baud"><code>show serial baud</code> — 显示远程串口 I/O 的波特率。</p>

<p id="cmd-show-serial-parity"><code>show serial parity</code> — 显示远程串口 I/O 的奇偶校验。</p>

<p id="cmd-show-solib-absolute-prefix"><code>show solib-absolute-prefix</code> — 显示备用系统根目录。</p>

<p id="cmd-show-solib-search-path"><code>show solib-search-path</code> — 显示加载非绝对路径共享库符号文件的搜索路径。</p>

<p id="cmd-show-stack-cache"><code>show stack-cache</code> — 显示栈访问的缓存使用。</p>

<p id="cmd-show-step-mode"><code>show step-mode</code> — 显示 step 操作的模式。</p>

<p id="cmd-show-stop-on-solib-events"><code>show stop-on-solib-events</code> — 显示是否在共享库事件处停止。</p>

<p id="cmd-show-style"><code>show style</code> — 样式相关设置。</p>

<p id="cmd-show-style-address"><code>show style address</code> — 地址显示样式。</p>

<p id="cmd-show-style-address-background"><code>show style address background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-address-foreground"><code>show style address foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-address-intensity"><code>show style address intensity</code> — 显示此属性的显示强度。</p>

<p id="cmd-show-style-enabled"><code>show style enabled</code> — 显示是否启用 CLI 样式。</p>

<p id="cmd-show-style-filename"><code>show style filename</code> — 文件名显示样式。</p>

<p id="cmd-show-style-filename-background"><code>show style filename background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-filename-foreground"><code>show style filename foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-filename-intensity"><code>show style filename intensity</code> — 显示此属性的显示强度。</p>

<p id="cmd-show-style-function"><code>show style function</code> — 函数名显示样式。</p>

<p id="cmd-show-style-function-background"><code>show style function background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-function-foreground"><code>show style function foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-function-intensity"><code>show style function intensity</code> — 显示此属性的显示强度。</p>

<p id="cmd-show-style-highlight"><code>show style highlight</code> — 高亮显示样式。</p>

<p id="cmd-show-style-highlight-background"><code>show style highlight background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-highlight-foreground"><code>show style highlight foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-highlight-intensity"><code>show style highlight intensity</code> — 显示此属性的显示强度。</p>

<p id="cmd-show-style-metadata"><code>show style metadata</code> — 元数据显示样式。</p>

<p id="cmd-show-style-metadata-background"><code>show style metadata background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-metadata-foreground"><code>show style metadata foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-metadata-intensity"><code>show style metadata intensity</code> — 显示此属性的显示强度。</p>

<p id="cmd-show-style-sources"><code>show style sources</code> — 显示是否启用源代码样式。</p>

<p id="cmd-show-style-title"><code>show style title</code> — 标题显示样式。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-style-title-background"><code>show style title background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-title-foreground"><code>show style title foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-title-intensity"><code>show style title intensity</code> — 显示此属性的显示强度。</p>

<p id="cmd-show-style-tui-active-border"><code>show style tui-active-border</code> — TUI 活动边框显示样式。</p>

<p id="cmd-show-style-tui-active-border-background"><code>show style tui-active-border background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-tui-active-border-foreground"><code>show style tui-active-border foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-tui-border"><code>show style tui-border</code> — TUI 边框显示样式。</p>

<p id="cmd-show-style-tui-border-background"><code>show style tui-border background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-tui-border-foreground"><code>show style tui-border foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-variable"><code>show style variable</code> — 变量名显示样式。</p>

<p id="cmd-show-style-variable-background"><code>show style variable background</code> — 显示此属性的背景色。</p>

<p id="cmd-show-style-variable-foreground"><code>show style variable foreground</code> — 显示此属性的前景色。</p>

<p id="cmd-show-style-variable-intensity"><code>show style variable intensity</code> — 显示此属性的显示强度。</p>

<p id="cmd-show-substitute-path"><code>show substitute-path</code> — 添加用于重写源目录的替换规则。</p>

<p id="cmd-show-sysroot"><code>show sysroot</code> — 显示备用系统根目录。</p>

<p id="cmd-show-target-charset"><code>show target-charset</code> — 显示目标字符集。</p>

<p id="cmd-show-target-file-system-kind"><code>show target-file-system-kind</code> — 显示目标报告文件名所假定的文件系统类型。</p>

<p id="cmd-show-target-wide-charset"><code>show target-wide-charset</code> — 显示目标宽字符集。</p>

<p id="cmd-show-tcp"><code>show tcp</code> — TCP 协议相关变量。</p>

<p id="cmd-show-tcp-auto-retry"><code>show tcp auto-retry</code> — 显示套接字连接是否自动重试。</p>

<p id="cmd-show-tcp-connect-timeout"><code>show tcp connect-timeout</code> — 显示套接字连接的超时限制（秒）。</p>

<p id="cmd-show-tdesc"><code>show tdesc</code> — 目标描述相关变量。</p>

<p id="cmd-show-tdesc-filename"><code>show tdesc filename</code> — 显示用于读取 XML 目标描述的文件。</p>

<p id="cmd-show-trace-buffer-size"><code>show trace-buffer-size</code> — 显示请求的跟踪缓冲区大小。</p>

<p id="cmd-show-trace-commands"><code>show trace-commands</code> — 显示是否跟踪 GDB CLI 命令。</p>

<p id="cmd-show-trace-notes"><code>show trace-notes</code> — 显示当前及今后跟踪运行使用的备注字符串。</p>

<p id="cmd-show-trace-stop-notes"><code>show trace-stop-notes</code> — 显示今后 tstop 命令使用的备注字符串。</p>

<p id="cmd-show-trace-user"><code>show trace-user</code> — 显示当前及今后跟踪运行使用的用户名。</p>

<p id="cmd-show-trust-readonly-sections"><code>show trust-readonly-sections</code> — 显示从只读段读取的模式。</p>

<p id="cmd-show-tui"><code>show tui</code> — TUI 配置变量。</p>

<p id="cmd-show-tui-active-border-mode"><code>show tui active-border-mode</code> — 显示活动 TUI 窗口边框使用的属性模式。</p>

<p id="cmd-show-tui-border-kind"><code>show tui border-kind</code> — 显示 TUI 窗口边框类型。</p>

<p id="cmd-show-tui-border-mode"><code>show tui border-mode</code> — 显示 TUI 窗口边框使用的属性模式。</p>

<p id="cmd-show-tui-compact-source"><code>show tui compact-source</code> — 显示 TUI 源窗口是否紧凑。</p>

<p id="cmd-show-tui-tab-width"><code>show tui tab-width</code> — 显示 TUI 的制表符宽度（字符数）。</p>

<p id="cmd-show-unwind-on-terminating-exception"><code>show unwind-on-terminating-exception</code> — 显示在 call dummy 中调用 std::terminate 时是否展开栈。</p>

<p id="cmd-show-unwindonsignal"><code>show unwindonsignal</code> — 显示在 call dummy 中收到信号时是否展开栈。</p>

<p id="cmd-show-use-coredump-filter"><code>show use-coredump-filter</code> — 显示 gcore 是否考虑 /proc/PID/coredump_filter。</p>

<p id="cmd-show-use-deprecated-index-sections"><code>show use-deprecated-index-sections</code> — 显示是否使用已弃用的 gdb_index 段。</p>

<p id="cmd-show-user"><code>show user</code> — 显示 definitions of non-python/scheme user defined commands.</p>

<p id="cmd-show-values"><code>show values</code> — 显示编号 IDX 附近（或最近十条）的值历史元素。</p>

<p id="cmd-show-varsize-limit"><code>show varsize-limit</code> — 显示可变大小对象允许的最大字节数。</p>

<p id="cmd-show-verbose"><code>show verbose</code> — 显示详细程度。</p>

<p id="cmd-show-version"><code>show version</code> — 显示 what version of GDB this is.</p>

<p id="cmd-show-warranty"><code>show warranty</code> — 您并不拥有的各种保修条款。</p>


*--Type <RET> for more, q to quit, c to continue without paging--*

<p id="cmd-show-watchdog"><code>show watchdog</code> — 显示看门狗定时器。</p>

<p id="cmd-show-width"><code>show width</code> — 显示 GDB 输出换行的字符数。</p>

<p id="cmd-show-write"><code>show write</code> — 显示是否写入可执行文件和 core 文件。</p>


---



[↑ 返回目录](#目录)

<h2 id="cat-support">命令类别：support（支持）</h2>

<h4 id="cmd-bang"><code>!</code></h4>

将行剩余部分作为 shell 命令执行。

<h4 id="cmd-add-auto-load-safe-path"><code>add-auto-load-safe-path</code></h4>

向可安全自动加载文件的目录列表添加条目。

<h4 id="cmd-add-auto-load-scripts-directory"><code>add-auto-load-scripts-directory</code></h4>

向加载自动脚本的目录列表添加条目。

<h4 id="cmd-alias"><code>alias</code></h4>

定义作为现有命令别名的新命令。

<h4 id="cmd-apropos"><code>apropos</code></h4>

搜索匹配 REGEXP 的命令。

<h4 id="cmd-define"><code>define</code></h4>

定义新命令名。命令名作为参数。

<h4 id="cmd-define-prefix"><code>define-prefix</code></h4>

定义或标记命令为用户定义前缀命令。

<h4 id="cmd-demangle"><code>demangle</code></h4>

还原修饰名。

<h4 id="cmd-document"><code>document</code></h4>

为用户定义命令编写文档。

<h4 id="cmd-dont-repeat"><code>dont-repeat</code></h4>

不重复此命令。

<h4 id="cmd-down-silently"><code>down-silently</code></h4>

与 `down' 命令相同，但不打印任何内容。

<h4 id="cmd-echo"><code>echo</code></h4>

打印常量字符串。字符串作为参数。

<h4 id="cmd-help"><code>help</code></h4>

打印命令列表。

<h4 id="cmd-if"><code>if</code></h4>

当条件表达式非零时执行一次嵌套命令。

<h4 id="cmd-interpreter-exec"><code>interpreter-exec</code></h4>

在解释器中执行命令。

<h4 id="cmd-make"><code>make</code></h4>

使用行剩余部分作为参数运行 ``make'' 程序。

<h4 id="cmd-new-ui"><code>new-ui</code></h4>

创建新 UI。

<h4 id="cmd-overlay"><code>overlay</code></h4>

用于调试 overlay 的命令。

<p id="cmd-overlay-auto"><code>overlay auto</code> — 启用自动 overlay 调试。</p>

<p id="cmd-overlay-list-overlays"><code>overlay list-overlays</code> — 列出 overlay 段的映射。</p>

<p id="cmd-overlay-load-target"><code>overlay load-target</code> — 从目标读取 overlay 映射状态。</p>

<p id="cmd-overlay-manual"><code>overlay manual</code> — 启用 overlay 调试。</p>

<p id="cmd-overlay-map-overlay"><code>overlay map-overlay</code> — 断言 overlay 段已映射。</p>

<p id="cmd-overlay-off"><code>overlay off</code> — 禁用 overlay 调试。</p>

<p id="cmd-overlay-unmap-overlay"><code>overlay unmap-overlay</code> — 断言 overlay 段未映射。</p>

<h4 id="cmd-pipe"><code>pipe</code></h4>

将 gdb 命令输出发送到 shell 命令。

<h4 id="cmd-quit"><code>quit</code></h4>

退出 gdb。

<h4 id="cmd-shell"><code>shell</code></h4>

将行剩余部分作为 shell 命令执行。

<h4 id="cmd-source"><code>source</code></h4>

从名为 FILE 的文件读取命令。

<h4 id="cmd-up-silently"><code>up-silently</code></h4>

与 `up' 命令相同，但不打印任何内容。

<h4 id="cmd-while"><code>while</code></h4>

当条件表达式非零时执行嵌套命令。

<h4 id="cmd-bar"><code>|</code></h4>

将 gdb 命令输出发送到 shell 命令。


---



[↑ 返回目录](#目录)

<h2 id="cat-tracepoints">命令类别：tracepoints（跟踪点）</h2>

<h4 id="cmd-actions"><code>actions</code></h4>

指定跟踪点处要执行的动作。

<h4 id="cmd-collect"><code>collect</code></h4>

指定跟踪点处要收集的一个或多个数据项。

<h4 id="cmd-end"><code>end</code></h4>

结束命令或动作列表。

<h4 id="cmd-passcount"><code>passcount</code></h4>

设置跟踪点的 passcount。


*--Type <RET> for more, q to quit, c to continue without paging--*

<h4 id="cmd-tdump"><code>tdump</code></h4>

打印当前跟踪点收集的全部内容。

<h4 id="cmd-teval"><code>teval</code></h4>

指定跟踪点处要求值的一个或多个表达式。

<h4 id="cmd-tfind"><code>tfind</code></h4>

选择跟踪帧。

<p id="cmd-tfind-end"><code>tfind end</code> — 取消选择任何跟踪帧并恢复“实时”调试。</p>

<p id="cmd-tfind-line"><code>tfind line</code> — 按源行选择跟踪帧。</p>

<p id="cmd-tfind-none"><code>tfind none</code> — 取消选择任何跟踪帧并恢复“实时”调试。</p>

<p id="cmd-tfind-outside"><code>tfind outside</code> — 选择 PC 在给定范围外（不含边界）的跟踪帧。</p>

<p id="cmd-tfind-pc"><code>tfind pc</code> — 按 PC 选择跟踪帧。</p>

<p id="cmd-tfind-range"><code>tfind range</code> — 选择 PC 在给定范围内（含边界）的跟踪帧。</p>

<p id="cmd-tfind-start"><code>tfind start</code> — 选择跟踪缓冲区中的第一个跟踪帧。</p>

<p id="cmd-tfind-tracepoint"><code>tfind tracepoint</code> — 按跟踪点编号选择跟踪帧。</p>

<h4 id="cmd-tsave"><code>tsave</code></h4>

将跟踪数据保存到文件。

<h4 id="cmd-tstart"><code>tstart</code></h4>

开始收集跟踪数据。

<h4 id="cmd-tstatus"><code>tstatus</code></h4>

显示当前跟踪数据收集的状态。

<h4 id="cmd-tstop"><code>tstop</code></h4>

停止收集跟踪数据。

<h4 id="cmd-tvariable"><code>tvariable</code></h4>

定义跟踪状态变量。

<h4 id="cmd-while-stepping"><code>while-stepping</code></h4>

指定跟踪点处的单步行为。


---



[↑ 返回目录](#目录)

<h2 id="cat-user-defined">命令类别：user-defined（用户定义）</h2>

<h3 id="cat-unclassified">未分类命令</h3>

<h4 id="cmd-add-inferior"><code>add-inferior</code></h4>

添加新 inferior。

<h4 id="cmd-clone-inferior"><code>clone-inferior</code></h4>

克隆 inferior ID。

<h4 id="cmd-eval"><code>eval</code></h4>

构造 GDB 命令并求值。

<h4 id="cmd-flash-erase"><code>flash-erase</code></h4>

擦除所有 flash 内存区域。

<h4 id="cmd-function"><code>function</code></h4>

用于显示便利函数帮助的占位命令。

<p id="cmd-function-cimag"><code>function _cimag</code> — 提取复数的虚部。</p>

<p id="cmd-function-creal"><code>function _creal</code> — 提取复数的实部。</p>

<p id="cmd-function-gdb-maint-setting"><code>function _gdb_maint_setting</code> — $_gdb_maint_setting - 返回 GDB 维护设置的值。</p>

<p id="cmd-function-gdb-maint-setting-str"><code>function _gdb_maint_setting_str</code> — $_gdb_maint_setting_str - 以字符串形式返回 GDB 维护设置的值。</p>

<p id="cmd-function-gdb-setting"><code>function _gdb_setting</code> — $_gdb_setting - 返回 GDB 设置的值。</p>

<p id="cmd-function-gdb-setting-str"><code>function _gdb_setting_str</code> — $_gdb_setting_str - 以字符串形式返回 GDB 设置的值。</p>

<p id="cmd-function-isvoid"><code>function _isvoid</code> — 检查表达式是否为 void。</p>

<h4 id="cmd-jit-reader-load"><code>jit-reader-load</code></h4>

将 FILE 加载为 JIT 编译代码的调试信息读取器和展开器。

<h4 id="cmd-jit-reader-unload"><code>jit-reader-unload</code></h4>

卸载当前已加载的 JIT 调试信息读取器。

<h4 id="cmd-remove-inferiors"><code>remove-inferiors</code></h4>

移除 inferior ID（或 ID 列表）。

<h4 id="cmd-unset"><code>unset</code></h4>

某些 "set" 命令的互补命令。

<p id="cmd-unset-environment"><code>unset environment</code> — 取消程序的环境变量 VAR。</p>

<p id="cmd-unset-substitute-path"><code>unset substitute-path</code> — 删除重写源目录的一条或全部替换规则。</p>

<p id="cmd-unset-tdesc"><code>unset tdesc</code> — 取消设置目标描述相关变量。</p>

<p id="cmd-unset-tdesc-filename"><code>unset tdesc filename</code> — 取消设置用于读取 XML 目标描述的文件。</p>


`(gdb)`


---



[↑ 返回目录](#目录)


---

<h2 id="目录">目录</h2>

**快速跳转：** [aliases](#cat-aliases) | [breakpoints](#cat-breakpoints) | [data](#cat-data) | [files](#cat-files) | [internals](#cat-internals) | [obscure](#cat-obscure) | [running](#cat-running) | [stack](#cat-stack) | [status](#cat-status) | [support](#cat-support) | [tracepoints](#cat-tracepoints) | [user-defined](#cat-user-defined)

- [**aliases（别名）**](#cat-aliases)
  - [ni](#cmd-ni) — 单步执行一条指令，但会穿过子程序调用。
  - [rc](#cmd-rc) — 继续运行被调试程序，但以反向方式执行。
  - [rni](#cmd-rni) — 向后单步一条指令，但会穿过被调用的子程序。
  - [rsi](#cmd-rsi) — 精确向后单步一条指令。
  - [si](#cmd-si) — 精确单步执行一条指令。
  - [stepping](#cmd-stepping) — 指定跟踪点处的单步行为。
  - [tp](#cmd-tp) — 在指定位置设置跟踪点。
  - [tty](#cmd-tty) — 为被调试程序今后的运行设置终端。
  - [where](#cmd-where) — 打印所有栈帧的回溯，或最内层 COUNT 个栈帧。
  - [ws](#cmd-ws) — 指定跟踪点处的单步行为。

- [**breakpoints（断点）**](#cat-breakpoints)
  - [awatch](#cmd-awatch) — 为表达式设置监视点（访问时触发）。
  - [break](#cmd-break) — 在指定位置设置断点。
  - [break-range](#cmd-break-range) — 为地址范围设置断点。
  - [catch](#cmd-catch) — 设置捕获点以捕获事件。
    - [catch catch](#cmd-catch-catch) — 在异常被捕获时捕获。
    - [catch exception](#cmd-catch-exception) — 在 Ada 异常被抛出时捕获。
    - [catch exec](#cmd-catch-exec) — 捕获对 exec 的调用。
    - [catch fork](#cmd-catch-fork) — 捕获对 fork 的调用。
    - [catch handlers](#cmd-catch-handlers) — 在 Ada 异常被处理时捕获。
    - [catch load](#cmd-catch-load) — 捕获共享库的加载。
    - [catch rethrow](#cmd-catch-rethrow) — 在异常被重新抛出时捕获。
    - [catch signal](#cmd-catch-signal) — 按名称和/或编号捕获信号。
    - [catch syscall](#cmd-catch-syscall) — 按名称、分组和/或编号捕获系统调用。
    - [catch throw](#cmd-catch-throw) — 在异常被抛出时捕获。
    - [catch unload](#cmd-catch-unload) — 捕获共享库的卸载。
    - [catch vfork](#cmd-catch-vfork) — 捕获对 vfork 的调用。
  - [clear](#cmd-clear) — 清除指定位置的断点。
  - [commands](#cmd-commands) — 设置在给定断点命中时要执行的命令。
  - [condition](#cmd-condition) — 指定断点编号 N 仅在 COND 为真时中断。
  - [delete](#cmd-delete) — 删除全部或部分断点。
    - [delete breakpoints](#cmd-delete-breakpoints) — 删除全部或部分断点或自动显示表达式。
    - [delete display](#cmd-delete-display) — 取消程序停止时要显示的部分表达式。
    - [delete mem](#cmd-delete-mem) — 删除内存区域。
    - [delete tracepoints](#cmd-delete-tracepoints) — 删除指定的跟踪点。
    - [delete tvariable](#cmd-delete-tvariable) — 删除一个或多个跟踪状态变量。
  - [disable](#cmd-disable) — 禁用全部或部分断点。
    - [disable display](#cmd-disable-display) — 禁用程序停止时要显示的部分表达式。
    - [disable mem](#cmd-disable-mem) — 禁用内存区域。
    - [disable probes](#cmd-disable-probes) — 禁用探针。
  - [dprintf](#cmd-dprintf) — 在指定位置设置动态 printf。
  - [enable](#cmd-enable) — 启用全部或部分断点。
    - [enable breakpoints count](#cmd-enable-breakpoints-count) — 启用部分断点，命中 COUNT 次后失效。
    - [enable breakpoints delete](#cmd-enable-breakpoints-delete) — 启用部分断点，命中后删除。
    - [enable breakpoints once](#cmd-enable-breakpoints-once) — 启用部分断点，仅命中一次。
    - [enable count](#cmd-enable-count) — 启用部分断点，命中 COUNT 次后失效。
    - [enable delete](#cmd-enable-delete) — 启用部分断点，命中后删除。
    - [enable display](#cmd-enable-display) — 启用程序停止时要显示的部分表达式。
    - [enable mem](#cmd-enable-mem) — 启用内存区域。
    - [enable once](#cmd-enable-once) — 启用部分断点，仅命中一次。
    - [enable probes](#cmd-enable-probes) — 启用探针。
  - [ftrace](#cmd-ftrace) — 在指定位置设置快速跟踪点。
  - [hbreak](#cmd-hbreak) — 设置硬件辅助断点。
  - [ignore](#cmd-ignore) — 将断点编号 N 的忽略计数设为 COUNT。
  - [rbreak](#cmd-rbreak) — 为所有匹配 REGEXP 的函数设置断点。
  - [rwatch](#cmd-rwatch) — 为表达式设置读监视点。
  - [save](#cmd-save) — 将断点定义保存为脚本。
    - [save gdb-index](#cmd-save-gdb-index) — 保存 gdb-index 文件。
    - [save tracepoints](#cmd-save-tracepoints) — 将当前跟踪点定义保存为脚本。
  - [skip](#cmd-skip) — 单步时忽略某个函数。
    - [skip disable](#cmd-skip-disable) — 禁用 skip 条目。
    - [skip enable](#cmd-skip-enable) — 启用 skip 条目。
    - [skip file](#cmd-skip-file) — 单步时忽略某个文件。
    - [skip function](#cmd-skip-function) — 单步时忽略某个函数。
  - [strace](#cmd-strace) — 在位置或标记处设置静态跟踪点。
  - [tbreak](#cmd-tbreak) — 设置临时断点。
  - [tcatch](#cmd-tcatch) — 设置临时捕获点以捕获事件。
    - [tcatch catch](#cmd-tcatch-catch) — 在异常被捕获时捕获。
    - [tcatch exception](#cmd-tcatch-exception) — 在 Ada 异常被抛出时捕获。
    - [tcatch exec](#cmd-tcatch-exec) — 捕获对 exec 的调用。
    - [tcatch fork](#cmd-tcatch-fork) — 捕获对 fork 的调用。
    - [tcatch handlers](#cmd-tcatch-handlers) — 在 Ada 异常被处理时捕获。
    - [tcatch load](#cmd-tcatch-load) — 捕获共享库的加载。
    - [tcatch rethrow](#cmd-tcatch-rethrow) — 在异常被重新抛出时捕获。
    - [tcatch signal](#cmd-tcatch-signal) — 按名称和/或编号捕获信号。
    - [tcatch syscall](#cmd-tcatch-syscall) — 按名称、分组和/或编号捕获系统调用。
    - [tcatch throw](#cmd-tcatch-throw) — 在异常被抛出时捕获。
    - [tcatch unload](#cmd-tcatch-unload) — 捕获共享库的卸载。
    - [tcatch vfork](#cmd-tcatch-vfork) — 捕获对 vfork 的调用。
  - [thbreak](#cmd-thbreak) — 设置临时硬件辅助断点。
  - [trace](#cmd-trace) — 在指定位置设置跟踪点。
  - [watch](#cmd-watch) — 为表达式设置监视点。

- [**data（数据）**](#cat-data)
  - [agent-printf](#cmd-agent-printf) — 仅由目标 agent 执行的格式化打印，类似 C 的 "printf" 函数。
  - [append](#cmd-append) — 将目标代码/数据追加到本地文件。
    - [append binary memory](#cmd-append-binary-memory) — 将内存内容追加到原始二进制文件。
    - [append binary value](#cmd-append-binary-value) — 将表达式的值追加到原始二进制文件。
    - [append memory](#cmd-append-memory) — 将内存内容追加到原始二进制文件。
    - [append value](#cmd-append-value) — 将表达式的值追加到原始二进制文件。
  - [call](#cmd-call) — 调用程序中的函数。
  - [disassemble](#cmd-disassemble) — 反汇编指定的内存段。
  - [display](#cmd-display) — 每次程序停止时打印表达式 EXP 的值。
  - [dump](#cmd-dump) — 将目标代码/数据转储到本地文件。
    - [dump binary memory](#cmd-dump-binary-memory) — 将内存内容写入原始二进制文件。
    - [dump binary value](#cmd-dump-binary-value) — 将表达式的值写入原始二进制文件。
    - [dump ihex](#cmd-dump-ihex) — 将目标代码/数据写入 Intel hex 文件。
    - [dump ihex memory](#cmd-dump-ihex-memory) — 将内存内容写入 ihex 文件。
    - [dump ihex value](#cmd-dump-ihex-value) — 将表达式的值写入 ihex 文件。
    - [dump memory](#cmd-dump-memory) — 将内存内容写入原始二进制文件。
    - [dump srec](#cmd-dump-srec) — 将目标代码/数据写入 srec 文件。
    - [dump srec memory](#cmd-dump-srec-memory) — 将内存内容写入 srec 文件。
    - [dump srec value](#cmd-dump-srec-value) — 将表达式的值写入 srec 文件。
    - [dump tekhex](#cmd-dump-tekhex) — 将目标代码/数据写入 tekhex 文件。
    - [dump tekhex memory](#cmd-dump-tekhex-memory) — 将内存内容写入 tekhex 文件。
    - [dump tekhex value](#cmd-dump-tekhex-value) — 将表达式的值写入 tekhex 文件。
    - [dump value](#cmd-dump-value) — 将表达式的值写入原始二进制文件。
    - [dump verilog](#cmd-dump-verilog) — 将目标代码/数据写入 Verilog hex 文件。
    - [dump verilog memory](#cmd-dump-verilog-memory) — 将内存内容写入 Verilog hex 文件。
    - [dump verilog value](#cmd-dump-verilog-value) — 将表达式的值写入 Verilog hex 文件。
  - [find](#cmd-find) — 在内存中搜索字节序列。
  - [init-if-undefined](#cmd-init-if-undefined) — 如有必要则初始化便利变量。
  - [mem](#cmd-mem) — 定义内存区域属性，或将内存区域处理重置为基于目标的方式。
  - [output](#cmd-output) — 类似 "print"，但不记入值历史且不换行。
  - [print](#cmd-print) — 打印表达式 EXP 的值。
  - [print-object](#cmd-print-object) — 让 Objective-C 对象自行打印。
  - [printf](#cmd-printf) — 格式化打印，类似 C 的 "printf" 函数。
  - [ptype](#cmd-ptype) — 打印类型 TYPE 的定义。
  - [restore](#cmd-restore) — 将 FILE 的内容恢复到目标内存。
  - [set](#cmd-set) — 求值表达式 EXP 并将结果赋给变量 VAR。
    - [set ada print-signatures](#cmd-set-ada-print-signatures) — 启用或禁用在重载选择菜单中输出函数的形式参数和返回类型。
    - [set ada trust-PAD-over-XVS](#cmd-set-ada-trust-pad-over-xvs) — 启用或禁用信任 PAD 类型优于 XVS 类型的优化。
    - [set agent](#cmd-set-agent) — 设置调试器是否愿意使用 agent 作为辅助。
    - [set annotate](#cmd-set-annotate) — 设置 annotation_level。
    - [set architecture](#cmd-set-architecture) — 设置目标架构。
    - [set args](#cmd-set-args) — 设置被调试程序启动时传入的参数列表。
    - [set arm](#cmd-set-arm) — 各种 ARM 相关命令。
    - [set arm abi](#cmd-set-arm-abi) — 设置 ABI。
    - [set arm apcs32](#cmd-set-arm-apcs32) — 设置 ARM 32 位模式的使用。
    - [set arm disassembler](#cmd-set-arm-disassembler) — 设置反汇编风格。
    - [set arm fallback-mode](#cmd-set-arm-fallback-mode) — 设置符号不可用时的假定模式。
    - [set arm force-mode](#cmd-set-arm-force-mode) — 设置即使符号可用时也假定的模式。
    - [set arm fpu](#cmd-set-arm-fpu) — 设置浮点类型。
    - [set auto-connect-native-target](#cmd-set-auto-connect-native-target) — 设置 GDB 是否可自动连接到本机目标。
    - [set auto-load](#cmd-set-auto-load) — 自动加载相关设置。
    - [set auto-load gdb-scripts](#cmd-set-auto-load-gdb-scripts) — 启用或禁用自动加载预制命令序列脚本。
    - [set auto-load local-gdbinit](#cmd-set-auto-load-local-gdbinit) — 启用或禁用自动加载当前目录中的 .gdbinit 脚本。
    - [set auto-load safe-path](#cmd-set-auto-load-safe-path) — 设置可安全自动加载的文件和目录列表。
    - [set auto-load scripts-directory](#cmd-set-auto-load-scripts-directory) — 设置从中加载自动脚本的目录列表。
    - [set auto-solib-add](#cmd-set-auto-solib-add) — 设置共享库符号的自动加载。
    - [set backtrace](#cmd-set-backtrace) — 设置回溯相关变量。
    - [set backtrace limit](#cmd-set-backtrace-limit) — 设置回溯层数的上限。
    - [set backtrace past-entry](#cmd-set-backtrace-past-entry) — 设置回溯是否应越过程序入口点继续。
    - [set backtrace past-main](#cmd-set-backtrace-past-main) — 设置回溯是否应越过 "main" 继续。
    - [set basenames-may-differ](#cmd-set-basenames-may-differ) — 设置源文件是否可有多个基本名。
    - [set breakpoint](#cmd-set-breakpoint) — 断点相关设置。
    - [set breakpoint always-inserted](#cmd-set-breakpoint-always-inserted) — 设置插入断点的模式。
    - [set breakpoint auto-hw](#cmd-set-breakpoint-auto-hw) — 设置是否自动使用硬件断点。
    - [set breakpoint condition-evaluation](#cmd-set-breakpoint-condition-evaluation) — 设置断点条件求值模式。
    - [set breakpoint pending](#cmd-set-breakpoint-pending) — 设置调试器对待决断点的行为。
    - [set can-use-hw-watchpoints](#cmd-set-can-use-hw-watchpoints) — 设置调试器是否愿意使用监视点硬件。
    - [set case-sensitive](#cmd-set-case-sensitive) — 设置名称搜索的大小写敏感性（on/off/auto）。
    - [set charset](#cmd-set-charset) — 设置主机和目标字符集。
    - [set check](#cmd-set-check) — 设置类型/范围检查器的状态。
    - [set check range](#cmd-set-check-range) — 设置范围检查（on/warn/off/auto）。
    - [set check type](#cmd-set-check-type) — 设置严格类型检查。
    - [set circular-trace-buffer](#cmd-set-circular-trace-buffer) — 设置目标是否使用环形跟踪缓冲区。
    - [set code-cache](#cmd-set-code-cache) — 设置代码段访问的缓存使用。
    - [set coerce-float-to-double](#cmd-set-coerce-float-to-double) — 设置调用函数时是否将 float 强制转换为 double。
    - [set compile-args](#cmd-set-compile-args) — 设置编译命令的 GCC 命令行参数。
    - [set compile-gcc](#cmd-set-compile-gcc) — 设置编译命令的 GCC 驱动程序文件名。
    - [set complaints](#cmd-set-complaints) — 设置关于错误符号的最大抱怨次数。
    - [set confirm](#cmd-set-confirm) — 设置是否确认潜在危险操作。
    - [set cp-abi](#cmd-set-cp-abi) — 设置用于检查 C++ 对象的 ABI。
    - [set cwd](#cmd-set-cwd) — 设置 inferior 启动时使用的当前工作目录。
    - [set data-directory](#cmd-set-data-directory) — 设置 GDB 的数据目录。
    - [set dcache](#cmd-set-dcache) — 使用此命令设置 dcache 的行数和行大小。
    - [set dcache line-size](#cmd-set-dcache-line-size) — 设置 dcache 行大小（字节，必须为 2 的幂）。
    - [set dcache size](#cmd-set-dcache-size) — 设置 dcache 行数。
    - [set debug](#cmd-set-debug) — 用于设置 gdb 调试标志的通用命令。
    - [set debug arch](#cmd-set-debug-arch) — 设置架构调试。
    - [set debug arm](#cmd-set-debug-arm) — 设置 ARM 调试。
    - [set debug auto-load](#cmd-set-debug-auto-load) — 设置自动加载验证调试。
    - [set debug bfd-cache](#cmd-set-debug-bfd-cache) — 设置 bfd 缓存调试。
    - [set debug check-physname](#cmd-set-debug-check-physname) — 设置 "physname" 代码与 demangler 的交叉检查。
    - [set debug coff-pe-read](#cmd-set-debug-coff-pe-read) — 设置 coff PE 读取调试。
    - [set debug compile](#cmd-set-debug-compile) — 设置编译命令调试。
    - [set debug compile-cplus-scopes](#cmd-set-debug-compile-cplus-scopes) — 设置 C++ 编译作用域调试。
    - [set debug compile-cplus-types](#cmd-set-debug-compile-cplus-types) — 设置 C++ 编译类型转换调试。
    - [set debug displaced](#cmd-set-debug-displaced) — 设置 displaced stepping 调试。
    - [set debug dwarf-die](#cmd-set-debug-dwarf-die) — 设置 DWARF DIE 读取器调试。
    - [set debug dwarf-line](#cmd-set-debug-dwarf-line) — 设置 dwarf 行读取器调试。
    - [set debug dwarf-read](#cmd-set-debug-dwarf-read) — 设置 DWARF 读取器调试。
    - [set debug entry-values](#cmd-set-debug-entry-values) — 设置入口值和尾调用帧调试。
    - [set debug expression](#cmd-set-debug-expression) — 设置表达式调试。
    - [set debug frame](#cmd-set-debug-frame) — 设置帧调试。
    - [set debug index-cache](#cmd-set-debug-index-cache) — 设置是否显示 index-cache 调试消息。
    - [set debug infrun](#cmd-set-debug-infrun) — 设置 inferior 调试。
    - [set debug jit](#cmd-set-debug-jit) — 设置 JIT 调试。
    - [set debug notification](#cmd-set-debug-notification) — 设置异步远程通知调试。
    - [set debug observer](#cmd-set-debug-observer) — 设置 observer 调试。
    - [set debug overload](#cmd-set-debug-overload) — 设置 C++ 重载调试。
    - [set debug parser](#cmd-set-debug-parser) — 设置解析器调试。
    - [set debug record](#cmd-set-debug-record) — 设置 record/replay 功能调试。
    - [set debug remote](#cmd-set-debug-remote) — 设置远程协议调试。
    - [set debug remote-packet-max-chars](#cmd-set-debug-remote-packet-max-chars) — 设置每个远程包显示的最大字符数。
    - [set debug separate-debug-file](#cmd-set-debug-separate-debug-file) — 设置是否打印独立调试信息文件搜索的调试输出。
    - [set debug serial](#cmd-set-debug-serial) — 设置串口调试。
    - [set debug skip](#cmd-set-debug-skip) — 设置是否打印关于跳过文件和函数的调试输出。
    - [set debug stap-expression](#cmd-set-debug-stap-expression) — 设置 SystemTap 表达式调试。
    - [set debug symbol-lookup](#cmd-set-debug-symbol-lookup) — 设置符号查找调试。
    - [set debug symfile](#cmd-set-debug-symfile) — 设置 symfile 函数调试。
    - [set debug symtab-create](#cmd-set-debug-symtab-create) — 设置符号表创建调试。
    - [set debug target](#cmd-set-debug-target) — 设置目标调试。
    - [set debug timestamp](#cmd-set-debug-timestamp) — 设置是否为调试消息添加时间戳。
    - [set debug varobj](#cmd-set-debug-varobj) — 设置 varobj 调试。
    - [set debug xml](#cmd-set-debug-xml) — 设置 XML 解析器调试。
    - [set debug-file-directory](#cmd-set-debug-file-directory) — 设置搜索独立调试符号的目录。
    - [set default-collect](#cmd-set-default-collect) — 设置默认要收集的表达式列表。
    - [set demangle-style](#cmd-set-demangle-style) — 设置当前 C++ 还原符号风格。
    - [set detach-on-fork](#cmd-set-detach-on-fork) — 设置 gdb 是否在 fork 后分离子进程。
    - [set directories](#cmd-set-directories) — 设置查找源文件的搜索路径。
    - [set disable-randomization](#cmd-set-disable-randomization) — 设置是否禁用被调试进程的虚拟地址空间随机化。
    - [set disassemble-next-line](#cmd-set-disassemble-next-line) — 设置执行停止时是否反汇编下一条源行或指令。
    - [set disassembler-options](#cmd-set-disassembler-options) — 设置反汇编器选项。
    - [set disconnected-dprintf](#cmd-set-disconnected-dprintf) — 设置 GDB 断开后 dprintf 是否继续。
    - [set disconnected-tracing](#cmd-set-disconnected-tracing) — 设置 GDB 断开后跟踪是否继续。
    - [set displaced-stepping](#cmd-set-displaced-stepping) — 设置调试器是否愿意使用 displaced stepping。
    - [set dprintf-channel](#cmd-set-dprintf-channel) — 设置动态 printf 使用的通道。
    - [set dprintf-function](#cmd-set-dprintf-function) — 设置动态 printf 使用的函数。
    - [set dprintf-style](#cmd-set-dprintf-style) — 设置动态 printf 的使用风格。
    - [set dump-excluded-mappings](#cmd-set-dump-excluded-mappings) — 设置 gcore 是否转储带 VM_DONTDUMP 标志的映射。
    - [set editing](#cmd-set-editing) — 设置是否在输入时编辑命令行。
    - [set endian](#cmd-set-endian) — 设置目标字节序。
    - [set environment](#cmd-set-environment) — 设置传给程序的环境变量值。
    - [set exec-direction](#cmd-set-exec-direction) — 设置执行方向。
    - [set exec-done-display](#cmd-set-exec-done-display) — 设置异步执行命令完成时的通知。
    - [set extension-language](#cmd-set-extension-language) — 设置文件名扩展名与源语言的映射。
    - [set filename-display](#cmd-set-filename-display) — 设置如何显示文件名。
    - [set follow-exec-mode](#cmd-set-follow-exec-mode) — 设置调试器对程序调用 exec 的响应。
    - [set follow-fork-mode](#cmd-set-follow-fork-mode) — 设置调试器对程序调用 fork 或 vfork 的响应。
    - [set gnutarget](#cmd-set-gnutarget) — 设置当前 BFD 目标。
    - [set guile](#cmd-set-guile) — Guile 偏好设置的前缀命令。
    - [set guile print-stack](#cmd-set-guile-print-stack) — 设置出错时 Guile 异常打印模式。
    - [set height](#cmd-set-height) — 设置 GDB 输出分页时每页行数。
    - [set history](#cmd-set-history) — 用于设置命令历史参数的通用命令。
    - [set history expansion](#cmd-set-history-expansion) — 设置命令输入的历史展开。
    - [set history filename](#cmd-set-history-filename) — 设置记录命令历史的文件名。
    - [set history remove-duplicates](#cmd-set-history-remove-duplicates) — 设置在历史中向后查找并删除重复条目的范围。
    - [set history save](#cmd-set-history-save) — 设置退出时是否保存历史记录。
    - [set history size](#cmd-set-history-size) — 设置命令历史大小。
    - [set host-charset](#cmd-set-host-charset) — 设置主机字符集。
    - [set index-cache](#cmd-set-index-cache) — 设置 index-cache 选项。
    - [set index-cache directory](#cmd-set-index-cache-directory) — 设置 index cache 的目录。
    - [set index-cache off](#cmd-set-index-cache-off) — 禁用 index cache。
    - [set index-cache on](#cmd-set-index-cache-on) — 启用 index cache。
    - [set inferior-tty](#cmd-set-inferior-tty) — 为被调试程序今后的运行设置终端。
    - [set input-radix](#cmd-set-input-radix) — 设置输入数字的默认进制。
    - [set interactive-mode](#cmd-set-interactive-mode) — 设置 GDB 标准输入是否为终端。
    - [set language](#cmd-set-language) — 设置当前源语言。
    - [set listsize](#cmd-set-listsize) — 设置 gdb 默认列出的源行数。
    - [set logging](#cmd-set-logging) — 设置日志选项。
    - [set logging debugredirect](#cmd-set-logging-debugredirect) — 设置日志调试输出模式。
    - [set logging file](#cmd-set-logging-file) — 设置当前日志文件。
    - [set logging off](#cmd-set-logging-off) — 禁用日志。
    - [set logging on](#cmd-set-logging-on) — 启用日志。
    - [set logging overwrite](#cmd-set-logging-overwrite) — 设置日志是覆盖还是追加到日志文件。
    - [set logging redirect](#cmd-set-logging-redirect) — 设置日志输出模式。
    - [set max-completions](#cmd-set-max-completions) — 设置补全候选的最大数量。
    - [set max-user-call-depth](#cmd-set-max-user-call-depth) — 设置非 python/scheme 用户自定义命令的最大调用深度。
    - [set max-value-size](#cmd-set-max-value-size) — 设置 gdb 从 inferior 加载的值的最大尺寸。
    - [set may-call-functions](#cmd-set-may-call-functions) — 设置是否允许调用程序中的函数。
    - [set may-insert-breakpoints](#cmd-set-may-insert-breakpoints) — 设置是否允许在目标中插入断点。
    - [set may-insert-fast-tracepoints](#cmd-set-may-insert-fast-tracepoints) — 设置是否允许在目标中插入快速跟踪点。
    - [set may-insert-tracepoints](#cmd-set-may-insert-tracepoints) — 设置是否允许在目标中插入跟踪点。
    - [set may-interrupt](#cmd-set-may-interrupt) — 设置是否允许中断或向目标发信号。
    - [set may-write-memory](#cmd-set-may-write-memory) — 设置是否允许写入目标内存。
    - [set may-write-registers](#cmd-set-may-write-registers) — 设置是否允许写入寄存器。
    - [set mem](#cmd-set-mem) — 内存区域设置。
    - [set mem inaccessible-by-default](#cmd-set-mem-inaccessible-by-default) — 设置未知内存区域的处理方式。
    - [set mi-async](#cmd-set-mi-async) — 设置是否启用 MI 异步模式。
    - [set multiple-symbols](#cmd-set-multiple-symbols) — 设置调试器如何处理表达式中的歧义。
    - [set non-stop](#cmd-set-non-stop) — 设置 gdb 是否以 non-stop 模式控制 inferior。
    - [set observer](#cmd-set-observer) — 设置 gdb 是否以 observer 模式控制 inferior。
    - [set opaque-type-resolution](#cmd-set-opaque-type-resolution) — 设置不透明 struct/class/union 类型的解析（须在加载符号前设置）。
    - [set osabi](#cmd-set-osabi) — 设置目标的 OS ABI。
    - [set output-radix](#cmd-set-output-radix) — 设置打印值的默认输出进制。
    - [set overload-resolution](#cmd-set-overload-resolution) — 设置求值 C++ 函数时的重载解析。
    - [set pagination](#cmd-set-pagination) — 设置 GDB 输出分页状态。
    - [set print](#cmd-set-print) — 用于设置打印方式的通用命令。
    - [set print address](#cmd-set-print-address) — 设置是否打印地址。
    - [set print array](#cmd-set-print-array) — 设置数组的美化格式。
    - [set print array-indexes](#cmd-set-print-array-indexes) — 设置是否打印数组下标。
    - [set print asm-demangle](#cmd-set-print-asm-demangle) — 设置反汇编列表中 C++/ObjC 名称的还原。
    - [set print demangle](#cmd-set-print-demangle) — 设置显示符号时是否还原编码的 C++/ObjC 名称。
    - [set print elements](#cmd-set-print-elements) — 设置字符串字符或数组元素打印的上限。
    - [set print entry-values](#cmd-set-print-entry-values) — 设置是否在函数入口打印函数参数。
    - [set print finish](#cmd-set-print-finish) — 设置 `finish' 是否打印返回值。
    - [set print frame-arguments](#cmd-set-print-frame-arguments) — 设置是否打印非标量帧参数。
    - [set print frame-info](#cmd-set-print-frame-info) — 设置是否打印帧信息。
    - [set print inferior-events](#cmd-set-print-inferior-events) — 设置是否打印 inferior 事件（如启动和退出）。
    - [set print max-depth](#cmd-set-print-max-depth) — 设置嵌套结构体、联合体和数组的最大打印深度。
    - [set print max-symbolic-offset](#cmd-set-print-max-symbolic-offset) — 设置以 <SYMBOL+1234> 形式打印的最大偏移。
    - [set print null-stop](#cmd-set-print-null-stop) — 设置字符数组是否在首个空字符处停止打印。
    - [set print object](#cmd-set-print-object) — 设置是否打印 C++ 虚函数表。
    - [set print pascal_static-members](#cmd-set-print-pascal-static-members) — 设置是否打印 Pascal 静态成员。
    - [set print pretty](#cmd-set-print-pretty) — 设置结构体的美化格式。
    - [set print raw-frame-arguments](#cmd-set-print-raw-frame-arguments) — 设置是否以原始形式打印帧参数。
    - [set print raw-values](#cmd-set-print-raw-values) — 设置是否以原始形式打印值。
    - [set print repeats](#cmd-set-print-repeats) — 设置重复打印元素的阈值。
    - [set print sevenbit-strings](#cmd-set-print-sevenbit-strings) — 设置字符串中 8 位字符是否以 \nnn 形式打印。
    - [set print static-members](#cmd-set-print-static-members) — 设置是否打印 C++ 静态成员。
    - [set print symbol](#cmd-set-print-symbol) — 设置打印指针时是否打印符号名。
    - [set print symbol-filename](#cmd-set-print-symbol-filename) — 设置是否在 <SYMBOL> 旁打印源文件名和行号。
    - [set print symbol-loading](#cmd-set-print-symbol-loading) — 设置是否打印符号加载消息。
    - [set print thread-events](#cmd-set-print-thread-events) — 设置是否打印线程事件（如线程启动和退出）。
    - [set print type](#cmd-set-print-type) — 用于设置类型打印方式的通用命令。
    - [set print type methods](#cmd-set-print-type-methods) — 设置是否打印类中定义的方法。
    - [set print type nested-type-limit](#cmd-set-print-type-nested-type-limit) — 设置要打印的递归嵌套类型定义数量（"unlimited" 或 -1 表示全部）。
    - [set print type typedefs](#cmd-set-print-type-typedefs) — 设置是否打印类中定义的 typedef。
    - [set print union](#cmd-set-print-union) — 设置是否打印结构体内部的联合体。
    - [set print vtbl](#cmd-set-print-vtbl) — 设置是否打印 C++ 虚函数表。
    - [set prompt](#cmd-set-prompt) — 设置 gdb 提示符。
    - [set python](#cmd-set-python) — Python 偏好设置的前缀命令。
    - [set python print-stack](#cmd-set-python-print-stack) — 设置出错时 Python 栈转储模式。
    - [set radix](#cmd-set-radix) — 设置默认输入和输出数字进制。
    - [set range-stepping](#cmd-set-range-stepping) — 启用或禁用范围单步。
    - [set record](#cmd-set-record) — 设置 record 选项。
    - [set record btrace](#cmd-set-record-btrace) — 设置 record 选项。
    - [set record btrace bts](#cmd-set-record-btrace-bts) — 设置 record btrace bts 选项。
    - [set record btrace bts buffer-size](#cmd-set-record-btrace-bts-buffer-size) — 设置 record/replay bts 缓冲区大小。
    - [set record btrace cpu](#cmd-set-record-btrace-cpu) — 设置用于跟踪解码的 CPU。
    - [set record btrace cpu auto](#cmd-set-record-btrace-cpu-auto) — 自动确定用于跟踪解码的 CPU。
    - [set record btrace cpu none](#cmd-set-record-btrace-cpu-none) — 不为跟踪解码启用勘误表变通。
    - [set record btrace pt](#cmd-set-record-btrace-pt) — 设置 record btrace pt 选项。
    - [set record btrace pt buffer-size](#cmd-set-record-btrace-pt-buffer-size) — 设置 record/replay pt 缓冲区大小。
    - [set record btrace replay-memory-access](#cmd-set-record-btrace-replay-memory-access) — 设置回放期间允许的内存访问。
    - [set record full](#cmd-set-record-full) — 设置 record 选项。
    - [set record full insn-number-max](#cmd-set-record-full-insn-number-max) — 设置 record/replay 缓冲区上限。
    - [set record full memory-query](#cmd-set-record-full-memory-query) — 设置若 PREC 无法记录下一条指令的内存变化时是否查询。
    - [set record full stop-at-limit](#cmd-set-record-full-stop-at-limit) — 设置 record/replay 缓冲区满时是否停止。
    - [set record function-call-history-size](#cmd-set-record-function-call-history-size) — 设置 "record function-call-history" 中打印的函数数量。
    - [set record instruction-history-size](#cmd-set-record-instruction-history-size) — 设置 "record instruction-history" 中打印的指令数量。
    - [set remote](#cmd-set-remote) — 远程协议相关变量。
    - [set remote P-packet](#cmd-set-remote-p-packet) — 设置是否使用远程协议 `P' (set-register) 包。
    - [set remote TracepointSource-packet](#cmd-set-remote-tracepointsource-packet) — 设置是否使用远程协议 `TracepointSource' (TracepointSource) 包。
    - [set remote X-packet](#cmd-set-remote-x-packet) — 设置是否使用远程协议 `X' (binary-download) 包。
    - [set remote Z-packet](#cmd-set-remote-z-packet) — 设置是否使用远程协议 `Z' packets.
    - [set remote access-watchpoint-packet](#cmd-set-remote-access-watchpoint-packet) — 设置是否使用远程协议 `Z4' (access-watchpoint) 包。
    - [set remote agent-packet](#cmd-set-remote-agent-packet) — 设置是否使用远程协议 `QAgent' (agent) 包。
    - [set remote allow-packet](#cmd-set-remote-allow-packet) — 设置是否使用远程协议 `QAllow' (allow) 包。
    - [set remote attach-packet](#cmd-set-remote-attach-packet) — 设置是否使用远程协议 `vAttach' (attach) 包。
    - [set remote binary-download-packet](#cmd-set-remote-binary-download-packet) — 设置是否使用远程协议 `X' (binary-download) 包。
    - [set remote breakpoint-commands-packet](#cmd-set-remote-breakpoint-commands-packet) — 设置是否使用远程协议 `BreakpointCommands' (breakpoint-commands) 包。
    - [set remote btrace-conf-bts-size-packet](#cmd-set-remote-btrace-conf-bts-size-packet) — 设置是否使用远程协议 `Qbtrace-conf:bts:size' (btrace-conf-bts-size) 包。
    - [set remote btrace-conf-pt-size-packet](#cmd-set-remote-btrace-conf-pt-size-packet) — 设置是否使用远程协议 `Qbtrace-conf:pt:size' (btrace-conf-pt-size) 包。
    - [set remote catch-syscalls-packet](#cmd-set-remote-catch-syscalls-packet) — 设置是否使用远程协议 `QCatchSyscalls' (catch-syscalls) 包。
    - [set remote conditional-breakpoints-packet](#cmd-set-remote-conditional-breakpoints-packet) — 设置是否使用远程协议 `ConditionalBreakpoints' (conditional-breakpoints) 包。
    - [set remote conditional-tracepoints-packet](#cmd-set-remote-conditional-tracepoints-packet) — 设置是否使用远程协议 `ConditionalTracepoints' (conditional-tracepoints) 包。
    - [set remote ctrl-c-packet](#cmd-set-remote-ctrl-c-packet) — 设置是否使用远程协议 `vCtrlC' (ctrl-c) 包。
    - [set remote disable-btrace-packet](#cmd-set-remote-disable-btrace-packet) — 设置是否使用远程协议 `Qbtrace:off' (disable-btrace) 包。
    - [set remote disable-randomization-packet](#cmd-set-remote-disable-randomization-packet) — 设置是否使用远程协议 `QDisableRandomization' (disable-randomization) 包。
    - [set remote enable-btrace-bts-packet](#cmd-set-remote-enable-btrace-bts-packet) — 设置是否使用远程协议 `Qbtrace:bts' (enable-btrace-bts) 包。
    - [set remote enable-btrace-pt-packet](#cmd-set-remote-enable-btrace-pt-packet) — 设置是否使用远程协议 `Qbtrace:pt' (enable-btrace-pt) 包。
    - [set remote environment-hex-encoded-packet](#cmd-set-remote-environment-hex-encoded-packet) — 设置是否使用远程协议 `QEnvironmentHexEncoded' (environment-hex-encoded) 包。
    - [set remote environment-reset-packet](#cmd-set-remote-environment-reset-packet) — 设置是否使用远程协议 `QEnvironmentReset' (environment-reset) 包。
    - [set remote environment-unset-packet](#cmd-set-remote-environment-unset-packet) — 设置是否使用远程协议 `QEnvironmentUnset' (environment-unset) 包。
    - [set remote exec-event-feature-packet](#cmd-set-remote-exec-event-feature-packet) — 设置是否使用远程协议 `exec-event-feature' (exec-event-feature) 包。
    - [set remote exec-file](#cmd-set-remote-exec-file) — 设置 "run" 的远程路径名。
    - [set remote fast-tracepoints-packet](#cmd-set-remote-fast-tracepoints-packet) — 设置是否使用远程协议 `FastTracepoints' (fast-tracepoints) 包。
    - [set remote fetch-register-packet](#cmd-set-remote-fetch-register-packet) — 设置是否使用远程协议 `p' (fetch-register) 包。
    - [set remote fork-event-feature-packet](#cmd-set-remote-fork-event-feature-packet) — 设置是否使用远程协议 `fork-event-feature' (fork-event-feature) 包。
    - [set remote get-thread-information-block-address-packet](#cmd-set-remote-get-thread-information-block-address-packet) — 设置是否使用远程协议 `qGetTIBAddr' (get-thread-information-block-address) 包。
    - [set remote get-thread-local-storage-address-packet](#cmd-set-remote-get-thread-local-storage-address-packet) — 设置是否使用远程协议 `qGetTLSAddr' (get-thread-local-storage-address) 包。
    - [set remote hardware-breakpoint-limit](#cmd-set-remote-hardware-breakpoint-limit) — 设置目标硬件断点的最大数量。
    - [set remote hardware-breakpoint-packet](#cmd-set-remote-hardware-breakpoint-packet) — 设置是否使用远程协议 `Z1' (hardware-breakpoint) 包。
    - [set remote hardware-watchpoint-length-limit](#cmd-set-remote-hardware-watchpoint-length-limit) — 设置目标硬件监视点的最大长度（字节）。
    - [set remote hardware-watchpoint-limit](#cmd-set-remote-hardware-watchpoint-limit) — 设置目标硬件监视点的最大数量。
    - [set remote hostio-close-packet](#cmd-set-remote-hostio-close-packet) — 设置是否使用远程协议 `vFile:close' (hostio-close) 包。
    - [set remote hostio-fstat-packet](#cmd-set-remote-hostio-fstat-packet) — 设置是否使用远程协议 `vFile:fstat' (hostio-fstat) 包。
    - [set remote hostio-open-packet](#cmd-set-remote-hostio-open-packet) — 设置是否使用远程协议 `vFile:open' (hostio-open) 包。
    - [set remote hostio-pread-packet](#cmd-set-remote-hostio-pread-packet) — 设置是否使用远程协议 `vFile:pread' (hostio-pread) 包。
    - [set remote hostio-pwrite-packet](#cmd-set-remote-hostio-pwrite-packet) — 设置是否使用远程协议 `vFile:pwrite' (hostio-pwrite) 包。
    - [set remote hostio-readlink-packet](#cmd-set-remote-hostio-readlink-packet) — 设置是否使用远程协议 `vFile:readlink' (hostio-readlink) 包。
    - [set remote hostio-setfs-packet](#cmd-set-remote-hostio-setfs-packet) — 设置是否使用远程协议 `vFile:setfs' (hostio-setfs) 包。
    - [set remote hostio-unlink-packet](#cmd-set-remote-hostio-unlink-packet) — 设置是否使用远程协议 `vFile:unlink' (hostio-unlink) 包。
    - [set remote hwbreak-feature-packet](#cmd-set-remote-hwbreak-feature-packet) — 设置是否使用远程协议 `hwbreak-feature' (hwbreak-feature) 包。
    - [set remote install-in-trace-packet](#cmd-set-remote-install-in-trace-packet) — 设置是否使用远程协议 `InstallInTrace' (install-in-trace) 包。
    - [set remote interrupt-on-connect](#cmd-set-remote-interrupt-on-connect) — 设置 gdb 连接时是否向远程目标发送中断序列。
    - [set remote interrupt-sequence](#cmd-set-remote-interrupt-sequence) — 设置发往远程目标的中断序列。
    - [set remote kill-packet](#cmd-set-remote-kill-packet) — 设置是否使用远程协议 `vKill' (kill) 包。
    - [set remote library-info-packet](#cmd-set-remote-library-info-packet) — 设置是否使用远程协议 `qXfer:libraries:read' (library-info) 包。
    - [set remote library-info-svr4-packet](#cmd-set-remote-library-info-svr4-packet) — 设置是否使用远程协议 `qXfer:libraries-svr4:read' (library-info-svr4) 包。
    - [set remote memory-map-packet](#cmd-set-remote-memory-map-packet) — 设置是否使用远程协议 `qXfer:memory-map:read' (memory-map) 包。
    - [set remote memory-read-packet-size](#cmd-set-remote-memory-read-packet-size) — 设置每个内存读包的最大字节数。
    - [set remote memory-write-packet-size](#cmd-set-remote-memory-write-packet-size) — 设置每个内存写包的最大字节数。
    - [set remote multiprocess-feature-packet](#cmd-set-remote-multiprocess-feature-packet) — 设置是否使用远程协议 `multiprocess-feature' (multiprocess-feature) 包。
    - [set remote no-resumed-stop-reply-packet](#cmd-set-remote-no-resumed-stop-reply-packet) — 设置是否使用远程协议 `N stop reply' (no-resumed-stop-reply) 包。
    - [set remote noack-packet](#cmd-set-remote-noack-packet) — 设置是否使用远程协议 `QStartNoAckMode' (noack) 包。
    - [set remote osdata-packet](#cmd-set-remote-osdata-packet) — 设置是否使用远程协议 `qXfer:osdata:read' (osdata) 包。
    - [set remote p-packet](#cmd-set-remote-p-packet-2) — 设置是否使用远程协议 `p' (fetch-register) 包。
    - [set remote pass-signals-packet](#cmd-set-remote-pass-signals-packet) — 设置是否使用远程协议 `QPassSignals' (pass-signals) 包。
    - [set remote pid-to-exec-file-packet](#cmd-set-remote-pid-to-exec-file-packet) — 设置是否使用远程协议 `qXfer:exec-file:read' (pid-to-exec-file) 包。
    - [set remote program-signals-packet](#cmd-set-remote-program-signals-packet) — 设置是否使用远程协议 `QProgramSignals' (program-signals) 包。
    - [set remote query-attached-packet](#cmd-set-remote-query-attached-packet) — 设置是否使用远程协议 `qAttached' (query-attached) 包。
    - [set remote read-aux-vector-packet](#cmd-set-remote-read-aux-vector-packet) — 设置是否使用远程协议 `qXfer:auxv:read' (read-aux-vector) 包。
    - [set remote read-btrace-conf-packet](#cmd-set-remote-read-btrace-conf-packet) — 设置是否使用远程协议 `qXfer:btrace-conf' (read-btrace-conf) 包。
    - [set remote read-btrace-packet](#cmd-set-remote-read-btrace-packet) — 设置是否使用远程协议 `qXfer:btrace' (read-btrace) 包。
    - [set remote read-fdpic-loadmap-packet](#cmd-set-remote-read-fdpic-loadmap-packet) — 设置是否使用远程协议 `qXfer:fdpic:read' (read-fdpic-loadmap) 包。
    - [set remote read-sdata-object-packet](#cmd-set-remote-read-sdata-object-packet) — 设置是否使用远程协议 `qXfer:statictrace:read' (read-sdata-object) 包。
    - [set remote read-siginfo-object-packet](#cmd-set-remote-read-siginfo-object-packet) — 设置是否使用远程协议 `qXfer:siginfo:read' (read-siginfo-object) 包。
    - [set remote read-watchpoint-packet](#cmd-set-remote-read-watchpoint-packet) — 设置是否使用远程协议 `Z3' (read-watchpoint) 包。
    - [set remote reverse-continue-packet](#cmd-set-remote-reverse-continue-packet) — 设置是否使用远程协议 `bc' (reverse-continue) 包。
    - [set remote reverse-step-packet](#cmd-set-remote-reverse-step-packet) — 设置是否使用远程协议 `bs' (reverse-step) 包。
    - [set remote run-packet](#cmd-set-remote-run-packet) — 设置是否使用远程协议 `vRun' (run) 包。
    - [set remote search-memory-packet](#cmd-set-remote-search-memory-packet) — 设置是否使用远程协议 `qSearch:memory' (search-memory) 包。
    - [set remote set-register-packet](#cmd-set-remote-set-register-packet) — 设置是否使用远程协议 `P' (set-register) 包。
    - [set remote set-working-dir-packet](#cmd-set-remote-set-working-dir-packet) — 设置是否使用远程协议 `QSetWorkingDir' (set-working-dir) 包。
    - [set remote software-breakpoint-packet](#cmd-set-remote-software-breakpoint-packet) — 设置是否使用远程协议 `Z0' (software-breakpoint) 包。
    - [set remote startup-with-shell-packet](#cmd-set-remote-startup-with-shell-packet) — 设置是否使用远程协议 `QStartupWithShell' (startup-with-shell) 包。
    - [set remote static-tracepoints-packet](#cmd-set-remote-static-tracepoints-packet) — 设置是否使用远程协议 `StaticTracepoints' (static-tracepoints) 包。
    - [set remote supported-packets-packet](#cmd-set-remote-supported-packets-packet) — 设置是否使用远程协议 `qSupported' (supported-packets) 包。
    - [set remote swbreak-feature-packet](#cmd-set-remote-swbreak-feature-packet) — 设置是否使用远程协议 `swbreak-feature' (swbreak-feature) 包。
    - [set remote symbol-lookup-packet](#cmd-set-remote-symbol-lookup-packet) — 设置是否使用远程协议 `qSymbol' (symbol-lookup) 包。
    - [set remote system-call-allowed](#cmd-set-remote-system-call-allowed) — 设置是否允许目标使用主机的 system(3) 调用。
    - [set remote target-features-packet](#cmd-set-remote-target-features-packet) — 设置是否使用远程协议 `qXfer:features:read' (target-features) 包。
    - [set remote thread-events-packet](#cmd-set-remote-thread-events-packet) — 设置是否使用远程协议 `QThreadEvents' (thread-events) 包。
    - [set remote threads-packet](#cmd-set-remote-threads-packet) — 设置是否使用远程协议 `qXfer:threads:read' (threads) 包。
    - [set remote trace-buffer-size-packet](#cmd-set-remote-trace-buffer-size-packet) — 设置是否使用远程协议 `QTBuffer:size' (trace-buffer-size) 包。
    - [set remote trace-status-packet](#cmd-set-remote-trace-status-packet) — 设置是否使用远程协议 `qTStatus' (trace-status) 包。
    - [set remote traceframe-info-packet](#cmd-set-remote-traceframe-info-packet) — 设置是否使用远程协议 `qXfer:traceframe-info:read' (traceframe-info) 包。
    - [set remote unwind-info-block-packet](#cmd-set-remote-unwind-info-block-packet) — 设置是否使用远程协议 `qXfer:uib:read' (unwind-info-block) 包。
    - [set remote verbose-resume-packet](#cmd-set-remote-verbose-resume-packet) — 设置是否使用远程协议 `vCont' (verbose-resume) 包。
    - [set remote verbose-resume-supported-packet](#cmd-set-remote-verbose-resume-supported-packet) — 设置是否使用远程协议 `vContSupported' (verbose-resume-supported) 包。
    - [set remote vfork-event-feature-packet](#cmd-set-remote-vfork-event-feature-packet) — 设置是否使用远程协议 `vfork-event-feature' (vfork-event-feature) 包。
    - [set remote write-siginfo-object-packet](#cmd-set-remote-write-siginfo-object-packet) — 设置是否使用远程协议 `qXfer:siginfo:write' (write-siginfo-object) 包。
    - [set remote write-watchpoint-packet](#cmd-set-remote-write-watchpoint-packet) — 设置是否使用远程协议 `Z2' (write-watchpoint) 包。
    - [set remoteaddresssize](#cmd-set-remoteaddresssize) — 设置内存包中地址的最大位数。
    - [set remotecache](#cmd-set-remotecache) — 设置远程目标的缓存使用。
    - [set remoteflow](#cmd-set-remoteflow) — 设置远程串口 I/O 是否使用硬件流控。
    - [set remotelogbase](#cmd-set-remotelogbase) — 设置远程会话日志的数字进制。
    - [set remotelogfile](#cmd-set-remotelogfile) — 设置远程会话记录的文件名。
    - [set remotetimeout](#cmd-set-remotetimeout) — 设置等待目标响应的超时限制。
    - [set remotewritesize](#cmd-set-remotewritesize) — 设置每个内存写包的最大字节数（已弃用）。
    - [set schedule-multiple](#cmd-set-schedule-multiple) — 设置恢复所有进程线程的模式。
    - [set scheduler-locking](#cmd-set-scheduler-locking) — 设置执行期间锁定调度器的模式。
    - [set script-extension](#cmd-set-script-extension) — 设置脚本文件名扩展名识别模式。
    - [set serial](#cmd-set-serial) — 设置默认串口/并口配置。
    - [set serial baud](#cmd-set-serial-baud) — 设置远程串口 I/O 的波特率。
    - [set serial parity](#cmd-set-serial-parity) — 设置远程串口 I/O 的奇偶校验。
    - [set solib-absolute-prefix](#cmd-set-solib-absolute-prefix) — 设置备用系统根目录。
    - [set solib-search-path](#cmd-set-solib-search-path) — 设置加载非绝对路径共享库符号文件的搜索路径。
    - [set stack-cache](#cmd-set-stack-cache) — 设置栈访问的缓存使用。
    - [set step-mode](#cmd-set-step-mode) — 设置 step 操作的模式。
    - [set stop-on-solib-events](#cmd-set-stop-on-solib-events) — 设置是否在共享库事件处停止。
    - [set style](#cmd-set-style) — 样式相关设置。
    - [set style address](#cmd-set-style-address) — 地址显示样式。
    - [set style address background](#cmd-set-style-address-background) — 设置此属性的背景色。
    - [set style address foreground](#cmd-set-style-address-foreground) — 设置此属性的前景色。
    - [set style address intensity](#cmd-set-style-address-intensity) — 设置此属性的显示强度。
    - [set style enabled](#cmd-set-style-enabled) — 设置是否启用 CLI 样式。
    - [set style filename](#cmd-set-style-filename) — 文件名显示样式。
    - [set style filename background](#cmd-set-style-filename-background) — 设置此属性的背景色。
    - [set style filename foreground](#cmd-set-style-filename-foreground) — 设置此属性的前景色。
    - [set style filename intensity](#cmd-set-style-filename-intensity) — 设置此属性的显示强度。
    - [set style function](#cmd-set-style-function) — 函数名显示样式。
    - [set style function background](#cmd-set-style-function-background) — 设置此属性的背景色。
    - [set style function foreground](#cmd-set-style-function-foreground) — 设置此属性的前景色。
    - [set style function intensity](#cmd-set-style-function-intensity) — 设置此属性的显示强度。
    - [set style highlight](#cmd-set-style-highlight) — 高亮显示样式。
    - [set style highlight background](#cmd-set-style-highlight-background) — 设置此属性的背景色。
    - [set style highlight foreground](#cmd-set-style-highlight-foreground) — 设置此属性的前景色。
    - [set style highlight intensity](#cmd-set-style-highlight-intensity) — 设置此属性的显示强度。
    - [set style metadata](#cmd-set-style-metadata) — 元数据显示样式。
    - [set style metadata background](#cmd-set-style-metadata-background) — 设置此属性的背景色。
    - [set style metadata foreground](#cmd-set-style-metadata-foreground) — 设置此属性的前景色。
    - [set style metadata intensity](#cmd-set-style-metadata-intensity) — 设置此属性的显示强度。
    - [set style sources](#cmd-set-style-sources) — 设置是否启用源代码样式。
    - [set style title](#cmd-set-style-title) — 标题显示样式。
    - [set style title background](#cmd-set-style-title-background) — 设置此属性的背景色。
    - [set style title foreground](#cmd-set-style-title-foreground) — 设置此属性的前景色。
    - [set style title intensity](#cmd-set-style-title-intensity) — 设置此属性的显示强度。
    - [set style tui-active-border](#cmd-set-style-tui-active-border) — TUI 活动边框显示样式。
    - [set style tui-active-border background](#cmd-set-style-tui-active-border-background) — 设置此属性的背景色。
    - [set style tui-active-border foreground](#cmd-set-style-tui-active-border-foreground) — 设置此属性的前景色。
    - [set style tui-border](#cmd-set-style-tui-border) — TUI 边框显示样式。
    - [set style tui-border background](#cmd-set-style-tui-border-background) — 设置此属性的背景色。
    - [set style tui-border foreground](#cmd-set-style-tui-border-foreground) — 设置此属性的前景色。
    - [set style variable](#cmd-set-style-variable) — 变量名显示样式。
    - [set style variable background](#cmd-set-style-variable-background) — 设置此属性的背景色。
    - [set style variable foreground](#cmd-set-style-variable-foreground) — 设置此属性的前景色。
    - [set style variable intensity](#cmd-set-style-variable-intensity) — 设置此属性的显示强度。
    - [set substitute-path](#cmd-set-substitute-path) — 添加用于重写源目录的替换规则。
    - [set sysroot](#cmd-set-sysroot) — 设置备用系统根目录。
    - [set target-charset](#cmd-set-target-charset) — 设置目标字符集。
    - [set target-file-system-kind](#cmd-set-target-file-system-kind) — 设置目标报告文件名所假定的文件系统类型。
    - [set target-wide-charset](#cmd-set-target-wide-charset) — 设置目标宽字符集。
    - [set tcp](#cmd-set-tcp) — TCP 协议相关变量。
    - [set tcp auto-retry](#cmd-set-tcp-auto-retry) — 设置套接字连接是否自动重试。
    - [set tcp connect-timeout](#cmd-set-tcp-connect-timeout) — 设置套接字连接的超时限制（秒）。
    - [set tdesc](#cmd-set-tdesc) — 目标描述相关变量。
    - [set tdesc filename](#cmd-set-tdesc-filename) — 设置用于读取 XML 目标描述的文件。
    - [set trace-buffer-size](#cmd-set-trace-buffer-size) — 设置请求的跟踪缓冲区大小。
    - [set trace-commands](#cmd-set-trace-commands) — 设置是否跟踪 GDB CLI 命令。
    - [set trace-notes](#cmd-set-trace-notes) — 设置当前及今后跟踪运行使用的备注字符串。
    - [set trace-stop-notes](#cmd-set-trace-stop-notes) — 设置今后 tstop 命令使用的备注字符串。
    - [set trace-user](#cmd-set-trace-user) — 设置当前及今后跟踪运行使用的用户名。
    - [set trust-readonly-sections](#cmd-set-trust-readonly-sections) — 设置从只读段读取的模式。
    - [set tui](#cmd-set-tui) — TUI 配置变量。
    - [set tui active-border-mode](#cmd-set-tui-active-border-mode) — 设置活动 TUI 窗口边框使用的属性模式。
    - [set tui border-kind](#cmd-set-tui-border-kind) — 设置 TUI 窗口边框类型。
    - [set tui border-mode](#cmd-set-tui-border-mode) — 设置 TUI 窗口边框使用的属性模式。
    - [set tui compact-source](#cmd-set-tui-compact-source) — 设置 TUI 源窗口是否紧凑。
    - [set tui tab-width](#cmd-set-tui-tab-width) — 设置 TUI 的制表符宽度（字符数）。
    - [set unwind-on-terminating-exception](#cmd-set-unwind-on-terminating-exception) — 设置在 call dummy 中调用 std::terminate 时是否展开栈。
    - [set unwindonsignal](#cmd-set-unwindonsignal) — 设置在 call dummy 中收到信号时是否展开栈。
    - [set use-coredump-filter](#cmd-set-use-coredump-filter) — 设置 gcore 是否考虑 /proc/PID/coredump_filter。
    - [set use-deprecated-index-sections](#cmd-set-use-deprecated-index-sections) — 设置是否使用已弃用的 gdb_index 段。
    - [set var](#cmd-set-var) — 求值表达式 EXP 并将结果赋给变量 VAR。
    - [set variable](#cmd-set-variable) — 求值表达式 EXP 并将结果赋给变量 VAR。
    - [set varsize-limit](#cmd-set-varsize-limit) — 设置可变大小对象允许的最大字节数。
    - [set verbose](#cmd-set-verbose) — 设置详细程度。
    - [set watchdog](#cmd-set-watchdog) — 设置看门狗定时器。
    - [set width](#cmd-set-width) — 设置 GDB 输出换行的字符数。
    - [set write](#cmd-set-write) — 设置是否写入可执行文件和 core 文件。
  - [undisplay](#cmd-undisplay) — 取消程序停止时要显示的部分表达式。
  - [whatis](#cmd-whatis) — 打印表达式 EXP 的数据类型。
  - [with](#cmd-with) — 临时将 SETTING 设为 VALUE，运行 COMMAND，然后恢复 SETTING。
  - [x](#cmd-x) — 检查内存：x/FMT ADDRESS。

- [**files（文件）**](#cat-files)
  - [add-symbol-file](#cmd-add-symbol-file) — 从 FILE 加载符号，假定 FILE 已被动态加载。
  - [add-symbol-file-from-memory](#cmd-add-symbol-file-from-memory) — 从动态加载的目标文件的内存中加载符号。
  - [cd](#cmd-cd) — 为调试器将工作目录设为 DIR。
  - [core-file](#cmd-core-file) — 使用 FILE 作为 core 转储以检查内存和寄存器。
  - [directory](#cmd-directory) — 将目录 DIR 添加到源文件搜索路径开头。
  - [edit](#cmd-edit) — 编辑指定文件或函数。
  - [exec-file](#cmd-exec-file) — 使用 FILE 作为获取纯内存内容的程序。
  - [file](#cmd-file) — 使用 FILE 作为要调试的程序。
  - [forward-search](#cmd-forward-search) — 从上次列出的行起向前搜索正则表达式（见 regex(3)）。
  - [generate-core-file](#cmd-generate-core-file) — 保存包含被调试进程当前状态的 core 文件。
  - [list](#cmd-list) — 列出指定函数或行。
  - [load](#cmd-load) — 将 FILE 动态加载到运行中的程序。
  - [nosharedlibrary](#cmd-nosharedlibrary) — 卸载所有共享对象库符号。
  - [path](#cmd-path) — 将目录 DIR(s) 添加到目标文件搜索路径开头。
  - [pwd](#cmd-pwd) — 打印工作目录。
  - [remote](#cmd-remote) — 操作远程系统上的文件。
    - [remote get](#cmd-remote-get) — 将远程文件复制到本地系统。
    - [remote put](#cmd-remote-put) — 将本地文件复制到远程系统。
  - [remove-symbol-file](#cmd-remove-symbol-file) — 移除通过 add-symbol-file 命令添加的符号文件。
  - [reverse-search](#cmd-reverse-search) — 从上次列出的行起向后搜索正则表达式（见 regex(3)）。
  - [search](#cmd-search) — 从上次列出的行起搜索正则表达式（见 regex(3)）。
  - [section](#cmd-section) — 将可执行文件段 SECTION 的基址改为 ADDR。
  - [sharedlibrary](#cmd-sharedlibrary) — 为匹配 REGEXP 的文件加载共享对象库符号。
  - [symbol-file](#cmd-symbol-file) — 从可执行文件 FILE 加载符号表。

- [**internals（内部）**](#cat-internals)
  - [flushregs](#cmd-flushregs) — 强制 gdb 刷新其寄存器缓存（维护者命令）。
  - [maintenance](#cmd-maintenance) — 供 GDB 维护者使用的命令。
    - [maintenance agent-eval](#cmd-maintenance-agent-eval) — 将表达式转换为用于求值的远程 agent 字节码。
    - [maintenance agent-printf](#cmd-maintenance-agent-printf) — 将表达式转换为用于求值的远程 agent 字节码并显示字节码。
    - [maintenance btrace](#cmd-maintenance-btrace) — 分支跟踪维护命令。
    - [maintenance btrace clear](#cmd-maintenance-btrace-clear) — 清除分支跟踪数据。
    - [maintenance btrace clear-packet-history](#cmd-maintenance-btrace-clear-packet-history) — 清除分支跟踪包历史。
    - [maintenance btrace packet-history](#cmd-maintenance-btrace-packet-history) — 打印原始分支跟踪数据。
    - [maintenance check](#cmd-maintenance-check) — 用于检查 gdb 内部状态的命令。
    - [maintenance check xml-descriptions](#cmd-maintenance-check-xml-descriptions) — 检查 GDB 目标描述与 XML 创建描述是否一致。
    - [maintenance check-psymtabs](#cmd-maintenance-check-psymtabs) — 检查当前已展开 psymtab 与 symtab 的一致性。
    - [maintenance check-symtabs](#cmd-maintenance-check-symtabs) — 检查当前已展开 symtab 的一致性。
    - [maintenance cplus](#cmd-maintenance-cplus) — C++ 维护命令。
    - [maintenance cplus first_component](#cmd-maintenance-cplus-first-component) — 打印 NAME 的第一个类/命名空间组件。
    - [maintenance demangler-warning](#cmd-maintenance-demangler-warning) — 向 GDB 发出 demangler 警告。
    - [maintenance deprecate](#cmd-maintenance-deprecate) — 弃用命令（用于测试）。
    - [maintenance dump-me](#cmd-maintenance-dump-me) — 触发致命错误；使调试器转储其 core。
    - [maintenance expand-symtabs](#cmd-maintenance-expand-symtabs) — 展开符号表。
    - [maintenance flush-symbol-cache](#cmd-maintenance-flush-symbol-cache) — 刷新每个程序空间的符号缓存。
    - [maintenance info](#cmd-maintenance-info) — 用于显示被调试程序内部信息的命令。
    - [maintenance info bfds](#cmd-maintenance-info-bfds) — 列出当前打开的 BFD。
    - [maintenance info breakpoints](#cmd-maintenance-info-breakpoints) — 所有断点的状态，或断点编号 NUMBER。
    - [maintenance info btrace](#cmd-maintenance-info-btrace) — 关于分支跟踪数据的信息。
    - [maintenance info line-table](#cmd-maintenance-info-line-table) — 列出所有符号表中行表的内容。
    - [maintenance info program-spaces](#cmd-maintenance-info-program-spaces) — 关于当前已知程序空间的信息。
    - [maintenance info psymtabs](#cmd-maintenance-info-psymtabs) — 列出所有目标文件的部分符号表。
    - [maintenance info sections](#cmd-maintenance-info-sections) — 列出可执行文件和 core 文件的 BFD 段。
    - [maintenance info selftests](#cmd-maintenance-info-selftests) — 列出已注册的自测项。
    - [maintenance info symtabs](#cmd-maintenance-info-symtabs) — 列出所有目标文件的完整符号表。
    - [maintenance internal-error](#cmd-maintenance-internal-error) — 向 GDB 发出内部错误。
    - [maintenance internal-warning](#cmd-maintenance-internal-warning) — 向 GDB 发出内部警告。
    - [maintenance packet](#cmd-maintenance-packet) — 向远程目标发送任意包。
    - [maintenance print](#cmd-maintenance-print) — 用于打印 GDB 内部状态的维护命令。
    - [maintenance print architecture](#cmd-maintenance-print-architecture) — 打印内部架构配置。
    - [maintenance print c-tdesc](#cmd-maintenance-print-c-tdesc) — 将当前目标描述打印为 C 源文件。
    - [maintenance print cooked-registers](#cmd-maintenance-print-cooked-registers) — 打印内部寄存器配置（含 cooked 值）。
    - [maintenance print dummy-frames](#cmd-maintenance-print-dummy-frames) — 打印内部 dummy 帧栈内容。
    - [maintenance print msymbols](#cmd-maintenance-print-msymbols) — 打印当前最小符号定义的转储。
    - [maintenance print objfiles](#cmd-maintenance-print-objfiles) — 打印当前目标文件定义的转储。
    - [maintenance print psymbols](#cmd-maintenance-print-psymbols) — 打印当前部分符号定义的转储。
    - [maintenance print raw-registers](#cmd-maintenance-print-raw-registers) — 打印内部寄存器配置（含 raw 值）。
    - [maintenance print reggroups](#cmd-maintenance-print-reggroups) — 打印内部寄存器组名。
    - [maintenance print register-groups](#cmd-maintenance-print-register-groups) — 打印内部寄存器配置（含各寄存器所属组）。
    - [maintenance print registers](#cmd-maintenance-print-registers) — 打印内部寄存器配置。
    - [maintenance print remote-registers](#cmd-maintenance-print-remote-registers) — 打印内部寄存器配置（含远程寄存器编号及 g/G 包偏移）。
    - [maintenance print statistics](#cmd-maintenance-print-statistics) — 打印关于 gdb 内部状态的统计信息。
    - [maintenance print symbol-cache](#cmd-maintenance-print-symbol-cache) — 转储每个程序空间的符号缓存。
    - [maintenance print symbol-cache-statistics](#cmd-maintenance-print-symbol-cache-statistics) — 打印每个程序空间的符号缓存统计。
    - [maintenance print symbols](#cmd-maintenance-print-symbols) — 打印当前符号定义的转储。
    - [maintenance print target-stack](#cmd-maintenance-print-target-stack) — 打印内部目标栈各层名称。
    - [maintenance print type](#cmd-maintenance-print-type) — 打印给定符号的类型链。
    - [maintenance print user-registers](#cmd-maintenance-print-user-registers) — 列出当前用户寄存器名称。
    - [maintenance selftest](#cmd-maintenance-selftest) — 运行 gdb 单元测试。
    - [maintenance set](#cmd-maintenance-set) — 设置 GDB 维护者使用的内部变量。
    - [maintenance set ada](#cmd-maintenance-set-ada) — 设置 Ada 维护相关变量。
    - [maintenance set ada ignore-descriptive-types](#cmd-maintenance-set-ada-ignore-descriptive-types) — 设置是否忽略 GNAT 生成的描述性类型。
    - [maintenance set bfd-sharing](#cmd-maintenance-set-bfd-sharing) — 设置 gdb 是否共享看似相同的 bfd 文件。
    - [maintenance set btrace](#cmd-maintenance-set-btrace) — 设置分支跟踪相关变量。
    - [maintenance set btrace pt](#cmd-maintenance-set-btrace-pt) — 设置 Intel Processor Trace 相关变量。
    - [maintenance set btrace pt skip-pad](#cmd-maintenance-set-btrace-pt-skip-pad) — 设置是否在 btrace 包历史中跳过 PAD 包。
    - [maintenance set catch-demangler-crashes](#cmd-maintenance-set-catch-demangler-crashes) — 设置是否尝试捕获 demangler 崩溃。
    - [maintenance set demangler-warning](#cmd-maintenance-set-demangler-warning) — 配置检测到 demangler-warning 时 GDB 的行为。
    - [maintenance set demangler-warning quit](#cmd-maintenance-set-demangler-warning-quit) — 设置检测到 demangler-warning 时 GDB 是否退出。
    - [maintenance set dwarf](#cmd-maintenance-set-dwarf) — 设置 DWARF 相关变量。
    - [maintenance set dwarf always-disassemble](#cmd-maintenance-set-dwarf-always-disassemble) — 设置 `info address' 是否总是反汇编 DWARF 表达式。
    - [maintenance set dwarf max-cache-age](#cmd-maintenance-set-dwarf-max-cache-age) — 设置缓存的 DWARF 编译单元年龄上限。
    - [maintenance set dwarf unwinders](#cmd-maintenance-set-dwarf-unwinders) — 设置是否使用 DWARF 栈帧展开器。
    - [maintenance set internal-error](#cmd-maintenance-set-internal-error) — 配置检测到 internal-error 时 GDB 的行为。
    - [maintenance set internal-error corefile](#cmd-maintenance-set-internal-error-corefile) — 设置检测到 internal-error 时 GDB 是否生成自身的 core 文件。
    - [maintenance set internal-error quit](#cmd-maintenance-set-internal-error-quit) — 设置检测到 internal-error 时 GDB 是否退出。
    - [maintenance set internal-warning](#cmd-maintenance-set-internal-warning) — 配置检测到 internal-warning 时 GDB 的行为。
    - [maintenance set internal-warning corefile](#cmd-maintenance-set-internal-warning-corefile) — 设置检测到 internal-warning 时 GDB 是否生成自身的 core 文件。
    - [maintenance set internal-warning quit](#cmd-maintenance-set-internal-warning-quit) — 设置检测到 internal-warning 时 GDB 是否退出。
    - [maintenance set per-command](#cmd-maintenance-set-per-command) — 每条命令的统计设置。
    - [maintenance set per-command space](#cmd-maintenance-set-per-command-space) — 设置是否显示每条命令的空间占用。
    - [maintenance set per-command symtab](#cmd-maintenance-set-per-command-symtab) — 设置是否显示每条命令的 symtab 统计。
    - [maintenance set per-command time](#cmd-maintenance-set-per-command-time) — 设置是否显示每条命令的执行时间。
    - [maintenance set profile](#cmd-maintenance-set-profile) — 设置内部性能分析。
    - [maintenance set symbol-cache-size](#cmd-maintenance-set-symbol-cache-size) — 设置符号缓存大小。
    - [maintenance set target-async](#cmd-maintenance-set-target-async) — 设置 gdb 是否以异步模式控制 inferior。
    - [maintenance set target-non-stop](#cmd-maintenance-set-target-non-stop) — 设置 gdb 是否始终以 non-stop 模式控制 inferior。
    - [maintenance set test-settings](#cmd-maintenance-set-test-settings) — 设置用于 set/show 命令基础设施测试的 GDB 内部变量。
    - [maintenance set test-settings auto-boolean](#cmd-maintenance-set-test-settings-auto-boolean) — 用于内部测试的命令。
    - [maintenance set test-settings boolean](#cmd-maintenance-set-test-settings-boolean) — 用于内部测试的命令。
    - [maintenance set test-settings enum](#cmd-maintenance-set-test-settings-enum) — 用于内部测试的命令。
    - [maintenance set test-settings filename](#cmd-maintenance-set-test-settings-filename) — 用于内部测试的命令。
    - [maintenance set test-settings integer](#cmd-maintenance-set-test-settings-integer) — 用于内部测试的命令。
    - [maintenance set test-settings optional-filename](#cmd-maintenance-set-test-settings-optional-filename) — 用于内部测试的命令。
    - [maintenance set test-settings string](#cmd-maintenance-set-test-settings-string) — 用于内部测试的命令。
    - [maintenance set test-settings string-noescape](#cmd-maintenance-set-test-settings-string-noescape) — 用于内部测试的命令。
    - [maintenance set test-settings uinteger](#cmd-maintenance-set-test-settings-uinteger) — 用于内部测试的命令。
    - [maintenance set test-settings zinteger](#cmd-maintenance-set-test-settings-zinteger) — 用于内部测试的命令。
    - [maintenance set test-settings zuinteger](#cmd-maintenance-set-test-settings-zuinteger) — 用于内部测试的命令。
    - [maintenance set test-settings zuinteger-unlimited](#cmd-maintenance-set-test-settings-zuinteger-unlimited) — 用于内部测试的命令。
    - [maintenance set tui-resize-message](#cmd-maintenance-set-tui-resize-message) — 设置 TUI 调整大小消息。
    - [maintenance set worker-threads](#cmd-maintenance-set-worker-threads) — 设置 GDB 可使用的工作线程数。
    - [maintenance show](#cmd-maintenance-show) — 显示 GDB 维护者使用的内部变量。
    - [maintenance show ada](#cmd-maintenance-show-ada) — 显示 Ada 维护相关变量。
    - [maintenance show ada ignore-descriptive-types](#cmd-maintenance-show-ada-ignore-descriptive-types) — 显示是否忽略 GNAT 生成的描述性类型。
    - [maintenance show bfd-sharing](#cmd-maintenance-show-bfd-sharing) — 显示 gdb 是否共享看似相同的 bfd 文件。
    - [maintenance show btrace](#cmd-maintenance-show-btrace) — 显示分支跟踪相关变量。
    - [maintenance show btrace pt](#cmd-maintenance-show-btrace-pt) — 显示 Intel Processor Trace 相关变量。
    - [maintenance show btrace pt skip-pad](#cmd-maintenance-show-btrace-pt-skip-pad) — 显示是否在 btrace 包历史中跳过 PAD 包。
    - [maintenance show catch-demangler-crashes](#cmd-maintenance-show-catch-demangler-crashes) — 显示是否尝试捕获 demangler 崩溃。
    - [maintenance show demangler-warning](#cmd-maintenance-show-demangler-warning) — 显示检测到 demangler-warning 时 GDB 的行为。
    - [maintenance show demangler-warning quit](#cmd-maintenance-show-demangler-warning-quit) — 显示检测到 demangler-warning 时 GDB 是否会退出。
    - [maintenance show dwarf](#cmd-maintenance-show-dwarf) — 显示 DWARF 相关变量。
    - [maintenance show dwarf always-disassemble](#cmd-maintenance-show-dwarf-always-disassemble) — 显示 `info address' 是否总是反汇编 DWARF 表达式。
    - [maintenance show dwarf max-cache-age](#cmd-maintenance-show-dwarf-max-cache-age) — 显示缓存的 DWARF 编译单元年龄上限。
    - [maintenance show dwarf unwinders](#cmd-maintenance-show-dwarf-unwinders) — 显示是否使用 DWARF 栈帧展开器。
    - [maintenance show internal-error](#cmd-maintenance-show-internal-error) — 显示检测到 internal-error 时 GDB 的行为。
    - [maintenance show internal-error corefile](#cmd-maintenance-show-internal-error-corefile) — 显示检测到 internal-error 时 GDB 是否会生成自身的 core 文件。
    - [maintenance show internal-error quit](#cmd-maintenance-show-internal-error-quit) — 显示检测到 internal-error 时 GDB 是否会退出。
    - [maintenance show internal-warning](#cmd-maintenance-show-internal-warning) — 显示检测到 internal-warning 时 GDB 的行为。
    - [maintenance show internal-warning corefile](#cmd-maintenance-show-internal-warning-corefile) — 显示检测到 internal-warning 时 GDB 是否会生成自身的 core 文件。
    - [maintenance show internal-warning quit](#cmd-maintenance-show-internal-warning-quit) — 显示检测到 internal-warning 时 GDB 是否会退出。
    - [maintenance show per-command](#cmd-maintenance-show-per-command) — 显示每条命令的统计设置。
    - [maintenance show per-command space](#cmd-maintenance-show-per-command-space) — 显示是否显示每条命令的空间占用。
    - [maintenance show per-command symtab](#cmd-maintenance-show-per-command-symtab) — 显示是否显示每条命令的 symtab 统计。
    - [maintenance show per-command time](#cmd-maintenance-show-per-command-time) — 显示是否显示每条命令的执行时间。
    - [maintenance show profile](#cmd-maintenance-show-profile) — 显示内部性能分析。
    - [maintenance show symbol-cache-size](#cmd-maintenance-show-symbol-cache-size) — 显示符号缓存大小。
    - [maintenance show target-async](#cmd-maintenance-show-target-async) — 显示 gdb 是否以异步模式控制 inferior。
    - [maintenance show target-non-stop](#cmd-maintenance-show-target-non-stop) — 显示 gdb 是否始终以 non-stop 模式控制 inferior。
    - [maintenance show test-options-completion-result](#cmd-maintenance-show-test-options-completion-result) — 显示 maintenance test-options 补全结果。
    - [maintenance show test-settings](#cmd-maintenance-show-test-settings) — 显示用于 set/show 命令基础设施测试的 GDB 内部变量。
    - [maintenance show test-settings auto-boolean](#cmd-maintenance-show-test-settings-auto-boolean) — 用于内部测试的命令。
    - [maintenance show test-settings boolean](#cmd-maintenance-show-test-settings-boolean) — 用于内部测试的命令。
    - [maintenance show test-settings enum](#cmd-maintenance-show-test-settings-enum) — 用于内部测试的命令。
    - [maintenance show test-settings filename](#cmd-maintenance-show-test-settings-filename) — 用于内部测试的命令。
    - [maintenance show test-settings integer](#cmd-maintenance-show-test-settings-integer) — 用于内部测试的命令。
    - [maintenance show test-settings optional-filename](#cmd-maintenance-show-test-settings-optional-filename) — 用于内部测试的命令。
    - [maintenance show test-settings string](#cmd-maintenance-show-test-settings-string) — 用于内部测试的命令。
    - [maintenance show test-settings string-noescape](#cmd-maintenance-show-test-settings-string-noescape) — 用于内部测试的命令。
    - [maintenance show test-settings uinteger](#cmd-maintenance-show-test-settings-uinteger) — 用于内部测试的命令。
    - [maintenance show test-settings zinteger](#cmd-maintenance-show-test-settings-zinteger) — 用于内部测试的命令。
    - [maintenance show test-settings zuinteger](#cmd-maintenance-show-test-settings-zuinteger) — 用于内部测试的命令。
    - [maintenance show test-settings zuinteger-unlimited](#cmd-maintenance-show-test-settings-zuinteger-unlimited) — 用于内部测试的命令。
    - [maintenance show tui-resize-message](#cmd-maintenance-show-tui-resize-message) — 显示 TUI 调整大小消息。
    - [maintenance show worker-threads](#cmd-maintenance-show-worker-threads) — 显示 GDB 可使用的工作线程数。
    - [maintenance space](#cmd-maintenance-space) — 设置空间占用的显示。
    - [maintenance test-options](#cmd-maintenance-test-options) — 用于测试选项基础设施的通用命令。
    - [maintenance test-options require-delimiter](#cmd-maintenance-test-options-require-delimiter) — 用于测试选项处理的命令。
    - [maintenance test-options unknown-is-error](#cmd-maintenance-test-options-unknown-is-error) — 用于测试选项处理的命令。
    - [maintenance test-options unknown-is-operand](#cmd-maintenance-test-options-unknown-is-operand) — 用于测试选项处理的命令。
    - [maintenance time](#cmd-maintenance-time) — 设置时间占用的显示。
    - [maintenance translate-address](#cmd-maintenance-translate-address) — 将段名和地址转换为符号。
    - [maintenance undeprecate](#cmd-maintenance-undeprecate) — 取消弃用命令（用于测试）。
    - [maintenance with](#cmd-maintenance-with) — 类似 "with"，但适用于 "maintenance set" 变量。

- [**obscure（晦涩）**](#cat-obscure)
  - [compare-sections](#cmd-compare-sections) — 将目标上的段数据与可执行文件比较。
  - [compile](#cmd-compile) — 编译源代码并注入 inferior 的命令。
    - [compile file](#cmd-compile-file) — 求值包含源代码的文件。
    - [compile print](#cmd-compile-print) — 使用编译器求值 EXPR 并打印结果。
  - [complete](#cmd-complete) — 列出该行剩余部分作为命令的补全项。
  - [expression](#cmd-expression) — 编译源代码并注入 inferior 的命令。
  - [compile](#cmd-compile) — 编译源代码并注入 inferior 的命令。
    - [compile file](#cmd-compile-file-2) — 求值包含源代码的文件。
    - [compile print](#cmd-compile-print-2) — 使用编译器求值 EXPR 并打印结果。
  - [guile](#cmd-guile) — 求值 Guile 表达式。
  - [guile-repl](#cmd-guile-repl) — 启动 Guile 交互提示符。
  - [monitor](#cmd-monitor) — 向远程监视器发送命令（仅远程目标）。
  - [python](#cmd-python) — 求值 Python 命令。
  - [python-interactive](#cmd-python-interactive) — 启动 Python 交互提示符。
  - [record](#cmd-record) — 开始记录。
    - [record btrace bts](#cmd-record-btrace-bts) — 以 Branch Trace Store (BTS) 格式开始分支跟踪记录。
    - [record btrace pt](#cmd-record-btrace-pt) — 以 Intel Processor Trace 格式开始分支跟踪记录。
    - [record delete](#cmd-record-delete) — 删除执行日志的剩余部分并重新开始记录。
    - [record full](#cmd-record-full) — 开始完整执行记录。
    - [record full restore](#cmd-record-full-restore) — 从文件恢复执行日志。
    - [record function-call-history](#cmd-record-function-call-history) — 以函数粒度打印执行历史。
    - [record goto](#cmd-record-goto) — 将程序恢复到指令编号 N 处的状态。
    - [record goto begin](#cmd-record-goto-begin) — 转到执行日志开头。
    - [record goto end](#cmd-record-goto-end) — 转到执行日志末尾。
    - [record instruction-history](#cmd-record-instruction-history) — 打印执行日志中存储的反汇编指令。
    - [record save](#cmd-record-save) — 将执行日志保存到文件。
    - [record stop](#cmd-record-stop) — 停止 record/replay 目标。
  - [stop](#cmd-stop) — 没有 `stop' 命令，但可在 `stop' 上设置 hook。

- [**running（运行）**](#cat-running)
  - [advance](#cmd-advance) — 继续运行程序直至给定位置（参数形式与 break 命令相同）。
  - [attach](#cmd-attach) — 附加到 GDB 外的进程或文件。
  - [continue](#cmd-continue) — 在信号或断点后继续运行被调试程序。
  - [detach](#cmd-detach) — 分离先前附加的进程或文件。
  - [disconnect](#cmd-disconnect) — 断开与目标的连接。
  - [finish](#cmd-finish) — 执行直至所选栈帧返回。
  - [handle](#cmd-handle) — 指定如何处理信号。
  - [inferior](#cmd-inferior) — 使用此命令在多个 inferior 之间切换。
  - [interrupt](#cmd-interrupt) — 中断被调试程序的执行。
  - [jump](#cmd-jump) — 在被调试程序的指定行或地址处继续执行。
  - [kill](#cmd-kill) — 终止被调试程序的执行。
  - [next](#cmd-next) — 单步执行程序，穿过子程序调用。
  - [nexti](#cmd-nexti) — 单步一条指令，但穿过子程序调用。
  - [queue-signal](#cmd-queue-signal) — 将信号加入队列，在线程恢复时传递给当前线程。
  - [reverse-continue](#cmd-reverse-continue) — 继续运行被调试程序，但以反向方式执行。
  - [reverse-finish](#cmd-reverse-finish) — 向后执行直至所选栈帧即将被调用之前。
  - [reverse-next](#cmd-reverse-next) — 向后单步执行程序，穿过子程序调用。
  - [reverse-nexti](#cmd-reverse-nexti) — 向后单步一条指令，但穿过被调用的子程序。
  - [reverse-step](#cmd-reverse-step) — 向后单步执行程序直至到达另一条源行开头。
  - [reverse-stepi](#cmd-reverse-stepi) — 精确向后单步一条指令。
  - [run](#cmd-run) — 启动被调试程序。
  - [signal](#cmd-signal) — 以指定信号继续运行程序。
  - [start](#cmd-start) — 启动被调试程序并在 main 过程开头停止。
  - [starti](#cmd-starti) — 启动被调试程序并在第一条指令处停止。
  - [step](#cmd-step) — 单步执行程序直至到达不同的源行。
  - [stepi](#cmd-stepi) — 精确单步执行一条指令。
  - [taas](#cmd-taas) — 对所有线程应用命令（忽略错误和空输出）。
  - [target](#cmd-target) — 连接到目标机或进程。
    - [target exec](#cmd-target-exec) — 使用可执行文件作为目标。
    - [target extended-remote](#cmd-target-extended-remote) — 通过串口使用 gdb 专用协议连接远程计算机。
    - [target record-btrace](#cmd-target-record-btrace) — 收集控制流跟踪并提供执行历史。
    - [target record-core](#cmd-target-record-core) — 在执行时记录程序并从日志回放执行。
    - [target record-full](#cmd-target-record-full) — 在执行时记录程序并从日志回放执行。
    - [target remote](#cmd-target-remote) — 通过串口使用 gdb 专用协议连接远程计算机。
    - [target tfile](#cmd-target-tfile) — 使用跟踪文件作为目标。
  - [task](#cmd-task) — 使用此命令在 Ada 任务之间切换。
  - [tfaas](#cmd-tfaas) — 对所有线程的所有帧应用命令（忽略错误和空输出）。
  - [thread](#cmd-thread) — 使用此命令在线程之间切换。
    - [thread apply all](#cmd-thread-apply-all) — 对所有线程应用命令。
    - [thread find](#cmd-thread-find) — 查找匹配正则表达式的线程。
    - [thread name](#cmd-thread-name) — 设置当前线程的名称。
  - [until](#cmd-until) — 执行直至越过当前行或越过 LOCATION。

- [**stack（栈）**](#cat-stack)
  - [backtrace](#cmd-backtrace) — 打印所有栈帧的回溯，或最内层 COUNT 个栈帧。
  - [bt](#cmd-bt) — 打印所有栈帧的回溯，或最内层 COUNT 个栈帧。
  - [down](#cmd-down) — 选择并打印调用当前帧的栈帧。
  - [faas](#cmd-faas) — 对所有帧应用命令（忽略错误和空输出）。
  - [frame](#cmd-frame) — 选择并打印栈帧。
    - [frame apply](#cmd-frame-apply) — 对若干帧应用命令。
    - [frame apply all](#cmd-frame-apply-all) — 对所有帧应用命令。
    - [frame apply level](#cmd-frame-apply-level) — 对帧列表应用命令。
    - [frame function](#cmd-frame-function) — 按函数名选择并打印栈帧。
    - [frame level](#cmd-frame-level) — 按层级选择并打印栈帧。
    - [frame view](#cmd-frame-view) — 查看可能位于当前回溯之外的栈帧。
  - [return](#cmd-return) — 使所选栈帧返回到其调用者。
  - [select-frame](#cmd-select-frame) — 选择栈帧但不打印任何内容。
    - [select-frame function](#cmd-select-frame-function) — 按函数名选择栈帧。
    - [select-frame level](#cmd-select-frame-level) — 按层级选择栈帧。
    - [select-frame view](#cmd-select-frame-view) — 选择可能位于当前回溯之外的栈帧。
  - [up](#cmd-up) — 选择并打印调用当前帧的栈帧。

- [**status（状态）**](#cat-status)
  - [info](#cmd-info) — 用于显示被调试程序相关信息的通用命令。
    - [info all-registers](#cmd-info-all-registers) — 列出所选栈帧的所有寄存器及其内容。
    - [info args](#cmd-info-args) — 当前栈帧的所有参数变量，或匹配 REGEXP 的变量。
    - [info auto-load](#cmd-info-auto-load) — 打印自动加载文件的当前状态。
    - [info auto-load gdb-scripts](#cmd-info-auto-load-gdb-scripts) — 打印自动加载的命令序列列表。
    - [info auto-load local-gdbinit](#cmd-info-auto-load-local-gdbinit) — 打印是否已加载当前目录的 .gdbinit 文件。
    - [info auxv](#cmd-info-auxv) — 显示 inferior 的辅助向量。
    - [info bookmarks](#cmd-info-bookmarks) — 用户可设书签的状态。
    - [info breakpoints](#cmd-info-breakpoints) — 指定断点的状态（无参数时为所有用户可设断点）。
    - [info classes](#cmd-info-classes) — 所有 Objective-C 类，或匹配 REGEXP 的类。
    - [info common](#cmd-info-common) — 打印 Fortran COMMON 块中的值。
    - [info copying](#cmd-info-copying) — 再分发 GDB 副本的条件。
    - [info dcache](#cmd-info-dcache) — 打印 dcache 性能信息。
    - [info display](#cmd-info-display) — 程序停止时要显示的表达式及编号。
    - [info exceptions](#cmd-info-exceptions) — 列出所有 Ada 异常名。
    - [info extensions](#cmd-info-extensions) — 与源语言关联的所有文件名扩展名。
    - [info files](#cmd-info-files) — 目标和被调试文件的名称。
    - [info float](#cmd-info-float) — 打印浮点单元状态。
    - [info frame](#cmd-info-frame) — 关于所选栈帧的全部信息。
    - [info frame address](#cmd-info-frame-address) — 打印按栈地址所选栈帧的信息。
    - [info frame function](#cmd-info-frame-function) — 打印按函数名所选栈帧的信息。
    - [info frame level](#cmd-info-frame-level) — 打印按层级所选栈帧的信息。
    - [info frame view](#cmd-info-frame-view) — 打印当前回溯之外栈帧的信息。
    - [info functions](#cmd-info-functions) — 所有函数名，或匹配 REGEXP 的函数名。
    - [info guile](#cmd-info-guile) — Guile 信息显示的前缀命令。
    - [info handle](#cmd-info-handle) — 程序收到各种信号时调试器的行为。
    - [info inferiors](#cmd-info-inferiors) — 打印正在管理的 inferior 列表。
    - [info line](#cmd-info-line) — 源行代码的核心地址。
    - [info locals](#cmd-info-locals) — 当前栈帧的所有局部变量，或匹配 REGEXP 的变量。
    - [info macro](#cmd-info-macro) — 显示宏 MACRO 的定义及其源位置。
    - [info macros](#cmd-info-macros) — 显示 LINESPEC 处或当前源位置的所有宏定义。
    - [info mem](#cmd-info-mem) — 内存区域属性。
    - [info module](#cmd-info-module) — 打印模块信息。
    - [info module functions](#cmd-info-module-functions) — 按模块显示函数。
    - [info module variables](#cmd-info-module-variables) — 按模块显示变量。
    - [info modules](#cmd-info-modules) — 所有模块名，或匹配 REGEXP 的模块名。
    - [info os](#cmd-info-os) — 显示 OS 数据 ARG。
    - [info probes](#cmd-info-probes) — 显示可用的静态探针。
    - [info probes all](#cmd-info-probes-all) — 显示所有类型探针的信息。
    - [info probes dtrace](#cmd-info-probes-dtrace) — 显示 DTrace 静态探针的信息。
    - [info probes stap](#cmd-info-probes-stap) — 显示 SystemTap 静态探针的信息。
    - [info proc](#cmd-info-proc) — 显示进程的附加信息。
    - [info proc all](#cmd-info-proc-all) — 列出指定进程的所有可用信息。
    - [info proc cmdline](#cmd-info-proc-cmdline) — 列出指定进程的命令行参数。
    - [info proc cwd](#cmd-info-proc-cwd) — 列出指定进程的当前工作目录。
    - [info proc exe](#cmd-info-proc-exe) — 列出指定进程可执行文件的绝对路径。
    - [info proc files](#cmd-info-proc-files) — 列出指定进程打开的文件。
    - [info proc mappings](#cmd-info-proc-mappings) — 列出指定进程映射的内存区域。
    - [info proc stat](#cmd-info-proc-stat) — 列出来自 /proc/PID/stat 的进程信息。
    - [info proc status](#cmd-info-proc-status) — 列出来自 /proc/PID/status 的进程信息。
    - [info program](#cmd-info-program) — 程序的执行状态。
    - [info record](#cmd-info-record) — record 选项信息。
    - [info registers](#cmd-info-registers) — 列出所选栈帧的整数寄存器及其内容。
    - [info scope](#cmd-info-scope) — 列出作用域内的局部变量。
    - [info selectors](#cmd-info-selectors) — 所有 Objective-C 选择器，或匹配 REGEXP 的选择器。
    - [info set](#cmd-info-set) — 显示所有 GDB 设置。
    - [info sharedlibrary](#cmd-info-sharedlibrary) — 已加载共享对象库的状态。
    - [info signals](#cmd-info-signals) — 程序收到各种信号时调试器的行为。
    - [info skip](#cmd-info-skip) — 显示 skip 的状态。
    - [info source](#cmd-info-source) — 关于当前源文件的信息。
    - [info sources](#cmd-info-sources) — 程序中所有源文件，或匹配 REGEXP 的源文件。
    - [info stack](#cmd-info-stack) — 栈的回溯，或最内层 COUNT 个帧。
    - [info static-tracepoint-markers](#cmd-info-static-tracepoint-markers) — 列出目标静态跟踪点标记。
    - [info symbol](#cmd-info-symbol) — 描述地址 ADDR 处的符号。
    - [info target](#cmd-info-target) — 目标和被调试文件的名称。
    - [info tasks](#cmd-info-tasks) — 提供所有已知 Ada 任务的信息。
    - [info terminal](#cmd-info-terminal) — 打印 inferior 保存的终端状态。
    - [info threads](#cmd-info-threads) — 显示当前已知线程。
    - [info tracepoints](#cmd-info-tracepoints) — 指定跟踪点的状态（无参数时为所有跟踪点）。
    - [info tvariables](#cmd-info-tvariables) — 跟踪状态变量及其值的状态。
    - [info types](#cmd-info-types) — 所有类型名，或匹配 REGEXP 的类型名。
    - [info variables](#cmd-info-variables) — 所有全局和静态变量名，或匹配 REGEXP 的变量名。
    - [info vector](#cmd-info-vector) — 打印向量单元状态。
    - [info vtbl](#cmd-info-vtbl) — 显示 C++ 对象的虚函数表。
    - [info warranty](#cmd-info-warranty) — 您并不拥有的各种保修条款。
    - [info watchpoints](#cmd-info-watchpoints) — 指定监视点的状态（无参数时为所有监视点）。
    - [info win](#cmd-info-win) — 列出所有已显示窗口。
  - [macro](#cmd-macro) — 处理 C 预处理器宏的命令前缀。
    - [macro expand](#cmd-macro-expand) — 完全展开 EXPRESSION 中的 C/C++ 预处理器宏调用。
    - [macro expand-once](#cmd-macro-expand-once) — 展开 EXPRESSION 中直接出现的 C/C++ 预处理器宏调用。
    - [macro list](#cmd-macro-list) — 列出使用 `macro define' 命令定义的所有宏。
    - [macro undef](#cmd-macro-undef) — 移除给定名称的 C/C++ 预处理器宏定义。
  - [show](#cmd-show) — 用于显示调试器相关信息的通用命令。
    - [show ada print-signatures](#cmd-show-ada-print-signatures) — 启用或禁用在重载选择菜单中输出函数的形式参数和返回类型。
    - [show ada trust-PAD-over-XVS](#cmd-show-ada-trust-pad-over-xvs) — 启用或禁用信任 PAD 类型优于 XVS 类型的优化。
    - [show agent](#cmd-show-agent) — 显示调试器是否愿意使用 agent 作为辅助。
    - [show annotate](#cmd-show-annotate) — 显示 annotation_level。
    - [show architecture](#cmd-show-architecture) — 显示目标架构。
    - [show args](#cmd-show-args) — 显示被调试程序启动时传入的参数列表。
    - [show arm](#cmd-show-arm) — 各种 ARM 相关命令。
    - [show arm abi](#cmd-show-arm-abi) — 显示 ABI.
    - [show arm apcs32](#cmd-show-arm-apcs32) — 显示 ARM 32 位模式的使用。
    - [show arm disassembler](#cmd-show-arm-disassembler) — 显示反汇编风格。
    - [show arm fallback-mode](#cmd-show-arm-fallback-mode) — 显示符号不可用时的假定模式。
    - [show arm force-mode](#cmd-show-arm-force-mode) — 显示即使符号可用时也假定的模式。
    - [show arm fpu](#cmd-show-arm-fpu) — 显示浮点类型。
    - [show auto-connect-native-target](#cmd-show-auto-connect-native-target) — 显示 GDB 是否可自动连接到本机目标。
    - [show auto-load](#cmd-show-auto-load) — 自动加载相关设置。
    - [show auto-load gdb-scripts](#cmd-show-auto-load-gdb-scripts) — 启用或禁用自动加载预制命令序列脚本。
    - [show auto-load local-gdbinit](#cmd-show-auto-load-local-gdbinit) — 启用或禁用自动加载当前目录中的 .gdbinit 脚本。
    - [show auto-load safe-path](#cmd-show-auto-load-safe-path) — 显示可安全自动加载的文件和目录列表。
    - [show auto-load scripts-directory](#cmd-show-auto-load-scripts-directory) — 显示从中加载自动脚本的目录列表。
    - [show auto-solib-add](#cmd-show-auto-solib-add) — 显示共享库符号的自动加载。
    - [show backtrace](#cmd-show-backtrace) — 显示回溯相关变量。
    - [show backtrace limit](#cmd-show-backtrace-limit) — 显示回溯层数的上限。
    - [show backtrace past-entry](#cmd-show-backtrace-past-entry) — 显示回溯是否应越过程序入口点继续。
    - [show backtrace past-main](#cmd-show-backtrace-past-main) — 显示回溯是否应越过 "main" 继续。
    - [show basenames-may-differ](#cmd-show-basenames-may-differ) — 显示源文件是否可有多个基本名。
    - [show breakpoint](#cmd-show-breakpoint) — 断点相关设置。
    - [show breakpoint always-inserted](#cmd-show-breakpoint-always-inserted) — 显示插入断点的模式。
    - [show breakpoint auto-hw](#cmd-show-breakpoint-auto-hw) — 显示是否自动使用硬件断点。
    - [show breakpoint condition-evaluation](#cmd-show-breakpoint-condition-evaluation) — 显示断点条件求值模式。
    - [show breakpoint pending](#cmd-show-breakpoint-pending) — 显示调试器对待决断点的行为。
    - [show can-use-hw-watchpoints](#cmd-show-can-use-hw-watchpoints) — 显示调试器是否愿意使用监视点硬件。
    - [show case-sensitive](#cmd-show-case-sensitive) — 显示名称搜索的大小写敏感性（on/off/auto）。
    - [show charset](#cmd-show-charset) — 显示主机和目标字符集。
    - [show check](#cmd-show-check) — 显示类型/范围检查器的状态。
    - [show check range](#cmd-show-check-range) — 显示范围检查（on/warn/off/auto）。
    - [show check type](#cmd-show-check-type) — 显示严格类型检查。
    - [show circular-trace-buffer](#cmd-show-circular-trace-buffer) — 显示目标是否使用环形跟踪缓冲区。
    - [show code-cache](#cmd-show-code-cache) — 显示代码段访问的缓存使用。
    - [show coerce-float-to-double](#cmd-show-coerce-float-to-double) — 显示调用函数时是否将 float 强制转换为 double。
    - [show commands](#cmd-show-commands) — 显示 history of commands you typed.
    - [show compile-args](#cmd-show-compile-args) — 显示编译命令的 GCC 命令行参数。
    - [show compile-gcc](#cmd-show-compile-gcc) — 显示编译命令的 GCC 驱动程序文件名。
    - [show complaints](#cmd-show-complaints) — 显示关于错误符号的最大抱怨次数。
    - [show configuration](#cmd-show-configuration) — 显示 how GDB was configured at build time.
    - [show confirm](#cmd-show-confirm) — 显示是否确认潜在危险操作。
    - [show convenience](#cmd-show-convenience) — 调试器便利（"$foo"）变量和函数。
    - [show copying](#cmd-show-copying) — 再分发 GDB 副本的条件。
    - [show cp-abi](#cmd-show-cp-abi) — 显示用于检查 C++ 对象的 ABI。
    - [show cwd](#cmd-show-cwd) — 显示 inferior 启动时使用的当前工作目录。
    - [show data-directory](#cmd-show-data-directory) — 显示 GDB 的数据目录。
    - [show dcache](#cmd-show-dcache) — 使用此命令设置 dcache 的行数和行大小。
    - [show dcache line-size](#cmd-show-dcache-line-size) — 显示 dcache 行大小（字节，必须为 2 的幂）。
    - [show dcache size](#cmd-show-dcache-size) — 显示 dcache 行数。
    - [show debug](#cmd-show-debug) — 用于设置 gdb 调试标志的通用命令。
    - [show debug arch](#cmd-show-debug-arch) — 显示架构调试。
    - [show debug arm](#cmd-show-debug-arm) — 显示 ARM 调试。
    - [show debug auto-load](#cmd-show-debug-auto-load) — 显示自动加载验证调试。
    - [show debug bfd-cache](#cmd-show-debug-bfd-cache) — 显示 bfd 缓存调试。
    - [show debug check-physname](#cmd-show-debug-check-physname) — 显示 "physname" 代码与 demangler 的交叉检查。
    - [show debug coff-pe-read](#cmd-show-debug-coff-pe-read) — 显示 coff PE 读取调试。
    - [show debug compile](#cmd-show-debug-compile) — 显示编译命令调试。
    - [show debug compile-cplus-scopes](#cmd-show-debug-compile-cplus-scopes) — 显示 C++ 编译作用域调试。
    - [show debug compile-cplus-types](#cmd-show-debug-compile-cplus-types) — 显示 C++ 编译类型转换调试。
    - [show debug displaced](#cmd-show-debug-displaced) — 显示 displaced stepping 调试。
    - [show debug dwarf-die](#cmd-show-debug-dwarf-die) — 显示 DWARF DIE 读取器调试。
    - [show debug dwarf-line](#cmd-show-debug-dwarf-line) — 显示 dwarf 行读取器调试。
    - [show debug dwarf-read](#cmd-show-debug-dwarf-read) — 显示 DWARF 读取器调试。
    - [show debug entry-values](#cmd-show-debug-entry-values) — 显示入口值和尾调用帧调试。
    - [show debug expression](#cmd-show-debug-expression) — 显示表达式调试。
    - [show debug frame](#cmd-show-debug-frame) — 显示帧调试。
    - [show debug index-cache](#cmd-show-debug-index-cache) — 显示是否显示 index-cache 调试消息。
    - [show debug infrun](#cmd-show-debug-infrun) — 显示 inferior 调试。
    - [show debug jit](#cmd-show-debug-jit) — 显示 JIT 调试。
    - [show debug notification](#cmd-show-debug-notification) — 显示异步远程通知调试。
    - [show debug observer](#cmd-show-debug-observer) — 显示 observer 调试。
    - [show debug overload](#cmd-show-debug-overload) — 显示 C++ 重载调试。
    - [show debug parser](#cmd-show-debug-parser) — 显示解析器调试。
    - [show debug record](#cmd-show-debug-record) — 显示 record/replay 功能调试。
    - [show debug remote](#cmd-show-debug-remote) — 显示远程协议调试。
    - [show debug remote-packet-max-chars](#cmd-show-debug-remote-packet-max-chars) — 显示每个远程包显示的最大字符数。
    - [show debug separate-debug-file](#cmd-show-debug-separate-debug-file) — 显示是否打印独立调试信息文件搜索的调试输出。
    - [show debug serial](#cmd-show-debug-serial) — 显示串口调试。
    - [show debug skip](#cmd-show-debug-skip) — 显示是否打印关于跳过文件和函数的调试输出。
    - [show debug stap-expression](#cmd-show-debug-stap-expression) — 显示 SystemTap 表达式调试。
    - [show debug symbol-lookup](#cmd-show-debug-symbol-lookup) — 显示符号查找调试。
    - [show debug symfile](#cmd-show-debug-symfile) — 显示 symfile 函数调试。
    - [show debug symtab-create](#cmd-show-debug-symtab-create) — 显示符号表创建调试。
    - [show debug target](#cmd-show-debug-target) — 显示目标调试。
    - [show debug timestamp](#cmd-show-debug-timestamp) — 显示是否为调试消息添加时间戳。
    - [show debug varobj](#cmd-show-debug-varobj) — 显示 varobj 调试。
    - [show debug xml](#cmd-show-debug-xml) — 显示 XML 解析器调试。
    - [show debug-file-directory](#cmd-show-debug-file-directory) — 显示搜索独立调试符号的目录。
    - [show default-collect](#cmd-show-default-collect) — 显示默认要收集的表达式列表。
    - [show demangle-style](#cmd-show-demangle-style) — 显示当前 C++ 还原符号风格。
    - [show detach-on-fork](#cmd-show-detach-on-fork) — 显示 gdb 是否在 fork 后分离子进程。
    - [show directories](#cmd-show-directories) — 显示查找源文件的搜索路径。
    - [show disable-randomization](#cmd-show-disable-randomization) — 显示是否禁用被调试进程的虚拟地址空间随机化。
    - [show disassemble-next-line](#cmd-show-disassemble-next-line) — 显示执行停止时是否反汇编下一条源行或指令。
    - [show disassembler-options](#cmd-show-disassembler-options) — 显示反汇编器选项。
    - [show disconnected-dprintf](#cmd-show-disconnected-dprintf) — 显示 GDB 断开后 dprintf 是否继续。
    - [show disconnected-tracing](#cmd-show-disconnected-tracing) — 显示 GDB 断开后跟踪是否继续。
    - [show displaced-stepping](#cmd-show-displaced-stepping) — 显示调试器是否愿意使用 displaced stepping。
    - [show dprintf-channel](#cmd-show-dprintf-channel) — 显示动态 printf 使用的通道。
    - [show dprintf-function](#cmd-show-dprintf-function) — 显示动态 printf 使用的函数。
    - [show dprintf-style](#cmd-show-dprintf-style) — 显示动态 printf 的使用风格。
    - [show dump-excluded-mappings](#cmd-show-dump-excluded-mappings) — 显示 gcore 是否转储带 VM_DONTDUMP 标志的映射。
    - [show editing](#cmd-show-editing) — 显示是否在输入时编辑命令行。
    - [show endian](#cmd-show-endian) — 显示目标字节序。
    - [show environment](#cmd-show-environment) — 显示传给程序的环境变量值。
    - [show exec-direction](#cmd-show-exec-direction) — 显示执行方向。
    - [show exec-done-display](#cmd-show-exec-done-display) — 显示异步执行命令完成时的通知。
    - [show extension-language](#cmd-show-extension-language) — 显示文件名扩展名与源语言的映射。
    - [show filename-display](#cmd-show-filename-display) — 显示如何显示文件名。
    - [show follow-exec-mode](#cmd-show-follow-exec-mode) — 显示调试器对程序调用 exec 的响应。
    - [show follow-fork-mode](#cmd-show-follow-fork-mode) — 显示调试器对程序调用 fork 或 vfork 的响应。
    - [show gnutarget](#cmd-show-gnutarget) — 显示当前 BFD 目标。
    - [show guile](#cmd-show-guile) — Guile 偏好设置的前缀命令。
    - [show guile print-stack](#cmd-show-guile-print-stack) — 显示出错时 Guile 异常打印模式。
    - [show height](#cmd-show-height) — 显示 GDB 输出分页时每页行数。
    - [show history](#cmd-show-history) — 用于设置命令历史参数的通用命令。
    - [show history expansion](#cmd-show-history-expansion) — 显示命令输入的历史展开。
    - [show history filename](#cmd-show-history-filename) — 显示记录命令历史的文件名。
    - [show history remove-duplicates](#cmd-show-history-remove-duplicates) — 显示在历史中向后查找并删除重复条目的范围。
    - [show history save](#cmd-show-history-save) — 显示退出时是否保存历史记录。
    - [show history size](#cmd-show-history-size) — 显示命令历史大小。
    - [show host-charset](#cmd-show-host-charset) — 显示主机字符集。
    - [show index-cache](#cmd-show-index-cache) — 显示 index-cache 选项。
    - [show index-cache directory](#cmd-show-index-cache-directory) — 显示 index cache 的目录。
    - [show index-cache stats](#cmd-show-index-cache-stats) — 显示 some stats about the index cache.
    - [show inferior-tty](#cmd-show-inferior-tty) — 为被调试程序今后的运行设置终端。
    - [show input-radix](#cmd-show-input-radix) — 显示输入数字的默认进制。
    - [show interactive-mode](#cmd-show-interactive-mode) — 显示 GDB 标准输入是否为终端。
    - [show language](#cmd-show-language) — 显示当前源语言。
    - [show listsize](#cmd-show-listsize) — 显示 gdb 默认列出的源行数。
    - [show logging](#cmd-show-logging) — 显示日志选项。
    - [show logging debugredirect](#cmd-show-logging-debugredirect) — 显示日志调试输出模式。
    - [show logging file](#cmd-show-logging-file) — 显示当前日志文件。
    - [show logging overwrite](#cmd-show-logging-overwrite) — 显示日志是覆盖还是追加到日志文件。
    - [show logging redirect](#cmd-show-logging-redirect) — 显示日志输出模式。
    - [show max-completions](#cmd-show-max-completions) — 显示补全候选的最大数量。
    - [show max-user-call-depth](#cmd-show-max-user-call-depth) — 显示非 python/scheme 用户自定义命令的最大调用深度。
    - [show max-value-size](#cmd-show-max-value-size) — 显示 gdb 从 inferior 加载的值的最大尺寸。
    - [show may-call-functions](#cmd-show-may-call-functions) — 显示是否允许调用程序中的函数。
    - [show may-insert-breakpoints](#cmd-show-may-insert-breakpoints) — 显示是否允许在目标中插入断点。
    - [show may-insert-fast-tracepoints](#cmd-show-may-insert-fast-tracepoints) — 显示是否允许在目标中插入快速跟踪点。
    - [show may-insert-tracepoints](#cmd-show-may-insert-tracepoints) — 显示是否允许在目标中插入跟踪点。
    - [show may-interrupt](#cmd-show-may-interrupt) — 显示是否允许中断或向目标发信号。
    - [show may-write-memory](#cmd-show-may-write-memory) — 显示是否允许写入目标内存。
    - [show may-write-registers](#cmd-show-may-write-registers) — 显示是否允许写入寄存器。
    - [show mem](#cmd-show-mem) — 内存区域设置。
    - [show mem  inaccessible-by-default](#cmd-show-mem-inaccessible-by-default) — 显示 handling of unknown memory regions.
    - [show mi-async](#cmd-show-mi-async) — 显示是否启用 MI 异步模式。
    - [show multiple-symbols](#cmd-show-multiple-symbols) — 显示调试器如何处理表达式中的歧义。
    - [show non-stop](#cmd-show-non-stop) — 显示 gdb 是否以 non-stop 模式控制 inferior。
    - [show observer](#cmd-show-observer) — 显示 gdb 是否以 observer 模式控制 inferior。
    - [show opaque-type-resolution](#cmd-show-opaque-type-resolution) — 显示不透明 struct/class/union 类型的解析（须在加载符号前设置）。
    - [show osabi](#cmd-show-osabi) — 显示目标的 OS ABI。
    - [show output-radix](#cmd-show-output-radix) — 显示打印值的默认输出进制。
    - [show overload-resolution](#cmd-show-overload-resolution) — 显示求值 C++ 函数时的重载解析。
    - [show pagination](#cmd-show-pagination) — 显示 GDB 输出分页状态。
    - [show paths](#cmd-show-paths) — 查找目标文件的当前搜索路径。
    - [show print](#cmd-show-print) — 用于设置打印方式的通用命令。
    - [show print address](#cmd-show-print-address) — 显示是否打印地址。
    - [show print array](#cmd-show-print-array) — 显示数组的美化格式。
    - [show print array-indexes](#cmd-show-print-array-indexes) — 显示是否打印数组下标。
    - [show print asm-demangle](#cmd-show-print-asm-demangle) — 显示反汇编列表中 C++/ObjC 名称的还原。
    - [show print demangle](#cmd-show-print-demangle) — 显示显示符号时是否还原编码的 C++/ObjC 名称。
    - [show print elements](#cmd-show-print-elements) — 显示字符串字符或数组元素打印的上限。
    - [show print entry-values](#cmd-show-print-entry-values) — 显示是否在函数入口打印函数参数。
    - [show print finish](#cmd-show-print-finish) — 显示 `finish' 是否打印返回值。
    - [show print frame-arguments](#cmd-show-print-frame-arguments) — 显示是否打印非标量帧参数。
    - [show print frame-info](#cmd-show-print-frame-info) — 显示是否打印帧信息。
    - [show print inferior-events](#cmd-show-print-inferior-events) — 显示是否打印 inferior 事件（如启动和退出）。
    - [show print max-depth](#cmd-show-print-max-depth) — 显示嵌套结构体、联合体和数组的最大打印深度。
    - [show print max-symbolic-offset](#cmd-show-print-max-symbolic-offset) — 显示以 <SYMBOL+1234> 形式打印的最大偏移。
    - [show print null-stop](#cmd-show-print-null-stop) — 显示字符数组是否在首个空字符处停止打印。
    - [show print object](#cmd-show-print-object) — 显示是否打印 C++ 虚函数表。
    - [show print pascal_static-members](#cmd-show-print-pascal-static-members) — 显示是否打印 Pascal 静态成员。
    - [show print pretty](#cmd-show-print-pretty) — 显示结构体的美化格式。
    - [show print raw-frame-arguments](#cmd-show-print-raw-frame-arguments) — 显示是否以原始形式打印帧参数。
    - [show print raw-values](#cmd-show-print-raw-values) — 显示是否以原始形式打印值。
    - [show print repeats](#cmd-show-print-repeats) — 显示重复打印元素的阈值。
    - [show print sevenbit-strings](#cmd-show-print-sevenbit-strings) — 显示字符串中 8 位字符是否以 \nnn 形式打印。
    - [show print static-members](#cmd-show-print-static-members) — 显示是否打印 C++ 静态成员。
    - [show print symbol](#cmd-show-print-symbol) — 显示打印指针时是否打印符号名。
    - [show print symbol-filename](#cmd-show-print-symbol-filename) — 显示是否在 <SYMBOL> 旁打印源文件名和行号。
    - [show print symbol-loading](#cmd-show-print-symbol-loading) — 显示是否打印符号加载消息。
    - [show print thread-events](#cmd-show-print-thread-events) — 显示是否打印线程事件（如线程启动和退出）。
    - [show print type](#cmd-show-print-type) — 用于设置类型打印方式的通用命令。
    - [show print type methods](#cmd-show-print-type-methods) — 显示是否打印类中定义的方法。
    - [show print type nested-type-limit](#cmd-show-print-type-nested-type-limit) — 显示要打印的递归嵌套类型定义数量（"unlimited" 或 -1 表示全部）。
    - [show print type typedefs](#cmd-show-print-type-typedefs) — 显示是否打印类中定义的 typedef。
    - [show print union](#cmd-show-print-union) — 显示是否打印结构体内部的联合体。
    - [show print vtbl](#cmd-show-print-vtbl) — 显示是否打印 C++ 虚函数表。
    - [show prompt](#cmd-show-prompt) — 显示 gdb 提示符。
    - [show python](#cmd-show-python) — Python 偏好设置的前缀命令。
    - [show python print-stack](#cmd-show-python-print-stack) — 显示出错时 Python 栈转储模式。
    - [show radix](#cmd-show-radix) — 显示默认输入和输出数字进制。
    - [show range-stepping](#cmd-show-range-stepping) — 启用或禁用范围单步。
    - [show record](#cmd-show-record) — 显示 record 选项。
    - [show record btrace](#cmd-show-record-btrace) — 显示 record 选项。
    - [show record btrace bts](#cmd-show-record-btrace-bts) — 显示 record btrace bts 选项。
    - [show record btrace bts buffer-size](#cmd-show-record-btrace-bts-buffer-size) — 显示 record/replay bts 缓冲区大小。
    - [show record btrace cpu](#cmd-show-record-btrace-cpu) — 显示用于跟踪解码的 CPU。
    - [show record btrace pt](#cmd-show-record-btrace-pt) — 显示 record btrace pt 选项。
    - [show record btrace pt buffer-size](#cmd-show-record-btrace-pt-buffer-size) — 显示 record/replay pt 缓冲区大小。
    - [show record btrace replay-memory-access](#cmd-show-record-btrace-replay-memory-access) — 显示回放期间允许的内存访问。
    - [show record full](#cmd-show-record-full) — 显示 record 选项。
    - [show record full insn-number-max](#cmd-show-record-full-insn-number-max) — 显示 record/replay 缓冲区上限。
    - [show record full memory-query](#cmd-show-record-full-memory-query) — 显示若 PREC 无法记录下一条指令的内存变化时是否查询。
    - [show record full stop-at-limit](#cmd-show-record-full-stop-at-limit) — 显示 record/replay 缓冲区满时是否停止。
    - [show record function-call-history-size](#cmd-show-record-function-call-history-size) — 显示 "record function-call-history" 中打印的函数数量。
    - [show record instruction-history-size](#cmd-show-record-instruction-history-size) — 显示 "record instruction-history" 中打印的指令数量。
    - [show remote](#cmd-show-remote) — 远程协议相关变量。
    - [show remote P-packet](#cmd-show-remote-p-packet) — 显示是否使用远程协议 `P' (set-register) 包。
    - [show remote TracepointSource-packet](#cmd-show-remote-tracepointsource-packet) — 显示是否使用远程协议 `TracepointSource' (TracepointSource) 包。
    - [show remote X-packet](#cmd-show-remote-x-packet) — 显示是否使用远程协议 `X' (binary-download) 包。
    - [show remote Z-packet](#cmd-show-remote-z-packet) — 显示是否使用远程协议 `Z' packets.
    - [show remote access-watchpoint-packet](#cmd-show-remote-access-watchpoint-packet) — 显示是否使用远程协议 `Z4' (access-watchpoint) 包。
    - [show remote agent-packet](#cmd-show-remote-agent-packet) — 显示是否使用远程协议 `QAgent' (agent) 包。
    - [show remote allow-packet](#cmd-show-remote-allow-packet) — 显示是否使用远程协议 `QAllow' (allow) 包。
    - [show remote attach-packet](#cmd-show-remote-attach-packet) — 显示是否使用远程协议 `vAttach' (attach) 包。
    - [show remote binary-download-packet](#cmd-show-remote-binary-download-packet) — 显示是否使用远程协议 `X' (binary-download) 包。
    - [show remote breakpoint-commands-packet](#cmd-show-remote-breakpoint-commands-packet) — 显示是否使用远程协议 `BreakpointCommands' (breakpoint-commands) 包。
    - [show remote btrace-conf-bts-size-packet](#cmd-show-remote-btrace-conf-bts-size-packet) — 显示是否使用远程协议 `Qbtrace-conf:bts:size' (btrace-conf-bts-size) 包。
    - [show remote btrace-conf-pt-size-packet](#cmd-show-remote-btrace-conf-pt-size-packet) — 显示是否使用远程协议 `Qbtrace-conf:pt:size' (btrace-conf-pt-size) 包。
    - [show remote catch-syscalls-packet](#cmd-show-remote-catch-syscalls-packet) — 显示是否使用远程协议 `QCatchSyscalls' (catch-syscalls) 包。
    - [show remote conditional-breakpoints-packet](#cmd-show-remote-conditional-breakpoints-packet) — 显示是否使用远程协议 `ConditionalBreakpoints' (conditional-breakpoints) 包。
    - [show remote conditional-tracepoints-packet](#cmd-show-remote-conditional-tracepoints-packet) — 显示是否使用远程协议 `ConditionalTracepoints' (conditional-tracepoints) 包。
    - [show remote ctrl-c-packet](#cmd-show-remote-ctrl-c-packet) — 显示是否使用远程协议 `vCtrlC' (ctrl-c) 包。
    - [show remote disable-btrace-packet](#cmd-show-remote-disable-btrace-packet) — 显示是否使用远程协议 `Qbtrace:off' (disable-btrace) 包。
    - [show remote disable-randomization-packet](#cmd-show-remote-disable-randomization-packet) — 显示是否使用远程协议 `QDisableRandomization' (disable-randomization) 包。
    - [show remote enable-btrace-bts-packet](#cmd-show-remote-enable-btrace-bts-packet) — 显示是否使用远程协议 `Qbtrace:bts' (enable-btrace-bts) 包。
    - [show remote enable-btrace-pt-packet](#cmd-show-remote-enable-btrace-pt-packet) — 显示是否使用远程协议 `Qbtrace:pt' (enable-btrace-pt) 包。
    - [show remote environment-hex-encoded-packet](#cmd-show-remote-environment-hex-encoded-packet) — 显示是否使用远程协议 `QEnvironmentHexEncoded' (environment-hex-encoded) 包。
    - [show remote environment-reset-packet](#cmd-show-remote-environment-reset-packet) — 显示是否使用远程协议 `QEnvironmentReset' (environment-reset) 包。
    - [show remote environment-unset-packet](#cmd-show-remote-environment-unset-packet) — 显示是否使用远程协议 `QEnvironmentUnset' (environment-unset) 包。
    - [show remote exec-event-feature-packet](#cmd-show-remote-exec-event-feature-packet) — 显示是否使用远程协议 `exec-event-feature' (exec-event-feature) 包。
    - [show remote exec-file](#cmd-show-remote-exec-file) — 显示 "run" 的远程路径名。
    - [show remote fast-tracepoints-packet](#cmd-show-remote-fast-tracepoints-packet) — 显示是否使用远程协议 `FastTracepoints' (fast-tracepoints) 包。
    - [show remote fetch-register-packet](#cmd-show-remote-fetch-register-packet) — 显示是否使用远程协议 `p' (fetch-register) 包。
    - [show remote fork-event-feature-packet](#cmd-show-remote-fork-event-feature-packet) — 显示是否使用远程协议 `fork-event-feature' (fork-event-feature) 包。
    - [show remote get-thread-information-block-address-packet](#cmd-show-remote-get-thread-information-block-address-packet) — 显示是否使用远程协议 `qGetTIBAddr' (get-thread-information-block-address) 包。
    - [show remote get-thread-local-storage-address-packet](#cmd-show-remote-get-thread-local-storage-address-packet) — 显示是否使用远程协议 `qGetTLSAddr' (get-thread-local-storage-address) 包。
    - [show remote hardware-breakpoint-limit](#cmd-show-remote-hardware-breakpoint-limit) — 显示目标硬件断点的最大数量。
    - [show remote hardware-breakpoint-packet](#cmd-show-remote-hardware-breakpoint-packet) — 显示是否使用远程协议 `Z1' (hardware-breakpoint) 包。
    - [show remote hardware-watchpoint-length-limit](#cmd-show-remote-hardware-watchpoint-length-limit) — 显示目标硬件监视点的最大长度（字节）。
    - [show remote hardware-watchpoint-limit](#cmd-show-remote-hardware-watchpoint-limit) — 显示目标硬件监视点的最大数量。
    - [show remote hostio-close-packet](#cmd-show-remote-hostio-close-packet) — 显示是否使用远程协议 `vFile:close' (hostio-close) 包。
    - [show remote hostio-fstat-packet](#cmd-show-remote-hostio-fstat-packet) — 显示是否使用远程协议 `vFile:fstat' (hostio-fstat) 包。
    - [show remote hostio-open-packet](#cmd-show-remote-hostio-open-packet) — 显示是否使用远程协议 `vFile:open' (hostio-open) 包。
    - [show remote hostio-pread-packet](#cmd-show-remote-hostio-pread-packet) — 显示是否使用远程协议 `vFile:pread' (hostio-pread) 包。
    - [show remote hostio-pwrite-packet](#cmd-show-remote-hostio-pwrite-packet) — 显示是否使用远程协议 `vFile:pwrite' (hostio-pwrite) 包。
    - [show remote hostio-readlink-packet](#cmd-show-remote-hostio-readlink-packet) — 显示是否使用远程协议 `vFile:readlink' (hostio-readlink) 包。
    - [show remote hostio-setfs-packet](#cmd-show-remote-hostio-setfs-packet) — 显示是否使用远程协议 `vFile:setfs' (hostio-setfs) 包。
    - [show remote hostio-unlink-packet](#cmd-show-remote-hostio-unlink-packet) — 显示是否使用远程协议 `vFile:unlink' (hostio-unlink) 包。
    - [show remote hwbreak-feature-packet](#cmd-show-remote-hwbreak-feature-packet) — 显示是否使用远程协议 `hwbreak-feature' (hwbreak-feature) 包。
    - [show remote install-in-trace-packet](#cmd-show-remote-install-in-trace-packet) — 显示是否使用远程协议 `InstallInTrace' (install-in-trace) 包。
    - [show remote interrupt-on-connect](#cmd-show-remote-interrupt-on-connect) — 显示 gdb 连接时是否向远程目标发送中断序列。
    - [show remote interrupt-sequence](#cmd-show-remote-interrupt-sequence) — 显示发往远程目标的中断序列。
    - [show remote kill-packet](#cmd-show-remote-kill-packet) — 显示是否使用远程协议 `vKill' (kill) 包。
    - [show remote library-info-packet](#cmd-show-remote-library-info-packet) — 显示是否使用远程协议 `qXfer:libraries:read' (library-info) 包。
    - [show remote library-info-svr4-packet](#cmd-show-remote-library-info-svr4-packet) — 显示是否使用远程协议 `qXfer:libraries-svr4:read' (library-info-svr4) 包。
    - [show remote memory-map-packet](#cmd-show-remote-memory-map-packet) — 显示是否使用远程协议 `qXfer:memory-map:read' (memory-map) 包。
    - [show remote memory-read-packet-size](#cmd-show-remote-memory-read-packet-size) — 显示每个内存读包的最大字节数。
    - [show remote memory-write-packet-size](#cmd-show-remote-memory-write-packet-size) — 显示每个内存写包的最大字节数。
    - [show remote multiprocess-feature-packet](#cmd-show-remote-multiprocess-feature-packet) — 显示是否使用远程协议 `multiprocess-feature' (multiprocess-feature) 包。
    - [show remote no-resumed-stop-reply-packet](#cmd-show-remote-no-resumed-stop-reply-packet) — 显示是否使用远程协议 `N stop reply' (no-resumed-stop-reply) 包。
    - [show remote noack-packet](#cmd-show-remote-noack-packet) — 显示是否使用远程协议 `QStartNoAckMode' (noack) 包。
    - [show remote osdata-packet](#cmd-show-remote-osdata-packet) — 显示是否使用远程协议 `qXfer:osdata:read' (osdata) 包。
    - [show remote p-packet](#cmd-show-remote-p-packet-2) — 显示是否使用远程协议 `p' (fetch-register) 包。
    - [show remote pass-signals-packet](#cmd-show-remote-pass-signals-packet) — 显示是否使用远程协议 `QPassSignals' (pass-signals) 包。
    - [show remote pid-to-exec-file-packet](#cmd-show-remote-pid-to-exec-file-packet) — 显示是否使用远程协议 `qXfer:exec-file:read' (pid-to-exec-file) 包。
    - [show remote program-signals-packet](#cmd-show-remote-program-signals-packet) — 显示是否使用远程协议 `QProgramSignals' (program-signals) 包。
    - [show remote query-attached-packet](#cmd-show-remote-query-attached-packet) — 显示是否使用远程协议 `qAttached' (query-attached) 包。
    - [show remote read-aux-vector-packet](#cmd-show-remote-read-aux-vector-packet) — 显示是否使用远程协议 `qXfer:auxv:read' (read-aux-vector) 包。
    - [show remote read-btrace-conf-packet](#cmd-show-remote-read-btrace-conf-packet) — 显示是否使用远程协议 `qXfer:btrace-conf' (read-btrace-conf) 包。
    - [show remote read-btrace-packet](#cmd-show-remote-read-btrace-packet) — 显示是否使用远程协议 `qXfer:btrace' (read-btrace) 包。
    - [show remote read-fdpic-loadmap-packet](#cmd-show-remote-read-fdpic-loadmap-packet) — 显示是否使用远程协议 `qXfer:fdpic:read' (read-fdpic-loadmap) 包。
    - [show remote read-sdata-object-packet](#cmd-show-remote-read-sdata-object-packet) — 显示是否使用远程协议 `qXfer:statictrace:read' (read-sdata-object) 包。
    - [show remote read-siginfo-object-packet](#cmd-show-remote-read-siginfo-object-packet) — 显示是否使用远程协议 `qXfer:siginfo:read' (read-siginfo-object) 包。
    - [show remote read-watchpoint-packet](#cmd-show-remote-read-watchpoint-packet) — 显示是否使用远程协议 `Z3' (read-watchpoint) 包。
    - [show remote reverse-continue-packet](#cmd-show-remote-reverse-continue-packet) — 显示是否使用远程协议 `bc' (reverse-continue) 包。
    - [show remote reverse-step-packet](#cmd-show-remote-reverse-step-packet) — 显示是否使用远程协议 `bs' (reverse-step) 包。
    - [show remote run-packet](#cmd-show-remote-run-packet) — 显示是否使用远程协议 `vRun' (run) 包。
    - [show remote search-memory-packet](#cmd-show-remote-search-memory-packet) — 显示是否使用远程协议 `qSearch:memory' (search-memory) 包。
    - [show remote set-register-packet](#cmd-show-remote-set-register-packet) — 显示是否使用远程协议 `P' (set-register) 包。
    - [show remote set-working-dir-packet](#cmd-show-remote-set-working-dir-packet) — 显示是否使用远程协议 `QSetWorkingDir' (set-working-dir) 包。
    - [show remote software-breakpoint-packet](#cmd-show-remote-software-breakpoint-packet) — 显示是否使用远程协议 `Z0' (software-breakpoint) 包。
    - [show remote startup-with-shell-packet](#cmd-show-remote-startup-with-shell-packet) — 显示是否使用远程协议 `QStartupWithShell' (startup-with-shell) 包。
    - [show remote static-tracepoints-packet](#cmd-show-remote-static-tracepoints-packet) — 显示是否使用远程协议 `StaticTracepoints' (static-tracepoints) 包。
    - [show remote supported-packets-packet](#cmd-show-remote-supported-packets-packet) — 显示是否使用远程协议 `qSupported' (supported-packets) 包。
    - [show remote swbreak-feature-packet](#cmd-show-remote-swbreak-feature-packet) — 显示是否使用远程协议 `swbreak-feature' (swbreak-feature) 包。
    - [show remote symbol-lookup-packet](#cmd-show-remote-symbol-lookup-packet) — 显示是否使用远程协议 `qSymbol' (symbol-lookup) 包。
    - [show remote system-call-allowed](#cmd-show-remote-system-call-allowed) — 显示是否允许目标使用主机的 system(3) 调用。
    - [show remote target-features-packet](#cmd-show-remote-target-features-packet) — 显示是否使用远程协议 `qXfer:features:read' (target-features) 包。
    - [show remote thread-events-packet](#cmd-show-remote-thread-events-packet) — 显示是否使用远程协议 `QThreadEvents' (thread-events) 包。
    - [show remote threads-packet](#cmd-show-remote-threads-packet) — 显示是否使用远程协议 `qXfer:threads:read' (threads) 包。
    - [show remote trace-buffer-size-packet](#cmd-show-remote-trace-buffer-size-packet) — 显示是否使用远程协议 `QTBuffer:size' (trace-buffer-size) 包。
    - [show remote trace-status-packet](#cmd-show-remote-trace-status-packet) — 显示是否使用远程协议 `qTStatus' (trace-status) 包。
    - [show remote traceframe-info-packet](#cmd-show-remote-traceframe-info-packet) — 显示是否使用远程协议 `qXfer:traceframe-info:read' (traceframe-info) 包。
    - [show remote unwind-info-block-packet](#cmd-show-remote-unwind-info-block-packet) — 显示是否使用远程协议 `qXfer:uib:read' (unwind-info-block) 包。
    - [show remote verbose-resume-packet](#cmd-show-remote-verbose-resume-packet) — 显示是否使用远程协议 `vCont' (verbose-resume) 包。
    - [show remote verbose-resume-supported-packet](#cmd-show-remote-verbose-resume-supported-packet) — 显示是否使用远程协议 `vContSupported' (verbose-resume-supported) 包。
    - [show remote vfork-event-feature-packet](#cmd-show-remote-vfork-event-feature-packet) — 显示是否使用远程协议 `vfork-event-feature' (vfork-event-feature) 包。
    - [show remote write-siginfo-object-packet](#cmd-show-remote-write-siginfo-object-packet) — 显示是否使用远程协议 `qXfer:siginfo:write' (write-siginfo-object) 包。
    - [show remote write-watchpoint-packet](#cmd-show-remote-write-watchpoint-packet) — 显示是否使用远程协议 `Z2' (write-watchpoint) 包。
    - [show remoteaddresssize](#cmd-show-remoteaddresssize) — 显示内存包中地址的最大位数。
    - [show remotecache](#cmd-show-remotecache) — 显示远程目标的缓存使用。
    - [show remoteflow](#cmd-show-remoteflow) — 显示远程串口 I/O 是否使用硬件流控。
    - [show remotelogbase](#cmd-show-remotelogbase) — 显示远程会话日志的数字进制。
    - [show remotelogfile](#cmd-show-remotelogfile) — 显示远程会话记录的文件名。
    - [show remotetimeout](#cmd-show-remotetimeout) — 显示等待目标响应的超时限制。
    - [show remotewritesize](#cmd-show-remotewritesize) — 显示每个内存写包的最大字节数（已弃用）。
    - [show schedule-multiple](#cmd-show-schedule-multiple) — 显示恢复所有进程线程的模式。
    - [show scheduler-locking](#cmd-show-scheduler-locking) — 显示执行期间锁定调度器的模式。
    - [show script-extension](#cmd-show-script-extension) — 显示脚本文件名扩展名识别模式。
    - [show serial](#cmd-show-serial) — 显示默认串口/并口配置。
    - [show serial baud](#cmd-show-serial-baud) — 显示远程串口 I/O 的波特率。
    - [show serial parity](#cmd-show-serial-parity) — 显示远程串口 I/O 的奇偶校验。
    - [show solib-absolute-prefix](#cmd-show-solib-absolute-prefix) — 显示备用系统根目录。
    - [show solib-search-path](#cmd-show-solib-search-path) — 显示加载非绝对路径共享库符号文件的搜索路径。
    - [show stack-cache](#cmd-show-stack-cache) — 显示栈访问的缓存使用。
    - [show step-mode](#cmd-show-step-mode) — 显示 step 操作的模式。
    - [show stop-on-solib-events](#cmd-show-stop-on-solib-events) — 显示是否在共享库事件处停止。
    - [show style](#cmd-show-style) — 样式相关设置。
    - [show style address](#cmd-show-style-address) — 地址显示样式。
    - [show style address background](#cmd-show-style-address-background) — 显示此属性的背景色。
    - [show style address foreground](#cmd-show-style-address-foreground) — 显示此属性的前景色。
    - [show style address intensity](#cmd-show-style-address-intensity) — 显示此属性的显示强度。
    - [show style enabled](#cmd-show-style-enabled) — 显示是否启用 CLI 样式。
    - [show style filename](#cmd-show-style-filename) — 文件名显示样式。
    - [show style filename background](#cmd-show-style-filename-background) — 显示此属性的背景色。
    - [show style filename foreground](#cmd-show-style-filename-foreground) — 显示此属性的前景色。
    - [show style filename intensity](#cmd-show-style-filename-intensity) — 显示此属性的显示强度。
    - [show style function](#cmd-show-style-function) — 函数名显示样式。
    - [show style function background](#cmd-show-style-function-background) — 显示此属性的背景色。
    - [show style function foreground](#cmd-show-style-function-foreground) — 显示此属性的前景色。
    - [show style function intensity](#cmd-show-style-function-intensity) — 显示此属性的显示强度。
    - [show style highlight](#cmd-show-style-highlight) — 高亮显示样式。
    - [show style highlight background](#cmd-show-style-highlight-background) — 显示此属性的背景色。
    - [show style highlight foreground](#cmd-show-style-highlight-foreground) — 显示此属性的前景色。
    - [show style highlight intensity](#cmd-show-style-highlight-intensity) — 显示此属性的显示强度。
    - [show style metadata](#cmd-show-style-metadata) — 元数据显示样式。
    - [show style metadata background](#cmd-show-style-metadata-background) — 显示此属性的背景色。
    - [show style metadata foreground](#cmd-show-style-metadata-foreground) — 显示此属性的前景色。
    - [show style metadata intensity](#cmd-show-style-metadata-intensity) — 显示此属性的显示强度。
    - [show style sources](#cmd-show-style-sources) — 显示是否启用源代码样式。
    - [show style title](#cmd-show-style-title) — 标题显示样式。
    - [show style title background](#cmd-show-style-title-background) — 显示此属性的背景色。
    - [show style title foreground](#cmd-show-style-title-foreground) — 显示此属性的前景色。
    - [show style title intensity](#cmd-show-style-title-intensity) — 显示此属性的显示强度。
    - [show style tui-active-border](#cmd-show-style-tui-active-border) — TUI 活动边框显示样式。
    - [show style tui-active-border background](#cmd-show-style-tui-active-border-background) — 显示此属性的背景色。
    - [show style tui-active-border foreground](#cmd-show-style-tui-active-border-foreground) — 显示此属性的前景色。
    - [show style tui-border](#cmd-show-style-tui-border) — TUI 边框显示样式。
    - [show style tui-border background](#cmd-show-style-tui-border-background) — 显示此属性的背景色。
    - [show style tui-border foreground](#cmd-show-style-tui-border-foreground) — 显示此属性的前景色。
    - [show style variable](#cmd-show-style-variable) — 变量名显示样式。
    - [show style variable background](#cmd-show-style-variable-background) — 显示此属性的背景色。
    - [show style variable foreground](#cmd-show-style-variable-foreground) — 显示此属性的前景色。
    - [show style variable intensity](#cmd-show-style-variable-intensity) — 显示此属性的显示强度。
    - [show substitute-path](#cmd-show-substitute-path) — 添加用于重写源目录的替换规则。
    - [show sysroot](#cmd-show-sysroot) — 显示备用系统根目录。
    - [show target-charset](#cmd-show-target-charset) — 显示目标字符集。
    - [show target-file-system-kind](#cmd-show-target-file-system-kind) — 显示目标报告文件名所假定的文件系统类型。
    - [show target-wide-charset](#cmd-show-target-wide-charset) — 显示目标宽字符集。
    - [show tcp](#cmd-show-tcp) — TCP 协议相关变量。
    - [show tcp auto-retry](#cmd-show-tcp-auto-retry) — 显示套接字连接是否自动重试。
    - [show tcp connect-timeout](#cmd-show-tcp-connect-timeout) — 显示套接字连接的超时限制（秒）。
    - [show tdesc](#cmd-show-tdesc) — 目标描述相关变量。
    - [show tdesc filename](#cmd-show-tdesc-filename) — 显示用于读取 XML 目标描述的文件。
    - [show trace-buffer-size](#cmd-show-trace-buffer-size) — 显示请求的跟踪缓冲区大小。
    - [show trace-commands](#cmd-show-trace-commands) — 显示是否跟踪 GDB CLI 命令。
    - [show trace-notes](#cmd-show-trace-notes) — 显示当前及今后跟踪运行使用的备注字符串。
    - [show trace-stop-notes](#cmd-show-trace-stop-notes) — 显示今后 tstop 命令使用的备注字符串。
    - [show trace-user](#cmd-show-trace-user) — 显示当前及今后跟踪运行使用的用户名。
    - [show trust-readonly-sections](#cmd-show-trust-readonly-sections) — 显示从只读段读取的模式。
    - [show tui](#cmd-show-tui) — TUI 配置变量。
    - [show tui active-border-mode](#cmd-show-tui-active-border-mode) — 显示活动 TUI 窗口边框使用的属性模式。
    - [show tui border-kind](#cmd-show-tui-border-kind) — 显示 TUI 窗口边框类型。
    - [show tui border-mode](#cmd-show-tui-border-mode) — 显示 TUI 窗口边框使用的属性模式。
    - [show tui compact-source](#cmd-show-tui-compact-source) — 显示 TUI 源窗口是否紧凑。
    - [show tui tab-width](#cmd-show-tui-tab-width) — 显示 TUI 的制表符宽度（字符数）。
    - [show unwind-on-terminating-exception](#cmd-show-unwind-on-terminating-exception) — 显示在 call dummy 中调用 std::terminate 时是否展开栈。
    - [show unwindonsignal](#cmd-show-unwindonsignal) — 显示在 call dummy 中收到信号时是否展开栈。
    - [show use-coredump-filter](#cmd-show-use-coredump-filter) — 显示 gcore 是否考虑 /proc/PID/coredump_filter。
    - [show use-deprecated-index-sections](#cmd-show-use-deprecated-index-sections) — 显示是否使用已弃用的 gdb_index 段。
    - [show user](#cmd-show-user) — 显示 definitions of non-python/scheme user defined commands.
    - [show values](#cmd-show-values) — 显示编号 IDX 附近（或最近十条）的值历史元素。
    - [show varsize-limit](#cmd-show-varsize-limit) — 显示可变大小对象允许的最大字节数。
    - [show verbose](#cmd-show-verbose) — 显示详细程度。
    - [show version](#cmd-show-version) — 显示 what version of GDB this is.
    - [show warranty](#cmd-show-warranty) — 您并不拥有的各种保修条款。
    - [show watchdog](#cmd-show-watchdog) — 显示看门狗定时器。
    - [show width](#cmd-show-width) — 显示 GDB 输出换行的字符数。
    - [show write](#cmd-show-write) — 显示是否写入可执行文件和 core 文件。

- [**support（支持）**](#cat-support)
  - [!](#cmd-bang) — 将行剩余部分作为 shell 命令执行。
  - [add-auto-load-safe-path](#cmd-add-auto-load-safe-path) — 向可安全自动加载文件的目录列表添加条目。
  - [add-auto-load-scripts-directory](#cmd-add-auto-load-scripts-directory) — 向加载自动脚本的目录列表添加条目。
  - [alias](#cmd-alias) — 定义作为现有命令别名的新命令。
  - [apropos](#cmd-apropos) — 搜索匹配 REGEXP 的命令。
  - [define](#cmd-define) — 定义新命令名。命令名作为参数。
  - [define-prefix](#cmd-define-prefix) — 定义或标记命令为用户定义前缀命令。
  - [demangle](#cmd-demangle) — 还原修饰名。
  - [document](#cmd-document) — 为用户定义命令编写文档。
  - [dont-repeat](#cmd-dont-repeat) — 不重复此命令。
  - [down-silently](#cmd-down-silently) — 与 `down' 命令相同，但不打印任何内容。
  - [echo](#cmd-echo) — 打印常量字符串。字符串作为参数。
  - [help](#cmd-help) — 打印命令列表。
  - [if](#cmd-if) — 当条件表达式非零时执行一次嵌套命令。
  - [interpreter-exec](#cmd-interpreter-exec) — 在解释器中执行命令。
  - [make](#cmd-make) — 使用行剩余部分作为参数运行 ``make'' 程序。
  - [new-ui](#cmd-new-ui) — 创建新 UI。
  - [overlay](#cmd-overlay) — 用于调试 overlay 的命令。
    - [overlay list-overlays](#cmd-overlay-list-overlays) — 列出 overlay 段的映射。
    - [overlay load-target](#cmd-overlay-load-target) — 从目标读取 overlay 映射状态。
    - [overlay manual](#cmd-overlay-manual) — 启用 overlay 调试。
    - [overlay map-overlay](#cmd-overlay-map-overlay) — 断言 overlay 段已映射。
    - [overlay off](#cmd-overlay-off) — 禁用 overlay 调试。
    - [overlay unmap-overlay](#cmd-overlay-unmap-overlay) — 断言 overlay 段未映射。
  - [pipe](#cmd-pipe) — 将 gdb 命令输出发送到 shell 命令。
  - [quit](#cmd-quit) — 退出 gdb。
  - [shell](#cmd-shell) — 将行剩余部分作为 shell 命令执行。
  - [source](#cmd-source) — 从名为 FILE 的文件读取命令。
  - [up-silently](#cmd-up-silently) — 与 `up' 命令相同，但不打印任何内容。
  - [while](#cmd-while) — 当条件表达式非零时执行嵌套命令。
  - [|](#cmd-bar) — 将 gdb 命令输出发送到 shell 命令。

- [**tracepoints（跟踪点）**](#cat-tracepoints)
  - [actions](#cmd-actions) — 指定跟踪点处要执行的动作。
  - [collect](#cmd-collect) — 指定跟踪点处要收集的一个或多个数据项。
  - [end](#cmd-end) — 结束命令或动作列表。
  - [passcount](#cmd-passcount) — 设置跟踪点的 passcount。
  - [tdump](#cmd-tdump) — 打印当前跟踪点收集的全部内容。
  - [teval](#cmd-teval) — 指定跟踪点处要求值的一个或多个表达式。
  - [tfind](#cmd-tfind) — 选择跟踪帧。
    - [tfind line](#cmd-tfind-line) — 按源行选择跟踪帧。
    - [tfind none](#cmd-tfind-none) — 取消选择任何跟踪帧并恢复“实时”调试。
    - [tfind outside](#cmd-tfind-outside) — 选择 PC 在给定范围外（不含边界）的跟踪帧。
    - [tfind pc](#cmd-tfind-pc) — 按 PC 选择跟踪帧。
    - [tfind range](#cmd-tfind-range) — 选择 PC 在给定范围内（含边界）的跟踪帧。
    - [tfind start](#cmd-tfind-start) — 选择跟踪缓冲区中的第一个跟踪帧。
    - [tfind tracepoint](#cmd-tfind-tracepoint) — 按跟踪点编号选择跟踪帧。
  - [tsave](#cmd-tsave) — 将跟踪数据保存到文件。
  - [tstart](#cmd-tstart) — 开始收集跟踪数据。
  - [tstatus](#cmd-tstatus) — 显示当前跟踪数据收集的状态。
  - [tstop](#cmd-tstop) — 停止收集跟踪数据。
  - [tvariable](#cmd-tvariable) — 定义跟踪状态变量。
  - [while-stepping](#cmd-while-stepping) — 指定跟踪点处的单步行为。

- [**user-defined（用户定义）**](#cat-user-defined)

### [未分类命令](#cat-unclassified)

- [add-inferior](#cmd-add-inferior) — 添加新 inferior。
- [clone-inferior](#cmd-clone-inferior) — 克隆 inferior ID。
- [eval](#cmd-eval) — 构造 GDB 命令并求值。
- [flash-erase](#cmd-flash-erase) — 擦除所有 flash 内存区域。
- [function](#cmd-function) — 用于显示便利函数帮助的占位命令。
- [function _cimag](#cmd-function-cimag) — 提取复数的虚部。
- [function _creal](#cmd-function-creal) — 提取复数的实部。
- [function _gdb_maint_setting](#cmd-function-gdb-maint-setting) — $_gdb_maint_setting - 返回 GDB 维护设置的值。
- [function _gdb_maint_setting_str](#cmd-function-gdb-maint-setting-str) — $_gdb_maint_setting_str - 以字符串形式返回 GDB 维护设置的值。
- [function _gdb_setting](#cmd-function-gdb-setting) — $_gdb_setting - 返回 GDB 设置的值。
- [function _gdb_setting_str](#cmd-function-gdb-setting-str) — $_gdb_setting_str - 以字符串形式返回 GDB 设置的值。
- [function _isvoid](#cmd-function-isvoid) — 检查表达式是否为 void。
- [jit-reader-load](#cmd-jit-reader-load) — 将 FILE 加载为 JIT 编译代码的调试信息读取器和展开器。
- [jit-reader-unload](#cmd-jit-reader-unload) — 卸载当前已加载的 JIT 调试信息读取器。
- [remove-inferiors](#cmd-remove-inferiors) — 移除 inferior ID（或 ID 列表）。
- [unset](#cmd-unset) — 某些 "set" 命令的互补命令。
- [unset environment](#cmd-unset-environment) — 取消程序的环境变量 VAR。
- [unset substitute-path](#cmd-unset-substitute-path) — 删除重写源目录的一条或全部替换规则。
- [unset tdesc](#cmd-unset-tdesc) — 取消设置目标描述相关变量。
- [unset tdesc filename](#cmd-unset-tdesc-filename) — 取消设置用于读取 XML 目标描述的文件。

