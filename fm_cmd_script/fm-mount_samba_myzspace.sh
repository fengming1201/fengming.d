#!/bin/bash

scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh
isinclude_common_func=false
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
function func_debug_help
{
    echo "--func function_name [args ...] [--debug]  #优先级3: 列出所有子函数或调用子函数"
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
    if [ $debug = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:func_test=${func_test}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    if [ ${func_test} = true ];then
        if [ ${#remaining_args[@]} -lt 1 ];then
            echo "函数列表:"
            if [ $isinclude_common_func = true ];then grep -w "^function"  ${common_share_function};fi
            grep -w "^function"  ${scriptfile}
            echo "用法:";echo -n "$scriptname ";func_debug_help;return 1
        fi
        local func_list=($(grep -w "^function"  ${scriptfile} ${common_share_function} | awk '{print$2}'))
        if [ $debug = true ];then echo "DEBUG:func_list=${func_list[@]}";fi
        local found_it=false
        for func in ${func_list[@]};do
            if [ ${func} = "${remaining_args[0]}" ];then found_it=true;fi
        done
        if [ ${found_it} = false ];then
            echo "ERROR:${remaining_args[0]} not at this scriptfile"
            echo "Possible Function Name:{ ${func_list[@]} }"
            return 2
        fi
        echo -e "\e[31mcall func ....\e[0m"
        if [ ${debug} = true ];then echo "CALL: ${remaining_args[0]}( ${remaining_args[@]:1} )";fi
        ${remaining_args[0]} "${remaining_args[@]:1}"
        echo -e "\e[31m.... done\e[0m"
        return 3
    fi
    return 0
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
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_list
{
    echo "call func_list"
    if [ ${debug} = true ];then
        echo "DEBUG:df -h | grep 135XXXX1201"
    fi
    df -h | grep 135XXXX1201

    return 0
}

function func_mount
{
    local ip=
    local remote_ip=
    local mount_dir1=zspace_nvme1
    local mount_dir2=zspace_nvme2
    local username="13534211201"
    local password="Fengming1201"
    local opt=
    #check ip
    if [ $# -lt 1 ];then
        #get from zspacet1
        local remote_ip=$(ssh MyZSpaceT2 "hostname -I")
        ip=$(echo ${remote_ip} | awk '{print $1}')
    else
        ip=$1
    fi
    if [ ${debug} = true ];then
        echo "DEBUG:ip=${ip}"
    fi
    COMMOND_FUNC_check_ip -m 1 ${ip}
    if [ $? -ne 0 ];then echo "${ip} is not a valid IP address.";return 2;fi

    #COMMOND_FUNC_quick_ping_ip  ${ip}
    #if [ $? -ne 0 ];then echo "This ${ip} is unreachable via ping.";return 3;fi

    #check mount dir
    if [ ! -d ${mount_dir1} ] && [ ${test} = false ];then
        read -p "permit mkdir ${mount_dir1}/ ?[Y/n]"  opt
        if [ "x${opt}" = x ];then opt=Y;fi
        if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ];then
            ${maybeSUDO} mkdir ${mount_dir1}
        fi
    fi
    if [ ! -d ${mount_dir2} ] && [ ${test} = false ];then
        read -p "permit mkdir ${mount_dir2}/ ?[Y/n]"  opt
        if [ "x${opt}" = x ];then opt=Y;fi
        if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ];then
            ${maybeSUDO} mkdir ${mount_dir2}
        fi
    fi

    
	#read -p "smb server IP:"  ip
	if [ "x${ip}" = x ];then echo "SMB server IP cannot be empty!";return 1;fi

    if [ -d ${mount_dir1} ] || [ ${test} = true ];then
        if $(mount -l | grep -w ${mount_dir1}) > /dev/null 2>&1;then
            echo "${mount_dir1} already mounted!!"
        else
            if [ ${test} = true ];then
	            echo "${maybeSUDO} mount -t cifs -o username=${username},password=********,vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme11}  ${mount_dir1}"
            else
                ${maybeSUDO}  mount -t cifs -o username=${username},password=${password},vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme11}  ${mount_dir1}
            fi
        fi
    fi
    if [ -d ${mount_dir2} ] || [ ${test} = true ];then
        if $(mount -l | grep -w ${mount_dir2}) > /dev/null 2>&1;then
            echo "${mount_dir2} already mounted!!"
        else    
            if [ ${test} = true ];then
                echo "${maybeSUDO} mount -t cifs -o username=${username},password=********,vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme12}  ${mount_dir2}"
            else
                ${maybeSUDO}  mount -t cifs -o username=${username},password=${password},vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme12}  ${mount_dir2}
            fi
        fi
    fi
    if [ ${test} = true ];then
        echo "TEST:nothing to do!!"
    fi
	return 0
}

function func_umount
{
    local opt=N
    local mount_point=$(mount -l  | grep 135XXXX1201 | awk '{print$3}' | tr  '\n' ' ')
    if [ "x${mount_point}" = x ];then
        echo "ERROR:umount: no mount point found"
        return 1
    fi
    read -p "Are you real umount ${mount_point} ?[y/N]"  opt
    if [ "x${opt}" = x ];then opt=N;fi
    if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ];then
        if [ ${test} = true ];then
            echo "${maybeSUDO} umount ${mount_point}"
        else
            ${maybeSUDO} umount ${mount_point}
        fi
    else
        echo "umount canceled"
    fi

    return 0
}
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]  {auto| ip | umount}"
    echo "opt:"
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
    echo "-t or --test     # test mode, no modifications"
    #echo "--realdo        # real execution"
    echo "-c or --cmd   {mount | umount}   # 等价于 mount == -M; umount == -U"
    echo "-l or --list         # 显示挂载信息"
    echo ""
    echo "-M or --mount  [ip]  # 挂载zspace,无参数,则从远程登陆获取IP; 给IP参数,则直接挂载"
    echo "-U or --umount       # 无需参数，自动卸载zspace"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_mount_zspace_samba
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
            -l|--list) cmd=list; shift ;;
            -M|--mount) cmd=mount; shift ;;
            -U|--umount) cmd=umount; shift ;;
            -c|--cmd)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd="$2"; shift 2 ;; #带参数,移动2
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
                        l) cmd=list ;;
                        M) cmd=mount ;;
                        U) cmd=umount ;;
                        c) cmd="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
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
        echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:cmd=${cmd}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} #累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    #if [ ${#remaining_args[@]} -lt 1 ];then
    #    echo "ERROR: platform list is empty!!";usage;return 2
    #fi
    #start your code
    if [ "${cmd}" = "list" ];then
        func_list
    elif [ "${cmd}" = "mount" ];then
        func_mount ${remaining_args[@]}
    elif [ "${cmd}" = "umount" ];then
        func_umount
    fi

    return 0
}

func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_mount_zspace_samba "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
