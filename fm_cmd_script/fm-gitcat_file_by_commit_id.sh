#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ $(ls -ld . | awk '{print$3}') != $(whoami) ];then
    maybeSUDO=sudo
fi
if [ $(id -u) -ne 0 ] && [ ${USER} != $(ls -ld . | awk '{print$3}') ];then
    maybeSUDO=sudo
fi
function func_gitcat_file_by_commit_id
{
	if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "$scriptname  commit_id  file or filelist"
		echo "git commit ID,you can :[git log --name-status]"
		echo "e.g.:$scriptname  fef3d5a1053480cb9ddccd05fbdc1426b57a1086 main.c"
		echo "e.g.:$scriptname  fef3d5a105 main.c"
		echo "NOTE:pay attention to the file path!!"
		return 0
	fi
	
	local commit_id=$1
	shift 1
	local file_list=$@

	git status > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo "git show ${commit_id}:${file_list}"
		sudo git show ${commit_id}:${file_list}
	else
		echo "git show ${commit_id}:${file_list}"
		git show ${commit_id}:${file_list}
	fi
	return 0
}

func_gitcat_file_by_commit_id $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
