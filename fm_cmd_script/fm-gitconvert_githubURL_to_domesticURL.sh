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
if [ $(ls -ld . | awk '{print$3}') != $(whoami) ];then
    maybeSUDO=sudo
fi
function func_convert_githubURL_to_domesticURL
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "CN:github 加速,替换为gitclone"
        echo "$scriptname   org_github_url"
        echo "$scriptname   https://github.com/apache/nuttx.git"
        echo "                                         -->https://gitclone.com/github.com/apache/nuttx.git"
        return 1
    fi
    local org_url="$1"
    local islagal=$(echo "${org_url}" | grep "https://github.com/")
    if [ "x${islagal}" = "x" ];then echo "not match github url";return 2;fi

    echo "${org_url}" | sed  's/https:\/\/github.com/https:\/\/gitclone.com\/github.com/g'
    return 0
}

func_convert_githubURL_to_domesticURL $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
