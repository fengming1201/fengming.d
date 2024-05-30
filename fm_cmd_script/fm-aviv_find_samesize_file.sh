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
function func_find_maybe_samefile
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  param_list"
        echo "$scriptname  search_dir_list"
        echo ""
        return 1
    fi
    
    local dir_list=()
    for dir in $@
    do
        if [ -d ${dir} ]
        then
            dir_list+=("${dir}")
        else
            echo "dir:${dir} not exist!"
        fi
    done
    
    local all_file_size_list=$(mktemp)
    for target_dir in "${dir_list[@]}"
    do
        #${maybeSUDO} find ${target_dir} -type f  -exec ls -il {} \; >> ${all_file_size_list}
        ${maybeSUDO} find ${target_dir} -type f -size +100M -exec ls -il {} \; >> ${all_file_size_list}
    done
    
    local all_file_size_sort_uniq=$(mktemp)
    cat ${all_file_size_list} | awk '{print$6}' | sort -n | uniq -d > ${all_file_size_sort_uniq}
    if [ $(stat -c%s ${all_file_size_sort_uniq}) -eq 0 ]
    then
        echo "under ${dir_list[@]} directory not have same size file"
        rm ${all_file_size_list} ${all_file_size_sort_uniq}
        return 2
    fi

    local all_same_size_file=$(mktemp)
    for size in $(cat ${all_file_size_sort_uniq})
    do
        grep -w ${size}  ${all_file_size_list} | awk '{print$6" "$1" "$10$11$12}' >> ${all_same_size_file}
        #grep -w ${size}  ${all_file_size_list} | awk '{print$9$10}' >> ${all_same_size_file}
    done

    cat  ${all_same_size_file} > ~/all_same_size_file

    rm ${all_file_size_list} ${all_file_size_sort_uniq} ${all_same_size_file}
    return 0
}

func_find_maybe_samefile "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
