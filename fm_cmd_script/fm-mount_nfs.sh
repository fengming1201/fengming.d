#!/bin/bash

scriptfilename=$0

function func_mount_nfs
{
	if [ $# -lt 3 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
	then
		echo "parameter wrong!"
		echo "$scriptfilename  ip  src_dir  mount_dir"
		echo "e.g. $scriptfilename  192.168.254.3 /srv/nfs  /mnt/nfs"
		return 1
	fi

	local ip="$1"
	local src_dir="$2"
	local mount_dir="$3"
	if [ ! -d ${mount_dir} ];then echo "mount point not exit";return 1;fi

	if [ $(id -u) -eq 0 ]
	then
		echo "mount -t nfs -o nolock ${ip}:${src_dir} ${mount_dir}"
		mount -t nfs -o nolock ${ip}:${src_dir} ${mount_dir}
	else
		echo "sudo mount -t nfs -o nolock ${ip}:${src_dir} ${mount_dir}"
		sudo mount -t nfs -o nolock ${ip}:${src_dir} ${mount_dir}
	fi
	return 0
}

func_mount_nfs $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_mount_nfs() fail:${ret}"
    exit 1
fi
exit 0