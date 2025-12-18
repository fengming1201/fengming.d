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
# Function to convert hex to human-readable size
convert_hex_to_size() 
{
    local hex_value=$1
    local decimal_value=$((hex_value))

    local megabytes=$((decimal_value / (1024 * 1024)))
    local remaining=$((decimal_value % (1024 * 1024)))
    local kilobytes=$((remaining / 1024))
    local bytes=$((remaining % 1024))

    local result=""
    if (( megabytes > 0 )); then
        result="${megabytes}M"
    fi
    if (( kilobytes > 0 )); then
        result="${result}${kilobytes}K"
    fi
    if (( bytes > 0 )); then
        result="${result}${bytes}B"
    fi
    # 处理0值的特殊情况
    if [ -z "$result" ]; then
        result="0B"
    fi

    echo "$result"
    return 0
}
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "brief:将十六进制值 空间大小或区间列表 转换成易读的单位"
    echo "$scriptname  [opt]  hex_value"
    echo "$scriptname  [opt]  0x1000"
    echo "opt:"
    echo "-h or --help       # help"
    echo "-d or --debug      # print variable status"
    echo "-t or --test       # test mode, no modifications"
    #echo "--realdo          # real execution"
    #echo "-m or --mode       # you define"
    #echo "--setx or --detail # open set -x mode"
    echo "-H or --hex        # 仅换算十六进制值，不进行区间分析"
    echo "example:"
    echo "$scriptname  0x1000   或  0x1000 0x3190 0x5000 0x8000 -H "
    echo "$scriptname  0x1000  0x150000"
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
    local setx=false
    local hex_only=false
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
            -H|--hex) hex_only=true; shift ;; #不带参数,移动1
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
                        H) hex_only=true ;;
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
    if [ ${remaining_argc} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    if [ ${remaining_argc} -eq 1 ] || [ ${hex_only} = true ];then
        for hex_value in "${remaining_args[@]}"
        do
            local size_readable=$(convert_hex_to_size $hex_value)
            # 格式化输出，确保等宽对齐
            printf "大小: %-10s --> %s\n" "$hex_value" "$size_readable"
        done
        return 0;
    fi
    # 对十六进制地址进行排序
    local sorted_args=()
    local temp_array=()
    
    # 将十六进制地址转换为十进制进行排序
    for value in "${remaining_args[@]}"
    do
        # 移除可能的0x前缀并转换为十进制
        local decimal_value=$((value))
        temp_array+=("$decimal_value:$value")
    done
    
    # 按十进制值排序
    IFS=$'\n' sorted_temp=($(sort -n <<<"${temp_array[*]}"))
    unset IFS
    
    # 提取排序后的原始十六进制值
    for item in "${sorted_temp[@]}"
    do
        local hex_value="${item#*:}"
        sorted_args+=("$hex_value")
    done
    if [ ${debug} = true ];then
        echo "DEBUG:sort_result:${sorted_args[@]}"
    fi
    # 计算地址区间大小并转换
    local prev_addr=0
    local i=0
    
    for hex_value in "${sorted_args[@]}"
    do
        local current_addr=$((hex_value))
        if [ $i -gt 0 ]; then
            local interval_size=$((current_addr - prev_addr))
            local prev_hex="${sorted_args[$((i-1))]}"
            local size_hex="0x$(printf "%x" $interval_size)"
            local size_readable=$(convert_hex_to_size $interval_size)
            
            # 格式化输出，确保等宽对齐
            printf "区间: [%-10s - %-10s], 大小: %-10s --> %s\n" "$prev_hex" "$hex_value" "$size_hex" "$size_readable"
        fi
        prev_addr=$current_addr
        ((i++))
    done

    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
