#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_git_push_update
{
	local tmp_file=$(mktemp)
	local ret=128
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "no args"
		return 1
	fi

	git status > ${tmp_file}  2>&1
	ret=$?
	if [ "x$(grep "not a git repository" ${tmp_file})" != x ] && [ ${ret} -ne 0 ]
	then 
		echo "fatal: not a git repository"
		rm -f ${tmp_file}
		return 1
	fi
	rm -f ${tmp_file}
	local remote_name="origin"
	local branch_name="main"
	if [ ${ret} -ne 0 ]
	then
		remote_name=$(sudo git remote -v | awk '{print $1}' | uniq)
		branch_name=$(sudo git branch | awk '{print $2}' | uniq)
		echo "sudo git push ${remote_name} ${branch_name}"
		sudo git push ${remote_name} ${branch_name}
	else
		remote_name=$(git remote -v | awk '{print $1}' | uniq)
		branch_name=$(git branch | awk '{print $2}' | uniq)
		echo "git push ${remote_name} ${branch_name}"
		git push ${remote_name} ${branch_name}
	fi

	return 0
}

func_git_push_update "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
