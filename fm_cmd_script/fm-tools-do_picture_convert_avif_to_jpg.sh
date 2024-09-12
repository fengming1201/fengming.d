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
function func_convert_avif_to_jpg
{
    local tool=convert
    local default_opt=
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  input.avif  list"
        echo "$scriptname  input.avif             #default output:  'input.avif.jpg'"
        echo "$scriptname  1.avif  2.avif ...     #outout: 1.avif.jpg  2.avif.jpg"
        echo "" 
        return 1
    fi

    which ${tool} > /dev/null
    if [ $? -ne 0 ]
    then 
        echo "ERROR:${tool} not exit! please install it first!"
        echo "apt install imagemagick"
        echo ""
        return 2
    fi
    
	local input_list=()
	for file in "$@"
	do
		if [ -f "${file}" ]
		then 
			input_list+=("${file}")
		else
			echo "file:${file} not exist!"
		fi
	done
	if [ ${#input_list[@]} -eq 0 ];then echo "input_list is empty!";return 3;fi


    for vfile in "${input_list[@]}"
    do
        echo "${tool} ${default_opt} ${vfile} ---> ${vfile}.jpg"   
        ${tool} ${default_opt}  "${vfile}"  "${vfile}.jpg"  
    done

    return 0
}

func_convert_avif_to_jpg "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
