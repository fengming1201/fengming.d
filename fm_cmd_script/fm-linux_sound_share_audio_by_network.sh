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
function func_audio_share_by_network
{
    #[optional]
    #local need_help=no
    #if [ "$1" != "1" ] && [ "$1" != "2" ] && [ "$1" != "param1" ] && [ "$1" != "param2" ];then need_help=yes;fi
    #if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ ${need_help} = "yes" ]
    #local tool=as-cmd
    local tool=audio_share
    local opt="-b"
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  [Server-IP]  [Server-Port]"
        echo "$scriptname  #no parameter means use default param: localhost  65530"
        echo "e.g. $scriptname  192.168.1.100 65531"
        return 1
    fi
    which ${tool}  2>&1 /dev/NULL
    if [ $? -ne 0 ];then
        echo "ERROR:tool: ${} not exist!"
        return 2
    fi
    local ip=localhost
    local port=65530
    
    if [ $# -gt 2 ]
    then

    elif []
    then

    fi

    ${tool} ${opt}  ${ip}:${port}

    return 0
}

func_audio_share_by_network "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
