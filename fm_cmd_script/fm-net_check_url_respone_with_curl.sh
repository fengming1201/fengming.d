#!/bin/bash

scriptfilename=$0

function func_net_check_url_respone_with_curl 
{
	local tool=curl
	local default_opt="-I"

	which ${tool} > /dev/null
	if [ $? -ne 0 ];then echo "${tool} not found,please install it first!";return 1;fi

	if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:检测URL响应状态，也是URL是否可达。"
		echo "$scriptfilename  URL"
		echo ".e.g:$scriptfilename  http://ip:port"
		echo ".e.g:$scriptfilename  www.baidu.com"
		return 2
	fi
	local  url_str=$1
	echo "${tool} ${default_opt}  ${url_str}"
	${tool} ${default_opt}  ${url_str}
	return 0
}

func_net_check_url_respone_with_curl $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0