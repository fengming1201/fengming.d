#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ];then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ];then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo "查看系统使用的是哪种初始化系统。"
    echo "命令：ps -p 1 -o comm="
    echo "如果输出是 init，则系统使用的是 SysVinit。"
    echo "如果输出是 upstart，则系统使用的是 Upstart。"
    echo "如果输出是 systemd，则系统使用的是 Systemd。"
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
if [ $(id -u) -ne 0 ] && [ lshm != lshm ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_show_init_system_use
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ];then
        echo "查看系统使用的是哪种初始化系统。"
        echo "命令：ps -p 1 -o comm="
        echo "如果输出是 init，则系统使用的是 SysVinit。"
        echo "如果输出是 upstart，则系统使用的是 Upstart。"
        echo "如果输出是 systemd，则系统使用的是 Systemd。"
        echo ""
        return 1
    fi
    
    type=$(ps -p 1 -o comm=)
    case "$type" in
        systemd) INIT_TYPE=Systemd ;;
        init) INIT_TYPE=SysVinit ;;
        upstart) INIT_TYPE=Upstart ;;
        *) echo "Unknown init system: $type"; exit 1 ;;
    esac
    echo "ps -p 1 -o comm="
    echo "The initialization system of this Linux is [ ${INIT_TYPE} ] "
    return 0
}

func_show_init_system_use "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
