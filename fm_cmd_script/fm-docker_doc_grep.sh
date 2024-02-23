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
if [ "$1" = "info" ];then
    echo "abstract:"
    echo ""
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
function func_sub_docker_grep
{
    local doc_file_path=${fengming_dir}/documents/sub_doc_docker
	
	#check para
	if [ $# -lt 1 ]
	then
		echo "e.g $scriptname  keyword"
		return 1
	fi
	echo "grep --color=auto -rn $* ${doc_file_path}"
	grep --color=auto -rn "$*" ${doc_file_path}

    return 0
}

func_sub_docker_grep "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
