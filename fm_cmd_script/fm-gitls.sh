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
function func_gitls
{
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "no args"
		return 1
	fi
	if [ ! -d .git/ ];then
		echo "ERROR:No git repository found in current directory !!"
		return 2
	fi
	git status > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		sudo git status | grep -E 'new file:|modified:|deleted:|renamed:|copied:'
	else
		git status | grep -E 'new file:|modified:|deleted:|renamed:|copied:'
	fi
	return 0
}

func_gitls $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
