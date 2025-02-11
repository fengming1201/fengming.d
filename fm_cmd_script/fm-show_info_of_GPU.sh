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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_get_GPU_info
{
    # lspci
    echo "COMMOM  lspci ======================"
    local app=lspci
    which ${app} > /dev/null
    if [ $? -eq 0 ]
    then
        echo "${app} | grep -i vga"
        local gpuinfo=$(${app} | grep -i vga)
        echo ${gpuinfo}
        local idlist=$(echo ${gpuinfo} | awk '{print $1}')
        for id in ${idlist};do
            echo "${app} -v -s ${id}"
            ${app} -v -s ${id}
        done
    else 
        echo "ERROR:${app} not found!,please install it first"
        echo "apt install  pciutils"
    fi
    # lshw
    echo ""
    echo "COMMOM  lshw ==================="
    app=lshw
    which ${app} > /dev/null
    if [ $? -eq 0 ]
    then
        echo "${maybeSUDO} ${app} -C display"
        ${maybeSUDO} ${app} -C display
    else 
        echo "ERROR:${app} not found!,please install it first"
        echo "apt install lshw"
    fi
    # lshw
    echo ""
    echo "COMMOM  glxinfo ==================="
    app=glxinfo
    which ${app} > /dev/null
    if [ $? -eq 0 ]
    then
        echo "${app} | grep -i 'device\|memory'"
        ${app} | grep -i 'device\|memory'
    else 
        echo "ERROR:${app} not found!,please install it first"
        echo "apt install mesa-utils"
    fi
    # inxi
    echo ""
    echo "COMMOM  inxi ==================="
    app=inxi
    which ${app} > /dev/null
    if [ $? -eq 0 ]
    then
        echo "${app} -G"
        ${app} -G
    else 
        echo "ERROR:${app} not found!,please install it first"
        echo "apt install inxi"
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
        echo "apt install  nvidia-detect"
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
