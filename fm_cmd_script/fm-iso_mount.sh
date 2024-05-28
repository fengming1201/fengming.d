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
function func_mount_iso
{
	if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "parameter wrong!"
		echo "$scriptname  iso_file/iso_dev  mount_dir"
		echo "e.g. $scriptname  file.iso  /media/cdrom0"
		return 1
	fi

	local iso="$1"
	local mount_dir="$2"
	if [ ! -f ${iso} ];then echo "file:${iso} not found";return 2;fi
	if [ ! -d ${mount_dir} ];then echo "mount dir not exit";return 2;fi

	echo "${maybeSUDO} mount -o loop  ${iso} ${mount_dir}"
	${maybeSUDO} mount -o loop  ${iso} ${mount_dir}
	
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