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
function func_pdf_viewer_terminal
{
	local app=evince
	local default_opt=

	#check parameter
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:终端"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  filename.pdf [file1.pdf file2.pdf ...]"
        return 1
    fi
	which ${app} > /dev/null
	if [ $? -ne 0 ] ; then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;
	
	$app ${default_opt} $*

	return 0
}

func_pdf_viewer_terminal $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
