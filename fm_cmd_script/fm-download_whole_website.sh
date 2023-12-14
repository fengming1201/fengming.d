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
function func_download_whole_website
{
	local tool=wget
	which ${tool} > /dev/null
	if [ $? != 0 ];then echo "ERROR:${tool} not found!!";return 1;fi
	
	if [ $# -lt 1 ];then echo "ERROR:paramter missing!!";echo "$scriptname URL";return 2;fi
	
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