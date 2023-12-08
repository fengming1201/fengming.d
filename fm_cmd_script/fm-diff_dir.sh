#!/bin/bash

scriptfilename=$0

function func_diff_dir
{
    local app=diff
    local default_opt="-d"
    #check param
	if [ $# -ne 2 ]
	then
		echo "ERROR:parameter missing"
		echo "discripttion:compare two directories"
		echo "example:"
		echo "$scriptfilename    [-h or --help]"
		echo "$scriptfilename    dir1  dir2"
		echo "$scriptfilename    "
		return 1
	fi
	local dir1=$1
    local dir2=$2
	#check tools
	which ${app} > /dev/null
	if [ $? -ne 0   ];then echo "${app} not found!";return 2;fi

    ${app} -u <(ls "${dir1}" | short)  <(ls "${dir2}")
    if [ $? -ne 0 ];then echo "${app} exec error!";return 3;fi

    return 0
}


func_diff_dir $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_diff_dir() fail:${ret}"
    exit 1
fi
exit 0
