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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function  func_search_all_by_keyword
{
	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
        echo "DESCRIPTION:在目录:${fengming_top_dir}中搜索内容或文件"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  keyword"
		echo ""
		return 1
	fi
	local key_word=$*
	#search key
	grep -rn "${key_word}"  ${fengming_top_dir}

	#search file
	find ${fengming_top_dir} -type f -iname "*${key_word}*" -o  -type l -iname "*${key_word}*"

	return 0
}

func_search_all_by_keyword $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
