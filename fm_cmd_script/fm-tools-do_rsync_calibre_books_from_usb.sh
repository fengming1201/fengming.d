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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_copy_calibre_books_from_usb
{
    local tools=rsync
    local default_opt="-av --delete --ignore-existing --quiet --info=progress2"
    local usb_mount_dir_root=/mnt
    local calibre_docker_dir_root=/opt/calibre_web

    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname  usb_mount_point  [calibre_docker_root_path]"
        echo "$scriptname  /mnt"
        echo "$scriptname  /mnt   /opt/calibre_web"
        echo ""
        return 1
    fi
    which ${tools} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "tool:${tools} not found!!"
        echo "please install it first!!"
        echo "apt install ${tools}"
        return 2
    fi
    if [ $# -eq 1 ]
    then
        usb_mount_dir_root=$1
    elif [ $# -eq 1 ]
    then
        usb_mount_dir_root=$1
        calibre_docker_dir_root=$2
    fi
    echo "usb_mount_dir_root=$usb_mount_dir_root"
    echo "calibre_docker_dir_root=$calibre_docker_dir_root"

    if [ ! -d "${usb_mount_dir_root}/Calibre Portable" ]
    then
        echo "ERROR:usb src_dir not exist:"${usb_mount_dir_root}/Calibre\\ Portable/""
        return 3
    fi

    if [ ! -d "${calibre_docker_dir_root}" ]
    then
        echo "ERROR:usb src_dir not exist:"${calibre_docker_dir_root}""
        return 4
    fi

    local usb_sub_dir_list=("Calibre Library Collect" "Calibre Library Cookbook" "Calibre Library CS" "Calibre Library Finance Law" "Calibre Library MPC" "Calibre Library MyCV" "Calibre Library SS")
    local usb_sub_dir_list_size=${#usb_sub_dir_list[@]}
    local docker_sub_dir_list=(Books_Coll  Books_Cook  Books_CS  Books_Finance_Law  Books_MPC  Books_MyCV  Books_SS)
    local docker_sub_dir_list_size=${#docker_sub_dir_list[@]}
    
    if [ ${usb_sub_dir_list_size} -ne ${docker_sub_dir_list_size} ]
    then 
        echo "ERROR: sub dir list size not eqult"
        return 5
    fi
    local list_size=$(expr ${usb_sub_dir_list_size} - 1)
    #check 
    for n in $(seq 1 ${list_size})
    do
        if [ -d "${usb_mount_dir_root}/Calibre Portable/${usb_sub_dir_list[$n]}" ] && [ -d "${calibre_docker_dir_root}/${docker_sub_dir_list[$n]}/books" ]
        then
            echo "$n:src_dir:${usb_mount_dir_root}/Calibre Portable/${usb_sub_dir_list[$n]} --> $n:des_dir:${calibre_docker_dir_root}/${docker_sub_dir_list[$n]}/books"
            ${maybeSUDO} ${tools} ${default_opt} "${usb_mount_dir_root}/Calibre Portable/${usb_sub_dir_list[$n]}/" "${calibre_docker_dir_root}/${docker_sub_dir_list[$n]}/books/"
            if [ $? -ne 0 ];then echo "ERROR: ${tools} do fail";fi
        fi
    done
    return 0
}

func_copy_calibre_books_from_usb "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
