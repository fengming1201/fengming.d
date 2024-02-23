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
function func_git_fengming_info
{
	local mygit_site="https://github.com/fengming1201/fengming.d.git"
	local target_dir=("${fengming_dir}" "${fengming_dir}.bak" "${fengming_dir}.backup")

	for dir in ${target_dir[*]}
	do
		if [ -d ${dir} ]
		then
			echo ${mygit_site}
			git -C ${dir}  log  -1
		fi
	done

	return 0;
}

func_git_fengming_info $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
