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

function usage
{
	echo ""
	echo "$scriptname  opt  [args]"
	echo "$scriptname  check    #health checks"
	echo ""	
	echo "$scriptname  [-u username] ls  [subdir]  #list/search directory contents"
	echo ""
	echo "$scriptname  [-u username] upload  file_list  target_dir"
	echo ""
	echo "$scriptname  [-u username] download  pathto/target_file"
	echo ""
	return 0
}
function func_upload_files_to_fileserver
{
	local myfileserver_url="http://106.13.34.177:8060"
	local tool=curl
	local tool_opt="-#"
	which ${tool} > /dev/null
	if [ $? -ne 0 ];then
		echo "ERROR:"
		echo ""
		return 1
	fi
	local username=none
    while getopts "u:h" opt; do
        case $opt in
			u)
				username=$OPTARG
				;;
			h)
				usage
				return 0
				;;
			\?)
				usage
				return 0
				;;
		esac
	done
	shift $((OPTIND - 1))
	if [ $# -lt 1 ];then usage;return 2;fi
	local option=$1
	if [ "${option}" = "ls" ];then
		local subdir="$2"
		if [ ${username} != "none" ];then
			echo "${tool} ${myfileserver_url}/${subdir}?simple -u ${username}"
			echo "============================================================"
			${tool} ${myfileserver_url}/${subdir}?simple -u ${username}
		else
			echo "${tool} ${myfileserver_url}/${subdir}?simple"
			echo "============================================================"
			${tool} ${myfileserver_url}/${subdir}?simple
		fi
	elif [ "${option}" = "check" ];then
		echo "${tool} ${myfileserver_url}/__dufs__/health"
		echo "============================================================"
		${tool} ${myfileserver_url}/__dufs__/health
		echo -e "\ndone .."
	elif [ "${option}" = "upload" ];then
		if [ $# -eq 1 ];then usage;return 3;fi
		shift 1
		local file_list
		local num_args=$#
		local target_dir=${!num_args}
		for file in "$@"
		do
			if [ ! -f "${file}" ]
			then
				echo "WARNING:file:${file} not found,ignore it"
			else
				file_list+=("${file}")
			fi
		done
		for file in ${file_list[@]}
		do
			if [ ${username} != "none" ];then
				echo "${tool} ${tool_opt} -T ${file} ${myfileserver_url}/${target_dir}/ -u ${username}"
				echo "============================================================"
				${tool} ${tool_opt} -T "${file}" ${myfileserver_url}/${target_dir}/ -u ${username}
			else
				echo "${tool} ${tool_opt}  -T ${file} ${myfileserver_url}/${target_dir}/"
				echo "============================================================"
				${tool} ${tool_opt} -T "${file}" ${myfileserver_url}/${target_dir}/
			fi
		done
	elif [ "${option}" = "download" ];then
		local target_file=$2
		if [ ${username} != "none" ];then
			echo "${tool}  ${tool_opt} ${myfileserver_url}/${target_file} -O  -u ${username}"
			echo "============================================================"
			${tool}  ${tool_opt} ${myfileserver_url}/${target_file} -O  -u ${username}
		else
			echo "${tool}  ${tool_opt} ${myfileserver_url}/${target_file}  -O"
			echo "============================================================"
			${tool}  ${tool_opt} ${myfileserver_url}/${target_file}  -O
		fi
	else
		echo "ERROR:Unkown opt"
		return 3
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
