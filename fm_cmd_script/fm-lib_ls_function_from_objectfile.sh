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
#列出《目标文件》中包含的《函数接口》
function lib_ls_function_from_objectfile
{
	#check 
	local tool=objdump
	local default_opt="-t"
	which ${tool} > /dev/null
	if [ $? -ne 0   ];then echo "${tool} not found!";return 1;fi

	if [ $# -lt 1  ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then 
		echo "CN:列出《目标文件》中包含的《函数接口》"
		echo "discripttion:ls obj from librarys"
		echo "example:"
		echo "$scriptname    [-h or --help]"
		echo "$scriptname    object file list"
		echo "$scriptname    1.o 2.o 3.o or *.so [current dir]"
		return 2
	fi
	local file_list=()
	#check file isn't exist
	for file in "$@"
	do
		if [ -f ${file} ]
		then
			file_list+=("${file}")
		else
			echo "file:${file} not exist"
		fi
	done
	local file_counts=${#file_list[@]}
	if [ ${file_counts} -lt 1 ];then return 3;fi
	
	for file in ${file_list[@]}
	do
		echo "${tool} ${default_opt} ${file}"
		${tool} ${default_opt} ${file}
		echo "------------------------------------"
	done
	return 0
}

lib_ls_function_from_objectfile $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
