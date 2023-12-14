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
function func_software_install_tutorial
{
	local sorftware_tutorial_dir=${fengming_dir}/sorftware_toolket
	
	#check paramter
	if [ $# -lt 1 ];then tree  ${sorftware_tutorial_dir};return 1;fi
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:软件的安装教程"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  [name / keyword]  //关键字或软件名称"
        return 0
    fi

	local parameter=$@
	local tutor_file="none"
	for file in ${parameter}
	do
		if [ -d ${sorftware_tutorial_dir}/${file} ]
		then
			tree ${sorftware_tutorial_dir}/${file}
			continue
		fi
		tutor_file=$(find ${sorftware_tutorial_dir} -type f -iname "*${file}*" -o  -type l -iname "*${file}*")
		if [ "x${tutor_file}" = x ];then echo "ERROR:no found ${file} toturial file";return 2;fi
		for file_each in ${tutor_file}
		do
			echo "start >>>"
			cat ${file_each}
			echo "end <<<"
			echo "file:${file_each}"
		done
	done
	return 0
}

func_software_install_tutorial $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
