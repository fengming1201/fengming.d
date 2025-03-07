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
function func_samba_mount
{
	if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "parameter wrong!"
		echo "$scriptname  src_dir  mount_dir"
		echo "e.g. $scriptname  media_dir  samba1"
		return 1
	fi

	local src_dir="$1"
	local mount_dir="$2"

	local ip="none"
	local username="none"
	local password="none"
	read -p "smb server IP:"  ip
	if [ "x${ip}" = x ];then echo "SMB server IP cannot be empty!";return 1;fi

	read -p "username:[root]" username
	if [ "x${username}" = x ];then username=root;fi

	read -s -p "password:[samba]" password
	if [ "x${password}" = x ];then password=samba;fi
	echo " "
	if [ ! -d ${mount_dir} ];then echo "mount point not exist";return 2;fi

	echo "${maybeSUDO} mount -t cifs -o username=${username},password=********,vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${src_dir}  ${mount_dir}"
	${maybeSUDO} mount -t cifs -o username=${username},password=${password},vers=3.1.1,uid=$(id -u),gid=$(id -g) //${ip}/${src_dir}  ${mount_dir}

	return 0
}

func_samba_mount $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_samba_mount() fail:${ret}"
    exit 1
fi
exit 0
