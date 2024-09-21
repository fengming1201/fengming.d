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
    echo "从目标文件中读取每行并当作命令执行"
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
function func_how_to_do
{ 
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname  target_file"
        echo ""
        return 1
    fi

    local todo=$1
    local todo_log=$1.log
    if [ ! -f ${todo} ]
    then
        echo "file:${todo} not exist!!"
        return 2
    fi

    shellcheck ${todo}  > /dev/null
    local ret=$?
    if [ $ret -gt 1 ]
    then
        echo "shellcheck ${todo} return $ret"
        return 3
    fi

    old_ifs=$IFS
    IFS=$'\n'
    for action in $(cat ${todo})
    do
        eval ${action}
        ret=$?
        if [ ${ret} -eq 0 ];then
            echo "[  OK] -- ${action}" | tee -a ${todo_log}
        else
            echo "[FAIL] -- ${action}" | tee -a ${todo_log}
        fi
    done
    IFS=${old_ifs}

    return 0
}

func_how_to_do "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
