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
function func_docker_compose_vim_dictionary_copy2current_dir
{
	local dic_file_path=${fengming_dir}/documents/sub_doc_docker/docker-compose/dictionary_for_docker_compose
	local target_file=.dictionary_for_docker_compose
	#check
	if [ ! -f ${dic_file_path} ]
	then
		echo "vim dict file:$dic_file_path not exist"
		return 1
	fi
	if [ -w ./ ];then
		cp  -vi  ${dic_file_path}  ./${target_file}
	else
		sudo cp -vi  ${dic_file_path}  ./${target_file}
	fi
	return 0
}

func_docker_compose_vim_dictionary_copy2current_dir $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
