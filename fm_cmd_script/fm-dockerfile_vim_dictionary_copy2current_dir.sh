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
function func_dockerfile_vim_dictionary_copy2current_dir
{
	local dic_file_path=${fengming_documents_dir}/sub_doc_docker/Dockerfile/dictionary_for_dockerfile
	local target_file=.dictionary_for_dockerfile
	#check
	if [ ! -f ${dic_file_path} ]
	then
		echo "vim dict file:$dic_file_path not exist"
		return 1
	fi

	auto_sudo --cmd cp --arg '-vi' --src ${dic_file_path} --des ${target_file}

	return 0
}

func_dockerfile_vim_dictionary_copy2current_dir $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
