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
function func_gitlog
{
	local tmp_file=$(mktemp)
	local ret=128
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "no args"
		return 1
	fi
	if [ ! -d .git/ ];then
		echo "ERROR:No git repository found in current directory !!"
		return 2
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

	if [ $ret -ne 0 ]
	then
		echo "git log --name-status"
		sudo git log --name-status
	else
		echo "git log --name-status"
		git log --name-status
	fi
	
	return 0
}

func_gitlog $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
