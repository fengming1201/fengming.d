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
log_file=.log
find_exlude_dir=()
#提取视频文件，删除无用文件
function extract_video_file_and_delete_useless_files
{
    echo "starting extract ..."
    if [ ${realdo} = false ];then
        echo "EXEC:find ${find_exlude_dir[@]} -type f -name "*.torrent" -exec echo 'TEST: rm -v {}' \;"
        find ${find_exlude_dir[@]} -type f -name "*.torrent" -exec echo 'TEST: rm -v {}' \;
        echo "EXEC:find -mindepth 2 ${find_exlude_dir[@]} -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" \) -exec echo 'TEST: mv -vi {} .' \;"
        find -mindepth 2 ${find_exlude_dir[@]} -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" \) -exec echo 'TEST: mv -vi {} .' \;
        echo "EXEC:find -mindepth 1 -type d -exec echo 'TEST: rmdir -v {}' \;"
        find -mindepth 1 -type d -exec echo 'TEST: rmdir -v {}' \;
    else
        echo "EXEC:find ${find_exlude_dir[@]} -type f -name "*.torrent" -exec rm -v {} \;"
        find ${find_exlude_dir[@]} -type f -name "*.torrent" -exec rm -v {} \;
        echo "EXEC:find -mindepth 2 ${find_exlude_dir[@]} -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" \) -exec mv -vi {} . \;"
        find -mindepth 2 ${find_exlude_dir[@]} -type f \( -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" \) -exec mv -vi {} . \;
        echo "EXEC:find -mindepth 1 -type d -exec rmdir -v {} \;"
        find -mindepth 1 -type d -exec rmdir -v {} \;
    fi
    echo "extract done!"
    return 0
}

#删除无效的前缀或后缀
function delete_invalid_prefixes_and_suffixes
{
    echo "starting rename ..."
    local delete_str_list=( "hhd800.com@*" "*-nyap2p.com*" "*~nyap2p.com*" \
                            "fun2048.com@*" "gg5.co@*" "4k2.com@*" "big2048.com@*" \
                            "rh2048.com@*" "www.freedl.org@*" "kfa33.com@*" "kcf9.com@*" \
                            "www.youiv.me-*" "www.youiv.pw_*" "www.youiv.pw-*" "www.youiv.in-*" \
                            "\[88k.me\]*" "4k2.me@*" "\[Thz.la\]*" "489155.com@*" )
    if [ ${realdo} = true ];then
        rm ${log_file}
    fi
    eval "${open_setx_mode}"
    for pattern in "${delete_str_list[@]}"
    do
        new_pat=$(echo "${pattern}" | tr -d '*')
        for file in $(ls ${pattern} 2> /dev/null)
        do
            new=$(echo $file | sed "s/${new_pat}//g")
            if [ ! -w ${file} ];then
                maybeSUDO=sudo
            fi
            if [ -f "${file}" ];then
                if [ ${realdo} = false ];then
                    echo "TEST: ${maybeSUDO} mv -vi ${file}  ${new}"
                else
                    echo "${file}  -> ${new}" >> ${log_file}
                    ${maybeSUDO} mv -vi "${file}"  "${new}"
                fi
            fi
        done
    done
    eval "${close_setx_mode}"
    echo "rename done!"
    return 0
}

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
    echo "--realdo          # real execution"
    echo "-m or --mode   [ extract | rename | all ]    # 执行模式"
    echo "-e or --exclude  list         # 排除清单，允许多个-e"
    echo "--setx or --detail # open set -x mode"
    #echo "--func   func_name  args ...                            #调试某个函数,无参数--func,显示函数列表"
    #echo "--stdin            # 从标准输入读取输入（支持heredoc和管道）"
    #echo "example:"
    #echo "$scriptname --stdin << EOF"
    #echo ">data line 1"
    #echo ">data line 2"
    #echo ">EOF"
    #echo "cat data.txt | $scriptname --stdin"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_main
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=none
    local setx=false
    local use_stdin=false
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    local exclude_dir=()    #排除参数
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
            -e|--exclude)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                exclude_dir+=("$2"); shift 2 ;; #带参数,移动2
            --stdin) use_stdin=true; shift ;;
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        e) exclude_dir+=("$2"); shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        Q) cmd_opt+=("--qr=true") ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    # 处理
    if [ ${#exclude_dir[@]} -gt 0 ];then
        find_exlude_dir=("(" -path "*/${exclude_dir[0]}*")
        for path in "${exclude_dir[@]:1}"
        do
            find_exlude_dir+=(-o -path "*/${path}*")
        done
        find_exlude_dir+=(")" -prune -o)
    fi
    #==================== print debug =============================#
    if [ ${debug} = true ];then
        echo "DEBUG:maybeSUDO=${maybeSUDO}"
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:mode=${mode}"
        echo "DEBUG:setx=${setx}"
        echo "DEBUG:use_stdin=${use_stdin}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
        echo "DEBUG:exclude_dir=${exclude_dir[@]}"
        echo "DEBUG:find_exlude_dir=${find_exlude_dir}"
    fi
    #=================== start your code ==============================#
    # check if input is from stdin
    if [ ${use_stdin} = true ];then
        # Read from stdin
        if [ -t 0 ]; then
            echo "ERROR: --stdin option requires input from pipe or heredoc!" >&2
            return 2
        fi
        input_string=$(cat)
        # Remove newlines and extra whitespace
        #input_string=$(echo "${input_string}" | tr '\n' ' ' | tr -s ' ')
        echo "DEBUG:input_string=${input_string}"
    else
        local remaining_argc=${#remaining_args[@]}
        #if [ ${remaining_argc} -lt 1 ];then
        #    echo "ERROR: platform list is empty!!";usage;return 2
        #fi
    fi
    
    #for file in "${remaining_args[@]}"
    #do
        #here we process each parameter
        #linux_cmd  ${cmd_opt[@]} args ....
    #done

    if [ ${mode} = "extract" ] || [ ${mode} = "1" ] || [ ${mode} = "all" ];then
        extract_video_file_and_delete_useless_files
    fi
    if [ ${mode} = "rename" ] || [ ${mode} = "2" ] || [ ${mode} = "all" ];then
        delete_invalid_prefixes_and_suffixes
    fi
    if [ ${realdo} = false ];then
        echo "------------------------------------------------------------"
        echo "above result is just a simulated execution,"
        echo "if you want to actually execute it, add the option --realdo "
        echo ""
    fi
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
