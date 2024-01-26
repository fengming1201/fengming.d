#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_upload_files_to_fileserver
{
	if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "paramter wrong!"
		echo "$scriptname  file1 file2 fileN ...  remote_dir"
		echo "$scriptname  file1 file2   /root/Pictures"
		return 1
	fi

	local file_list
    local target_dir
	#check file stat
	for file in "$@"
	do
		if [ ! -f ${file} ]
		then 
			echo "WARNING:<${file}> not found,ignore it"
		else
			file_list+=("${file}")
		fi
        target_dir=${file}
	done

	if [ ${#file_list[@]} -ge 1 ]
	then
        local ip="none"
        local port="22"
        local username="none"
        read -p "remote server IP:"  ip
        if [ "x${ip}" = x ];then echo "remote server IP cannot be empty!";return 2;fi
        read -p "remote server PORT:[22]:"  port
        if [ "x${port}" = x ];then port=22;fi

        read -p "username:[root]" username
        if [ "x${username}" = x ];then username=root;fi

		echo "scp -P ${port}  ${file_list[@]}   ${username}@${ip}:${target_dir}"
		#scp -P ${port}  ${file_list[@]}   ${username}@${ip}:${target_dir}
	fi
	echo "all done ..."
	return 0	
}

func_upload_files_to_fileserver $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
