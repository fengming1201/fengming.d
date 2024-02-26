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
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
		tree -L 1 ${sub_doc_path}
		echo ""
        echo "DESCRIPTION:shell语法和功能模块用法帮助文档"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  suffix  //功能或模块前缀"
		echo "         ${scriptname}  [ABCDE]"
		echo ""
        return 1
    fi
	 
	local parameter=$@
	local doc_file="none"
	local num=1
	for file_list in ${parameter}
	do
		doc_file=$(find ${sub_doc_path} -type f -iname "${file_list}*")
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
		local sub_num=1
		for file_each in ${doc_file}
		do
			echo ""
			cat ${file_each}
			echo ""
			echo "end[$sub_num] file:${file_each}"
			sub_num=$(expr $sub_num + 1)
			echo "--------------------------------------------------------"
		done
		echo "[$num]====================================================="
		num=$(expr $num + 1)
		sub_num=1
		for file_each in ${doc_file}
		do 
			echo "file[$sub_num]: ${file_each}"
			sub_num=$(expr $sub_num + 1)
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