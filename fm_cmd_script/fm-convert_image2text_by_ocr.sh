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
function func_convert_image2text_by_ocr
{
	local app=tesseract
	local default_opt="-l chi_sim"
	#check parameter
    if [ $# -ne 2 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
    then
        echo "DESCRIPTION:recognition  image"
        echo "SYNOPSIS:"
        echo "         ${scriptfilename}  imagename output_filename   //default use chi_sim"
		echo "example: ${scriptfilename}  test_org.jpg    outfilename"
        return 1
    fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptfilename},${app} not exist!¨;return 1;fi;

	local src_image=$1
	local output_file=$2

	echo "image=${src_image}  output=${output_file}"

	${app}  ${src_image}  ${output_file} ${default_opt}

	return 0
}

func_convert_image2text_by_ocr $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
