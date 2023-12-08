#!/bin/bash

scriptfilename=$0

function func_docker_cmd_help
{
	local docker_path=${fengming_documents_dir}/sub_doc_docker
	if [ $# -lt 1 ];then tree ${docker_path};return 0;fi
	if [ $1 = "-h" ] || [ $1 = "--help" ]
	then
		echo "SYNOPSIS:"
		echo "         ${scriptfilename}  cmd_prefix / sub_dir_name_suffix"
		echo "example:"
		echo "        ${scriptfilename}  images"
		echo "        ${scriptfilename}  volume"
		return 1
	fi
	local parameter=$@
	local txt_file="none"
	local dir_file="none"
	for file in ${parameter}
	do
		#check dir first
		dir_file=$(find ${docker_path} -type d -iname "*${file}*")
		if [ "x${dir_file}" != x ]
		then
			for dir in ${dir_file}
			do
				tree -sh ${dir}
			done
			continue
		fi
		#check text file
		txt_file=$(find ${docker_path} -type f -iname "*${file}*" -o -type l -iname "*${file}*")
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

func_docker_cmd_help $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0