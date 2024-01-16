#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] 
then
    source ${common_share_function}
fi
function func_location
{
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ];then
    echo "abstract:"
    echo "          rarcrack暴力破解RAR，ZIP，7Z压缩包"
    COMMOND_FUNC_file_password_cracking_tools_list
    func_location
    exit 0
fi
if [ "$1" = "show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi

function func_crack_rar_password
{
    local app=rarcrack

    which ${app} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "ERROR:${app} not found!"
        echo "please install it first!"
        echo "apt install rarcrack"
        return 1
    fi
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "${scriptname} target_file.rar [--threads NUM] [--type rar|zip|7z]"
        echo "${scriptname} target_file.rar --threads 4 --type rar"
        echo ""

        return 2
    fi

    ${app} "$@"
    
    return 0
}

func_crack_rar_password $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
