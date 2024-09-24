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
    echo "自动找到最新编译出的app.img，并拷贝到http文件服务器下。"
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
#file server info
http_server_ip=$(hostname -I | awk '{print$1}')
#根据你的服务器自行配置，端口号
http_server_port=8080
#根据你的服务器自行配置，http文件服务器的根目录。
http_server_root_dir=/opt/http_share/data

function func_OTA_appimg_step_help 
{
    echo "===================================================="
    echo "OTA appimg using local server:"
    echo ""
    echo "http_ota http://${http_server_ip}:${http_server_port}/app.img soc 1"
    echo ""
    return 0
}

function func_copy_latest_appimg_to_http_server
 { 
    local filename=app.img
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname  [search_path]"
        echo "$scriptname  no parameter #default path is ~/"
        echo "auto find latest app.img and copy to http server"
        echo ""
        return 1
    fi
    #local search_path=${HOME}
    local search_path=./
    local opt="Y"
    if [ $# -lt 1 ]
    then
		read -p "search from ${search_path}? [Y/n]"  opt
		if [ "x${opt}" = "x"  ];then opt="Y";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
            echo " "
        else
            echo "usage:"
            echo "$scriptname  [search_path]"
            echo "$scriptname  no parameter #default path is $HOME"
            echo ""        
            return 0
        fi
    fi
    if [ $# -eq 1 ] && [ -d $1 ]
    then
        search_path=$1
    fi
    echo ">>>searching ..."
    echo ">>>find ${search_path} -type f -name ${filename}  -exec ls -lt {} + 2>/dev/null | head -n 1 | awk '{print\$(NF)}'"
    local found_it=$(find ${search_path} -type f -name "${filename}"  -exec ls -lt {} + 2>/dev/null | head -n 1 | awk '{print$(NF)}')
    if [ "x${found_it}" != "x" ]
    then
        echo ">>>found it !!"
        ls -lh ${found_it}
    else
        echo ">>>No found it !!!"
        return 2
    fi

    if [ ! -w ${http_server_root_dir} ];then
        maybeSUDO=sudo
    fi
    echo ">>>${maybeSUDO} cp -v ${found_it}  ${http_server_root_dir}"
    ${maybeSUDO} cp -v ${found_it}  ${http_server_root_dir}
    if [ $? -ne 0 ]
    then
        echo ">>>copy fail..."
        return 3
    else
        echo ">>>copy done !!"
        date
        func_OTA_appimg_step_help
    fi
    return 0
}

func_copy_latest_appimg_to_http_server "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
