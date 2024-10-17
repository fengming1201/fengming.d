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
function func_detected_system_run_in_where
{
    local tool=none
    local noMore=no
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  no_param"
        return 1
    fi
    #isn't docker container
    if [ -f /.dockerenv ];then
        echo "============= /.dockerenv ================"
        echo "   cmd: [ -f /.dockerenv ] && echo 'Running in Docker'"
        echo "result:"
        echo "Running in Docker"
        echo "=========== end /.dockerenv =============="
        noMore=yes
    fi
    #isn't windows WLS
    if grep -qEi "(Microsoft|WSL)" /proc/version || uname -r | grep -qEi "(microsoft|WSL)"; then
        echo "============= /proc/version ================"
        echo "   cmd: grep -qEi "(Microsoft|WSL)" /proc/version || uname -r | grep -qEi "(microsoft|WSL)""
        echo "result:"
        echo "Running inside WSL"
        echo "=========== end /.dockerenv =============="
        noMore=yes
    fi
    #use dmesg
    tool=dmesg
    which ${tool} > /dev/null
    if [ $? -eq 0 ] && [ ${noMore} = no ];then
        echo "=============== dmesg ===================="
        echo "   cmd: ${maybeSUDO} dmesg | grep -i 'hypervisor'"
        echo "result:"
        ${maybeSUDO} dmesg | grep -i 'hypervisor'
        echo "=========== end dmesg ===================="
    fi
    #use /usr/bin/systemd-detect-virt
    tool=systemd-detect-virt
    which ${tool} > /dev/null
    if [ $? -eq 0 ] && [ ${noMore} = no ];then
        echo "======= systemd-detect-virt =============="
        echo "   cmd: ${tool}"
        echo "result:"        
        ${tool}
        echo "======= end systemd-detect-virt =========="
    fi
    #use lscpu
    tool=lscpu
    which ${tool} > /dev/null
    if [ $? -eq 0 ] && [ ${noMore} = no ];then
        echo "=============== lscpu ===================="
        echo "   cmd: ${tool} | grep 'Hypervisor vendor'"
        echo "result:"           
        ${tool} | grep 'Hypervisor vendor'
        echo "============= end lscpu =================="
    fi
    #use dmidecode
    tool=dmidecode
    ${maybeSUDO} which ${tool} > /dev/null
    if [ $? -eq 0 ] && [ ${noMore} = no ];then
        echo "============ dmidecode ==================="
        echo "   cmd: ${maybeSUDO} dmidecode -s system-manufacturer"
        echo "result:"           
        ${maybeSUDO} dmidecode -s system-manufacturer
        echo "=========== end  dmidecode ==============="
    fi
    return 0
}

func_detected_system_run_in_where "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
