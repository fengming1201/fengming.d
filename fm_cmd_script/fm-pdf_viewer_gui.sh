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
function func_pdf_viewer_gui
{
	local app=evince
	# local app=xpdf
	local default_opt=
	#check parameter
    if [ $# -lt 1 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
    then
        echo "DESCRIPTION:pdf 阅读器"
        echo "SYNOPSIS:"
        echo "         ${scriptfilename}  filename.pdf"
        return 1
    fi	
	which ${app} > /dev/null
	if [ $? -ne 0 ] ; then echo ¨ERROR:${scriptfilename},${app} not exist!¨;return 1;fi;

	if [ x"$SSH_CLIENT" = x  ]
	then
		$app ${default_opt} $*
	else
		local opt="N"
		read -p "Are you sure display to remote screen？ [y/N]"  opt
		if [ "x${opt}" = "x"   ];then opt="N";fi
		if [ "x${opt}" = "xy"   ] || [ "x${opt}" = "xY"   ] || [ "x${opt}" = "xyes"   ] || [ "x${opt}" = "xYES"   ]
		then
			DISPLAY=:0 $app ${default_opt} $*
		fi
	fi
	return 0
}

func_pdf_viewer_gui $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
