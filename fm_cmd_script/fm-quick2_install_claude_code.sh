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
    echo "  在 Debian/Ubuntu 上快速安装 Claude Code（Node.js 20 + npm + @anthropic-ai/claude-code）"
    echo "  支持环境检测、已安装检查、依赖检查；可用 -t 测试模式、-m check 仅检查"
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



function func_cmd_exists
{
    command -v "$1" > /dev/null 2>&1
}

function func_run_or_echo
{
    local test_mode=$1
    shift
    if [ "${test_mode}" = true ]; then
        echo "[TEST] $*"
        return 0
    fi
    eval "$@"
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example: func_check_os
# return: 0=Debian/Ubuntu, 1=不支持
##
function func_check_os
{
    if [ ! -f /etc/os-release ]; then
        echo "ERROR: 无法识别操作系统，本脚本仅支持 Debian/Ubuntu" >&2
        return 1
    fi
    # shellcheck disable=SC1091
    . /etc/os-release
    case "${ID}${ID_LIKE}" in
        *debian*|*ubuntu*)
            echo "系统: ${PRETTY_NAME:-${ID}}"
            return 0
            ;;
        *)
            echo "ERROR: 本脚本仅支持 Debian 或 Ubuntu，当前: ${PRETTY_NAME:-${ID}}" >&2
            return 1
            ;;
    esac
}

##Parameter Counts      : 0
# return: 0=已安装, 1=未安装
##
function func_check_claude_installed
{
    if func_cmd_exists claude; then
        local ver
        ver=$(claude --version 2>/dev/null)
        echo "Claude Code 已安装: ${ver:-未知版本}"
        return 0
    fi
    echo "Claude Code 未安装"
    return 1
}

##Parameter Counts      : 0
# return: 0=满足要求, 1=未安装或版本过低
##
function func_check_node
{
    local min_major=20
    if ! func_cmd_exists node; then
        echo "Node.js 未安装（需要 >= v${min_major}.x）"
        return 1
    fi
    local ver major
    ver=$(node --version 2>/dev/null | sed 's/^v//')
    major=$(echo "${ver}" | cut -d. -f1)
    if [ -z "${major}" ] || [ "${major}" -lt "${min_major}" ] 2>/dev/null; then
        echo "Node.js 版本不满足要求: v${ver:-未知}，需要 >= v${min_major}.x"
        return 1
    fi
    echo "Node.js 已安装: v${ver}"
    return 0
}

##Parameter Counts      : 0
# return: 0=已安装, 1=未安装
##
function func_check_npm
{
    if func_cmd_exists npm; then
        echo "npm 已安装: v$(npm --version 2>/dev/null)"
        return 0
    fi
    echo "npm 未安装"
    return 1
}

##Parameter Counts      : 2
# $1=test_mode, $2=debug
##
function func_install_curl
{
    local test_mode=$1
    if func_cmd_exists curl; then
        echo "curl 已安装"
        return 0
    fi
    echo "安装 curl..."
    func_run_or_echo "${test_mode}" "${maybeSUDO} apt update && ${maybeSUDO} apt install -y curl"
    if [ "${test_mode}" = false ] && ! func_cmd_exists curl; then
        echo "ERROR: curl 安装失败" >&2
        return 1
    fi
    return 0
}

##Parameter Counts      : 2
# $1=test_mode, $2=debug
##
function func_install_node
{
    local test_mode=$1
    if func_check_node; then
        return 0
    fi
    echo "安装 Node.js 20.x（NodeSource）..."
    if [ "${test_mode}" = true ]; then
        echo "[TEST] curl -fsSL https://deb.nodesource.com/setup_20.x | ${maybeSUDO} bash -"
        echo "[TEST] ${maybeSUDO} apt install -y nodejs"
        return 0
    fi
    curl -fsSL https://deb.nodesource.com/setup_20.x | ${maybeSUDO} bash - || {
        echo "ERROR: NodeSource 仓库配置失败" >&2
        return 1
    }
    ${maybeSUDO} apt install -y nodejs || {
        echo "ERROR: nodejs 安装失败" >&2
        return 1
    }
    func_check_node || {
        echo "ERROR: Node.js 安装后仍不满足版本要求" >&2
        return 1
    }
    return 0
}

