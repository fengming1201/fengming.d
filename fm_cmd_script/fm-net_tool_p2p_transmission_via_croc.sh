#!/bin/bash

scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/bash_function_lib/env_variable

if [ -f ${common_share_function} ];then
    source ${common_share_function}
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
    if [ ${func_test} = true ];then
        if [ ${#remaining_args[@]} -lt 1 ];then grep -w "^function"  ${scriptfile};return 1;fi
        local func_list=($(grep -w "^function"  ${scriptfile} | awk '{print$2}'))
        local found_it=false
        for func in ${func_list[@]};do
            if [ ${func} = "${remaining_args[0]}" ];then found_it=true;fi
        done
        if [ ${found_it} = false ];then
            echo "ERROR:${remaining_args[0]} not at this scriptfile"
            echo "Possible Function Name:{ ${func_list[@]} }"
            return 2
        fi
        echo -e "\e[31mcall func call....\e[0m"
        ${remaining_args[0]} "${remaining_args[@]:1}"
        if [ ${debug} = true ];then echo "DEBUG:${remaining_args[0]} ${remaining_args[@]:1}";fi
        return 3
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo ""
    echo " [info | -info | --info]                           #优先级1: 显示摘要"
    echo " [show | -show | --show]                           #优先级2: 打印本脚本文件"
    echo " [--debug ||&& --func [function_name  args ...] ]  #优先级3: 列出所有子函数或调用子函数"
    echo ""
    echo "abstract:"
    echo "croc 是一款允许任意两台计算机简单安全地传输文件和文件夹的工具。"
    echo "- 允许任意两台计算机传输数据（使用中继）"
    echo "- 提供端到端加密（使用 PAKE)"
    echo "- 轻松实现跨平台传输(Windows、Linux、Mac)"
    echo "- 允许多个文件传输"
    echo "- 允许恢复中断的传输"
    echo "- 无需本地服务器或端口转发"
    echo "- IPv6 优先,IPv4 回退"
    echo "- 可以使用代理，如 Tor"
    echo "github: https://github.com/schollz/croc"
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
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
    echo "$scriptname  [opt] args ..."
    echo ""
    echo "opt:"
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
    echo "-t or --test     # test mode, no modifications"
    #echo "--realdo        # real execution"
    echo "-c or --cmd  { send  files or dirs   # 发送文件或目录"
    echo "             | recv   [-O ourdir]    # 接收文件 ，会要求输入口令"
    echo "             | msg  \"your massage\" # 发送短消息 “你的消息”"
    echo "             | file  files           # 发送文件内容"
    echo "             }                       # 发送命令组"
    echo "-C or --code {recv_code}             # 接收口令"
    echo "-O or --out  {dir_name}              # 输出到指定的文件夹"
    echo "-L or --local                        # 强制不使用任何中继，本地局域网传输（默认使用官方中继）"
    echo "-Q or --qrcode                       # 将接收代码显示为二维码"
    echo "-Z or --zip                          # 发送前压缩文件夹s"
    echo ""
}

mycroc_pass=fengming
serverip=$(echo $g_my_cloud_server_ip_baidu2 | tr -d '\r\n')
serverport=9009
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_p2p_tool_croc
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local cmd=
    local glabole_opt=("--pass ${mycroc_pass}" "--relay \"${g_my_cloud_server_ip_baidu2}:${serverport}\"" "--ask")
    local send_opt=("--git")
    local code=12345678
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
            -C|--code)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                code="$2"; shift 2 ;; #带参数,移动2
            -O|--out)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                glabole_opt+=("--out $2"); shift 2 ;; #带参数,移动2
            -L|--local) 
                unset glabole_opt[0];unset glabole_opt[1];glabole_opt=("${glabole_opt[@]}")
                glabole_opt+=("--local"); shift ;;
            -Q|--qrcode) send_opt+=("--qr"); shift ;;
            -Z|--zip) send_opt+=("--zip"); shift ;;
            -*)
                # 处理合并的选项,如-dLh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        c) cmd="$2"; shift;break ;; # 当 c 是合并选项的一部分时，它应该停止解析剩余的字符
                        C) code="$2"; shift;break ;; # 当 C 是合并选项的一部分时，它应该停止解析剩余的字符
                        O) glabole_opt+=("--out $2"); shift;break ;; # 当 O 是合并选项的一部分时，它应该停止解析剩余的字符
                        L) unset glabole_opt[0];unset glabole_opt[1];glabole_opt=("${glabole_opt[@]}");glabole_opt+=("--local") ;;
                        Q) send_opt+=("--qr") ;;
                        Z) send_opt+=("--zip") ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    #==================== print debug =============================#
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:cmd=${cmd}"
        echo "DEBUG:code=${code}"
        echo "DEBUG:out=${outdir}"
        if [ ${test} = true ];then
            echo "DEBUG:glabole_opt[0]=${glabole_opt[0]}"
            echo "DEBUG:glabole_opt[1]=${glabole_opt[1]}"
        fi
        echo "DEBUG:glabole_opt=${glabole_opt[@]}"
        echo "DEBUG:send_opt=${send_opt[@]}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"        
    fi

    #=================== start your code ==============================#
    #if [ ${#remaining_args[@]} -lt 1 ];then
    #    echo "ERROR: platform list is empty!!";usage;return 2
    #fi
    if [ "x$cmd" = "x" ];then 
        echo "ERROR:-c | --cmd must request"
        return 2
    fi

    #start your code
    if [ $cmd = send ];then
        if [ ${#remaining_args[@]} -lt 1 ];then echo "ERROR:args is empty!";return 2;fi
        echo "CROC_SECRET=${code} croc ${glabole_opt[@]} send ${send_opt[@]} ${remaining_args[@]}"
        if [ ${test} = false ];then
            CROC_SECRET=${code} croc ${glabole_opt[@]} send ${send_opt[@]} ${remaining_args[@]}
        fi
    elif [ $cmd = recv ];then
        if [ "x$code" != x12345678 ];then
            echo "CROC_SECRET=${code} croc ${glabole_opt[@]}"
            if [ ${test} = false ];then
                CROC_SECRET=${code} croc ${glabole_opt[@]}
            fi
        else
            echo "croc ${glabole_opt[@]}"
            if [ ${test} = false ];then
                croc ${glabole_opt[@]}
            fi
        fi
    elif [ $cmd = text ];then
        if [ ${#remaining_args[@]} -lt 1 ];then echo "ERROR:args is empty!";return 2;fi
        echo "CROC_SECRET=${code} croc ${glabole_opt[@]} send ${send_opt[@]} --text ${remaining_args[0]}"
        if [ ${test} = false ];then
            CROC_SECRET=${code} croc ${glabole_opt[@]} send ${send_opt[@]} --text "${remaining_args[0]}"
        fi
    elif [ $cmd = file ];then
        if [ ${#remaining_args[@]} -lt 1 ];then echo "ERROR:args is empty!";return 2;fi
        echo "cat ${remaining_args[@]} | CROC_SECRET=${code} croc ${glabole_opt[@]} send ${send_opt[@]} "
        if [ ${test} = false ];then
            cat ${remaining_args[@]} | CROC_SECRET=${code} croc ${glabole_opt[@]} send ${send_opt[@]} 
        fi
    else
        echo "ERROR:Unknow Cammand!!"
        return 3
    fi

    return 0
}

func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_p2p_tool_croc "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
