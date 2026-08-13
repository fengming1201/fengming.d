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
#根据你的服务器自行配置，http文件服务器的根目录。要求当前用户有读写此目录的权限。
http_server_root_dir=/srv/httpd_data

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
        # for bipc
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
    else
        # for fh1x and fh8626v3x
        echo "step 1:(redirect server)"
        echo "create file with follow command:"
        echo "cat <<-EOF >/mnt/mtd/system_data/flag_debug_dcm_server"
        echo "{"
        echo "    dcm_server:\"${http_server_ip}:${http_server_port}\","
        echo "    dcm_path:\"dcm/ipc/${platform}\""
        echo "}"
        echo "EOF"
        echo ""
        if [ ! -f ${http_server_root_dir}/dcm/ipc/${platform}/flag_debug_dcm_server ];then
            cat <<-EOF > ${http_server_root_dir}/dcm/ipc/${platform}/flag_debug_dcm_server
{
    dcm_server:"${http_server_ip}:${http_server_port}",
    dcm_path:"dcm/ipc/${platform}"
}
EOF
        fi
        echo "or download from http server: "
        echo "    wget http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/flag_debug_dcm_server -P /mnt/mtd/system_data/"
        echo ""
        echo "step 2:(not certified)"
        echo "touch  /mnt/mtd/flag_debug_pkg_no_sign_verify"
        echo ""
        echo "step 3:(trigger upgrade)"
        echo "ccm_cmd  upgrade8m sbull       http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
        echo "ccm_cmd  upgrade8m sbull_fast  http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
        echo "ccm_cmd  upgrade8m merge       http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
        echo "ccm_cmd  upgrade8m fast        http://${http_server_ip}:${http_server_port}/dcm/ipc/${platform}/${version}/upgrade-init.pkg"
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
#upload upgrade_pack to local httpd server
function upload_version
{
    local ret=0
    local target_dir=${http_server_root_dir}/dcm/ipc

    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "help" ]
    then
        echo "Usage: "
        echo "$FUNCNAME  [ option ]  [version]"
        echo "option: "
        echo "  -l, --list               #Display the all versions on the server"
        echo "  -a, --add    [version]   #Add a new version to the server,default"
        echo "  -d, --del    [version]   #Delete a version from the server"
        echo "  -s, --show   [version]   #Show the version information"
        echo ""
        echo "Example1: $FUNCNAME  v1.5.3.240419103253       # Find this version release location and copy it to file server"
        echo "Example2: $FUNCNAME  -l                        # Display the all versions on the server"
        echo "Example3: $FUNCNAME  -s v1.5.3.240419103253    # Display special versions on the server"
        echo "Example4: $FUNCNAME  -d v1.5.3.240419103253    # Delete a version from the server"
        echo "Example5: $FUNCNAME  -a v1.5.3.240419103253    # Add a new version to the server,"
        echo "                                                    # equivalent to : $FUNCNAME v1.5.3.240419103253"
        echo ""
        
        return 1
    fi
    # list
    if [ "$1" = "-l" ] || [ "$1" = "--list" ]
    then
        if [ ! -d "${target_dir}" ];then
            echo "ERROR:dir ${target_dir} not exist"
            return 1
        fi
        #list all version
        tree -d -L 2 ${target_dir}
        return 0
    elif [ "$1" = "-d" ] || [ "$1" = "--del" ]
    then
        if [ $# -lt 2 ];then
            echo "ERROR:not found version"
            return 1
        fi
        #get path
        local target_version=$2
        local target_dpath=""
        target_dpath=$(find "${target_dir}" -maxdepth 2 -type d -name ${target_version}  2> /dev/null)
        if [ -z $target_dpath ];then
            echo "ERROR:not found version $target_version"
            return 1
        fi
        #echo "target_dpath=$target_dpath"
        target_platform=$(dirname "$target_dpath" | xargs basename)
        if [ -d "${target_dir}/${target_platform}/${target_version}" ];then
            echo "rm -r ${target_dir}/${target_platform}/${target_version}"
            rm -r ${target_dir}/${target_platform}/${target_version}
        else
            echo "ERROR:version ${target_version} not exist"
            return 1
        fi
        echo "delete version ${target_version} done"
        return 0
    elif [ "$1" = "-s" ] || [ "$1" = "--show" ]
    then 
        if [ $# -lt 2 ];then
            echo "ERROR:not found version"
            return 1
        fi
        #get path
        local target_version=$2
        local target_dpath=""
        target_dpath=$(find "${target_dir}" -maxdepth 2 -type d -name ${target_version}  2> /dev/null)
        if [ -z $target_dpath ];then
            echo "ERROR:not found version $target_version"
            return 1
        fi
        #echo "target_dpath=$target_dpath"
        target_platform=$(dirname "$target_dpath" | xargs basename)
        echo ""
        echo "===================================================="
        func_upgrade_step_help  ${target_platform} ${target_version}
        return 0
    elif [ "$1" = "-a" ] || [ "$1" = "--add" ]
    then
        echo "equivalent to : $FUNCNAME $2"
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
            if [ -d ${target_dir}/${version} ];then 
                #delete old version 
                echo "rm -r ${target_dir}/${version}/"
                rm -r ${target_dir}/${version}
            else
                echo "mkdir -p ${target_dir}/${version}"
                mkdir -p ${target_dir}/${version}
            fi
            echo "===================================================="
            if [ x"$platform" = "xbipc_fh8852v201_aiw4211" ] || [ x"$platform" = "xbipc_fh862x_hi3861" ];then
                echo "src_dir:${sub_dir}/upload_file/${version}"
                echo "des_dir:${target_dir}/${version}"
                if [ -d ${target_dir}/${version} ];then rm -r ${target_dir}/${version};fi
                echo ">>>cp -r ${sub_dir}/${version}/*  ${target_dir}/${version}/"
                cp -r ${sub_dir}/${version}/*  ${target_dir}/${version}/
                ret=$?
            else
                echo "src_dir:${sub_dir}/"
                echo "des_dir:${target_dir}/${version}"
                if [ -d ${target_dir}/${version} ];then rm -r ${target_dir}/${version};fi
                #fh1x-v88.88.88.250707170122.ver.zip
                local target_file=${sub_dir}/${platform}-${version}.ver.zip
                if [ -f ${target_file} ];then
                    echo ">>>unzip -q $target_file -d  ${target_dir}/${version}/"
                    unzip -q $target_file -d  ${target_dir}/${version}/
                    ret=$?
                else
                    echo ""
                    ret=1
                fi
            fi
            if [ $ret -ne 0 ];then 
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

upload_version "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
