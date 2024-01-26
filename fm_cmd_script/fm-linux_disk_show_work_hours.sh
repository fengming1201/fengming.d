#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
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
if [ "$1" = "info" ];then
    echo "abstract:CN:查看硬盘的工作时间。"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_show_disk_work_hours
{
    local tool=smartctl
    local opt_default="-a"

    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "${scriptname}   /dev/sdX  or disk_list"
        echo ""
        return 1
    fi
    ${maybeSUDO} which ${tool} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:${tool} not found!"
        echo "please install it first!"
        echo "apt install smartmontools"
        return 2
    fi
    for dev in "$@"
    do
        #check
        if [ -b ${dev} ] || [ -c ${dev} ]
        then
            ${maybeSUDO} ${tool} ${opt_default} ${dev} | grep  -w Power_On_Hours
        else
            echo "${dev} is not a device file."
        fi
    done
    return 0
}

func_show_disk_work_hours $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
