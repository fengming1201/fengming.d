#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
    exit 0
fi
function func_git_show_mygitinfo
{
	local mygit_site="https://github.com/fengming1201/fengming.d.git"
	local fengming_dir=("${fengming_top_dir}" "${fengming_top_dir}.bak" "${fengming_top_dir}.backup")

	for dir in ${fengming_dir[*]}
	do
		if [ -d ${dir} ]
		then
			echo ${mygit_site}
			git -C ${dir}  log  -1
		fi
	done

	return 0;
}

func_git_show_mygitinfo $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
