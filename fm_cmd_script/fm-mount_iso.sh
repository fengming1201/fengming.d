#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
    exit 0
fi
function func_mount_iso
{
	if [ $# -lt 2 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
	then
		echo "parameter wrong!"
		echo "$scriptfilename  iso_file/iso_dev  mount_dir"
		echo "e.g. $scriptfilename  file.iso  /media/cdrom0"
		return 1
	fi

	local iso="$1"
	local mount_dir="$2"
	if [ ! -f ${iso} ];then echo "file:${iso} not found";return 2;fi
	if [ ! -d ${mount_dir} ];then echo "mount dir not exit";return 2;fi

	if [ $(id -u) -eq 0 ]
	then
		echo "mount -o loop -t iso9660 ${iso} ${mount_dir}"
		mount -o loop -t iso9660 ${iso} ${mount_dir}
	else
		echo "sudo mount -o loop -t iso9660 ${iso} ${mount_dir}"
		sudo mount -o loop -t iso9660 ${iso} ${mount_dir}
	fi
	return 0
}

func_mount_iso $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_mount_iso() fail:${ret}"
    exit 1
fi
exit 0