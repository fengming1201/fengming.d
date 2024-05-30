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
function func_find_samesize_file
{
    local result_file=~/all_same_size_file
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  param_list"
        echo "$scriptname  search_dir_list"
        echo ""
        echo "$scriptname search_dir_list  [step1 | step2 | step3]"
        echo "step1 : do read all files size and inode under search_dir_list"
        echo "step2 : sort and uniq data from step1,"
        echo "step3 : extract all samesize file together,print format to save:size inode filename"
        return 1
    fi
    
    local dir_list=()
    for dir in $@
    do
        if [ -d ${dir} ]
        then
            dir_list+=("${dir}")
        else
            if [ "${dir}" = "step1" ]
            then
                local step1=${dir}
            elif [ "${dir}" = "step2" ]
            then
                local step2=${dir}
            elif [ "${dir}" = "step3" ]
            then
                local step3=${dir}
            else
                echo "dir:${dir} not exist!"
            fi
        fi
    done
    
    local all_file_size_list=$(mktemp)
    for target_dir in "${dir_list[@]}"
    do
        ${maybeSUDO} find ${target_dir} -type f  -exec ls -il {} \; >> ${all_file_size_list}
        #${maybeSUDO} find ${target_dir} -type f -size +100M -exec ls -il {} \; >> ${all_file_size_list}
    done
    #debug step1
    if [ "x${step1}" = "xstep1" ]
    then
        cat ${all_file_size_list}
        rm ${all_file_size_list}
        return 0
    fi

    local all_file_size_sort_uniq=$(mktemp)
    cat ${all_file_size_list} | awk '{print$6}' | sort -n | uniq -d > ${all_file_size_sort_uniq}
    if [ $(stat -c%s ${all_file_size_sort_uniq}) -eq 0 ]
    then
        echo "under ${dir_list[@]} directory not have same size file"
        rm ${all_file_size_list} ${all_file_size_sort_uniq}
        return 2
    fi
    #debug step2
    if [ "x${step2}" = "xstep2" ]
    then
        cat ${all_file_size_sort_uniq}
        rm  ${all_file_size_list} ${all_file_size_sort_uniq}
        return 0
    fi
    local all_same_size_file=$(mktemp)
    for size in $(cat ${all_file_size_sort_uniq})
    do
        grep -w ${size}  ${all_file_size_list} | awk '{print$6" "$1" "$10$11$12}' >> ${all_same_size_file}
        #grep -w ${size}  ${all_file_size_list} | awk '{print$9$10}' >> ${all_same_size_file}
    done
    #debug step3 
    if [ "x${step3}" = "xstep3" ]
    then
        cat ${all_same_size_file}
        echo "size  inode  filename"
        rm  ${all_file_size_list} ${all_file_size_sort_uniq} ${all_same_size_file}
        return 0
    fi
    cat  ${all_same_size_file} > ${result_file}

    rm ${all_file_size_list} ${all_file_size_sort_uniq} ${all_same_size_file}
    return 0
}

func_find_samesize_file "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
