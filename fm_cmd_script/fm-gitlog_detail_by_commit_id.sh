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

function func_gitlog_detail_by_commit_id
{
	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "(1)$scriptfile  commit_id"
		echo "(2)$scriptfile  commit_id  file or filelist"
		echo "git commit ID,you can :[git log --name-status]"
		echo "e.g.:$scriptfile  fef3d5a1053480cb9ddccd05fbdc1426b57a1086 main.c"
		echo "e.g.:$scriptfile  fef3d5a105 main.c"
		echo "NOTE:pay attention to the file path!!"
		return 0
	fi
	git status > /dev/null 2>&1
	local ret=$?
	local commit_id=$1
	if [ $# -gt 1 ]
	then
		shift 1
		local file_list=$@
		if [ $ret -ne 0 ]
		then
			echo "git show ${commit_id} -- ${file_list}"
			sudo git show ${commit_id} -- ${file_list}
		else
			echo "git show ${commit_id} -- ${file_list}"
			git show ${commit_id} -- ${file_list}
		fi
	else
		if [ $ret -ne 0 ]
		then
			echo "git show ${commit_id}"
			sudo git show ${commit_id}
		else
			echo "git show ${commit_id}"
			git show ${commit_id}
		fi
	fi
	return 0
}

func_gitlog_detail_by_commit_id $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
