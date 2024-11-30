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
function func_add_domestic_site_to_sources_list
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ];then
        echo "$scriptname  param_list"
        return 1
    fi
    local  source_list_file=/etc/apt/sources.list
    
    #check and backup 
    if [ ! -f ${source_list_file}.org ];then
        ${maybeSUDO} cp -v ${source_list_file} ${source_list_file}.org
    fi

    #add source
    local debian_name=$(grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME=//') && \
    ${maybeSUDO} tee ${source_list_file} <<EOF
# 阿里云
deb http://mirrors.aliyun.com/debian/ ${debian_name} main contrib non-free
deb http://mirrors.aliyun.com/debian/ ${debian_name}-updates main contrib non-free
deb http://mirrors.aliyun.com/debian-security/ ${debian_name}-security main contrib non-free

# 中科大
deb http://mirrors.ustc.edu.cn/debian/ ${debian_name} main contrib non-free
deb http://mirrors.ustc.edu.cn/debian/ ${debian_name}-updates main contrib non-free
deb http://mirrors.ustc.edu.cn/debian-security/ ${debian_name}-security main contrib non-free

# 163
deb http://mirrors.163.com/debian/ ${debian_name} main contrib non-free
deb http://mirrors.163.com/debian/ ${debian_name}-updates main contrib non-free
deb http://mirrors.163.com/debian-security/ ${debian_name}-security main contrib non-free
EOF
    cat ${source_list_file}
    return 0
}

func_add_domestic_site_to_sources_list "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
