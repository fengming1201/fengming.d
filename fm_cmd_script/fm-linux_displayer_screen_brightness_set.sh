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
if [ "$1" = "info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ];then
    cat ${scriptfile}
    echo ""
    func_location
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
		echo "$scriptname  monitor_name  brightness_value(0-1)" 
		echo "$scriptname  HDMI-2  0.5"
        echo "$scriptname  HDMI-2  #will give current value"
		${app} -q | grep -w connected
		return 1
	fi
	local monitor=$1
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
    local brightness=
    if [ $# -eq 2 ]
    then
	    brightness=$2
    else
        if [ -e /sys/class/backlight/${monitor_name}/brightness ]
        then
            echo "current brightness value:$(cat /sys/class/backlight/${monitor_name}/brightness)"
        fi
        read -p "input brightness value:" brightness
    fi
	echo "${app} --output ${monitor_name} --brightness ${brightness}"
	${app} --output ${monitor_name} --brightness ${brightness}

	return 0
}

func_linux_brightness_control "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
