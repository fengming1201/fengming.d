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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_docker_compose_vim_dictionary_copy2current_dir
{
	local dic_file_path=${fengming_dir}/documents/sub_doc_docker/docker-compose/dictionary_for_docker_compose
	local target_file=.vim_dictionary_for_docker_compose
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
	#check vim enviroment
	local myvim_rc=~/.vim/myvimrc
	if [ ! -f ${myvim_rc} ]
	then
		echo "ERROR: vim config pack not install yet"
		echo "you can:fm-install_myvim_config_pack.sh"
		echo ""
		return 2
	fi
	local isinstalled=$(cat ${myvim_rc} | grep ${target_file})
	if [ "x${isinstalled}" = "x" ]
	then
		echo "add the following content to ${myvim_rc}"
		echo ""
		cat <<EOF | tee -a ${myvim_rc}
let cur_work_dir = getcwd()
let dict_file = cur_work_dir . '/.vim_dictionary_for_docker_compose'
if filereadable(dict_file)
    execute 'set dictionary+=' . dict_file
endif
let dict_file = cur_work_dir . '/.vim_dictionary_for_dockerfile'
if filereadable(dict_file)
    execute 'set dictionary+=' . dict_file
endif
let dict_file = cur_work_dir . '/.vim_dictionary_for_cmake'
if filereadable(dict_file)
    execute 'set dictionary+=' . dict_file
endif
EOF

	fi
	return 0
}

func_docker_compose_vim_dictionary_copy2current_dir $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
