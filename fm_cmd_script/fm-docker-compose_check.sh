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
function func_docker_compose_check
{
	local docker_compose_check1=docker-compose
	local target_file=docker-compose.yml
	
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "$scriptname [filename],but default para is ./docker-compose.yml"
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
