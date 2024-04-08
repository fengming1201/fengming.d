#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
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
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_unzip_for_honeypdf_with_passwd
{
    #[optional]
    #local need_help=no
    #if [ "$1" != "1" ] && [ "$1" != "2" ] && [ "$1" != "param1" ] && [ "$1" != "param2" ];then need_help=yes;fi
    #if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ ${need_help} = "yes" ]
    
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  zip_file_list"
        echo "$scriptname  a.zip  b.zip"
        echo "$scriptname  ./*.zip"
        return 1
    fi

    local pass=no
    local extract_dir=extract_dir
    if [ ! -d ${extract_dir} ];then mkdir ${extract_dir};fi

    old_ifs=$IFS
    IFS=$'\n'
    for file in "$@"
    do 
        if [ ! -f ${file} ]
        then
            echo "file:$file not exist!"
            continue    
        fi
        pass=$(echo $file|awk -F . '{print $(NF-1)}')
        unzip -x -P $pass $file  -d ${extract_dir}
        if [ $? -ne 0 ];then echo "unzip ${file} fail!!";fi
        #echo "file:${file}  === pass:${pass}"
    done
    
    IFS=$old_ifs

    return 0
}

func_unzip_for_honeypdf_with_passwd "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
