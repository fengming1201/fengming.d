#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "include" ];then
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
function func_mount_to_myzspace
{
    local nvme11=nvme11-135XXXX1201
    local mount_dir1=zspace_nvme1
    local nvme12=nvme12-135XXXX1201
    local mount_dir2=zspace_nvme2
    local ip="none"
	local username="13534211201"
	local password="Fengming1201"

	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "parameter wrong!"
		echo "$scriptname  IP"
		echo "e.g. $scriptname  192.168.254.100"
		return 1
	fi
    #check ip
    ip=$1
    COMMOND_FUNC_check_ip -m 1 ${ip}
    if [ $? -ne 0 ];then echo "${ip} is not a valid IP address.";return 2;fi

    #check mount dir
    if [ ! -d ${mount_dir1} ];then
        read -p "permit mkdir ${mount_dir1}/ ?[Y/n]"  opt
        if [ "x${opt}" = x ];then opt=Y;fi
        if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ];then
            ${maybeSUDO} mkdir ${mount_dir1}
        fi
    fi
    if [ ! -d ${mount_dir2} ];then
        read -p "permit mkdir ${mount_dir1}/ ?[Y/n]"  opt
        if [ "x${opt}" = x ];then opt=Y;fi
        if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ];then
            ${maybeSUDO} mkdir ${mount_dir2}
        fi
    fi

    
	#read -p "smb server IP:"  ip
	#if [ "x${ip}" = x ];then echo "SMB server IP cannot be empty!";return 1;fi

    if [ -d ${mount_dir1} ];then
        if $(mount -l | grep -w ${mount_dir1});then
            echo "${mount_dir1} already mounted!!"
        else
	        echo "${maybeSUDO} mount -t cifs -o username=${username},password=********,vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme11}  ${mount_dir1}"
            ${maybeSUDO}  mount -t cifs -o username=${username},password=${password},vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme11}  ${mount_dir1}
        fi
    fi
    if [ -d ${mount_dir2} ];then
        if $(mount -l | grep -w ${mount_dir2});then
            echo "${mount_dir2} already mounted!!"
        else    
	        echo "${maybeSUDO} mount -t cifs -o username=${username},password=********,vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme12}  ${mount_dir2}"
            ${maybeSUDO}  mount -t cifs -o username=${username},password=${password},vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${nvme12}  ${mount_dir2}
        fi
    fi
	return 0
}

func_mount_to_myzspace "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
