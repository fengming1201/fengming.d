#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ];then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ];then
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
if [ $(id -u) -ne 0 ] && [ lshm != lshm ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function usage
{
    echo "$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
}
function func_check_file_encode_type
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================================================#
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    for file in "${remaining_args[@]}"
    do
        if [ ! -f ${file} ];then
            echo "ERROR:${file} not exist!!"
            continue
        fi
        #method 1
        if [ ${debug} = true ];then
            echo "DEBUG:file -i ${file}"
        fi
        file -i "${file}"
        #method 2
        #which enca > /dev/null
        #if [ $? -ne 0 ];then
        #    echo "ERROR: enca cmd not found!!"
        #    echo "apt install enca"
        #else
        #    enca "${file}"
        #fi
    done

    return 0
}

func_check_file_encode_type "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
