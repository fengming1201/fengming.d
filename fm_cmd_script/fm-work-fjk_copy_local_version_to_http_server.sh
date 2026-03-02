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
    echo "描述:"
    echo "为方便进行‘本地在线升级’，拷贝升级所需文件到本地http服务器。该脚本可以在任意路径下执行。"
    echo "本脚唯一参数是版本号，脚本会根据所给的‘版本号’，自动从当前目录逐级向上查找到该版本号的路径。"
    echo "然后拷贝该本版的升级文件到http服务器相应目录。"
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
#根据你的服务器自行配置，端口号
http_server_port=8080
#根据你的服务器自行配置，http文件服务器的根目录。
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
    if [ x"$platform" = "xbipc_fh8852v201_aiw4211" ] || [ x"$platform" = "xbipc_fh862x_hi3861" ];then 
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
    elif [ x"$platform" = "xfh1x" ] || [ x"$platform" = "xfh8626v3x" ];then
        echo "step 1:(redirect server)"
        echo "      create file:/mnt/mtd/system_data/flag_debug_dcm_server"
        echo "      {"
        echo "         dcm_server:"${http_server_ip}:${http_server_port}","
        echo "         dcm_path:"dcm/ipc/$platform""
        echo "      }"
        echo ""
        echo "step 2:(not certified)"
        echo "      touch  /mnt/mtd/flag_debug_pkg_no_sign_verify"
        echo ""
        echo "step 3:(trigger upgrade)"
        echo "      upgrade8m sbull       http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
        echo "      upgrade8m sbull_fast  http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
        echo "      upgrade8m merge       http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
        echo "      upgrade8m fast        http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
        echo ""
        echo "UPGRADE_STATE: 1 create_virtual_mtd"
        echo "UPGRADE_STATE: 2 test_virtual_mtd"
        echo "UPGRADE_STATE: 3 upgrade_mtd"
        echo "UPGRADE_STATE: 4 test_mtd"
        echo "UPGRADE_STATE: 5 fix_ver"
        echo "UPGRADE_STATE: 6 sd_ver_customize"
        echo "UPGRADE_STATE: 7 run_from"
        echo ""
    fi

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
    echo ">>>searching ..."
    for dir in $(seq 1 "${dir_level}")
    do
        absolute_path=$(realpath ${search_dir})
        echo ">>>find ${absolute_path} -type d -path \"*${version}/upload_file\" -o -path \"*${version}/development/version_upload\" 2>/dev/null"
        found_dir=$(find ${absolute_path} -type d -path "*${version}/upload_file" -o -path "*${version}/development/version_upload" 2>/dev/null)
        if [ "x${found_dir}" != "x" ];then echo ">>>found it !!";tree -sh ${found_dir};break;fi
        #go to previous level directory
        search_dir="${current_path}/$(printf "../%.0s" $(seq 1 ${dir}))"
    done
    
    if [ "x${found_dir}" = "x" ];then return 2;fi
    echo ">>>jump dir:"
    pushd ${absolute_path}
    for sub_dir in ${found_dir}
    do
        echo "sub_dir=$sub_dir"
        if [ -d ${sub_dir}/${version} ] || [ -f ${sub_dir}/upgrade-init.pkg ]
        then
            #get platform
            local publish_path=$(echo "$sub_dir" | sed "s|\(.*$version\).*|\1|")
            local platform=$(realpath ${publish_path}/../ | xargs basename)
            local target_dir=${http_server_root_dir}/dcm/ipc/${platform}
            echo "publish_path=$publish_path"
            echo "platform=$platform"
            echo "target_dir=$target_dir"
            if [ ! -w ${http_server_root_dir}/dcm/ipc ];then
                maybeSUDO=sudo
            fi
            if [ -d ${target_dir}/${version} ];then 
                echo "${maybeSUDO} rm -r ${target_dir}/${version}/*"
                ${maybeSUDO} rm -r ${target_dir}/${version}/*
            else
                echo "${maybeSUDO} mkdir -p ${target_dir}/${version}"
                ${maybeSUDO} mkdir -p ${target_dir}/${version}
            fi
            echo "===================================================="
            if [ x"$platform" = "xbipc_fh8852v201_aiw4211" ] || [ x"$platform" = "xbipc_fh862x_hi3861" ];then
                echo "src_dir:${sub_dir}/upload_file/${version}"
                echo "des_dir:${target_dir}/${version}"
                if [ -d ${target_dir}/${version} ];then rm -r ${target_dir}/${version};fi
                echo ">>>${maybeSUDO} cp -r ${sub_dir}/${version}/*  ${target_dir}/${version}/"
                ${maybeSUDO} cp -r ${sub_dir}/${version}/*  ${target_dir}/${version}/
                ret=$?
            elif [ x"$platform" = "xfh1x" ] || [ x"$platform" = "xfh8626v3x" ];then
                echo "src_dir:${sub_dir}/"
                echo "des_dir:${target_dir}/${version}"
                if [ -d ${target_dir}/${version} ];then rm -r ${target_dir}/${version};fi
                #fh1x-v88.88.88.250707170122.ver.zip
                local target_file=${sub_dir}/${platform}-${version}.ver.zip
                if [ -f ${target_file} ];then
                    echo ">>>${maybeSUDO} unzip -q $target_file -d  ${target_dir}/${version}/"
                    ${maybeSUDO} unzip -q $target_file -d  ${target_dir}/${version}/
                    ret=$?
                else
                    echo ""
                    ret=1
                fi
            fi
            if [ $ret -ne 0 ]
            then 
                echo ">>>copy fail..."
                ret=3
            else
                echo ">>>copy done !!"
                
                #tree -sfh ${target_dir}/${version}
                echo ""
                echo "===================================================="
                func_upgrade_step_help  ${platform} ${version}
            fi
            break
        fi
    done
    echo ">>>jump back !!"
    popd
    
    return ${ret}
}

func_copy_local_version_to_http_server "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
