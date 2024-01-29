#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
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
if [ "$1" = "info" ];then
    echo "abstract:CN:在Linux中提供了 tmpfs 和 ramfs 两种内存文件系统用于创建内存磁盘"
    echo "#1 使用 tmpfs 创建内存磁盘，创建的内存磁盘并不百分百保证是存储在RAM芯片上。"
    echo "mount -t tmpfs -o size=1G tmpfs /mnt"
    echo ""
    echo "#2 使用 ramfs 创建内存磁盘，创建的内存磁盘百分百存储在实际内存上。"
    echo "mount -t ramfs -o size=1G ramfs /mnt"
    echo ""
    echo "more detail info in <tmpfs_ramfs_fs_build_on_memory.txt>"
    func_location
    exit 0
fi
if [ "$1" = "show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_create_ramfs_tmpfs_on_memory
{
    if [ $# -ne 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "${scriptname}  type      size[kMG]  mount_point"
        echo "${scriptname}  1/ramfs  [1-9][kMG]  /mnt"
        echo "${scriptname}  2/tmpfs  [1-9][kMG]  /mnt"
        echo "${scriptname}  ramfs     1G         /mnt"
        echo "${scriptname}  1         1G         /mnt"
        echo ""
        return 1;
    fi
    #check mount point
    if [ ! -d $3 ];then
        echo "$3 mount point not exist!!"
        return 2
    fi
    which mountpoint > /dev/null
    if [ $? -eq 0 ]
    then
        mountpoint -q $3
        if [ $? -eq 0 ];then
            echo "$3 is already mounted!"
            return 3
        fi
    fi
 
    if [ $1 -eq 1 ] || [ "$1" = "ramfs" ]
    then
        ${maybeSUDO} mount -t ramfs -o size=$2 ramfs $3
        if [ $? -eq 0 ];then
            mount -l | grep ramfs | grep "$3"
        fi
    elif [ $1 -eq 2 ] || [ "$1" = "tmpfs" ]
    then
        ${maybeSUDO} mount -t tmpfs -o size=$2 tmpfs $3
        if [ $? -eq 0 ];then
            mount -l | grep tmpfs | grep "$3"
        fi        
    else
        echo "Unknow Type!!"
        return 2
    fi

    return 0
}

func_create_ramfs_tmpfs_on_memory "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
