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
    CMDLINE_INPUT="${stdin_string}" python3 - <<'END'
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

def parse_cmdline(cmdline_str):
    """解析 cmdline 字符串，返回键值对字典"""
    cmdline = {}
    
    # 分割 cmdline 中的各个参数
    args = cmdline_str.split()
    for arg in args:
        if '=' in arg:
            key, value = arg.split('=', 1)
            cmdline[key] = value
        else:
            cmdline[arg] = ""
    
    return cmdline

SIZE_SUFFIX = {'k': 1024, 'm': 1024 ** 2, 'g': 1024 ** 3}

def parse_size(size_str):
    """解析大小/偏移字符串，返回字节数；'-' 或空串表示未知（剩余空间），返回 None

    支持：十六进制(0x前缀)、十进制，以及 K/M/G 后缀（大小写均可）。
    """
    s = size_str.strip()
    if s in ('', '-'):
        return None

    mult = 1
    if s[-1].lower() in SIZE_SUFFIX:
        mult = SIZE_SUFFIX[s[-1].lower()]
        s = s[:-1]

    try:
        if s.lower().startswith('0x'):
            return int(s, 16) * mult
        return int(s) * mult
    except ValueError:
        return None

def parse_partition_string(partition_str):
    """解析 mtdparts 字符串并返回 (设备, 分区列表)

    兼容以下分区项写法（可混合使用）：
        size@offset(name)   显式指定大小和偏移，如 0x30000@0(bootstrap)
        size(name)          仅指定大小，偏移自动紧接上一个分区，如 256k(bootstrap)
        size@(name)         偏移留空，等同于 size(name)
        -(name)             表示剩余空间，如 -(reserve)
    大小/偏移支持十六进制(0x)、十进制及 K/M/G 后缀。
    """
    # 分割设备和分区
    if ':' not in partition_str:
        print("错误: 分区格式不正确")
        return None, []

    device_part, partitions_part = partition_str.split(':', 1)

    partitions = []
    auto_offset = 0  # 未显式给出偏移时的自动累加偏移

    # 分割各个分区
    partition_items = partitions_part.split(',')

    for item in partition_items:
        item = item.strip()
        if not item:
            continue

        # 先拆出末尾的 (name)，其余部分为 size 或 size@offset
        match = re.match(r'^(?P<body>[^()]*)\((?P<name>[^)]*)\)\s*$', item)
        if not match:
            continue

        name = match.group('name').strip()
        body = match.group('body').strip()

        if '@' in body:
            size_str, offset_str = body.split('@', 1)
            size = parse_size(size_str)
            offset = parse_size(offset_str)
        else:
            size = parse_size(body)
            offset = None

        if offset is None:
            offset = auto_offset

        if size is None:
            # 剩余空间：结束位置未知
            end = None
            auto_offset = None
        else:
            end = offset + size
            auto_offset = end

        partitions.append({
            'name': name,
            'offset': offset,
            'size': size,
            'end': end
        })

    if not partitions:
        print("错误: 未找到有效的分区")
        return device_part, []

    return device_part, partitions

def print_table(headers, rows):
    """打印表格"""
    if not rows:
        return
    
    # 计算列宽
    col_widths = []
    for i in range(len(headers)):
        max_width = len(headers[i])
        for row in rows:
            if i < len(row):
                max_width = max(max_width, len(str(row[i])))
        col_widths.append(max_width)
    
    # 打印标题
    header_line = "|".join(f" {header:<{col_width}}".rstrip() for header, col_width in zip(headers, col_widths))
    print(f"+{'+'.join('-' * (w + 2) for w in col_widths)}+")
    print(f"|{header_line}|")
    print(f"+{'+'.join('=' * (w + 2) for w in col_widths)}+")
    
    # 打印行
    for row in rows:
        row_line = "|".join(f" {str(item):<{col_width}}".rstrip() for item, col_width in zip(row, col_widths))
        print(f"|{row_line}|")
    
    # 打印底部边框
    print(f"+{'+'.join('-' * (w + 2) for w in col_widths)}+")

# 获取输入
input_str = os.environ.get('CMDLINE_INPUT', '')

# 清理输入，去掉可能的 "cat /proc/cmdline" 行
if 'cat /proc/cmdline' in input_str:
    cmdline_str = input_str.split('cat /proc/cmdline', 1)[1].strip()
else:
    cmdline_str = input_str.strip()

# 解析 cmdline
cmdline = parse_cmdline(cmdline_str)

# 打印所有键值对
print("\nKey-Value Pairs:")
print("================")
if cmdline:
    for key, value in cmdline.items():
        if key != 'mtdparts':  # 跳过mtdparts，因为它会在后面单独解析
            print(f"{key}={value}")
else:
    print("未找到有效的键值对")

# 解析并打印 mtdparts
print("\n=== MTD 分区表 ===")
if 'mtdparts' in cmdline:
    device_part, partitions = parse_partition_string(cmdline['mtdparts'])
    if device_part and partitions:
        print(f"设备: {device_part}")
        print("-" * 80)

        def hex_or_dash(value):
            return f"0x{value:x}" if value is not None else "-"

        # 计算最大宽度用于对齐
        max_start_len = max(len(hex_or_dash(p['offset'])) for p in partitions)
        max_end_len = max(len(hex_or_dash(p['end'])) for p in partitions)

        for p in partitions:
            start_hex = hex_or_dash(p['offset'])
            end_hex = hex_or_dash(p['end'])
            if p['size'] is None:
                size_hex = "-"
                size_human = "剩余"
            else:
                size_hex = f"0x{p['size']:x}"
                size_human = format_size(p['size'])

            # 手动构建对齐字符串
            start_padded = start_hex + ' ' * (max_start_len - len(start_hex))
            end_padded = end_hex + ' ' * (max_end_len - len(end_hex))
            size_hex_padded = size_hex + ' ' * (10 - len(size_hex))
            size_human_padded = size_human + ' ' * (12 - len(size_human))

            print(f'区间: [{start_padded} - {end_padded}], 大小: {size_hex_padded} --> {size_human_padded} : "{p["name"]}"')
    else:
        print("未找到有效的 MTD 分区")
else:
    print("未找到 mtdparts 参数")

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
