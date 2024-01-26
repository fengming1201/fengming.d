#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ]
then
    source ${common_share_function}
fi

if [ "$1" = "info" ];then
    echo "abstract:暴力破解pdf密码"
    echo "格式："
    echo "     pdfcrack -f file.pdf  -n N -m M -c  密码字符集"
    echo "或   pdfcrack -f file.pdf  -n N -m M -w  密码字典文件"
    echo "-n  <最小密码长度> "
    echo "-m  <最大密码长度>" 
    echo ""
    COMMOND_FUNC_file_password_cracking_tools_list

    echo ""
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    echo ""
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_pdf_password_scrack
{
	local app=pdfcrack
	local default_opt=

    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "formate:"
        echo "${scriptname} -f file.pdf -n N -m M -c  0123456789"
        echo "${scriptname} -f file.pdf -n N -m M -w  pass_dict.txt"
        echo "${scriptname} -f file.pdf -n 2 -m 6 -c  0123456789"
        echo "${scriptname} info //to get more info"
        return 1
    fi
 
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;

	$app ${default_opt} $*
	return 0
}

func_pdf_password_scrack $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
