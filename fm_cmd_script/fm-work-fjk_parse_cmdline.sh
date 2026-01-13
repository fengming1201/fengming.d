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

# Function to extract MTD partition table from command line string
extract_mtd_parts() {
    local cmdline="$1"
    local mtd_pattern="mtdparts=[^[:space:]]*"
    
    if [[ "$cmdline" =~ $mtd_pattern ]]; then
        echo "${BASH_REMATCH[0]}"
        return 0
    else
        echo "ERROR: No MTD partition table found in command line"
        return 1
    fi
}

# Function to parse MTD partition string and extract partitions
parse_mtd_partitions() {
    local mtd_string="$1"
    
    # Check if this is an error message
    if [[ "$mtd_string" == "ERROR:"* ]]; then
        echo "Cannot parse partition table: $mtd_string"
        return 1
    fi
    
    # Remove "mtdparts=" prefix
    local partitions_part="${mtd_string#mtdparts=}"
    
    # Extract device name (before colon)
    local device="${partitions_part%%:*}"
    local partitions_str="${partitions_part#*:}"
    
    echo "Device: $device ,MTD partition table:"
    echo "=========================================="
    
    # Split partitions by comma and parse each
    IFS=',' read -ra PARTITIONS <<< "$partitions_str"
    local index=0
    
    for partition in "${PARTITIONS[@]}"; do
        # Parse partition format: size@offset(name)
        # Use a simpler approach to parse the partition string
        local size=$(echo "$partition" | cut -d'@' -f1)
        local offset_name=$(echo "$partition" | cut -d'@' -f2)
        local offset=$(echo "$offset_name" | cut -d'(' -f1)
        local name=$(echo "$offset_name" | cut -d'(' -f2 | cut -d')' -f1)
        
        if [ -n "$size" ] && [ -n "$offset" ] && [ -n "$name" ]; then
            # Convert hex to decimal for calculation
            local size_dec=$((size))
            local offset_dec=$((offset))
            
            # Calculate end address
            local end_addr=$((offset_dec + size_dec))
            local end_hex="0x$(printf "%x" $end_addr)"
            
            # Convert size to readable format using existing function
            local size_readable=$(convert_hex_to_size "$size")
            
            # Display partition info with formatting
            printf "[%2d] %-12s | 0x%-8s - 0x%-8s | 0x%-8s | %s\n" \
                "$index" "$name" "${offset#0x}" "${end_hex#0x}" "${size#0x}" "$size_readable"
            
            ((index++))
        else
            echo "Warning: Failed to parse partition: $partition"
        fi
    done
    echo "=========================================="
}

# Function to convert hex to human-readable size (reusing from fm-convert_hex_size.sh)
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

# Function to extract key-value pairs from command line string (excluding mtdparts)
extract_key_value_pairs() {
    local cmdline="$1"
    
    # Remove mtdparts from the string to avoid parsing it
    local cmdline_without_mtd=$(echo "$cmdline" | sed 's/mtdparts=[^[:space:]]*//g')
    
    # Split by spaces and process each token
    for token in $cmdline_without_mtd; do
        # Check if token contains '=' and is not empty
        if [[ "$token" == *"="* ]] && [ -n "$token" ]; then
            echo "$token"
        fi
    done
}

