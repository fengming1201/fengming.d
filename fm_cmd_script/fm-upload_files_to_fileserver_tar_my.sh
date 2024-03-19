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
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
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

function func_upload_files_to_fileserver_tar_my
{
	local target_dir_list=(Andriod_Apk  docker-compose.yml  Docker_Hub_Webpage  Release_DebianX_Runtime_Image  software_exe  software_package  source_packages  unclassified)
	local target_dir_list_size=${#target_dir_list[@]}
	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "$scriptname  file_list   [target_dir num]"
		echo "$scriptname  file_list     "
		echo "$scriptname  file_list   1 "
		echo "$scriptname  file_list   8 "
		echo ""
		echo "target_dir list:"
		local index=1
		for str in ${target_dir_list[*]}
		do
			echo "                ${index} -- ${str}/"
			index=$(expr $index + 1)
		done
		echo ""
		return 1
	fi
    local num_args=$#  # 获取参数个数
    local last_arg="${!num_args}"  # 获取最后一个参数
	local file_list
    local target_dir=/root/http_share/data
	#check file stat
	for file in "$@"
	do
		if [ ! -f ${file} ]
		then
			echo "WARNING:file:${file} not found,ignore it"
			if [ "${1}" -eq "${1}" ] 2>/dev/null; then
				echo "the first parameter should not be a number"
				retrun 2	
			fi
		else
			file_list+=("${file}")
		fi
	done
	if [ "${last_arg}" -eq "${last_arg}" ] 2>/dev/null; then
		if [ ${last_arg} -le ${target_dir_list_size} ];then
			target_dir=/root/http_share/data/${target_dir_list[$(expr ${last_arg} - 1)]}
		fi
	else
	    target_dir=${target_dir}/unclassified
		echo "Note: the target directory is:${target_dir}"

	fi

    local ip="139.9.186.120"
    local port="1201"
    local username="root"
	if [ ${#file_list[@]} -ge 1 ]
	then
		echo " file_list:${file_list[@]}"
		echo "target_dir:${target_dir}"
		echo ""
		echo "tar -zcf - ${file_list[@]} | ssh -p ${port} ${username}@${ip} tar zxf - -C ${target_dir}"
		tar -zcf - ${file_list[@]} | ssh -p ${port} ${username}@${ip} tar zxf - -C ${target_dir}
		#scp -P ${port}  ${file_list[@]}   ${username}@${fileserver_ip}:${target_path}
	else
		echo "file list is empty,abort upload!!"
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
