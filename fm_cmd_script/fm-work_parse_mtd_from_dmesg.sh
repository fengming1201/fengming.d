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
    MTD_CONTENT="${stdin_string}" python3 - <<'END'
import re
import os

def format_size(size):
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

content = os.environ.get('MTD_CONTENT', '')

# 只处理在"Creating MTD partitions"之后的内容，提高准确性
creating_mtd_marker = 'Creating MTD partitions'
if creating_mtd_marker in content:
    content = content.split(creating_mtd_marker, 1)[1]

# 更精确的正则表达式，只匹配真正的MTD分区格式
# 格式通常是：0x...-0x... : "partition_name"
# 同时匹配行首可能的时间戳等内容
pattern = r'0x([0-9a-fA-F]+)-0x([0-9a-fA-F]+)\s*:\s*"([^"]+)"'
matches = re.findall(pattern, content)

# 先处理所有匹配，计算最大地址长度
partitions = []
max_start_len = 0
max_end_len = 0
max_size_hex_len = 0

for match in matches:
    start_part, end_part, name = match
    
    try:
        start = int(f"0x{start_part}", 16)
        end = int(f"0x{end_part}", 16)
        
        # 排除像0xa0000000这样的大地址（通常是内存地址，不是MTD分区）
        # MTD闪存地址通常比较小，这里设为0x10000000作为阈值
        if start >= 0x10000000:
            continue
        
        # 确保结束地址大于开始地址
        if end <= start:
            continue
        
        # 格式化地址，去掉前面多余的0
        start_hex = f"0x{start:x}"
        end_hex = f"0x{end:x}"
        size = end - start
        size_hex = f"0x{size:x}"
        
        partitions.append((start_hex, end_hex, name, start, end, size, size_hex))
        
        # 更新最大地址长度
        max_start_len = max(max_start_len, len(start_hex))
        max_end_len = max(max_end_len, len(end_hex))
        max_size_hex_len = max(max_size_hex_len, len(size_hex))
        
    except ValueError:
        # 跳过无法正确转换为整数的匹配
        continue

# 打印所有分区
for start_hex, end_hex, name, start, end, size, size_hex in partitions:
    size_human = format_size(size)
    
    # 手动构建对齐字符串，确保使用标准空格
    start_padded = start_hex + ' ' * (max_start_len - len(start_hex))
    end_padded = end_hex + ' ' * (max_end_len - len(end_hex))
    size_hex_padded = size_hex + ' ' * (10 - len(size_hex))
    size_human_padded = size_human + ' ' * (12 - len(size_human))
    
    line = '分区: [' + start_padded + ' - ' + end_padded + '], 大小: ' + size_hex_padded + ' --> ' + size_human_padded + ' : "' + name + '"'
    print(line)
END
    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