# Function to display summary information
display_summary() {
    local mtd_string="$1"
    
    # Check if this is an error message
    if [[ "$mtd_string" == "ERROR:"* ]]; then
        echo "Cannot generate summary: $mtd_string"
        return 1
    fi
    
    local partitions_part="${mtd_string#mtdparts=}"
    local partitions_str="${partitions_part#*:}"
    
    IFS=',' read -ra PARTITIONS <<< "$partitions_str"
    local total_size=0
    local partition_count=${#PARTITIONS[@]}
    
    # Calculate total size
    for partition in "${PARTITIONS[@]}"; do
        local size=$(echo "$partition" | cut -d'@' -f1)
        if [ -n "$size" ]; then
            total_size=$((total_size + size))
        fi
    done
    
    local total_readable=$(convert_hex_to_size "$total_size")
    
    echo "Summary:"
    echo "--------"
    echo "Total partitions: $partition_count"
    echo "Total size: 0x$(printf "%x" $total_size) ($total_readable)"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "brief: 从命令行字符串中提取并解析MTD分区表"
    echo "$scriptname  [opt]  \"cmdline_string\""
    echo "$scriptname  \"mtdparts=spi0.0:0x20000@0(bootstrap),0x50000@0x20000(uboot)\""
    echo "opt:"
    echo "-h or --help       # help"
    echo "-d or --debug      # print variable status"
    #echo "-t or --test       # test mode, no modifications"
    #echo "-m or --mode       # you define"
    #echo "--setx or --detail # open set -x mode"
    echo "-f or --file       # 从文件中读取命令行字符串"
    echo "--extract-only     # 仅提取MTD分区表，不进行解析"
    echo "--show-kv          # 显示命令行中的键值对（排除mtdparts）"
    echo ""
    echo "example:"
    echo "cat data.txt | $scriptname"
    echo "$scriptname << EOF"
    echo ">mtdparts=spi0.0:0x20000@0(bootstrap),0x50000@0x20000(uboot)"
    echo ">EOF"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_main
{
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local setx=false
    local extract_only=false
    local show_kv=true
    local input_file=""
    local use_stdin=false
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    
    # 自动检测管道输入
    if [ ! -t 0 ]; then
        use_stdin=true
    fi
    
    # 如果没有参数且没有管道输入，显示帮助
    if [ $# -eq 0 ] && [ "$use_stdin" = false ]; then
        usage
        return 1
    fi
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            --setx) setx=true; shift ;; #不带参数,移动1
            --detail) setx=true; shift ;; #不带参数,移动1
            --extract-only) extract_only=true; shift ;;  
            --show-kv) show_kv=true; shift ;;  
            -f|--file)
                if [[ -z "$2" ]]; then echo "ERROR: this option requires one parameter" >&2; return 1; fi
                input_file="$2"; shift 2 ;; #带参数,移动2
            -m|--mode)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="$2"; shift 2 ;; #带参数,移动2
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        f) input_file="$2"; shift;break ;; # 当 f 是合并选项的一部分时，它应该停止解析剩余的字符
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
        echo "DEBUG:mode=${mode}"
        echo "DEBUG:setx=${setx}"
        echo "DEBUG:extract_only=${extract_only}"
        echo "DEBUG:show_kv=${show_kv}"
        echo "DEBUG:input_file=${input_file}"
        echo "DEBUG:use_stdin=${use_stdin}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    local cmdline_string=""
    
    # Check if input is from stdin, file, or command line arguments
    if [ "$use_stdin" = true ]; then
        # Read from stdin
        cmdline_string=$(cat)
        # Remove newlines and extra whitespace
        cmdline_string=$(echo "$cmdline_string" | tr '\n' ' ' | tr -s ' ')
    elif [ -n "$input_file" ]; then
        # Read from file
        if [ ! -f "$input_file" ]; then
            echo "ERROR: Input file '$input_file' does not exist!" >&2
            return 2
        fi
        if [ ! -r "$input_file" ]; then
            echo "ERROR: Input file '$input_file' is not readable!" >&2
            return 2
        fi
        cmdline_string=$(cat "$input_file")
        # Remove newlines and extra whitespace
        cmdline_string=$(echo "$cmdline_string" | tr '\n' ' ' | tr -s ' ')
    else
        # Read from command line arguments
        local remaining_argc=${#remaining_args[@]}
        if [ ${remaining_argc} -lt 1 ];then
            echo "ERROR: command line string is required!!";usage;return 2
        fi
        # Combine all remaining arguments into one command line string
        cmdline_string="${remaining_args[*]}"
    fi
    
    # Check if cmdline_string is empty
    if [ -z "$cmdline_string" ]; then
        echo "ERROR: No input data found!" >&2
        return 2
    fi
    
    echo "MTD Partition Table Parser"
    echo "=========================="
    echo "Input: ${cmdline_string:0:100}..."
    echo ""
    
    # Extract MTD partition table
    local mtd_result=$(extract_mtd_parts "$cmdline_string")
    local extract_status=$?
    if [ $extract_status -ne 0 ]; then
        echo "$mtd_result"
        return 3
    fi
    
    echo "Extracted MTD partition table:"
    echo "$mtd_result"
    echo ""
    
    # Display key-value pairs if requested
    if [ "$show_kv" = true ]; then
        echo "Key-Value Pairs:"
        echo "================"
        local kv_pairs=$(extract_key_value_pairs "$cmdline_string")
        if [ -n "$kv_pairs" ]; then
            echo "$kv_pairs"
        else
            echo "No key-value pairs found."
        fi
        echo ""
    fi
    
    # If extract-only mode, just return the extracted string
    if [ "$extract_only" = true ]; then
        return 0
    fi
    
    # Parse and display partitions
    parse_mtd_partitions "$mtd_result"
    echo ""
    
    # Display summary
    display_summary "$mtd_result"
    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
