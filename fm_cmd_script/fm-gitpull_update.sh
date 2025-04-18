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
if [ $(ls -ld . | awk '{print$3}') != $(whoami) ];then
    maybeSUDO=sudo
fi

function func_git_pull_update
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
		echo "sudo git pull ${remote_name} ${branch_name}"
		sudo git pull ${remote_name} ${branch_name}
	else
		remote_name=$(git remote -v | awk '{print $1}' | uniq)
		branch_name=$(git branch | awk '{print $2}' | uniq)
		echo "git pull ${remote_name} ${branch_name}"
		git pull ${remote_name} ${branch_name}
	fi

	return 0
}

func_git_pull_update $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