##Parameter Counts      : 2
# $1=test_mode, $2=debug
##
function func_install_npm_pkg
{
    local test_mode=$1
    if func_check_npm; then
        return 0
    fi
    echo "安装 npm..."
    func_run_or_echo "${test_mode}" "${maybeSUDO} apt install -y npm"
    if [ "${test_mode}" = false ] && ! func_check_npm; then
        echo "ERROR: npm 安装失败" >&2
        return 1
    fi
    return 0
}

##Parameter Counts      : 2
# $1=test_mode, $2=debug
##
function func_install_claude_code
{
    local test_mode=$1
    if func_check_claude_installed; then
        return 0
    fi
    echo "安装 Claude Code（npm global）..."
    func_run_or_echo "${test_mode}" "${maybeSUDO} npm install -g @anthropic-ai/claude-code"
    if [ "${test_mode}" = true ]; then
        return 0
    fi
    func_check_claude_installed || {
        echo "ERROR: Claude Code 安装失败，请检查 npm 全局路径是否在 PATH 中" >&2
        return 1
    }
    return 0
}

##Parameter Counts      : 3
# $1=test_mode, $2=debug, $3=mode(install|check)
##
function func_do_install
{
    local test_mode=$1
    local debug=$2
    local mode=$3

    echo "========== 1. 操作系统 =========="
    func_check_os || return 1

    echo ""
    echo "========== 2. 当前安装状态 =========="
    local claude_ok=false node_ok=false npm_ok=false
    func_check_claude_installed && claude_ok=true
    func_check_node && node_ok=true
    func_check_npm && npm_ok=true

    if [ "${mode}" = check ]; then
        echo ""
        echo "========== 检查结果 =========="
        if [ "${claude_ok}" = true ]; then
            echo "Claude Code 已就绪，无需安装。"
            return 0
        fi
        if [ "${node_ok}" = true ] && [ "${npm_ok}" = true ]; then
            echo "依赖已满足，可执行 '$scriptname' 安装 Claude Code。"
            return 0
        fi
        echo "依赖未完全满足，可执行 '$scriptname' 自动安装。"
        return 0
    fi

    if [ "${claude_ok}" = true ]; then
        echo ""
        echo "Claude Code 已安装，跳过。"
        return 0
    fi

    echo ""
    echo "========== 3. 安装依赖 =========="
    func_install_curl "${test_mode}" "${debug}" || return 1
    func_install_node "${test_mode}" "${debug}" || return 1
    func_install_npm_pkg "${test_mode}" "${debug}" || return 1

    echo ""
    echo "========== 4. 安装 Claude Code =========="
    func_install_claude_code "${test_mode}" "${debug}" || return 1

    echo ""
    echo "========== 完成 =========="
    if [ "${test_mode}" = true ]; then
        echo "测试模式结束，未实际安装。"
    else
        func_check_claude_installed
        echo "安装完成。运行 'claude --version' 验证；API 配置请参考 install_claude_code_on_linux.md"
    fi
    return 0
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]"
    echo "opt:"
    echo "-h or --help                  # 帮助"
    echo "-d or --debug                 # 开启调试，打印变量等"
    echo "-t or --test                  # 测试模式，不真正执行安装"
    echo "--setx                        # 开启 set -x 详细模式"
    echo "--func   func_name  args ...  # 调试某个函数,无参数--func,显示函数列表"
    echo ""
    echo "-m or --mode  install|check   # install=安装(默认), check=仅检查环境"
    echo ""
    echo "example:"
    echo "  $scriptname                  # 检测环境并安装 Claude Code"
    echo "  $scriptname -m check         # 仅检查系统/依赖/是否已安装"
    echo "  $scriptname -t               # 测试模式，打印将执行的命令"
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
    local mode=install
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

    case "${mode}" in
        install|check) ;;
        *)
            echo "ERROR: 无效 mode '${mode}'，可选: install, check" >&2
            usage
            return 1
            ;;
    esac

    if [ ${#remaining_args[@]} -gt 0 ]; then
        echo "ERROR: 本脚本不接受额外参数: ${remaining_args[*]}" >&2
        usage
        return 1
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
    fi
    #=================== start your code ==============================#
    eval "${open_setx_mode}"
    func_do_install "${test}" "${debug}" "${mode}"
    local ret=$?
    eval "${close_setx_mode}"
    return ${ret}
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
