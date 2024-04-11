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
function func_pdf_cut
{
	local app=pdftk
	local default_opt=

	#check parameter
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  src_file  page_num1-page_num2  outfile_name"
		echo "example: ${scriptname}  file.pdf  2-20   out.pdf"
        echo "example: ${scriptname}  file.pdf  2-end  out.pdf"
        echo "example: ${scriptname}  file.pdf  5-5    out.pdf"
        echo "example: ${scriptname}  file.pdf //only pdf file,then other parameters default to [2-end  out.pdf]"
        return 1
    fi
	local src_pdf_file="$1"

	if [ ! -f "${src_pdf_file}" ]
    then 
        echo "ERROR:file:${src_pdf_file} not exist"
        return 2
    fi
    local extract_range="2-end"
	local outfile_name="out.pdf"
    if [ $# -eq 3 ]
    then
        extract_range="$2"
	    outfile_name="$3"
    fi
    if [ -f ${outfile_name} ];then rm ${outfile_name};fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;
	#example:pdftk a.pdf cat 1-end output b.pdf
	$app "${src_pdf_file}"  cat "${extract_range}" output "${outfile_name}"
    if [ $? -eq 0 ] && [ ${extract_range} = "2-end" ];then rm -v "${src_pdf_file}";fi
	return 0
}

func_pdf_cut "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
