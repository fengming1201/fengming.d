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
function func_aviv_grep
{ 
    local app=grep
    local default_opt="-rin --exclude=*.torrent"
    local filename=none

	if [ $# -eq 1 ]
	then 
		
		local tmp=$(echo $1 | sed -n 's/-/00/p')
		if [ "$1" != "${tmp}" ]
		then
			filename=${tmp}
		fi
	fi

	local tmp_file=$(mktemp)
    find > ${tmp_file}
    $app ${default_opt} $*
	$app -in $* ${tmp_file}
	
	if [ "x${filename}" != "x" ]
	then
		$app ${default_opt} ${filename}
		$app -in ${filename} ${tmp_file}
	fi
	
    rm ${tmp_file}

    return 0
}
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]  key-words"
    echo "opt:"
    echo "-h or --help       # help"
    echo "-d or --debug      # print variable status"
    #echo "-t or --test       # test mode, no modifications"
    #echo "--realdo          # real execution"
    #echo "-m or --mode       # you define"
    echo "-c or --clean      # clear "
    #echo "--setx or --detail # open set -x mode"
    #echo "--func   func_name  args ...                            #调试某个函数,无参数--func,显示函数列表"
    echo "--stdin            # 从标准输入读取输入（支持heredoc和管道）"
    echo "example:"
    echo "$scriptname --stdin << EOF"
    echo ">data line 1"
    echo ">data line 2"
    echo ">EOF"
    echo "cat data.txt | $scriptname --stdin"
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
    local mode=normal
    local clean=flase
    local setx=false
    local use_stdin=false
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
            -c|--clean) clean=true; shift ;;
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
                        c) clean=true ;;
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
        echo "DEBUG:use_stdin=${use_stdin}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
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
        input_string=$(echo "${input_string}" | tr '\n' ' ' | tr -s ' ')
        echo "DEBUG:input_string=${input_string}"
        remaining_args=($input_string)
    else
        local remaining_argc=${#remaining_args[@]}
        if [ ${remaining_argc} -lt 1 ];then
            echo "ERROR: platform list is empty!!";usage;return 2
        fi
    fi
    if [ ${clean} = true ];then
        clear
    fi
    for file in "${remaining_args[@]}"
    do
        #here we process each parameter
        echo "reseult:$file"
        #func_aviv_grep "$file"
    done
    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
