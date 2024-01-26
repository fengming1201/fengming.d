#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ];then
    echo "location:${scriptfile}"
    echo "abstract:显示某个文件的所有提交记录。"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_gitlog_allcommit_of_file_detail
{
	if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "$scriptname  file_path or filename"
		echo "e.g.:$scriptname  src/main.c"
        echo "e.g.:$scriptname  main.c"
        echo ""
		return 0
	fi

    local file_list=none
    #check file path
    if [ -f $1 ]
    then
        file_list=$1
    else
        local filename=$(basename $1)
        file_list=$(find -name ${filename}  -printf "%P\n")
    fi
    
    echo "===${file_list}"

	git status > /dev/null 2>&1
	local ret=$?
    if [ $ret -ne 0 ]
    then
        for one in ${file_list}
        do
            echo "sudo git log  -p ${one}"
            sudo git log  -p ${one}
        done
    else
        for one in ${file_list}
        do
            echo "git log  -p ${one}"
            git log  -p ${one}
        done
    fi

	return 0
}
func_gitlog_allcommit_of_file_detail $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
