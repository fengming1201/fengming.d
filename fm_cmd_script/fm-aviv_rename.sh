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
function func_aviv_rename
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  [debug]"
        return 1
    fi
    local isdebug=no
    if [ $# -eq 1 ] && [ "x$1" = "xdebug" ]
    then
	isdebug=yes
    fi

    local delete_str_list=( "hhd800.com@*" "*-nyap2p.com*" "*~nyap2p.com*" "fun2048.com@*" "gg5.co@*" "4k2.com@*" "big2048.com@*" "rh2048.com@*" "www.freedl.org@*" "kfa33.com@*" "kcf9.com@*" "www.youiv.me-*" "www.youiv.pw_*" "www.youiv.pw-*" "www.youiv.in-*" "[88k.me]*" )

    #debug
    if [ "${isdebug}" = "yes" ]
    then
        for ter in "${delete_str_list[@]}"
	do
	    echo "debug:${ter}"
	done
    fi

    for pattern in "${delete_str_list[@]}"
    do
        new_pat=$(echo "${pattern}" | tr -d '*')
        for file in $(ls ${pattern} 2> /dev/null)
        do
            new=$(echo $file | sed "s/${new_pat}//g")
            if [ ! -w ${file} ];then
                maybeSUDO=sudo
            fi
            if [ -f "${file}" ];then
                ${maybeSUDO} mv -vi "${file}"  "${new}"
            fi
        done
    done
        
    return 0
}

func_aviv_rename "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
