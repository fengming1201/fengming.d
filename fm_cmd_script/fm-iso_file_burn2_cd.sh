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
function func_burn_to_cd
{
    local app=wodim

    if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "${scriptname}  param_list"
        echo "${scriptname}  filename.iso   device_file"
        echo "${scriptname}  filename.iso   /dev/cdrom"

        return 1
    fi
    which  ${app} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "${tool} not install yet,please install it first."
        echo "apt install wodim"
        echo ""
        return 2
    fi
    local iso_file=$1
    local cdrom=/dev/cdrom
    if [ ! -f ${iso_file} ]
    then
        echo "error:${iso_file} not exist!"
        return 3
    fi
    if [ ! -c ${cdrom} ]
    then
        echo "error:${cdrom} device not exist!"
        return 4
    fi

    ${maybeSUDO} ${app} -v dev=${cdrom} -data ${iso_file}

    return 0
}

func_burn_to_cd "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
