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
    echo "abstract:CN:查看硬盘的序列号。"
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
        echo ""
        return 1
    fi
    
    ${maybeSUDO} which smartctl > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:smartctl not found!"
        echo "please install it first!"
        echo "apt install smartmontools"
    else
        for dev in "$@"
        do
            #check
            if [ -b ${dev} ] || [ -c ${dev} ]
            then
                echo "smartctl result: ${dev}  "
                ${maybeSUDO}  smartctl -a  ${dev} | grep  "Serial Number"
            else
                echo "${dev} is not a device file."
            fi
        done
        echo "============================================"
    fi

    ${maybeSUDO}  which hdparm > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:hdparm not found!"
        echo "please install it first!"
        echo "apt install hdparm"
    else
        for dev in "$@"
        do
            #check
            if [ -b ${dev} ] || [ -c ${dev} ]
            then
                echo "hdparm result: ${dev}  "
                ${maybeSUDO}  hdparm -I ${dev} | grep "Serial Number" 
            else
                echo "${dev} is not a device file."
            fi
        done
        echo "============================================"
    fi

    ${maybeSUDO}  which udevadm > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:udevadm not found!"
        echo "please install it first!"
    else
        for dev in "$@"
        do
            #check
            if [ -b ${dev} ] || [ -c ${dev} ]
            then
                echo "udevadm result: ${dev}  "
                ${maybeSUDO}  udevadm info --query=property --name=${dev} | grep ID_SERIAL_SHORT
            else
                echo "${dev} is not a device file."
            fi
        done
        echo "============================================"
    fi
    return 0
}

func_show_disk_serial_number "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
