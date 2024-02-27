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
    local help_root_dir=${fengming_dir}/documents/sub_doc_dm-crypt-LUKS/luks_subcmd_help

    #check paramter
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        tree -L 1 ${help_root_dir}
        echo ""
        echo "DESCRIPTION:"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  suffix  //后缀"
		echo "e.g.:    ${scriptname}   add"
        echo "e.g.:    ${scriptname}   uuid"
        echo ""
        return 1
    fi
    local arg_list=$@
    local dir_list="none"
    local file_list="none"
    local file_array=()
    local file_list_size=0
    local num=1
    for one_arg in ${arg_list}
    do
        #[optional] check sub dir first
        #dir_list=$(find ${help_root_dir} -type d -iname "*${one_arg}*")
        #if [ "x${dir_list}" != x ]
        #then
        #    for one_dir in ${dir_list}
        #    do
        #        if [ -d ${one_dir} ];then
        #            tree -sh ${one_dir}
        #        fi
        #    done
        #    continue
        #fi

        #check file
        file_list=${help_root_dir}/${one_arg}
        if [ ! -f ${file_list} ]
        then
            file_list=$(find ${help_root_dir} -type f -iname "cryptsetup-*${one_arg}")  #后缀
        fi        
        if [ "x${file_list}" = x ]
        then 
            echo "no found help file with prefix ${one_arg}"
            local maybe_file=$(find ${help_root_dir} -type f -iname "*${one_arg}*")
            if [ "x${maybe_file}" != x ]
            then
                echo "maybe you looking for: "
                echo "${maybe_file}"
            fi
            return 2
        fi
        readarray -t file_array <<< "${file_list}"
        file_list_size=${#file_array[@]}
        
        local sub_num=1
        for file_each in ${file_list}
        do
            echo "start[$sub_num/$file_list_size] ..."
            echo ""
            cat ${file_each}
            echo ""
            echo "end[$sub_num/$file_list_size] file:${file_each}"
            sub_num=$(expr $sub_num + 1)
            echo "-----------------------------------------------------------"
        done
        echo "[$num]=====================================================[$num]"
        num=$(expr $num + 1)
        sub_num=1
        for file_each in ${file_list}
        do 
            echo "file[$sub_num/$file_list_size]: ${file_each}"
            sub_num=$(expr $sub_num + 1)
        done
        echo ""
    done	
    return 0
}

func_ "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
