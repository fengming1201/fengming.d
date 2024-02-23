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
function func_upload_files_to_fileserver_tar_my
{
	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "paramter wrong!"
		echo "$scriptname  file1 file2 fileN ..."
		echo "$scriptname  file1 file2"
		return 1
	fi

	local file_list
    local target_dir=/root/http_share/data/
	#check file stat
	for file in "$@"
	do
		if [ ! -f ${file} ]
		then 
			echo "WARNING:<${file}> not found,ignore it"
		else
			file_list+=("${file}")
		fi
	done
    local ip="139.9.186.120"
    local port="1201"
    local username="root"
	if [ ${#file_list[@]} -ge 1 ]
	then
		echo "tar -zcf - ${file_list[@]} | ssh -p ${port} ${username}@${ip} tar zxf - -C ${target_dir}"
		tar -zcf - ${file_list[@]} | ssh -p ${port} ${username}@${ip} tar zxf - -C ${target_dir}
		#scp -P ${port}  ${file_list[@]}   ${username}@${fileserver_ip}:${target_path}
	fi
	echo "all done ..."
	return 0
}

func_upload_files_to_fileserver_tar_my "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
