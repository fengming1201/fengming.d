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
function func_net_check_port_state_with_nmap
{
	local tool=nmap
	local default_opt="-p"

	which ${tool} > /dev/null
	if [ $? -ne 0 ];then echo "${tool} not found,please install it first!";return 1;fi

	if [ $# -ne 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:检测远程主机端口号状态，也是端口号是否开放。"
		echo "$scriptfilename  IP  PORT"
		echo ".e.g:$scriptfilename  116.62.103.60  1201"
		return 2
	fi
	local  ip=$1
	local port=$2
	echo "${tool} ${default_opt} ${port} ${ip}"
	${tool} ${default_opt} ${port}  ${ip} 
	return 0
}

func_net_check_port_state_with_nmap $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0