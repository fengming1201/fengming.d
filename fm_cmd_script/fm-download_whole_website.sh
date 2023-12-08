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
function func_download_whole_website
{
	local tool=wget
	which ${tool} > /dev/null
	if [ $? != 0 ];then echo "ERROR:${tool} not found!!";return 1;fi
	
	if [ $# -lt 1 ];then echo "ERROR:paramter missing!!";echo "$scriptfilename URL";return 2;fi
	
	echo "${tool} -r -p -np -k $*"
	${tool} -r -p -np -k $*

	return 0
}

func_download_whole_website $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0