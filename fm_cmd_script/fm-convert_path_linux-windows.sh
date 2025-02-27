#!/bin/bash

scriptfile=($0)
scriptname=$(basename ${scriptfile[0]})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh
isinclude_common_func=false
if [ -f ${common_share_function} ] && [ $isinclude_common_func = true ];then
    source ${common_share_function}
    scriptfile+=(${common_share_function})
fi
#if unnecessary, please do not modify this function

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_location
{
    if [ -L ${scriptfile[0]} ];then
        echo "location:${scriptfile[0]}  --> $(readlink ${scriptfile[0]})"
    else
        echo "location:${scriptfile[0]}"
    fi
    return 0
}

##Parameter Counts      : >=1
# Parameter Requirements: func_name  args ...
# Example: usage
##
function func_debug_help
{
    echo "--func {function_name or index} [args ...] [--debug]  #优先级3: 列出所有子函数或调用子函数"
}
function func_debug_function
{
    local debug=false
    local func_test=false
    local remaining_args=()
    while [[ $# -gt 0 ]];do
        case "$1" in
            --debug) debug=true; shift ;; #不带参数,移动1
            --func) func_test=true; shift ;; #不带参数,移动1
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    if [ ${func_test} = false ];then return 0;fi
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:func_test=${func_test}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    local index=0
    local func_list=($(grep -Eo 'function [a-zA-Z_][a-zA-Z0-9_]*|^[a-zA-Z_][a-zA-Z0-9_]*\(\)' ${scriptfile[@]} | awk '{print $2}' | sed 's/[()]//g'))
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "函数列表:"
        echo ""
        for func in ${func_list[@]};do echo "[${index}] ${func}";index=$((index+1));done
        echo ""
        echo "用法:";echo -n "$scriptname ";func_debug_help;return 1
    fi
    if [ ${debug} = true ];then echo "DEBUG:func_list[${#func_list[@]}]=${func_list[@]}";fi
    local call_func_name=
    if expr "${remaining_args[0]}" : '-*[0-9]\+$' > /dev/null; then
        if [ ${debug} = true ];then echo "${remaining_args[0]} is number";fi
        call_func_name=${func_list[${remaining_args[0]}]}
    else
        if [ ${debug} = true ];then echo "${remaining_args[0]} is string";fi
        for func in ${func_list[@]};do if [ ${func} = "${remaining_args[0]}" ];then call_func_name=${func};fi;done
    fi
    if [ ${debug} = true ];then echo "DEBUG:call_func_name=${call_func_name}";fi
    if [ x${call_func_name} = x ];then echo "ERROR:${remaining_args[0]} not at this scriptfile";echo "Possible Function Name:{ ${func_list[@]} }";return 2;fi
    echo -e "\e[31mcall func ....\e[0m"
    if [ ${debug} = true ];then echo "CALL: ${call_func_name}( ${remaining_args[@]:1} ) ";fi
    ${call_func_name} "${remaining_args[@]:1}"
    echo -e "\e[31m.... done\e[0m"
    return 3
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo ""
    echo "info | -info | --info                      #优先级1: 显示摘要"
    echo "show | -show | --show                      #优先级2: 打印本脚本文件"
    func_debug_help
    echo ""
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile[0]}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ] && [ ${USER} != $(ls -ld . | awk '{print$3}') ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]  path_str"
    echo "e.p:"
    echo "$scriptname  /root/test.txt    --> \\root\\test.txt"
    echo "$scriptname 'D:\\root\\test.txt' --> /root/test.txt"
    echo ""
    echo "opt:"
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
    #echo "-t or --test     # test mode, no modifications"
    #echo "--realdo        # real execution"
    #echo "-m or --mode     # you define"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_convert_linux_windows_path
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            -m|--mode)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="$2"; shift 2 ;; #带参数,移动2
            -F|--file)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd_opt+=("--file $2"); shift 2 ;; #带参数,移动2
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        F) cmd_opt+=("--file $2"); shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        Q) cmd_opt+=("--qr=true") ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    #==================== print debug =============================#
    if [ ${debug} = true ];then
        echo "DEBUG:maybeSUDO=${maybeSUDO}"
        echo "DEBUG:debug=${debug}"
        #echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        #echo "DEBUG:mode=${mode}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    for file in "${remaining_args}"
    do
        #here we process each parameter
        echo ""
        if [ "x$(echo ${file}  | grep / )" = "x" ];then
            if [ ${debug} = true ];then
                echo "windows type "
            fi
            echo "Windows: ${file}"
            echo ""
            echo "Linux  : $(echo ${file} | sed -e 's#^[A-Z]:##' -e 's#\\#/#g')"
        else
            if [ ${debug} = true ];then
                echo "linux type "
            fi
            echo "Windows: $(echo ${file} | sed 's#/#\\#g')"
            echo ""
            echo "Linux  : ${file}"
        fi
        echo ""
    done
    
    return 0
}
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_convert_linux_windows_path "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0