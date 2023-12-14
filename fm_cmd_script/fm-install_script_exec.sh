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
function func_install_script_exec
{
	local sorftware_install_dir=${fengming_top_dir}/sorftware_install
	local install_script_dir=${sorftware_install_dir}/install_script

	#check paramter
	if [ $# -lt 1 ]
	then 
		echo "----------------------------------"
		tree  ${install_script_dir}
		echo "path=${install_script_dir}"
		echo ""
        echo "SYNOPSIS:"
        echo "         ${scriptname}  [tool_name]  //软件名称"
		return 1
	fi
    if [ $1 = "-h" ] || [ $1 = "--help" ]
    then
        echo "DESCRIPTION:install tools by script"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  [tool_name]  //软件名称"
        return 1
    fi

	local parameter=$@
	local script_file="none"
	for file in ${parameter}
	do
		script_file=$(find ${install_script_dir} -type f -iname "*${file}*.sh")
		if [ "x${script_file}" = x ];then echo "ERROR:no found ${file} script file";return 2;fi
		for file_each in ${script_file}
		do
			echo "exec:${file_each}"
			if [ -x ${file_each} ] 
			then
				${file_each}
			else
				echo "ERROR:${file_each} can not exec"
				ls -lh ${file_each}
			fi
			
		done
	done
	return 0
}

func_install_script_exec $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
