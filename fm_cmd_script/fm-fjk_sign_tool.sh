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

function fjk_sign_tool
{
	local tool_path=${HOME}/XBox/XBox
	local app=bin/node
	local arg=generate_sign.js

	if [ $# -ne 1 ];then echo "parameter wrong!";echo "$FUNCNAME file";return 1;fi
	local file="$1"

	if [ ! -f "${file}" ];then echo "file:"${file}" not found";return 2;fi
	if [ ! -x ${tool_path}/${app} ];then echo "${tool_path}/${app} not exec permission";return 3;fi
	
	echo "${tool_path}/${app} ${tool_path}/${arg} ${file}"
	${tool_path}/${app} ${tool_path}/${arg} "${file}"

	if [ -e "pack.sig.${file}" ]
	then
		echo "generate sign success"
		echo "--->${file}"
		echo "--->pack.sig.${file}"
		return 0
	else
		echo "generate sign fail"
		return 4
	fi
}
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_fjk_sign_tool
{
	#check arg
	if [ $# -lt 1 ]
	then
		echo "parameter wrong!!"
		echo "$FUNCNAME filename / dirname"
		return 1
	fi
	
	local arg_list=$@
	for file in "${arg_list}"
	do
		if [ -f ${file} ]
		then
			fjk_sign_tool "${file}"
		elif [ -d ${file} ]
		then
			for filelist in $(find ${file} -type f -printf "%P\n")
			do
				fjk_sign_tool "${filelist}"
			done
		else
			echo "Unkown file type"
		fi
	done
	
	echo "done ......."
	return 0
}

func_fjk_sign_tool $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
