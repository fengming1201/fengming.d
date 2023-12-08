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
function func_docker_compose_template
{
	local template_file=${fengming_documents_dir}/sub_doc_docker/docker-compose/docker-compose.yml.template
	local target_file=docker-compose.yml
	if [ ! -f ${template_file} ]
	then
		echo "template file:${template_file} not exist"
		return 1
	fi
	echo " "
	cat -n ${template_file}
	echo " "
	local opt="N"
	if [ -f ${target_file} ]
	then
		read -p "Overwrite Current docker-compose.yml? [y/N]"  opt
		if [ "x${opt}" = "x" ];then opt="N";fi
		if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ]
		then
			auto_sudo --cmd cp --arg '-vi' --src ${template_file} --des ${target_file}
		fi
	else
		read -p "Copy docker-compose.yml template to here? [Y/n]"  opt
		if [ "x${opt}" = "x" ];then opt="Y";fi
		if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ]
		then
			auto_sudo --cmd cp --arg '-vi' --src ${template_file} --des ${target_file}
		fi
	fi
	return 0
}

func_docker_compose_template $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
