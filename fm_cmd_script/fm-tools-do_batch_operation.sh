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
    echo "mult to execuble cmd from file per line"
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
function func_batch_operation
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  opt  args"
        echo "$scriptname  --opt cmd  --file para_file --cmd 'command'" #e.g -cmd cp -param -vi  para_file
        echo "$scriptname  --opt exec --file exec_file" #e.g -exec  
        echo "$scriptname  opt  args"
        return 1
    fi
    #check 
    which getopt > /dev/null
    if [ $? -ne 0 ];then echo "ERROR:" ;fi
    echo "org=$@"
    local opt=
    local file=
    local cmd=
    #local parm_list=$(getopt -l opt:,file:,cmd: -- "$@")
    local PARSED_OPTIONS=$(getopt --long opt:,file:,cmd: -- "$@")
    if [ $? -ne 0 ]; then
        echo "error into"
    fi
    #eval set -- "$parm_list"
    eval set -- "$PARSED_OPTIONS"

    while true; do
        case "$1" in
            --opt)
            opt="$2"
            shift 2
            ;;
            --file)
            file="$2"
            shift 2
            ;;
            --cmd)
            file="$2"
            shift 2
            ;;
            --)
            shift
            break
            ;;
            *)
            echo "Unknown option: $1"
            exit 1
            ;;
        esac
    done
    echo "opt=$opt"
    echo "file=$file"
    echo "cmd=$cmd"

    return 0
    while true; do
        case "$1" in
            --opt)
                opt="$2"
                shift 1
                ;;
            --file)
                file="$2"
                shift 1
                ;;
            --cmd)
                cmd="$2"
                shift 1
                ;;
            --)
                shift
                break
                # -- 表示选项解析结束，shift 后退出循环。
                ;;
            *)
                ;;
        esac
    done

    echo "opt=$opt"
    echo "file=$file"
    echo "cmd=$cmd"

    if [ ${opt} = "cmd" ]
    then
        local complete_cmd=

    elif [ ${opt} = "exe" ]
    then 


    else
        echo "ERROR:Unknown option"
    fi


    return 0
}

func_batch_operation "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
