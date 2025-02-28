#!/bin/bash

scriptfile=($0)
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh
if [ -f ${common_share_function} ] && [ true = false ];then
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
    if [ -L ${scriptfile} ];then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
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
        echo "DEBUG:script_file=${scriptfile[@]}"
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:func_test=${func_test}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    local index=0
    local func_list=($(cat  ${scriptfile[@]} | grep -E '(function\s+[a-zA-Z_][a-zA-Z0-9_]*|\w+\s*\(\s*\))' | \
                        sed -e 's/#.*//' -e '/^[[:space:]]*$/d' -e '/=/d' -e 's/function//' -e 's/{//' -e 's/(//' -e 's/)//' | \
                        sed 's/^[[:space:]]*//; s/[[:space:]]*$//'))
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
    echo "         为 apt 添加国内镜像源"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
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
    echo "$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
    #echo "-t or --test     # test mode, no modifications"
    echo "--realdo        # real execution"
    #echo "-m or --mode   # you define"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_add_source_list_for_apt
{
    #if [ $# -lt 1 ];then usage; return 1; fi
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
        echo "DEBUG:realdo=${realdo}"
        #echo "DEBUG:mode=${mode}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    #if [ ${#remaining_args[@]} -lt 1 ];then
    #    echo "ERROR: platform list is empty!!";usage;return 2
    #fi
    #start your code
    #for file in "${remaining_args[@]}"
    #do
        #here we process each parameter
        #linux_cmd  ${cmd_opt[@]} args ....
    #done
    local  source_list_file=/etc/apt/sources.list
    #check and backup 
    if [ ! -f ${source_list_file}.org ] || [ ${realdo} == true ];then
        echo "backup ${source_list_file} ..."
        ${maybeSUDO} cp -v ${source_list_file} ${source_list_file}.org
    fi
    if [ ${realdo} == false ];then
        maybeSUDO=
        source_list_file=$(mktemp)
    fi
    #add source
    local debian_name=$(grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME=//') && \
    ${maybeSUDO} tee ${source_list_file} <<EOF
#debian offic
deb http://deb.debian.org/debian/  ${debian_name} main contrib non-free

# 阿里云
deb http://mirrors.aliyun.com/debian/ ${debian_name} main contrib non-free
deb http://mirrors.aliyun.com/debian/ ${debian_name}-updates main contrib non-free
deb http://mirrors.aliyun.com/debian-security/ ${debian_name}-security main contrib non-free

# 中科大
deb http://mirrors.ustc.edu.cn/debian/ ${debian_name} main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ ${debian_name}-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security/ ${debian_name}-security main contrib non-free

# 163
deb http://mirrors.163.com/debian/ ${debian_name} main contrib non-free
deb http://mirrors.163.com/debian/ ${debian_name}-updates main contrib non-free
deb http://mirrors.163.com/debian-security/ ${debian_name}-security main contrib non-free
EOF
    #cat ${source_list_file}
    if [ ${realdo} == false ];then echo -e "\nNote:use option --realdo to real write to /etc/apt/sources.list";rm ${source_list_file};fi
    return 0
}

func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_add_source_list_for_apt "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
