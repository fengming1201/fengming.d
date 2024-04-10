#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo "常见的显示管理器包括GDM（GNOME Display Manager）、LightDM、SDDM（Simple Desktop Display Manager）等。"
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
function func_show_display_manager
{
    #[optional]
    #local need_help=no
    #if [ "$1" != "1" ] && [ "$1" != "2" ] && [ "$1" != "param1" ] && [ "$1" != "param2" ];then need_help=yes;fi
    #if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ ${need_help} = "yes" ]
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  no para"
        echo ""
        return 1
    fi
    #methor 1
    echo "ps -ef | grep -i dm"
    ps -ef | grep -i dm
    echo ""
    echo "================================"
    #methor 2
    echo "systemctl status display-manager"
    ${maybeSUDO} systemctl status display-manager
    echo ""
    echo "================================"

    #methor 3
    if [ -f /etc/gdm/custom.conf ];then echo "display manager is GDM";fi
    if [ -f /etc/lightdm/lightdm.conf ];then echo "display manager is LightDM";fi
    if [ -f /etc/sddm.conf ];then echo "display manager is SDDM";fi
    echo ""
    #echo "================================"

    return 0
}

func_show_display_manager "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
