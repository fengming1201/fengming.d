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
function func_picture_convert_resize
{
	local app=convert
	local arg_default="-resize"

	if [ $# -ne 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "SYNOPSIS:"
		echo "$scriptfilename  input  output  resize"
		echo "e.g.$scriptfilename  mypic.jpg  newmyjpg.jpg  800x600"
		echo "resize format: "
		echo "800   --只指定宽度，而不指定高度,高度会根据原始图像的纵横比自动调整。" 
		echo "x600  --只指定高度，而不指定宽度,宽度会根据原始图像的纵横比自动调整。"
		echo "800x600 | 1024x1024 --指定宽度和高度。"
		echo "50% --使用百分比值来相对于原始图像的尺寸进行调整,50% 表示将图像调整为原始尺寸的一半。"
		echo "1024x1024>  --使用 > 符号来指定图像的最长边的大小,同时保持纵横比。"
		return 1
	fi
	local input=$1
	local output=$2
	local resize=$3
	if [ ! -f ${input} ];then echo "file:${input} not exist";return 2;fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo "${app} not found!";echo "apt install imagemagick";return 3;fi

	${app}   ${input}  ${arg_default} ${resize}  ${output}
	
	return 0
}

func_picture_convert_resize $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
