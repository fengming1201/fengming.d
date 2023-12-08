#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
    exit 0
fi
function func_document_grep
{
	local doc_file_path=${fengming_documents_dir}
	
	#check para
	if [ $# -lt 1 ]
	then
		echo "e.g $scriptfilename  keyword"
		return 1
	fi
	echo "grep -rn $* ${doc_file_path}"
	grep -rn "$*" ${doc_file_path}

	return 0
}
func_document_grep $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0