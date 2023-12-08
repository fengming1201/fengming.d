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
function func_docker_compose_check
{
	local docker_compose_check1=docker-compose
	local target_file=docker-compose.yml
	
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "$scriptfilename [filename],but default para is ./docker-compose.yml"
		return 1
	fi
	if [ $# -eq 1 ]
	then
		target_file=$1
	fi

	which ${docker_compose_check1} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "tool:${docker_compose_check1} not exist."
		echo "please install it first"
		return 1
	fi

	echo "================= docker-compose config ================"
	${docker_compose_check1} config
	return 0
}

func_docker_compose_check $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
