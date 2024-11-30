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
function func_mount_ntfs-3g
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname  mount  /dev/sdxx   mountpoint  #mount dev to mount point"
        echo "$scriptname  format  /dev/sdxx              #format to ntfs filesystem quickly"
        echo "$scriptname  fix-readonly  /dev/sdxx        #fix:readonly mode"
        echo ""
        return 1
    fi
    which ntfs-3g > /dev/null
    if [ $? -ne 0 ];then 
        echo "ERROR:please install ntfs-3g first!"
        echo "apt install ntfs-3g"
        return 2
    fi    
    local opt=$1
    local dev=$2
    if [ ! -f ${dev} ];then
        echo "ERROR:device:${dev} not exist!"
        return 1
    fi

    if [ "x${opt}" = "xmount" ] && [ $# -eq 3 ];then
        ${maybeSUDO} ntfs-3g -o remove_hiberfile ${dev} $3
    elif [ "x${opt}" = "xformat" ];then
        ${maybeSUDO} mkfs.ntfs --quick  ${dev}
    elif [ "x${opt}" = "xfix-readonly" ];then
        mount | grep ${dev} > /dev/null
        if [ $? -eq 0 ];then 
            ${maybeSUDO} umount ${dev}
        fi
        ${maybeSUDO} ntfsfix ${dev}
        #${maybeSUDO} ntfs-3g -o remove_hiberfile ${dev} /mnt/
    else
        echo "Unknown opt!"
    fi

    return 0
}

func_mount_ntfs-3g "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
