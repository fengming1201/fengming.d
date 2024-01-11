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

function func_pdf_cut
{
	local app=pdftk
	local default_opt=
	#check parameter
    if [ $# -ne 3 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
    then
        echo "DESCRIPTION:"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  src_file  page_num1-page_num2  outfile_name"
		echo "example: ${scriptname}  file.pdf  2-20  out.pdf"
        return 1
    fi
	local src_pdf_file=$1
	local extract_range=$2
	local outfile_name=$3
	if [ ! -f ${src_pdf_file} ];then echo "ERROR:file:${src_pdf_file} not exist";return 2;fi
	
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;
	#example:pdftk a.pdf cat 1-end output b.pdf
	$app ${src_pdf_file}  cat ${extract_range} output ${outfile_name}

	return 0
}

func_pdf_cut $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
