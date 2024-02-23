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
function func_parse_file_format
{
    #check paramter
    if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:解析常见的文件格式，即标记各个域的名称。"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  filepath"
        echo "         ${scriptname}  /etc/fstab"
        return 1
    fi

    #check file exist
    if [ ! -f $1 ];then echo "file:$1 not exist";return 1;fi

    local filename=$(basename $1)
    #check support list
    if [ ${filename} = "fstab" ]
    then
        echo "$1"
    elif [ ${filename} = "passwd" ]
    then
        echo "$1"
    elif [ ${filename} = "shadow" ]
    then
        echo "$1"
    elif [ ${filename} = "group" ]
    then
        echo "$1"
    elif [ ${filename} = "crontab" ]
    then
        echo "$1"
    else
        echo "no support parse this file format"
    fi


    return 0
}

func_parse_file_format $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_parse_file_format() fail:${ret}"
    exit 1
fi
exit 0
