#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_get_GPU_info
{
    echo "COMMOM  ======================"
    local app=lspci
    which ${app} > /dev/null
    if [ $? -eq 0 ]
    then
        echo "${app} | grep -i vga"
        ${app} | grep -i vga
    else 
        echo "ERROR:${app} not found!,please install it first"
        echo "apt install  pciutils"
    fi
    #NVIDIA GPU
    echo ""
    echo "NVIDIA GPU ==================="
    app=nvidia-smi
    which ${app} > /dev/null
    if [ $? -eq 0 ]
    then
        echo "${app}"
        ${app}
    else 
        echo "ERROR:${app} not found!,please install it first"
        echo "apt install  nvidia-driver-<version>"
        echo "apt install  nvidia-driver-460"
    fi
    #AMD GPU
    echo ""
    echo "AMD GPU ======================"
    app=rocm-smi
    which ${app} > /dev/null
    if [ $? -eq 0 ]
    then
        echo "${app}"
        ${app}
    else 
        echo "ERROR:${app} not found!,please install it first"
        echo "visit:https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html"
    fi
    return 0
}

func_get_GPU_info $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
