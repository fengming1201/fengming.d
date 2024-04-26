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
#file server info
http_server_ip=$(hostname -I | awk '{print$1}')
http_server_port=8080
http_server_root_dir=/opt/http_share/data
function func_OTA_appimg_step_help 
{
    echo "===================================================="
    echo "OTA appimg using local server:"
    echo ""
    echo "http_ota http://${http_server_ip}:${http_server_port}app.img soc 1"
    echo ""
    return 0
}

function func_copy_latest_appimg_to_http_server
 { 
    local filename=app.img
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  no parameter"
        echo "auto find latest app.img and copy to http server"
        return 1
    fi
    local found_it=$(find ~/ -type f -name "${filename}"  -exec ls -lt {} + 2>/dev/null | head -n 1 | awk '{print$(NF)}')
    if [ "x${found_it}" != "x" ]
    then
        echo "found it !!"
        ls -lh ${found_it}
    else
        echo "No found it !!!"
        return 2
    fi

    if [ ! -w ${http_server_root_dir} ];then
        maybeSUDO=sudo
    fi
    ${maybeSUDO} cp -v ${found_it}  ${http_server_root_dir}
    if [ $? -ne 0 ]
    then
        echo "copy fail..."
        return 3
    else
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
