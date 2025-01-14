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
function func_show_RAM_info
{
    local tool=dmidecode 
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  [type]     #无参数默认是memory"
        echo "$scriptname  bios       #BIOS 信"
        echo "$scriptname  system     #系统信息"
        echo "$scriptname  baseboard  #主板信息"
        echo "$scriptname  chassis    #机箱信息"
        echo "$scriptname  processor  #处理器信息"
        echo "$scriptname  memory     #内存信息"
        echo "$scriptname  cache      #缓存信息"
        echo "$scriptname  connector  #连接器信息"
        echo "$scriptname  slot       #插槽信息"
        echo ""
        return 1
    fi
    local type=memory
    if [ $# -eq 1 ];then
        type=$1
    fi

    sudo which ${tool}  > /dev/null
    if [ $? -ne 0 ];then
        echo "${tool} not exist! please install it first!"
        echo "apt install dmidecode"
        echo ""
        return 1
    fi
    echo "sudo ${tool} --type ${type}"
    sudo ${tool} --type ${type}

    return 0
}

func_show_RAM_info "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
