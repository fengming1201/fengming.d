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

if [ $(ls -ld . | awk '{print$3}') != $(whoami) ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help                      # help"
    echo "-d or --debug                     # print variable status"
    #echo "-t or --test                      # test mode, no modifications"
    echo "--realdo                          # real execution"
    echo "-y or --yes                       # sais yes"
    #echo "-m or --mode                      # you define"
    echo "-p or --prefix  prefix  filelist  # 给文件列表添加前缀"
    echo "-s or --suffix  suffix  filelist  # 给文件列表添加后缀"
    echo ""
    #echo "--setx or --detail                # open set -x mode"
    echo ".e.g:"
    echo "$scriptname  -p  'AAA-'   file.txt  --> AAA-file.txt"
    echo "$scriptname  -s  '-ZZZ'   file.txt  --> file-ZZZ.txt"
    echo "$scriptname  -p  'AAA-' -s  '-ZZZ'  file.txt  --> AAA-file-ZZZ.txt"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_aviv_add_prefix_suffix
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local all_yes=false
    local mode=normal
    local prefix_name=
    local suffix_name=
    local setx=false
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            -y|--yes) all_yes=true; shift ;;
            --setx) setx=true; shift ;; #不带参数,移动1
            --detail) setx=true; shift ;; #不带参数,移动1
            -m|--mode)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="$2"; shift 2 ;; #带参数,移动2
            -p|--prefix)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                prefix_name="$2"; shift 2 ;; #带参数,移动2
            -s|--suffix)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                suffix_name="$2"; shift 2 ;; #带参数,移动2                                
            -F|--file)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd_opt+=("--file $2"); shift 2 ;; #带参数,移动2
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        y) all_yes=true ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        p) prefix_name="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        s) suffix_name="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
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
        echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:mode=${mode}"
        echo "DEBUG:prefix_name=${prefix_name}"
        echo "DEBUG:suffix_name=${suffix_name}"
        echo "DEBUG:setx=${setx}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    local remaining_argc=${#remaining_args[@]}
    if [ ${remaining_argc} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    #for file in "${remaining_args[@]}"
    #do
        #here we process each parameter
        #linux_cmd  ${cmd_opt[@]} args ....
    #done
    if [ -z ${prefix_name} ] && [ -z ${suffix_name} ];then echo "both prefix  and suffix name is empty!!";return 1;fi

    local path=
    local filename=
    local name=
    local ext=
    for file in "${remaining_args[@]}"
    do
        if [ ! ${file} ];then echo "file:${file} not found!";fi
        path=$(dirname "$file")
        filename=$(basename "$file")
        if [ ${debug} = true ];then
            echo "DEBUG:path=${path}"
            echo "DEBUG:filename=${filename}"
        fi
        if [[ "$filename" == *.* ]]; then
            #name="${filename%.*}"        # 去掉最后一个 .xxx
            #ext=".${filename##*.}"       # 取最后一个扩展名
            name="${filename%%.*}" 
            ext="${filename#${name}}"    # .archive.tar.gz
        else
            name="$filename"             # 没有点就原样输出
            ext=""
        fi
        if [ ${debug} = true ];then
            echo "DEBUG:name=${name}"
            echo "DEBUG:ext=${ext}"
        fi
        
        if [ ${realdo} = true ];then
            if [ ${all_yes} = true ];then
                mv -v "${file}"  "${path}/${prefix_name}${name}${suffix_name}${ext}" 
            else
                mv -vi "${file}"  "${path}/${prefix_name}${name}${suffix_name}${ext}" 
            fi
        else
            if [ ${all_yes} = true ];then
                echo "TEST: mv -v "${file}"  "${path}/${prefix_name}${name}${suffix_name}${ext}""
            else
                echo "TEST: mv -vi "${file}"  "${path}/${prefix_name}${name}${suffix_name}${ext}""
            fi
        fi
    done
    if [ ${realdo} = false ];then
        echo ""
        echo " --realdo    #真正执行"
        echo " -y or --yes #all yes"
        echo ""
    fi

    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_aviv_add_prefix_suffix "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
