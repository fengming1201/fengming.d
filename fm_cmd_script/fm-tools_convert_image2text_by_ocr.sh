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
function func_convert_image2text_by_ocr
{
	local app=tesseract
	local default_opt="-l chi_sim"
	#check parameter
    if [ $# -ne 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:recognition  image"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  imagename output_filename   //default use chi_sim"
		echo "example: ${scriptname}  test_org.jpg    outfilename"
        return 1
    fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;

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
