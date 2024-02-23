#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ];then
    echo "location:${scriptfile}"
    echo "abstract:用来改变图片的尺寸或文件大小"
	echo "         可以多次调整百分比值，以满足图片文件大小的需求。"
	echo "         可以多次调整宽和高像素值，以满足图片尺寸的需求。"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_picture_convert_resize
{
	local app=convert
	local arg_default="-resize"

	if [ $# -ne 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "SYNOPSIS:"
		echo "$scriptname  input  output  option"
		echo "e.g.$scriptname  mypic.jpg  newmyjpg.jpg  800x600"
		echo "e.g.$scriptname  mypic.jpg  newmyjpg.jpg  80%"
		echo "option: 有两种方式"
		echo "1,指定尺寸："
		echo "       800   --限定宽度，只给宽度值，而不指定高度,高度会根据原始图像的纵横比自动调整。" 
		echo "       x600  --限定高度，只给高度值，而不指定宽度,宽度会根据原始图像的纵横比自动调整。"
		echo "       800x600 | 1024x1024 --具体尺寸值，指定宽度和高度。"
		echo "       800x600^  --缩放到填充指定尺寸,使用 ^ 符号，使图像缩放并填充到指定尺寸。"
		echo "       800x600!  --缩放并保持纵横比,使用 ! 符号，强制缩放图像并保持纵横比。"
		echo "       800x600>  --强制缩放到指定尺寸，使用 > 符号，强制缩放图像到指定尺寸，并保持纵横比。"
		echo "2,指定百分比："
		echo "       50% --使用百分比值来相对于原始图像的尺寸进行调整,50% 表示将图像调整为原始尺寸的一半。"
		echo ""
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
