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
if [ $(id -u) -ne 0 ] && [ lshm != lshm ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_apt_dpkg_help
{
    echo ""
    echo "apt（Advanced Package Tool）是一个高级包管理工具，用于从软件源安装、更新和管理软件包。它自动处理依赖关系，并提供了更友好的用户界面。"
    echo "1,更新软件包列表："
    echo "sudo apt update"
    echo ""
    echo "2,升级已安装的软件包："
    echo "sudo apt upgrade"
    echo ""
    echo "3,升级系统（包括内核）："
    echo "sudo apt full-upgrade"
    echo ""
    echo "4,安装软件包："
    echo "sudo apt install <package_name>"
    echo ""
    echo "5,卸载软件包："
    echo "sudo apt remove <package_name>"
    echo ""
    echo "6,完全卸载软件包："
    echo "sudo apt purge <package_name>"
    echo ""
    echo "7,搜索软件包："
    echo "apt search <keyword>"
    echo ""
    echo "8,查看软件包信息："
    echo "apt show <package_name>"
    echo ""
    echo "9,清理缓存："
    echo "sudo apt clean"
    echo ""
    echo "10,自动移除不需要的依赖："
    echo "sudo apt autoremove"
    echo "==========================================================="
    echo "dpkg 是 Debian 系统的底层包管理工具，用于直接操作 .deb 软件包文件。它不处理依赖关系，通常用于安装本地软件包或查询已安装的软件包。"
    echo ""
    echo "1,安装本地 .deb 文件："
    echo "sudo dpkg -i <package_file.deb>"
    echo ""
    echo "2,卸载软件包："
    echo "sudo dpkg -r <package_name>"
    echo ""
    echo "3,完全卸载软件包："
    echo "sudo dpkg -P <package_name>"
    echo ""
    echo "4,列出已安装的软件包："
    echo "dpkg -l"
    echo ""
    echo "5,查看软件包状态："
    echo "dpkg -s <package_name>"
    echo ""
    echo "6,列出软件包中的文件："
    echo "dpkg -L <package_name>"
    echo ""
    echo "7,查找文件所属的软件包："
    echo "dpkg -S <file_path>"
    echo ""
    echo "8,修复依赖问题："
    echo "sudo dpkg --configure -a"
    echo ""
    return 0
}

func_apt_dpkg_help "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
