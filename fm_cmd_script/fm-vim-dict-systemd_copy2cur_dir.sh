#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ]
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
function func_systemd_vim_dictionary_copy2current_dir
{
	local dic_file_path=${fengming_dir}/documents/sub_doc_systemd/dictionary_for_systemd
	local target_file=.vim_dictionary_for_systemd
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
    COMMOND_FUNC_check_vim_dictionary_env_variable ${target_file}
    if [ $? -ne 0 ]
    then
        echo "ERROR:COMMOND_FUNC_check_vim_dictionary_env_variable() fail,ret:${ret}"
        return 2
    fi
	return 0
}

func_systemd_vim_dictionary_copy2current_dir "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
