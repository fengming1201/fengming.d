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
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help                  # help"
    echo "-d or --debug                 # 开启调试，打印变量等"
    echo "-t or --test                  # 测试模式，不真正执行"
    #echo "--realdo                     # 缺省不执行"
    echo "--setx                        # 开启set -x 详细模式"
    echo "--func   func_name  args ...  # 调试某个函数,无参数--func,显示函数列表"
    echo ""
    echo "-m or --mode                  # 待你定义"
    echo "-f or --file                  # 从指定文件读取"
    echo "-e or --exclude  list         # 排除清单，允许多个-e"
    echo "-o or --opt  sub_option       # 给命令自自身添加子选项,允许多个-o,如：-o '-p' -o '-f file'"
    echo ""
    echo "example:                      # 从管道或标准输入"
    echo "(1), $scriptname < data.txt"
    echo "(2), cat data.txt | $scriptname"
    echo "(3), $scriptname << EOF"
    echo "your content"
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
    local setx=false #用法: eval \"${open_setx_mode}\" or eval \"${close_setx_mode}\""
    local input_file=""  #从指定文件读取
    local use_stdin=false
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=() #无选项参数
    local exclude_dir=()    #排除参数
    # 自动检测管道输入
    if [ ! -t 0 ]; then
        use_stdin=true
    fi
    # 如果没有参数且没有管道输入，显示帮助
    if [ $# -eq 0 ] && [ "${use_stdin}" = false ]; then
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
            -m|--mode)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="$2"; shift 2 ;; #带参数,移动2
            -e|--exclude)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                exclude_dir+=("$2"); shift 2 ;; #带参数,移动2
            -f|--file)
                if [[ -z "$2" ]]; then echo "ERROR: this option requires one parameter" >&2; return 1; fi
                input_file="$2"; shift 2 ;; #带参数,移动2
            -o|--opt)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd_opt+=("$2"); shift 2 ;; #带参数,移动2
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        e) exclude_dir+=("$2"); shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        f) input_file="$2"; shift;break ;; # 当 f 是合并选项的一部分时，它应该停止解析剩余的字符
                        o) cmd_opt="$2"; shift;break ;; # 当 f 是合并选项的一部分时，它应该停止解析剩余的字符
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    
    local stdin_string=""
    # Check if input is from stdin, file, or command line arguments
    if [ "${use_stdin}" = true ]; then
        # Read from stdin
        stdin_string=$(cat)
    elif [ -n "${input_file}" ]; then
        # Read from file
        if [ ! -f "${input_file}" ] || [ ! -r "${input_file}" ]; then
            echo "ERROR: Input file '${input_file}' does not exist!" >&2
            return 2
        fi
        stdin_string=$(cat "${input_file}")
    else
        # Read from command line arguments as file names
        local remaining_argc=${#remaining_args[@]}
        if [ ${remaining_argc} -lt 1 ];then
            echo "ERROR: either input file, stdin, or file name as argument is required!!";usage;return 2
        fi
        # Read content from files specified in remaining_args
        for file in "${remaining_args[@]}"; do
            if [ -f "${file}" ] && [ -r "${file}" ]; then
                if [ -n "${stdin_string}" ]; then
                    stdin_string+=$'\n'
                fi
                stdin_string+=$(cat "${file}")
            else
                echo "WARNING: File '${file}' does not exist or cannot be read!" >&2
            fi
        done
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
        echo "DEBUG:stdin_string=${stdin_string}"
    fi
    #=================== start your code ==============================#
    #for file in "${remaining_args[@]}"
    #do
        #here we process each parameter
        #linux_cmd  ${cmd_opt[@]} args ....
    #done
    MTDPARTS_INPUT="${stdin_string}" python3 - <<'END'
import re
import os

def format_size(size):
    """格式化大小为人类可读格式"""
    if size >= 1024 * 1024:
        m = size // (1024 * 1024)
        rem = size % (1024 * 1024)
        if rem == 0:
            return f"{m}M"
        else:
            k = rem // 1024
            return f"{m}M{k}K"
    elif size >= 1024:
        k = size // 1024
        return f"{k}K"
    else:
        return f"{size}B"

def parse_partition_string(partition_str, source_name):
    """解析分区字符串并返回设备和分区列表"""
    # 去掉可能的前缀 "mtdparts="
    if partition_str.startswith('mtdparts='):
        partition_str = partition_str[len('mtdparts='):]
    
    # 分割设备和分区
    if ':' not in partition_str:
        print(f"{source_name} 错误: 分区格式不正确")
        return None, []
    
    device_part, partitions_part = partition_str.split(':', 1)
    
    # 解析每个分区
    partitions = []
    
    # 分割各个分区
    partition_items = partitions_part.split(',')
    
    for item in partition_items:
        item = item.strip()
        if not item:
            continue
        
        # 匹配分区格式: size@offset(name)
        partition_match = re.match(r'([^@(]+)@([^(]+)\(([^)]+)\)', item)
        if partition_match:
            size_str = partition_match.group(1)
            offset_str = partition_match.group(2)
            name = partition_match.group(3)
            
            # 解析大小和偏移量
            try:
                if size_str.lower().startswith('0x'):
                    size = int(size_str, 16)
                else:
                    size = int(size_str)
                
                if offset_str.lower().startswith('0x'):
                    offset = int(offset_str, 16)
                else:
                    offset = int(offset_str)
                
                end = offset + size
                
                partitions.append({
                    'name': name,
                    'offset': offset,
                    'size': size,
                    'end': end
                })
            except ValueError:
                continue
    
    if not partitions:
        print(f"{source_name} 错误: 未找到有效的分区")
        return device_part, []
    
    return device_part, partitions

def print_partition_table(device_part, partitions, table_title):
    """打印分区表"""
    print(f"\n=== {table_title} ===")
    if not partitions:
        return
    
    # 计算最大宽度用于对齐
    max_start_len = max(len(f"0x{p['offset']:x}") for p in partitions)
    max_end_len = max(len(f"0x{p['end']:x}") for p in partitions)
    
    # 打印分区表
    print(f"设备: {device_part}")
    print("-" * 80)
    
    for p in partitions:
        start_hex = f"0x{p['offset']:x}"
        end_hex = f"0x{p['end']:x}"
        size_hex = f"0x{p['size']:x}"
        size_human = format_size(p['size'])
        
        # 手动构建对齐字符串
        start_padded = start_hex + ' ' * (max_start_len - len(start_hex))
        end_padded = end_hex + ' ' * (max_end_len - len(end_hex))
        size_hex_padded = size_hex + ' ' * (10 - len(size_hex))
        size_human_padded = size_human + ' ' * (12 - len(size_human))
        
        line = '分区: [' + start_padded + ' - ' + end_padded + '], 大小: ' + size_hex_padded + ' --> ' + size_human_padded + ' : "' + p['name'] + '"'
        print(line)

def parse_mtdpart_from_bootargs(bootargs_str):
    """从 bootargs 中解析 mtdparts 参数"""
    if not bootargs_str:
        return None, []
    
    # 查找 mtdparts 参数
    mtdparts_match = re.search(r'mtdparts=([^\s]+)', bootargs_str)
    if not mtdparts_match:
        return None, []
    
    return parse_partition_string(mtdparts_match.group(1), "Bootargs 中的 mtdparts")

def parse_mtdparts(input_str):
    """解析独立的 mtdparts 环境变量"""
    # 匹配完整的 mtdparts= 环境变量行
    mtdparts_match = re.search(r'^mtdparts=([^\n]+)', input_str, re.MULTILINE)
    
    if not mtdparts_match:
        return None, []
    
    return parse_partition_string(mtdparts_match.group(1), "独立的 mtdparts")

# 获取输入
input_str = os.environ.get('MTDPARTS_INPUT', '')

found_any_partition = False

# 从 bootargs 中解析 mtdparts
bootargs_match = re.search(r'bootargs=([^\n]+)', input_str)
if bootargs_match:
    device_part, partitions = parse_mtdpart_from_bootargs(bootargs_match.group(1))
    if device_part and partitions:
        print_partition_table(device_part, partitions, "Bootargs 中的 MTD 分区表")
        found_any_partition = True

# 解析独立的 mtdparts
device_part, partitions = parse_mtdparts(input_str)
if device_part and partitions:
    print_partition_table(device_part, partitions, "独立 mtdparts 分区表")
    found_any_partition = True

# 如果没有找到任何分区表，显示提示
if not found_any_partition:
    print("\n未找到任何有效的 MTD 分区表信息")
    print("请确保输入数据中包含以下任意一种格式的分区表：")
    print("1. bootargs 中的 mtdparts 参数")
    print("2. 独立的 mtdparts 环境变量")

print()
END
    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
