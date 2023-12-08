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
function func_picture_convert_quality
{
	local app=convert
	local arg_default="-quality"

	if [ $# -ne 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "SYNOPSIS:"
		echo "$scriptfilename  input  output  quality"
		echo "e.g.$scriptfilename  mypic.jpg  newmyjpg.jpg  80"
		return 1
	fi
	local input=$1
	local output=$2
	local qual=$3

	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo "${app} not found!";echo "apt install imagemagick";return 1;fi

	${app}   ${input}  ${arg_default} ${qual}  ${output}
	
	return 0
}

func_picture_convert_quality $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
