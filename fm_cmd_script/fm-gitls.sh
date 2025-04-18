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
function func_gitls
{
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "no args"
		return 1
	fi

	${maybeSUDO} git rev-parse --is-inside-work-tree &> /dev/null
	if [ $? -ne 0 ];then echo "No found git-repository in the current dir!!";return 2;fi
	local git_root_dir=$(${maybeSUDO} git rev-parse --show-toplevel 2>/dev/null)
	
	echo "{"
	if [ "${1}" = "--detail" ];then
		${maybeSUDO} git remote -v
	else
		${maybeSUDO} git remote -v
	fi
	echo "},"
	echo "{"
	if [ "${1}" = "--detail" ];then
		${maybeSUDO} git branch -r
	else
		${maybeSUDO} git branch
	fi
	echo "},"
	echo "{"
	${maybeSUDO} git status | grep -E 'new file:|modified:|deleted:|renamed:|copied:'
	echo "}"

	echo "git_root_dir:${git_root_dir}"
	echo ""
	return 0
}

func_gitls $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
