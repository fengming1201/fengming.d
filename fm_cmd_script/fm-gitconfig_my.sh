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
    echo "-h or --help       # help"
    echo "-d or --debug      # print variable status"
    #echo "-t or --test       # test mode, no modifications"
    #echo "--realdo          # real execution"
    echo "-s or --save   [file]    #save file to fengming.d ,defaulr .gitconfig"
    echo "-l or --load             #load .gitconfig from fengming.d"
    #echo "-m or --mode       # you define"
    echo "--setx or --detail # open set -x mode"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_git_deploy_alias
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local action=none
    local mode=normal
    local setx=false
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            -l|--load) action=load; shift ;;
            -s|--save) action=save; shift ;;
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
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        l) action=load ;;
                        s) action=save ;;
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
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    local remaining_argc=${#remaining_args[@]}
    if [ ${remaining_argc} -ge 1 ];then
        #echo "ERROR: platform list is empty!!";usage;return 2
        if [ ! -f ${remaining_args[0]} ];then echo "${remaining_args[0]} not found!";return 1;fi
        cat ${remaining_args[0]} | grep '\[alias\]' > /dev/null
        if [ $? -ne 0 ];then echo "file:${remaining_args[0]} not match git config format!";return 2;fi
    fi
    #start your code
    #for file in "${remaining_args[@]}"
    #do
        #here we process each parameter
        #linux_cmd  ${cmd_opt[@]} args ....
    #done
    local git_alias_file=${fengming_dir}/documents/sub_doc_git/gitconfig_alias
    local terget_dir=${HOME}/.gitconfig
    
    if [ ${action} = "load" ];then
        if [ ! -f ${git_alias_file} ];then echo "ERROR:file ${git_alias_file} not found!!";return 1;fi
        if [ -f ${terget_dir} ];then cp -v ${terget_dir} ${terget_dir}.bak;fi
        cp -v ${git_alias_file} ${terget_dir}
    elif [ ${action} = "save" ];then
        cp -v ${git_alias_file} ${git_alias_file}.bak
        if [ ${remaining_argc}  -lt 1 ];then
            cp -v ${terget_dir} ${git_alias_file}
        else
            cp -v ${remaining_args[0]} ${git_alias_file}
        fi
    else
        echo "WRNING: unknow action"
        return 2
    fi

    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_git_deploy_alias "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
