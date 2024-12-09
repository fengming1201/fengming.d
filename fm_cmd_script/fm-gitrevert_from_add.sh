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
        echo ""
        echo "$scriptname  file_list    --撤销单个文件的添加,并将它们从暂存区移回工作目录"
        echo "$scriptname  all          --撤销所有文件的添加,并将它们从暂存区移回工作目录"
        echo ""
        echo "$scriptname  checkout     --撤销对文件的修改： 如果你对文件进行了修改，并且想要撤销这些修改（但保留文件在上次提交时的状态）"
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
    local file_list="$@"

    if [ "x$1" = "xall" ] && [ $# -eq 1 ];then
        #撤销所有文件的添加,并将它们从暂存区移回工作目录
        echo " ${maybeSUDO} git reset HEAD ."
        echo ""
        ${maybeSUDO} git reset HEAD .
    elif [ "x$1" = "xcheckout" ] && [ $# -gt 1 ];then
        #撤销对文件的修改： 如果你对文件进行了修改，并且想要撤销这些修改（但保留文件在上次提交时的状态）
        shift 1
        ${maybeSUDO} git checkout -- "$@"
    else
        #撤销单个文件的添加,并将它们从暂存区移回工作目录
        echo "${maybeSUDO} git reset HEAD ${file_list}"
        echo ""
        ${maybeSUDO} git reset HEAD ${file_list}
    fi

    return 0
}

func_gitrevert "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
