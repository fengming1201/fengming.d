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
function func_picture_convert_quality
{
	local app=convert
	local arg_default="-quality"

	if [ $# -ne 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "SYNOPSIS:"
		echo "$scriptname  input  output  quality"
		echo "e.g.$scriptname  mypic.jpg  newmyjpg.jpg  80[0-100]"
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
