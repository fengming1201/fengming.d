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
function func_cmd_help
{
	local help_file_path=${fengming_dir}/cmd_help

    #check paramter
	if [ $# -lt 1 ]
	then 
		ls  ${help_file_path}
		echo "----------------------------------"
		echo "path=${help_file_path}"
		echo ""
        echo "SYNOPSIS:"
        echo "         ${scriptname}  prefix //命令或命令前缀"
		return 1
	fi
    #check paramter
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:命令的帮助文档和实例"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  prefix //命令或命令前缀"
        return 1
    fi
	
	local parameter=$@
	local help_file="none"
	local num=1
	for file_list in ${parameter}
	do
		help_file=$(find ${help_file_path} -type f -iname "${file_list}*" -o -type l -iname "${file_list}*")
		if [ "x${help_file}" = x ]
		then 
			echo "no found help file with prefix ${file_list}"
			
			local maybe_file=$(find ${help_file_path} -type f -iname "*${file_list}*" -o -type l -iname "*${file_list}*")
			if [ "x${maybe_file}" != x ]
			then
				echo "maybe you looking for: "
				echo "${maybe_file}"
			fi
			return 2
		fi
		local sub_num=1
		for file_each in ${help_file}
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
		for file_each in ${help_file}
		do 
			echo "file[$sub_num]: ${file_each}"
			sub_num=$(expr $sub_num + 1)
		done
	done
	return 0
}
func_cmd_help $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
