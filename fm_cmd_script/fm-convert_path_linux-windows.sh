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
    echo ""
    echo "$scriptname  [opt]  path_str"
    echo "e.p:"
    echo "$scriptname  /root/test.txt    --> \\root\\test.txt"
    echo "$scriptname 'D:\\root\\test.txt' --> /root/test.txt"
    echo ""
    echo "opt:"
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
    #echo "-t or --test     # test mode, no modifications"
    #echo "--realdo        # real execution"
    #echo "-m or --mode     # you define"
    echo ""
}
function func_convert_linux_windows_path
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            -m|--mode)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="$2"; shift 2 ;; #带参数,移动2
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        #echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        #echo "DEBUG:mode=${mode}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================================================#
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    for file in "${remaining_args}"
    do
        #here we process each parameter
        echo ""
        if [ "x$(echo ${file}  | grep / )" = "x" ];then
            if [ ${debug} = true ];then
                echo "windows type "
            fi
            echo "Windows: ${file}"
            echo ""
            echo "Linux  : $(echo ${file} | sed -e 's#^[A-Z]:##' -e 's#\\#/#g')"
        else
            if [ ${debug} = true ];then
                echo "linux type "
            fi
            echo "Windows: $(echo ${file} | sed 's#/#\\#g')"
            echo ""
            echo "Linux  : ${file}"
        fi
        echo ""
    done
    
    return 0
}

func_convert_linux_windows_path "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
