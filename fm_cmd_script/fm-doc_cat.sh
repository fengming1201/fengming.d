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
function func_document_cat
{
	local doc_file_path=${fengming_dir}/documents
	
	if [ $# -lt 1 ];then tree -L 1 ${doc_file_path};return 0;fi
	if [ "$1" = "-a" ] || [ "$1" = "--all" ]
	then
		tree -sh ${doc_file_path}
		return 0
	elif [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "SYNOPSIS:"
		echo "         ${scriptname}  file_prefix / sub_dir_name_suffix"
		echo "example:"
		echo "        ${scriptname}  docker"
		echo "        ${scriptname}  image_build"
		return 1
	fi
	#point to sub dir 
	if [ -d ${doc_file_path}/${1} ] && [ $# -eq 2 ]
	then
		#check text file
		txt_file=$(find ${doc_file_path}/${1} -type f -iname "*${2}*" -o -type l -iname "*${2}*")
		if [ "x${txt_file}" != x ]
		then
			for file_each in ${txt_file}
			do
				echo "start >>>"
				cat ${file_each}
				echo "end <<<"
				echo "file:${file_each}"
			done
		fi
		return 0
	fi

	local parameter=$@
	local txt_file="none"
	local dir_file="none"
	for file in ${parameter}
	do
		#check dir first
		dir_file=$(find ${doc_file_path} -type d -iname "*${file}*")
		if [ "x${dir_file}" != x ]
		then
			for dir in ${dir_file}
			do
				tree -sh ${dir}
			done
			continue
		fi
		#check text file
		txt_file=$(find ${doc_file_path} -type f -iname "*${file}*" -o -type l -iname "*${file}*")
		if [ "x${txt_file}" != x ]
		then
			for file_each in ${txt_file}
			do
				echo "start >>>"
				cat ${file_each}
				echo "end <<<"
				echo "file:${file_each}"
			done
		fi
	done
	return 0
}

func_document_cat $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0