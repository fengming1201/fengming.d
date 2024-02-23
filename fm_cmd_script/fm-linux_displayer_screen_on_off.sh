#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
	echo "xset dpms force off：关闭显示器。这会立即关闭显示器，进入省电模式"
	echo "xset dpms force on：打开显示器。这会唤醒显示器并恢复正常显示"
	echo "xset dpms force suspend：将显示器置于挂起（suspend）模式。这个模式下，显示器会进入更深的省电状态"
	echo "xset dpms force standby：将显示器置于待机（standby）模式。这个模式下，显示器会进入较低的省电状态"
	echo "xset dpms <timeout> <standby> <suspend> <off>：设置显示器的超时时间和省电模式"
	echo "          :<timeout>是显示器空闲后进入省电模式的时间（以秒为单位）"
	echo "          :<standby>是待机模式的超时时间"
	echo "          :<suspend>是挂起模式的超时时间"
	echo "          :<off>是关闭显示器的超时时间"
	echo "其他命令:xrandr --output <显示器标识> --off可以关闭指定的显示器"
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
function func_linux_displayer_screen_on_off
{
	local tool=xset
	local default_opt="dpms force"
	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then 
		echo ""
		echo "${scriptname}  1 / on"
		echo "${scriptname}  2 / off"
		echo "${scriptname}  3 / standby"
		echo "${scriptname}  4 / suspend"
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
	elif [ "$1" -eq 3 ] || [ "$1" = "standby" ]
	then
		action=standby
	elif [ "$1" -eq 4 ] || [ "$1" = "suspend" ]
	then
		action=suspend
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
