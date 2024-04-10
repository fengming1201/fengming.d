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
function func_document_grep
{
	local doc_file_path=${fengming_dir}/documents
	#check paramter
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        tree -L 1 ${doc_file_path}
        echo ""
        echo "DESCRIPTION:"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  keyword  //关键词"
        echo ""
        return 1
    fi
	echo "grep --color=auto -rin $* ${doc_file_path}"
	grep --color=auto -rin "$*" ${doc_file_path}

	return 0
}
func_document_grep "$@"
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0