#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
function func_mount_samba
{
	if [ $# -lt 2 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
	then
		echo "parameter wrong!"
		echo "$scriptfile  src_dir  mount_dir"
		echo "e.g. $scriptfile  media_dir  samba1"
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

	if [ $(id -u) -eq 0 ]
	then
		echo "mount -t cifs -o username=${username},password=********,vers=2.0 //${ip}/${src_dir}  ${mount_dir}"
		mount -t cifs -o username=${username},password=${password},vers=2.0 //${ip}/${src_dir}  ${mount_dir}
	else
		echo "sudo mount -t cifs -o username=${username},password=********,vers=2.0 //${ip}/${src_dir}  ${mount_dir}"
		sudo mount -t cifs -o username=${username},password=${password},vers=2.0 //${ip}/${src_dir}  ${mount_dir}
	fi
	return 0
}

func_mount_samba $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_mount_samba() fail:${ret}"
    exit 1
fi
exit 0
