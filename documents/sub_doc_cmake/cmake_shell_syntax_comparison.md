# CMake 语法与 Shell 脚本语法对比

下面是 CMake 语法与 Shell 脚本语法的左右分栏对比，帮助您快速了解两种语言的主要差异。

| CMake 语法 | Shell 脚本语法 |
|------------|---------------|
| **基础语法** | **基础语法** |
| 指令(参数1 参数2 ...) | 命令 [选项] [参数] |
| 指令大小写不敏感 | 命令大小写敏感 |
| 变量区分大小写 | 变量通常区分大小写（取决于 shell 类型） |
| 使用括号括起参数 | 使用空格分隔参数 |
| 示例：`message("Hello World")` | 示例：`echo "Hello World"` |
| **变量定义与引用** | **变量定义与引用** |
| 定义变量：`set(VAR_NAME value)` | 定义变量：`VAR_NAME=value` |
| 引用变量：`${VAR_NAME}` | 引用变量：`$VAR_NAME` 或 `${VAR_NAME}` |
| 在 IF 语句中直接使用变量名：`if(VAR_NAME)` | 在条件语句中使用变量：`if [ $VAR_NAME ]` |
| 列表变量：`set(LIST_VAR item1 item2 item3)` | 数组变量：`ARRAY=(item1 item2 item3)` |
| 环境变量：`$ENV{VAR_NAME}` | 环境变量：`$VAR_NAME` 或 `${VAR_NAME}` |
| 缓存变量：`set(VAR_NAME value CACHE TYPE "描述")` | 无直接对应概念 |
| **条件判断** | **条件判断** |
| ```cmake
if(condition)
  # 条件为真时执行的代码
elseif(another_condition)
  # 另一条件为真时执行的代码
else()
  # 所有条件为假时执行的代码
endif()
``` | ```bash
if [ condition ]; then
  # 条件为真时执行的代码
elif [ another_condition ]; then
  # 另一条件为真时执行的代码
else
  # 所有条件为假时执行的代码
fi
``` |
| 条件表达式丰富，如：`if(DEFINED VAR)`、`if(TARGET target)` | 条件表达式基于文件测试和字符串比较 |
| 比较运算符：`LESS`、`GREATER`、`EQUAL` 等 | 比较运算符：`-lt`、`-gt`、`-eq` 等 |
| 逻辑运算符：`AND`、`OR`、`NOT` | 逻辑运算符：`&&`、`||`、`!` |
| **循环结构** | **循环结构** |
| ```cmake
foreach(var item1 item2)
  message(${var})
endforeach()
``` | ```bash
for var in item1 item2; do
  echo $var
done
``` |
| ```cmake
while(condition)
  # 循环体
endwhile()
``` | ```bash
while [ condition ]; do
  # 循环体
done
``` |
| 循环控制：`break()`、`continue()` | 循环控制：`break`、`continue` |
| **函数/宏定义** | **函数/宏定义** |
| ```cmake
function(my_func arg1 arg2)
  # 函数体
  message("${arg1} ${arg2}")
endfunction()
``` | ```bash
my_func() {
  # 函数体
  echo "$1 $2"
}
``` |
| ```cmake
macro(my_macro arg1 arg2)
  # 宏体
  message("${arg1} ${arg2}")
endmacro()
``` | 无直接对应宏概念，但函数可以模拟 |
| 参数引用：`${ARGV0}`、`${ARGV1}` 等 | 参数引用：`$1`、`$2` 等 |
| **注释方式** | **注释方式** |
| 单行注释：`# 这是注释` | 单行注释：`# 这是注释` |
| 无多行注释 | Bash 中多行注释：`<<'COMMENT'
多行注释
COMMENT` |
| **文件操作** | **文件操作** |
| ```cmake
file(WRITE filename "content")
file(READ filename CONTENT_VAR)
file(GLOB SOURCES "*.cpp")
file(MAKE_DIRECTORY dir)
``` | ```bash
cat > filename << EOF
content
EOF
content=$(cat filename)
sources=(*.cpp)
mkdir -p dir
``` |
| 文件复制：`file(COPY source DESTINATION destination)` | 文件复制：`cp source destination` |
| 文件重命名：`file(RENAME oldname newname)` | 文件重命名：`mv oldname newname` |
| **执行外部命令** | **执行外部命令** |
| ```cmake
execute_process(
  COMMAND command arg1 arg2
  RESULT_VARIABLE result
  OUTPUT_VARIABLE output
)
``` | ```bash
result=$(command arg1 arg2)
output=$result
``` |
| **包含其他文件** | **包含其他文件** |
| ```cmake
include(file.cmake)
include(module)
``` | ```bash
. file.sh
source file.sh
``` |
| **输出信息** | **输出信息** |
| ```cmake
message("普通消息")
message(STATUS "状态消息")
message(WARNING "警告消息")
message(FATAL_ERROR "致命错误消息")
``` | ```bash
echo "普通消息"
echo "状态消息" >&2
echo "警告消息" >&2
echo "致命错误消息" >&2; exit 1
``` |
| **字符串操作** | **字符串操作** |
| ```cmake
string(TOLOWER "${VAR}" LOWER_VAR)
string(REPLACE "old" "new" RESULT "${VAR}")
string(FIND "${VAR}" "substr" POS)
``` | ```bash
lower_var=$(echo "$var" | tr '[:upper:]' '[:lower:]')
result=${var//old/new}
pos=$(expr index "$var" "substr")
``` |
| **数值计算** | **数值计算** |
| ```cmake
math(EXPR result "1 + 1")
math(EXPR result "${a} * ${b}")
``` | ```bash
result=$((1 + 1))
result=$((a * b))
``` |