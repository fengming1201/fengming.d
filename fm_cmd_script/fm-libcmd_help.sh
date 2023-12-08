#!/bin/bash

scriptfilename=$0

function func_libcmd_help
{
	local lib_top_path=${fengming_documents_dir}/sub_doc_c_library
	if [ $# -lt 1 ];then tree ${lib_top_path};return 0;fi
	if [ $1 = "-h" ] || [ $1 = "--help" ]
	then
		echo "SYNOPSIS:"
		echo "         ${scriptfilename}  cmd_suffix"
		echo "example:"
		echo "        ${scriptfilename}  nm"
		return 1
	fi
	local parameter=$@
	local txt_file="none"
	for file in ${parameter}
	do
		if [ -f ${lib_top_path}/${file} ]
		then
				echo "start >>>"
				cat ${lib_top_path}/${file}
				echo "end <<<"
				echo "file:${lib_top_path}/${file}"
				return 0
		fi
		#check text file
		txt_file=$(find ${lib_top_path} -type f -iname "clibrary_${file}*" -o -type l -iname "clibrary_${file}*")
		if [ "x${txt_file}" != x ]
		then
			for file_each in ${txt_file}
			do
				echo "start >>>"
				cat ${file_each}
				echo "end <<<"
				echo "file:${file_each}"
			done
		fi
	done
	return 0
}
func_libcmd_help $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
