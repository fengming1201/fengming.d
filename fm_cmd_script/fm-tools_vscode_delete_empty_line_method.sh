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
function func_vscode_delete_all_empty_line
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "表达式：^\s*(?=\r?$)\n"
        echo "   Find:(^\s*(?=\r?$)\n   Aa ab [.*])  //在搜索框中填入表达式，并选择“正则表达式”，即 .* "
        echo "Replace:(                        AB) replace_one [replace_all] //替换框为空，并点击“替换所有” "
        echo ""
        return 1
    fi

    return 0
}

func_vscode_delete_all_empty_line "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
