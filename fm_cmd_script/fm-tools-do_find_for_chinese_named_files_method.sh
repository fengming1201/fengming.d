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
function func_find_for_chinese_named_files
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "查找中文开头的文件名: "
        echo "            ls | grep -P \"^\\p{Han}\""
        echo "find . -type f | grep -P '^[\\x{4e00}-\\x{9fff}]'"
        echo ""
        echo ""
        echo "查找有中文的文件名:"
        echo "            ls | grep -P \"\\p{Han}\""
        echo "find . -type f | grep -P '[\\x{4e00}-\\x{9fff}]'"
        echo ""
        return 1
    fi

    return 0
}

func_find_for_chinese_named_files "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
