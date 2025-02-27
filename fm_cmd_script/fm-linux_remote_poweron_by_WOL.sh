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
    echo "WOL - Wake-on-LAN"
    echo "如果主板支持 Wake-on-LAN (WoL)，可以通过网络发送魔术包（Magic Packet）来唤醒计算节点。"
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile[0]}
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
    echo "--realdo         # real execution"
    echo "-c or --cmd  check 网口名称            # 查看网卡支持的功能"
    echo "             enable 网口名称           # 启用 WoL"
    echo "             disable 网口名称          # 禁用 WoL"
    echo "             wakeup MAC地址列表        # 唤醒列表中的主机"
    echo "-f or --file file                     # 从指定文件中读取参数"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local cmd=
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            -c|--cmd)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd="$2"; shift 2 ;; #带参数,移动2
            -f|--file)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                file="$2"; shift 2 ;; #带参数,移动2
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        c) cmd="$2"; shift;break ;; # 当 c 是合并选项的一部分时，它应该停止解析剩余的字符
                        f) file="$2"; shift;break ;; # 当 f 是合并选项的一部分时，它应该停止解析剩余的字符
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
        echo "DEBUG:cmd=${cmd}"
	echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:file=${file}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    if [ "x${file}" != "x" ];then
        if [ ! -f ${file} ];then echo "ERROR: file:${file} not exist!!";return 2;fi
        readarray -t loadfile < <(cat $file)
        remaining_args+=("${loadfile[@]}")
        if [ ${debug} = true ];then
            echo "append_from_file:remaining_args=${remaining_args[@]}"
        fi
    fi
    ${maybeSUDO} which ethtool > /dev/null
    if [ $? -ne 0 ];then echo -e "ERROR:ethtool not found,please install it first!\napt install ethtool";return 2;fi
    which wakeonlan > /dev/null
    if [ $? -ne 0 ];then echo -e "ERROR:wakeonlan not found,please install it first!\napt install wakeonlan";return 2;fi

    #start your code
    if [ "${cmd}" = "check" ];then
        if [ ${#remaining_args[@]} -lt 1 ];then echo -e "ERROR:this cmd must have one parameter!\nusage: check 网口名称";return 3;fi
        echo "${maybeSUDO} ethtool ${remaining_args[0]}"
        ${maybeSUDO} ethtool ${remaining_args[0]}
        if [ $? -ne 0 ];then echo -e "ERROR: parameter wrong!!\nusage: check 网口名称";fi
    elif [ "${cmd}" = "enable" ];then
        if [ ${#remaining_args[@]} -lt 1 ];then echo -e "ERROR:This command must have one parameter!\nusage: enable 网口名称";return 3;fi
        echo "${maybeSUDO} ethtool -s ${remaining_args[0]} wol g"
        if [ ${realdo} = true ];then
            ${maybeSUDO} ethtool -s ${remaining_args[0]} wol g
            if [ $? -ne 0 ];then echo -e "ERROR: parameter wrong!!\nusage: enable 网口名称";fi
        fi
    elif [ "${cmd}" = "disable" ];then
        if [ ${#remaining_args[@]} -lt 1 ];then echo -e "ERROR:This command must have one parameter!\nusage: disable 网口名称";return 3;fi
        echo "${maybeSUDO} ethtool -s ${remaining_args[0]} wol d"
        if [ ${realdo} = true ];then
            ${maybeSUDO} ethtool -s ${remaining_args[0]} wol d
            if [ $? -ne 0 ];then echo -e "ERROR: parameter wrong!!\nusage: disable 网口名称";fi
        fi
    elif [ "${cmd}" = "wakeup" ];then
        if [ ${#remaining_args[@]} -lt 1 ];then echo -e "ERROR:This command must have at least one argument!\nusage: wakeup MAC地址";return 3;fi
        for mac in "${remaining_args[@]}"
        do
            echo "wakeonlan ${mac}"
            if [ ${realdo} = true ];then
                wakeonlan ${mac}
                if [ $? -ne 0 ];then echo -e "ERROR: parameter wrong!!\nusage: wakeup MAC地址";fi
            fi
        done
    else
        echo "ERROR:Unknow cmd:$cmd"
        return 2
    fi

    return 0
}

func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_ "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
