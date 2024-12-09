#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ];then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ];then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo "在 Git 中撤销最近的一次提交，你可以使用 git reset 命令。有几种不同的方式来撤销提交。"
    echo "有几种不同的方式来撤销提交，具体取决于你是否希望保留更改或者完全丢弃更改。"
    echo ""
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
function func_gitrevert
{
    local opt=soft
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then
        echo "$scriptname  [sorft|1] [hard|2] [msg|3]"
        echo ""
        echo "$scriptname  sorft or 1    --保留更改，撤销提交。"
        echo "$scriptname  hard  or 2    --撤销更改和提交。"
        echo "$scriptname  msg   or 3    --仅更改最后一次提交的信息。"
        echo ""
        return 1
    fi
    if [ ! -d .git/ ];then
		echo "ERROR:No git repository found in current directory !!"
		return 2
	fi
    git status > /dev/null 2>&1
	if [ $? -ne 0 ];then
        maybeSUDO=sudo
    else
        maybeSUDO=
    fi
    opt=$1
    if [ "x${opt}" = "x1" ] || [ "x${opt}" = "xsorft" ];then
        echo " ${maybeSUDO} git reset --soft HEAD~1"
        echo ""
        ${maybeSUDO} git reset --soft HEAD~1
    elif [ "x${opt}" = "x2" ] || [ "x${opt}" = "xhard" ];then
        echo "${maybeSUDO} git reset --hard HEAD~1"
        echo ""
        ${maybeSUDO} git reset --hard HEAD~1
    elif [ "x${opt}" = "x3" ] || [ "x${opt}" = "xmsg" ];then
        echo "${maybeSUDO} git commit --amend"
        echo ""
        ${maybeSUDO} git commit --amend
    else
        echo "unknown opt:${opt}"
    fi

    return 0
}

func_gitrevert "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
