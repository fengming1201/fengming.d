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
function func_pdf_viewer_terminal
{
	local app=evince
	local default_opt=

	#check parameter
    if [ $# -lt 1 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
    then
        echo "DESCRIPTION:终端"
        echo "SYNOPSIS:"
        echo "         ${scriptfilename}  filename.pdf [file1.pdf file2.pdf ...]"
        return 1
    fi
	which ${app} > /dev/null
	if [ $? -ne 0 ] ; then echo ¨ERROR:${scriptfilename},${app} not exist!¨;return 1;fi;
	
	$app ${default_opt} $*

	return 0
}

func_pdf_viewer_terminal $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
