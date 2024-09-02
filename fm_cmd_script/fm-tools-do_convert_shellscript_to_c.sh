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
    echo "(1) gzexe命令使用gzip算法压缩shell脚本并创建自解压缩副本，无参数时默认压缩，使用-d参数可解压缩。"
    echo "(2) shc命令用于编译和加密脚本，参数包括指定输出路径、动态链接库路径、启用代码段压缩等。"
    echo "shc（Shell Script Compiler）是一款用来将 Shell 脚本转换为二进制可执行文件的工具。"
    echo "通过将脚本编译成二进制文件，shc 可以有效地隐藏脚本的源代码，从而提供一定程度的保护。"
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
function func_convert_shell2_c
{
    local tool1=gzexe
    local tool2=shc
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "Usage:"
        echo "$scriptname [-e date] [-m addr] [-i iopt] [-x cmnd] [-l lopt] [-o outfile] [-rvDSUHCABh] -f script"
        echo "-e %s  Expiration date in dd/mm/yyyy format [none]"
        return 1
    fi

    which ${tool1} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "ERROR:${tool} not exist!"
        echo "please install it first,sudo apt install ${tool}"
        echo ""
        return 2
    fi


    return 0
}

func_convert_shell2_c "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
