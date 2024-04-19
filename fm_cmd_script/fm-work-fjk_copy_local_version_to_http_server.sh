#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_lib=${fengming_dir}/bash_function_lib

if [ -d ${common_share_lib} ] && [ "include" = "enable" ]
then
    source ${common_share_lib}/*
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

#start here add your code,you need to implement the following function.
#file server info
http_server_ip=$(hostname -I | awk '{print$1}')
http_server_port=8080
http_server_root_dir=/opt/http_share/data

function func_upgrade_step_help 
{
    local platform=$1
    local version=$2
    if [ $# -lt 1 ]
    then
        platform="your_platform"
        version="your_version"
    fi
    echo "Upgrade steps using local server:"
    echo "step 1:(redirect server)"
    echo "      http_ota http://${http_server_ip}:${http_server_port}/flag_debug_dcm_server      /mnt/mtd/system_data/flag_debug_dcm_server 0"
    echo "      http_ota http://${http_server_ip}:${http_server_port}/flag_debug_dcm_server.md5  /mnt/mtd/system_data/flag_debug_dcm_server.md5 0"
    echo ""
    echo "step 2:(not certified)"
    echo "      touch  /mnt/mtd/flag_debug_pkg_no_sign_verify"
    echo ""
    echo "step 3:(trigger upgrade)"
    echo "      ipcctl_cmd_upgrade_ver http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
    echo ""
    return 0
}
function func_copy_local_version_to_http_server
{
    local ret=0

    if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  version"
        echo "$scriptname  v1.5.3.240419103253"
        return 1
    fi
    #parameter check
    local version=$1

    #location : where you are?
    local current_path=${PWD}
    local search_dir=${current_path}
    local absolute_path=${current_path}
    local dir_level=$(echo ${current_path} | tr -cd '/' | wc -c)
    local found_dir=""
    for dir in $(seq 1 "${dir_level}")
    do
        search_dir="${current_path}/$(printf "../%.0s" $(seq 1 ${dir}))"
        absolute_path=$(realpath ${search_dir})

        found_dir=$(find ${absolute_path} -type d -iname ${version})
        if [ "x${found_dir}" != "x" ];then break;fi
    done
    
    if [ "x${found_dir}" = "x" ];then return 2;fi
   
    pushd ${absolute_path}
    for sub_dir in ${found_dir}
    do
        if [ -d ${sub_dir}/upload_file/${version} ]
        then
            #get platform
            local platform=$(realpath ${sub_dir}/../ | xargs basename)
            local target_dir=${http_server_root_dir}/dcm/ipc/${platform}

            if [ ! -w ${http_server_root_dir}/dcm/ipc ];then
                maybeSUDO=sudo
            fi

            if [ -d ${target_dir}/${version} ];
            then 
                ${maybeSUDO} rm -r ${target_dir}/${version}/*
            else
                ${maybeSUDO} mkdir -p ${target_dir}/${version}
            fi
            ${maybeSUDO} cp -r ${sub_dir}/upload_file/${version}/*  ${target_dir}/${version}/
            if [ $? -ne 0 ]
            then 
                echo "copy fail..."
                ret=3
            else
                echo "copy done !!"
                echo "===================================================="
                echo "src_dir:${sub_dir}/upload_file/${version}"
                echo "des_dir:${target_dir}/${version}"
                tree -sfh ${target_dir}/${version}
                echo ""
                echo "===================================================="
                func_upgrade_step_help  ${platform} ${version}
            fi
            break
        fi
    done
    popd
    
    return ${ret}
}

func_copy_local_version_to_http_server "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
