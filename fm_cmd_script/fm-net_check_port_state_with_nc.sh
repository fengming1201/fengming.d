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
function func_net_check_port_state_with_nc
{
	local tool=nc
	local default_opt="-zv"

	which ${tool} > /dev/null
	if [ $? -ne 0 ];then echo "${tool} not found,please install it first!";return 1;fi

	if [ $# -ne 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:检测远程主机端口号状态，也是端口号是否开放。"
		echo "$scriptname  IP PORT"
		echo ".e.g:$scriptname  116.62.103.60  1201"
		return 2
	fi
	local  ip=$1
	local port=$2
	echo "${tool} ${default_opt}  ${ip} ${port}"
	${tool} ${default_opt}  ${ip} ${port}
	return 0
}

func_net_check_port_state_with_nc $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0