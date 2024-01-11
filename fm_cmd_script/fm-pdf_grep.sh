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

function func_pdf_grep
{
	local app=pdfgrep
	local default_opt="--cache -iHnr "
    which ${app} > /dev/null
	if [ $? -ne 0 ] ; then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;
	
	$app ${default_opt} $*

	return 0
}

func_pdf_grep $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
