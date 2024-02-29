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
function func_
{
	local template_file=${fengming_dir}/documents/sub_doc_systemd/template_x.service
    local target_dir=/etc/systemd/system
	local target_file=x.service

    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "${scriptname}   service_file_name"
        echo ".e.g:${scriptname}  frpc.service"
        echo ""
        return 1
    fi
    
	if [ ! -f ${template_file} ]
	then
		echo "template file:${template_file} not exist"
		return 2
	fi
	echo " "
	cat -n ${template_file}
	echo " "
	echo "path=${template_file}"

    target_file=$1
	local opt="N"
	if [ -f ${target_dir}/${target_file} ]
	then
		read -p "Overwrite Current ${target_dir}/${target_file}? [y/N]"  opt
		if [ "x${opt}" = "x" ];then opt="N";fi
		if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ]
		then
			${maybeSUDO} cp -vi ${template_file}  ${target_dir}/${target_file} 
		#fix
		else
			echo "Nothing to do!! End"
			return 0
		fi
	else
		read -p "Copy ${template_file}  to ${target_dir}/${target_file}? [Y/n]"  opt
		if [ "x${opt}" = "x" ];then opt="Y";fi
		if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ]
		then
			${maybeSUDO} cp -vi  ${template_file}  ${target_dir}/${target_file}
		#fix
		else
			echo "Nothing to do!! End"
			return 0
		fi
	fi
	if [ -f ${target_dir}/${target_file} ]
	then
		${maybeSUDO} chmod a+w ${target_dir}/${target_file}
	fi
	return 0
}

func_ "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
