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
function func_create_iso_file
{
    local app=mkisofs

    if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "${scriptname}  param_list"
        echo "${scriptname}  src_dir   out_filename.iso"
        echo "${scriptname}  /path/to/source_directory   /path/to/output.iso"

        return 1
    fi
    which  ${app} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "${tool} not install yet,please install it first."
        echo "apt install genisoimage"
        echo ""
        return 2
    fi
    local src_dir=$1
    local out_file=$2
    if [ ! -d ${src_dir} ]
    then
        echo "error:${src_dir} not exist!"
        return 3
    fi
    if [ -f ${out_file} ]
    then
        rm ${out_file}
    fi

    ${maybeSUDO} ${app} -o ${out_file}  ${src_dir}
    
    return 0
}

func_create_iso_file "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
