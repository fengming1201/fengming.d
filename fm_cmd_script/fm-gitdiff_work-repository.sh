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
function func_gitdiff_work-repository
{
	local tmp_file=$(mktemp)
	local ret=128

	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo " "
		echo "$FUNCNAME  file or file list"
		return 1
	fi
	git rev-parse --is-inside-work-tree &> /dev/null
	if [ $? -ne 0 ];then echo "No found git-repository in the current dir!!";return 2;fi
	git status > ${tmp_file}  2>&1
	ret=$?
	if [ "x$(grep "not a git repository" ${tmp_file})" != x ] && [ ${ret} -ne 0 ]
	then 
		echo "fatal: not a git repository"
		rm -f ${tmp_file}
		return 1
	fi
	rm -f ${tmp_file}

	local file_list
	for file in "$@"
    do
        if [ ! -f ${file} ]; then
            echo "WARNING:<${file}> not found,ignore it"
        else
            file_list+=("${file}")
        fi
    done
	
	if [ $ret -ne 0 ]
	then
		echo "git diff --cached ${file_list[*]}"
		sudo git diff --cached ${file_list[*]}
	else
		echo "git diff --cached ${file_list[*]}"
		git diff --cached ${file_list[*]}
	fi
	return 0
}

func_gitdiff_work-repository $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
