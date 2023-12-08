#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
fi
function func_rm_overwrite
{
	local app=shred
	local default_opt="-n 1 -u --random-source=/dev/urandom -v"

	#check parameter
    if [ $# -lt 1 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
    then
        echo "DESCRIPTION:安全删除文件--先用随机数覆盖文件最后再删除该文件"
        echo "SYNOPSIS:"
        echo "         ${scriptfilename}  [file or dir] list"	
        return 1
    fi

	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptfilename},${app} not exist!¨;return 1;fi;

	local total_file_num=
	local num=
	let total_file_num=0
	let num=0
	for param in "$@"
	do
		if [ -d ${param} ]
		then
			#first remove files under this dir
			let num=0
			for file in $(find ${param} -type f)
			do
				$app ${default_opt} ${file}
				let num=${num}+1
			done
			let total_file_num=${total_file_num}+${num}
			#final remove dir
			rm -rf ${param}
		else
			$app ${default_opt} ${param}
			let total_file_num=${total_file_num}+1
		fi
	done

	echo "total erase file counts:${total_file_num}"
	return 0
}
func_rm_overwrite $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
