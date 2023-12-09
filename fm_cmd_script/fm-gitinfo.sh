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

function func_gitinfo
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
	if [ ${ret} -ne 0 ]
	then
		echo "{"
		sudo git remote -v
		echo "},"
		echo "{"
		sudo git branch
		echo "}"
	else
		echo "{"
		git remote -v
		echo "},"
		echo "{"
		git branch
		echo "}"
	fi
	return 0
}

func_gitinfo $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
