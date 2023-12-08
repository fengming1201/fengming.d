#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
fi
function  func_search_all_by_keyword
{
	if [ $# -lt 1 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
	then
        echo "DESCRIPTION:在目录:${fengming_top_dir}中搜索内容或文件"
        echo "SYNOPSIS:"
        echo "         ${scriptfilename}  keyword"
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
