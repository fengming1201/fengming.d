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
function func_net_check_url_respone_with_curl 
{
	local tool=curl
	local default_opt="-I"

	which ${tool} > /dev/null
	if [ $? -ne 0 ];then echo "${tool} not found,please install it first!";return 1;fi

	if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:检测URL响应状态，也是URL是否可达。"
		echo "$scriptname  URL"
		echo ".e.g:$scriptname  http://ip:port"
		echo ".e.g:$scriptname  www.baidu.com"
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