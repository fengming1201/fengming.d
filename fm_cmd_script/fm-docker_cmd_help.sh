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
function func_docker_cmd_help
{
	local docker_path=${fengming_dir}/documents/sub_doc_docker

	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		tree ${docker_path}
		echo "SYNOPSIS:"
		echo "         ${scriptname}  cmd_prefix / sub_dir_name_suffix"
		echo "example:"
		echo "        ${scriptname}  images"
		echo "        ${scriptname}  volume"
		echo ""
		return 1
	fi
	local parameter=$@
	local txt_file="none"
	local dir_file="none"
	local num=1
	for file in ${parameter}
	do
		#check sub dir first
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
			local sub_num=1
			for file_each in ${txt_file}
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
			for file_each in ${txt_file}
			do 
				echo "file[$sub_num]: ${file_each}"
				sub_num=$(expr $sub_num + 1)
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