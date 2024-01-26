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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_linux_brightness_control
{
	local app=xrandr
	local default_opt=
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptname},${app} not exist!¨;return 2;fi;
	
	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:"
		echo "$scriptname  monitor  brightness(0-1)" 
		echo "$scriptname  HDMI-2  0.5"
		${app} -q | grep -w connected
		return 1
	fi
	local monitor=$1
	local brightness=$2
	local  monitor_name=""
	#check 
	local monitor_list=$(${app} -q | grep -w connected | awk '{print$1}')
	for name in ${monitor_list}
	do
		if [ ${name} = ${monitor} ]
		then
			monitor_name=${name}
		fi
	done
	if [ "x${monitor_name}" = "x" ];then echo "monitor name not found!";return 3;fi

	echo "${app} --output ${monitor_name} --brightness ${brightness}"
	${app} --output ${monitor_name} --brightness ${brightness}

	return 0
}


func_linux_brightness_control $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0