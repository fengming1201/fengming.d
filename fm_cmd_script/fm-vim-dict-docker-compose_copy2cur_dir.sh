#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_docker_compose_vim_dictionary_copy2current_dir
{
	local dic_file_path=${fengming_dir}/documents/sub_doc_docker/docker-compose/vim_dictionary_for_docker_compose
	local dictionary_file=.vim_dictionary
	#check  .vim_dictionary
	if [ ! -f ${dic_file_path} ]
	then
		echo "vim dict file:$dic_file_path not exist"
		return 1
	fi
	if [ -w ./ ];then
		cp  -vi  ${dic_file_path}  ./${dictionary_file}
	else
		sudo cp -vi  ${dic_file_path}  ./${dictionary_file}
	fi

	local snippet_file_path=${fengming_dir}/documents/sub_doc_systemd/vim_snippets_for_docker_compose
	local snippets_file=.vim_snippets
    #check .vim_snippets
	if [ ! -f ${snippet_file_path} ]
	then
		echo "vim dict file:$snippet_file_path not exist"
		return 1
	fi
	if [ -w ./ ];then
		cp  -vi  ${snippet_file_path}  ./${snippets_file}
	else
		sudo cp -vi  ${snippet_file_path}  ./${snippets_file}
	fi

	return 0
}

func_docker_compose_vim_dictionary_copy2current_dir $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
