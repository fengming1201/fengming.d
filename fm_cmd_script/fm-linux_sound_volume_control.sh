#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
fi
#Linux Sound volume control
function func_linux_sound_volume_control
{
	local app=alsamixer
	local default_opt=
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:"
		echo "" 
		return 1
	fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptfilename},${app} not exist!¨;return 2;fi;

	${app}
	return 0
}

func_linux_sound_volume_control $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0