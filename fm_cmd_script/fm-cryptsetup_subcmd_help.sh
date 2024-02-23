#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_luks_sub_cmd_help
{
    local cmd_help_path=${fengming_dir}/documents/sub_doc_dm-crypt-LUKS/luks_subcmd_help

    if [ $# -lt 1 ];then tree -L 1 ${cmd_help_path};return 0;fi
	if [ $# -gt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "parameter wrong!"
        echo ""
		echo "$scriptname cmd_suffix"
		echo "e.g.:$scriptname  add"
        echo "e.g.:$scriptname  uuid"
        echo ""
        echo "special opt:$scriptname  all"
		return 1
	fi
    if [ "$1" = "all" ] || [ "$1" = "--all" ]
    then
        tree -sfh ${fengming_dir}/documents/sub_doc_dm-crypt-LUKS
        return 0
    fi
	if [ -f ${cmd_help_path}/${1} ]
	then
			echo "start >>>"
			cat ${cmd_help_path}/${1}
			echo "end <<<"
			echo "file:${cmd_help_path}/${1}"
			return 0;
	fi
	local cmd_file=$(find ${cmd_help_path} -type f -iname "cryptsetup-*${1}*" -o -type l -iname "cryptsetup-*${1}*")
	if [ "x${cmd_file}" != x ]
	then
		for file_each in ${cmd_file}
		do
			echo "start >>>"
			cat ${file_each}
			echo "end <<<"
			echo "end file:${file_each}"
		done
		echo "================================================="
		for file_each in ${cmd_file}
		do 
			echo "file list:${file_each}"
		done
	fi

    return 0
}

func_luks_sub_cmd_help $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
