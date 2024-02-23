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
function func_mount_nfs
{
	if [ $# -lt 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "parameter wrong!"
		echo "$scriptname  ip  src_dir  mount_dir"
		echo "e.g. $scriptname  192.168.254.3 /srv/nfs  /mnt/nfs"
		return 1
	fi

	local ip="$1"
	local src_dir="$2"
	local mount_dir="$3"
	if [ ! -d ${mount_dir} ];then echo "mount point not exit";return 1;fi

	echo "${maybeSUDO} mount -t nfs -o nolock ${ip}:${src_dir} ${mount_dir}"
	${maybeSUDO} mount -t nfs -o nolock ${ip}:${src_dir} ${mount_dir}

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