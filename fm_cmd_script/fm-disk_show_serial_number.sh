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
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "abstract:CN:查看硬盘的序列号。"
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
if [ $(id -u) -ne 0 ]
then
    maybeSUDO=sudo
fi
function func_show_disk_serial_number
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "${scriptname}   /dev/sdX  or disk_list"
        echo "${scriptname}   /dev/sda  /dev/nvmen1 ...."
        echo ""
        return 1
    fi
    #check dev file
    local dev_list=()
    for dev in "$@"
    do
        if [ -b ${dev} ] || [ -c ${dev} ]
        then
            dev_list+=("${dev}")
        else
            echo "${dev} is not a device file."
            echo "============================================"
        fi
    done

    #check tool
    ${maybeSUDO} which smartctl > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:smartctl not found!"
        echo "please install it first!"
        echo "apt install smartmontools"
        echo "============================================"
    else
        local tool1=smartctl
    fi
    ${maybeSUDO}  which udevadm > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:udevadm not found!"
        echo "please install it first!"
        echo "============================================"
    else
        local tool2=udevadm
    fi
    ${maybeSUDO}  which hdparm > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:hdparm not found!"
        echo "please install it first!"
        echo "apt install hdparm"
        echo "============================================"
    else
        local tool3=hdparm
    fi
    ${maybeSUDO}  which nvme > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:udevadm not found!"
        echo "please install it first!"
        echo "apt install nvme-cli"
        echo "============================================"
    else
        local tool4=nvme
    fi


    #show
    for dev in "${dev_list[@]}"
    do  
        if [ "${tool1}" = "smartctl" ]
        then
            echo "smartctl result: ${dev}  "
            ${maybeSUDO}  smartctl -a  ${dev} | grep  "Serial Number"
            echo "============================================"
        fi
        if [ "${tool2}" = "udevadm" ]
        then
            echo "udevadm result: ${dev}  "
            ${maybeSUDO}  udevadm info --query=property --name=${dev} | grep ID_SERIAL_SHORT
            echo "============================================"
        fi
        if [ "${tool3}" = "hdparm" ] && [ "x$(echo ${dev} | grep "/dev/nvme*")" = x ]
        then
            echo "hdparm result: ${dev}  "
            ${maybeSUDO}  hdparm -I ${dev} | grep "Serial Number" 
            echo "============================================"
        fi
        if [ "${tool4}" = "nvme" ] && [ "x$(echo ${dev} | grep "/dev/nvme*")" != x ]
        then
            echo "nvme result: ${dev}  "
            ${maybeSUDO}  nvme id-ctrl ${dev} | grep -w "sn*:*"
            echo "============================================"
        fi
    done

    return 0
}

func_show_disk_serial_number "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
