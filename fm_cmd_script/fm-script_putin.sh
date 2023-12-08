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
function func_script_putin
{
	local tmp_dir=/tmp
	local scriptfifo=($(ls ${tmp_dir}/scriptfifo*))
	local num=1
	local array_len=${#scriptfifo[@]}

	#find out scriptfifo file
	if [ ${array_len} -gt 0 ]
	then
		echo "0 - create new file"
		for file in ${scriptfifo[*]}
		do
			echo "${num} - ${file}"
			num=$(expr ${num} + 1)
		done
		echo "N/n - nothing to do"
		read -p "Input number to select scriptfifo file:" opt
	fi

	if [ x"${opt}" = xN ] || [ x"${opt}" = xn ];then return 0;fi
	local target_file="none"
	if [ x"${opt}" = "x0" ] || [ ${array_len} -eq 0 ]
	then
		local scriptnum=$(head -c 2 /dev/random | od -A n -t u4)
		local new_scriptfifo=${tmp_dir}/scriptfifo${scriptnum// /}
		mkfifo ${new_scriptfifo}
		echo "create new mkfifo file:${new_scriptfifo}"
		target_file=${new_scriptfifo}
	else
		target_file=${scriptfifo[$(expr $opt - 1)]}
	fi
	if [ -p ${target_file} ]
	then
		echo "script -f ${target_file}"
		script -f ${target_file}
	else
		echo "not found target file:${target_file}"
	fi

	return 0
}

func_script_putin $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
