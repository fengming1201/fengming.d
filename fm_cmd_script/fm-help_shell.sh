#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
#if unnecessary, please do not modify following code
extern_script_files=(${fengming_dir}/fm_cmd_script/common_share_function.sh)
if [ -f ${extern_script_files[0]} ];then
    source ${extern_script_files[0]}
fi

#if unnecessary, please do not modify following code
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo ""
    echo "info | -info | --info                                 #优先级1: 显示摘要"
    echo "show | -show | --show                                 #优先级2: 打印本脚本文件"
    func_debug_help
    echo ""
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
#if unnecessary, please do not modify following code
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi

if [ $(id -u) -ne 0 ] && [ ${USER} != $(ls -ld . | awk '{print$3}') ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
target_dir=${fengming_dir}/documents/sub_doc_shell
prefix_or_suffix=prefix
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##

function usage
{
    echo ""
    echo "$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help          # help"
    echo "-d or --debug         # print variable status"
    echo "-t or --test          # test mode, no modifications"
    #echo "--realdo             # real execution"
    echo "-A or --add  [subdir]  file  # add new help files"
    echo "-D or --del  [subdir]  file  # delete file"

    #echo "-m or --mode          # you define"
    echo "--setx or --detail    # open set -x mode"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_
{
    if [ $# -lt 1 ];then tree -FhL 1 ${target_dir};usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local setx=false
    local cmd=()
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            --setx) setx=true; shift ;; #不带参数,移动1
            --detail) setx=true; shift ;; #不带参数,移动1
            -m|--mode)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="$2"; shift 2 ;; #带参数,移动2
            -F|--file)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd_opt+=("--file $2"); shift 2 ;; #带参数,移动2
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -A|--add) cmd+=("add"); shift ;;
            -D|--del) cmd+=("delete"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        F) cmd_opt+=("--file $2"); shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        Q) cmd_opt+=("--qr=true") ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    #==================== print debug =============================#
    if [ ${debug} = true ];then
        echo "DEBUG:maybeSUDO=${maybeSUDO}"
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:mode=${mode}"
        echo "DEBUG:setx=${setx}"
        echo "DEBUG:cmd=${cmd[@]}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    local remaining_argc=${#remaining_args[@]}
    if [ ${remaining_argc} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    local new_file_dir=
    local new_file_name=
    if [ ${#cmd[@]} -ge 1 ];then
        if [ ${remaining_argc} -gt 1 ] && [ -d ${target_dir}/${remaining_args[0]} ];then
            new_file_dir=${target_dir}/${remaining_args[0]}
            new_file_name=${remaining_args[1]}
        else
            new_file_dir=${target_dir}
            new_file_name=${remaining_args[0]}
        fi
    fi
    if [ "${cmd[0]}" = "add" ];then
        if [ -f ${new_file_dir}/${new_file_name} ];then
            read -p "WARN: file ${filename} already exists!!, do you want to oveewrite it?[y/N]" opt
            if [ "x${opt}" = "x" ];then opt=N;fi
            if [ "x${opt}" = "xY" ] || [ "x${opt}" = "xy" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ];then
                if [ ${debug} = true ];then echo "DEBUG:overwrite file ${filename}";fi
                echo "" > ${new_file_dir}/${new_file_name}
            fi
        else
            touch ${new_file_dir}/${new_file_name}
        fi
        return 0
    elif [ "${cmd[0]}" = "delete" ];then
        if [ ! -f ${new_file_dir}/${new_file_name} ];then
            echo "ERROR: file ${filename} not exists!!"
            return 2
        fi
        read -p "WARN: file ${filename}, do you want to delete it?[y/N]" opt
        if [ "x${opt}" = "x" ];then opt=N;fi
        if [ "x${opt}" = "xY" ] || [ "x${opt}" = "xy" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ];then
            if [ ${debug} = true ];then echo "DEBUG:delete file ${new_file_name}";fi
            pushd ${new_file_dir}/
            git rm ${new_file_name} 2>&1 /dev/null
            if [ $? -eq 128 ];then
                rm -v ${new_file_name}
            elif [ $? -eq 1 ];then
                git checkout ${new_file_name}
                git rm ${new_file_name}
            fi
            popd
        fi
        return 0
    fi
    
    local file_list=()
    local file_list_size=0
    #[optional] check sub dir first
    if [ -d ${target_dir}/${remaining_args[0]} ];then
        if [ ${debug} = true ];then echo "DEBUG:dir=${target_dir}/${remaining_args[0]}";fi
        #only dir
        if [ ${remaining_argc} -lt 2 ];then
            tree -Fh ${target_dir}/${remaining_args[0]}
            return 0
        fi
        #dir/file
        file_list+=($(COMMOND_FUNC_find_file_with_prefix_or_suffix ${target_dir}/${remaining_args[0]} ${remaining_args[1]} ${prefix_or_suffix}))
        #no found
        if [ ${#file_list[@]} -lt 1 ];then 
            echo "no found file with ${prefix_or_suffix} ${remaining_args[0]}"
            local maybe_file=$(COMMOND_FUNC_find_file_with_prefix_or_suffix ${target_dir}/${remaining_args[0]} ${remaining_args[1]} all)
            if [ "x${maybe_file}" != x ];then
                echo "maybe you looking for: "
                echo "${maybe_file}"
            fi
            return 2
        fi
    elif [ -f ${target_dir}/${remaining_args[0]} ];then
        if [ ${debug} = true ];then echo "DEBUG:file=${target_dir}/${remaining_args[0]}";fi
        #complete filename
        file_list+=(${target_dir}/${remaining_args[0]})
    else
        if [ ${debug} = true ];then echo "DEBUG:borth not dir and file";fi
        #borth not dir and file
        file_list+=($(COMMOND_FUNC_find_file_with_prefix_or_suffix ${target_dir}/ ${remaining_args[0]} ${prefix_or_suffix}))
        #no found
        if [ ${#file_list[@]} -lt 1 ];then 
            echo "no found file with ${prefix_or_suffix} ${remaining_args[0]}"
            local maybe_file=$(COMMOND_FUNC_find_file_with_prefix_or_suffix ${target_dir}/ ${remaining_args[0]} all)
            if [ "x${maybe_file}" != x ];then
                echo "maybe you looking for: "
                echo "${maybe_file}"
            fi
            return 2
        fi        
    fi

    #readarray -t file_array <<< "${file_list}"
    file_list_size=${#file_list[@]}
    if [ ${debug} = true ];then echo "DEBUG:file_list[${file_list_size}]=${file_list[@]}";fi

    local sub_num=1
    if [ ${file_list_size} -eq 1 ] || [ "${remaining_args[-1]}" = all ];then
        for file_each in "${file_list[@]}"
        do
            echo "start[$sub_num/$file_list_size] ..."
            echo ""
            cat ${file_each}
            echo ""
            echo "end[$sub_num/$file_list_size] file:${file_each}"
            echo "-----------------------------------------------------------[${sub_num}]"
            sub_num=$(expr $sub_num + 1)
        done
        echo "==============================================================="
    fi

    #select by number
    if [[ ${remaining_args[-1]} =~ ^[0-9]+$ ]] ;then
        if [ ${remaining_args[-1]} -gt ${file_list_size} ];then 
            echo "ERROR: input number is larger than file list size"
            return 3
        fi
        sub_num=$(expr ${remaining_args[-1]} - 1)
        echo "file[${remaining_args[-1]}] start..."
        echo ""
        cat ${file_list[${sub_num}]}
        echo ""
        echo "file[${remaining_args[-1]}] end"
        echo "--------------------------------------------------------------"
    fi
    echo ""
    sub_num=1
    for file_each in "${file_list[@]}"
    do 
        echo "file[$sub_num/$file_list_size]: ${file_each}"
        sub_num=$(expr $sub_num + 1)
    done
    if [ ${file_list_size} -gt 1 ] && [ ${remaining_args[-1]} != all ];then
        echo ""
        echo "multiple files found! which file do you want to see? select by number?"
    fi    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_ "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
