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
function func_show_monitor_info
{
	local tool=xrandr
	local tool2=xdpyinfo
	local hw_info=hwinfo
	local is_local=$(echo $SSH_TTY)

	which ${tool} > /dev/null
	if [ $? -ne 0 ]
	then 
		echo "${tool} not found!!"
		return 1
	else
		if [ "x${is_local}" = "x" ]
		then
			${tool}	
		else
			DISPLAY=:0 ${tool}	
		fi
		echo "============================================"
	fi

	which ${tool2} > /dev/null
	if [ $? -ne 0 ]
	then 
		echo "${tool2} not found!!"
		return 2
	else
		if [ "x${is_local}" = "x" ]
		then
			${tool2} | grep dimensions
		else
			DISPLAY=:0 ${tool2} | grep dimensions
		fi
		echo "============================================"
	fi

	${maybeSUDO} which ${hw_info} > /dev/null
	if [ $? -ne 0 ]
	then 
		echo "${hw_info} not found!!"
		echo "please install first:apt install hwinfo"
		return 3
	else
		${maybeSUDO} hwinfo --monitor
	fi
	return 0
}


func_show_monitor_info $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0