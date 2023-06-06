#!/bin/bash

#check param 
if [ $# -lt 1] || [ $# -gt 1]
then
    echo "parameter error!!"
    echo "$0  -h or --help"
    return 1
fi

if [ $1 = "-h" ] || [ $1 = "--help" ]
then 
    echo "DESCRIPTION:按不同等级安装基础软件"
    echo "SYNOPSIS:"
    echo "         $0  level  //level=1 2 3 or all"
    echo "         $0  show  //show level like tree"
    return 1
fi

install_level=$1
base_software_list_file=${${fengming_top_dir}}/sorftware_install/base_software_list.json
read_json_tool=jq
install_log=$(mktemp --suffix=base_sorfware_install.log)

function base_tool_list_get_from_json
{



}

funtion install_tools
{
    echo "[name:$]"
    sudo -v |\
    apt install "$*"  tee -a ${install_log}

}

#check tool
which ${read_json_tool} /dev/null
if [ $? -ne 0 ]
then 
    echo "ERROR:${read_json_tool} not found,must install it first"
fi



