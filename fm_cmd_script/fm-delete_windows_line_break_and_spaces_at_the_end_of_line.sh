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
    echo "删除行尾的“windows”换行符和空格"
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
    echo "-h or --help     # 帮助。"
    echo "-d or --debug    # 打印中间变量的状态或执行过程。"
    #echo "-t or --test     # test mode, no modifications"
    echo "--realdo         # 将修改后覆盖原文件，需谨慎！！"
    echo "-o or --output   # 保存到新文件，仅针对单文件有效。"
}
function func_
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local output=
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            -o|--output)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                output="$2"; shift 2 ;; #带参数,移动2
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        o) output="$2"; shift;break ;; # 当 o 是合并选项的一部分时，它应该停止解析剩余的字符
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
        echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:output=${output}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================================================#
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    for file in "${remaining_args[@]}";do
        if [ ! -f ${file} ];then
            echo "ERROR:file:$file not exist !!"
            continue
        fi
        if [ ${#remaining_args[@]} -eq 1 ] && [ "x${output}" != "x" ];then
            # 输出到新文件
            sed 's/\r$//; s/[[:space:]]\+$//' ${file} > "${output}"
            if [ ${debug} = true ];then echo "EXEC: sed 's/\r$//; s/[[:space:]]\+$//' ${file} > ${output}";fi
        elif [ ${realdo} = true ];then
            #写回原文件
            sed -i 's/\r$//; s/[[:space:]]\+$//' ${file}
            if [ ${debug} = true ];then echo "EXEC: sed -i 's/\r$//; s/[[:space:]]\+$//' ${file}";fi
        else
            # 对比修改后的差异
            local tmp_file=$(mktemp)
            sed 's/\r$//; s/[[:space:]]\+$//' ${file} > ${tmp_file}
            #diff -u -U0 ${file}  ${tmp_file} | colordiff
            diff -u -U0  <(cat -A ${file}) <(cat -A  ${tmp_file}) | colordiff
            if [ ${debug} = true ];then 
                echo "EXEC: sed 's/\r$//; s/[[:space:]]\+$//' ${file} > ${tmp_file}"
                echo "EXEC: diff -u -U0 ${file}  ${tmp_file}"
            fi            
            rm ${tmp_file}
        fi
    done
    return 0
}

func_ "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
