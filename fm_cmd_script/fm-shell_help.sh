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
function func_shell_help
{
	local doc_file_path=${fengming_dir}/documents
	local sub_doc_path=${doc_file_path}/sub_doc_shell
	
	#check paramter
	if [ $# -lt 1 ]
	then 
		echo "----------------------------------"
		ls  ${sub_doc_path}
		echo "path=${sub_doc_path}"
		echo ""
        echo "SYNOPSIS:"
        echo "         ${scriptname}  suffix  //功能或模块后缀"
		return 1
	fi
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:shell语法和功能模块用法帮助文档"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  suffix  //功能或模块后缀"
		echo "         ${scriptname}  show    //显示所有shell相关文件"
        return 1
    fi
	
	local parameter=$@
	local doc_file="none"
	for file_list in ${parameter}
	do
		doc_file=$(find ${sub_doc_path} -type f -iname "*${file_list}")
		if [ "x${doc_file}" = x ]
		then 
			echo "no found help file with prefix ${file_list}"
			
			local maybe_file=$(find ${sub_doc_path} -type f -iname "*${file_list}*")
			if [ "x${maybe_file}" != x ]
			then
				echo "maybe you looking for: "
				echo "${maybe_file}"
			fi
			return 2
		fi
		for file_each in ${doc_file}
		do
			echo ""
			cat ${file_each}
			echo ""
			echo "end file:${file_each}"
		done
		echo "====================================================="
		for file_each in ${cmd_file}
		do 
			echo "file list:${file_each}"
		done
	done	
	return 0
}

func_shell_help $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0