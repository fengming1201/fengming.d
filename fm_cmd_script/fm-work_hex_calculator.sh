#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
#if unnecessary, please do not modify following code
extern_script_files=(${fengming_dir}/fm_cmd_script/common_share_function.sh)
if [ -f ${extern_script_files[0]} ];then
    source ${extern_script_files[0]}
fi

#if unnecessary, please do not modify following code
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo ""
    echo "info | -info | --info                                 #优先级1: 显示摘要"
    echo "show | -show | --show                                 #优先级2: 打印本脚本文件"
    func_debug_help
    echo ""
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
#if unnecessary, please do not modify following code
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi

if [ $(ls -ld . | awk '{print$3}') != $(whoami) ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_hex_calculator
{
    local expression="$1"
    local output="$2"
    
    # 检查表达式是否为空
    if [ -z "$expression" ]; then
        echo "ERROR: expression is empty!" >&2
        return 1
    fi
    
    # 将表达式中的十六进制数转换为十进制
    local decimal_expr="$expression"
    
    # 匹配所有十六进制数 (0x开头的数字)
    while [[ "$decimal_expr" =~ 0x[0-9A-Fa-f]+ ]]; do
        hex_num="${BASH_REMATCH[0]}"
        # 转换为十进制
        dec_num=$((hex_num))
        # 替换表达式中的十六进制数为十进制
        decimal_expr="${decimal_expr//$hex_num/$dec_num}"
    done
    
    # 执行计算
    local result=0
    if ! result=$((decimal_expr)); then
        echo "ERROR: invalid expression!" >&2
        return 2
    fi
    
    # 根据输出选项格式化结果
    case "$output" in
        "2")
            # 输出二进制
            if [ "$result" -eq 0 ]; then
                echo "0b0"
            else
                local binary=""
                local num="$result"
                while [ "$num" -gt 0 ]; do
                    binary="$((num % 2))$binary"
                    num="$((num / 2))"
                done
                echo "0b$binary"
            fi
            ;;
        "8")
            # 输出八进制
            printf "0o%o\n" "$result"
            ;;
        "10"|"dec")
            # 输出十进制
            echo "$result"
            ;;
        "16"|"hex")
            # 输出十六进制
            printf "0x%X\n" "$result"
            ;;
        *)
            # 默认输出十六进制
            printf "0x%X\n" "$result"
            ;;
    esac
    
    return 0
}
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]  expression"
    echo "opt:"
    echo "-h or --help       # help"
    echo "-d or --debug      # print variable status"
    #echo "-t or --test       # test mode, no modifications"
    #echo "--realdo          # real execution"
    echo "-o or --output     # 输出进制选择: 2(二进制), 8(八进制), 10(十进制), 16(十六进制,默认)或hex/dec"
    #echo "--setx or --detail # open set -x mode"
    echo "--func   func_name  args ...                            #调试某个函数,无参数--func,显示函数列表"
    echo "--stdin            # 从标准输入读取输入（支持heredoc和管道）"
    echo "example:"
    echo "$scriptname 10+0xA"              # 十进制10加十六进制10，默认十六进制输出
    echo "$scriptname 0xFF-255"            # 十六进制255减十进制255
    echo "$scriptname 0x10*5 -o dec" # 十六进制16乘5，十进制输出
    echo "$scriptname 256/0x10 -o 10" # 十进制256除以十六进制16，十进制输出
    echo "$scriptname 10+5 -o 2"     # 10+5，二进制输出
    echo "$scriptname 255 -o 8"       # 255，八进制输出
    echo "$scriptname --stdin << EOF"
    echo ">0xA+10 -o 10"        # 支持管道输入
    echo ">EOF"
    echo "cat expr.txt | $scriptname"   # 从文件读取表达式
    echo "例子："
    echo "$scriptname \"0xA0800000-0x80000\"/0x1000"
    echo "$scriptname \"((0xA+10)*2-(0x5/0x1))+0x10\""
    echo "注意事项："
    echo "1. 表达式要用“”括起来，防止shell解释括号和运算符"
    echo "2. 支持的运算符：+ - * /，支持任意深度的嵌套括号，自动处理运算符优先级"
    echo "3. 可混合使用十六进制(0x开头)和十进制数"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_main
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local setx=false
    local use_stdin=false
    local output="hex"  # 默认输出十六进制
    local expression=""
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;  
            -o|--output)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                output="$2"; shift 2 ;; #带参数,移动2
            --setx) setx=true; shift ;; #不带参数,移动1
            --detail) setx=true; shift ;; #不带参数,移动1
            --stdin) use_stdin=true; shift ;;  
            -*)
                # 处理合并的选项
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;; 
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    #==================== print debug =============================#
    if [ ${debug} = true ];
then
        echo "DEBUG:maybeSUDO=${maybeSUDO}"
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:test=${test}"
        echo "DEBUG:output=${output}"
        echo "DEBUG:setx=${setx}"
        echo "DEBUG:use_stdin=${use_stdin}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    # check if input is from stdin
    if [ ${use_stdin} = true ];
then
        # Read from stdin
        if [ -t 0 ]; then
            echo "ERROR: --stdin option requires input from pipe or heredoc!" >&2
            return 2
        fi
        expression=$(cat | tr '\n' ' ' | tr -s ' ')
    else
        # 从剩余参数构建表达式
        if [ ${#remaining_args[@]} -eq 0 ];
then
            echo "ERROR: expression is empty!!";usage;return 2
        fi
        expression=$(IFS=" "; echo "${remaining_args[*]}")
    fi
    
    if [ ${debug} = true ]; then
        echo "DEBUG:expression=${expression}"
    fi
    
    # 调用十六进制计算器函数
    func_hex_calculator "${expression}" "${output}"
    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
