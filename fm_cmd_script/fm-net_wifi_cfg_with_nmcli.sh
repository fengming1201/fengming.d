#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_wifi_config_with_nmcli
{
    local cfg_tool=nmcli

    which ${cfg_tool} > /dev/null
    if [ $ne -0 ]
    then
        echo "tool:${cfg_tool} not found!"
        echo "please install it first!"
        echo "apt install network-manager"
        return 1
    fi
    #check param
    if [ $# -lt 1 ] || [ "$1" = "-h" ] | [ "$1" = "--help" ]
    then
        echo "${scriptname}  "

    fi

    return 0
}

func_wifi_config_with_nmcli $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
