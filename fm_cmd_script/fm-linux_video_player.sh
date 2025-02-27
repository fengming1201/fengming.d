#!/bin/bash

scriptfile=($0)
scriptname=$(basename ${scriptfile[0]})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh
isinclude_common_func=false
if [ -f ${common_share_function} ] && [ $isinclude_common_func = true ];then
    source ${common_share_function}
    scriptfile+=(${common_share_function})
fi
#if unnecessary, please do not modify this function

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_location
{
    if [ -L ${scriptfile[0]} ];then
        echo "location:${scriptfile[0]}  --> $(readlink ${scriptfile[0]})"
    else
        echo "location:${scriptfile[0]}"
    fi
    return 0
}

##Parameter Counts      : >=1
# Parameter Requirements: func_name  args ...
# Example: usage
##
function func_debug_help
{
    echo "--func {function_name or index} [args ...] [--debug]  #优先级3: 列出所有子函数或调用子函数"
}
function func_debug_function
{
    local debug=false
    local func_test=false
    local remaining_args=()
    while [[ $# -gt 0 ]];do
        case "$1" in
            --debug) debug=true; shift ;; #不带参数,移动1
            --func) func_test=true; shift ;; #不带参数,移动1
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    if [ ${func_test} = false ];then return 0;fi
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:func_test=${func_test}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    local index=0
    local func_list=($(grep -Eo 'function [a-zA-Z_][a-zA-Z0-9_]*|^[a-zA-Z_][a-zA-Z0-9_]*\(\)' ${scriptfile[@]} | awk '{print $2}' | sed 's/[()]//g'))
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "函数列表:"
        echo ""
        for func in ${func_list[@]};do echo "[${index}] ${func}";index=$((index+1));done
        echo ""
        echo "用法:";echo -n "$scriptname ";func_debug_help;return 1
    fi
    if [ ${debug} = true ];then echo "DEBUG:func_list[${#func_list[@]}]=${func_list[@]}";fi
    local call_func_name=
    if expr "${remaining_args[0]}" : '-*[0-9]\+$' > /dev/null; then
        if [ ${debug} = true ];then echo "${remaining_args[0]} is number";fi
        call_func_name=${func_list[${remaining_args[0]}]}
    else
        if [ ${debug} = true ];then echo "${remaining_args[0]} is string";fi
        for func in ${func_list[@]};do if [ ${func} = "${remaining_args[0]}" ];then call_func_name=${func};fi;done
    fi
    if [ ${debug} = true ];then echo "DEBUG:call_func_name=${call_func_name}";fi
    if [ x${call_func_name} = x ];then echo "ERROR:${remaining_args[0]} not at this scriptfile";echo "Possible Function Name:{ ${func_list[@]} }";return 2;fi
    echo -e "\e[31mcall func ....\e[0m"
    if [ ${debug} = true ];then echo "CALL: ${call_func_name}( ${remaining_args[@]:1} ) ";fi
    ${call_func_name} "${remaining_args[@]:1}"
    echo -e "\e[31m.... done\e[0m"
    return 3
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo ""
    echo "info | -info | --info                      #优先级1: 显示摘要"
    echo "show | -show | --show                      #优先级2: 打印本脚本文件"
    func_debug_help
    echo ""
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile[0]}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ] && [ ${USER} != $(ls -ld . | awk '{print$3}') ];then
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
    echo "$scriptname  [opt]  video_files"
    echo ""
    echo "opt:"
    echo "-P or --path   num                                   # pre path "
    echo "-p or --playlist   playlist1 playlist2 ...           # play list files"
    echo "-f or --videofile  a.mp4  b.mp4  cc* ...             # video list files "
    echo "-u or --rtmpurl    rtmp://IP:PORT/live/movie123 ...  # rtmp_url list"
    echo ""
    echo "-W or --which  num  # DISPLAY=:? "
    echo "-F or --full        # --fs :全屏"
    echo "-A or --auto        # --autofit :使得视频的最大尺寸适应屏幕"
    echo "-S or --speed  num  # 1.0, 1.10, 1.21, 1.33, 1.46, 1.61, 1.77"
    echo ""
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
    echo "-t or --test     # test mode, no modifications"
    #echo "--realdo        # real execution"
    #echo "-m or --mode    # videofile | playlist | rtmp_url"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_video_player
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local app=mpv
    local app_opt=()
    local debug=false
    local test=false
    local realdo=false
    local mode=none
    local whichis=0
    local path=
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local listmode=none
    local playlist=()
    local filelist=()
    local rtmp_url=()
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            -F|--full) app_opt+=("--fs"); shift ;;
            -A|--auto) app_opt+=("--autofit"); shift ;;
            --realdo) realdo=true; shift ;;
            -m|--mode)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="$2"; shift 2 ;; #带参数,移动2
            -W|--which)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                whichis="$2"; shift 2 ;; #带参数,移动2
            -P|--path)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                path="$2"; shift 2 ;; #带参数,移动2
            -S|--speed)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                app_opt+=("--speed=$2"); shift 2 ;; #带参数,移动2
            -F|--file)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd_opt+=("--file $2"); shift 2 ;; #带参数,移动2
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -p|--playlist) listmode=playlist; shift ;;
            -f|--videofile) listmode=filelist; shift ;;
            -u|--rtmpurl) listmode=rtmp_url; shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        F) app_opt+=("--fs") ;;
                        A) app_opt+=("--autofit") ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        W) whichis="$2"; shift;break ;; # 当 W 是合并选项的一部分时，它应该停止解析剩余的字符
                        P) path="$2"; shift;break ;; # 当 P 是合并选项的一部分时，它应该停止解析剩余的字符
                        S) app_opt=("--speed=$2"); shift;break ;; # 当 S 是合并选项的一部分时，它应该停止解析剩余的字符
			F) cmd_opt+=("--file $2"); shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        Q) cmd_opt+=("--qr=true") ;;
                        p) listmode=playlist ;;
                        f) listmode=filelist ;;
                        u) listmode=rtmp_url ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) if [ "$listmode" = "playlist" ];then
                   playlist+=("$1");
               elif [ "$listmode" = "filelist" ];then
                   filelist+=("$1");
                elif [ "$listmode" = "rtmp_url" ];then
                   rtmp_url+=("$1");
                else
                   remaining_args+=("$1"); 
                fi
                shift ;; # 非选项参数全部放入数组中
        esac
    done
    #==================== print debug =============================#
    if [ ${debug} = true ];then
        echo "DEBUG:maybeSUDO=${maybeSUDO}"
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:mode=${mode}"
	echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:which=${whichis}"
        echo "DEBUG:path=${path}"
        echo ""
        echp "DEBUG:app_opt=${app_opt[@]}"
        echo "DEBUG:playlist=${playlist[@]}"
        echo "DEBUG:filelist=${filelist[@]}"
        echo "DEBUG:rtmp_url=${rtmp_url[@]}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    local play_list=()
    local filecontext=
    #play list
    if [ ${#playlist[@]} -gt 0 ];then
        for list in "$playlist";do
            if [ -f ${list} ];then
                filecontext=$(cat ${list})
                play_list+=$(ls ${filecontext} 2>/dev/null | tr '\n' ' ')
            fi
        done
    fi
    if [ ${debug} = true ];then
        echo "==playlist=${play_list[@]}"
    fi
    #file list
    if [ ${#filelist[@]} -gt 0 ];then
        play_list+=$(ls ${filelist[@]} 2>/dev/null | tr '\n' ' ')
    fi
    if [ ${debug} = true ];then
        echo "==filelist=$(ls ${filelist[@]} 2>/dev/null | tr '\n' ' ')"
    fi
    #rtmp_url list
    if [ ${#rtmp_url[@]} -gt 0 ];then
        play_list+=${rtmp_url[@]}
    fi
    if [ ${debug} = true ];then
        echo "==rtmp_url=${rtmp_url[@]}"
    fi
    # other
    if [ ${#remaining_args[@]} -gt 0 ];then
        play_list+=${remaining_args[@]}
    fi
    if [ ${debug} = true ];then
        echo "==other=${remaining_args[@]}"
    fi

    if [ ${#play_list[@]} -eq 0 ];then echo "play_list is empty!";return 2;fi

    if [ x"$SSH_CLIENT" = x ]
    then
        for vfile in ${play_list[@]};do
            #if [ ! -f ${vfile} ];then echo 
            echo "${app} ${app_opt[@]} ${vfile}"
            if [ ${test} = false ];then
                ${app} ${app_opt[@]} "${vfile}"
            fi
        done
    else
        local opt="Y"
        read -p "Are you sure display to remote screen? [Y/n]"  opt
        if [ "x${opt}" = "x"  ];then opt="Y";fi
        if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
        then
            for vfile in ${play_list[@]};do
                echo "DISPLAY=:${whichis} ${app} ${app_opt[@]} ${vfile}"
                if [ ${test} = false ];then
                    DISPLAY=:${whichis} ${app} ${app_opt[@]} "${vfile}"
                fi
            done
        fi
    fi
    return 0
}

func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_video_player "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
