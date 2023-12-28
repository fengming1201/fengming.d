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

function func_linux_displayer_screen_on_off
{
	local tool=xset
	local default_opt="dpms force"
	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then 
		echo ""
		echo "${scriptname}  1 / on"
		echo "${scriptname}  2 / off"
		echo ""
		return 1
	fi
	
	which ${tool} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "ERROR:${tool} not found!!"
		echo "please install it first!"
		return 2
	fi
	local action=none
	if [ "$1" -eq 1 ] || [ "$1" = "on" ]
	then
		action=on
	elif [ "$1" -eq 2 ] || [ "$1" = "off" ]
	then
		action=off
	else
		echo "Unknow action!"
	fi
	if [ ${action} != "none" ]
	then
		if [ x"$SSH_CLIENT" = x ]
		then
			${tool} ${default_opt} ${action}
		else
			DISPLAY=:0 ${tool} ${default_opt} ${action}
		fi
	fi

    return 0
}

func_linux_displayer_screen_on_off $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
