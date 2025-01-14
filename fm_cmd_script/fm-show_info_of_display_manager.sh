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
    echo "常见的显示管理器包括"
    echo "1,kGDM（GNOME Display Manager）:GDM是GNOME桌面环境使用的默认显示管理器。它提供了一个图形登录界面，允许用户选择并登录到不同的桌面会话。"
    echo "2,LightDM：LightDM是一个跨桌面环境的显示管理器，设计简单、轻量且易于定制。它支持多个桌面环境，如XFCE、LXDE等。"
    echo "3,SDDM（Simple Desktop Display Manager）：SDDM是KDE桌面环境使用的默认显示管理器。它设计简单、现代化，并具有良好的可扩展性。"
    echo "4,XDM（X Display Manager）：XDM是最古老的显示管理器之一，用于X Window系统。它提供了一个简单的登录界面，允许用户登录到X会话。"
    echo "5,KDM（KDE Display Manager）：KDM曾是KDE桌面环境使用的默认显示管理器，但在KDE Plasma 5之后被SDDM取代。"
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
    echo "================================"

    #methor4 
    if [ -f /etc/X11/default-display-manager ];then
        cat /etc/X11/default-display-manager
        #The result is one of the following
        #/usr/sbin/lightdm
        #/usr/sbin/gdm3
        #/usr/bin/sddm
        #/usr/sbin/lxdm
    fi
    echo ""
    echo "================================"

    #methor5
    ps -e | grep -E 'lightdm|gdm|sddm|lxdm'
    echo ""
    echo "================================"
    return 0
}

func_show_display_manager "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
