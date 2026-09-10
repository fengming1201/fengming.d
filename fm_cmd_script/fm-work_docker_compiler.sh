#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile_path=$(readlink -f "$0")
# shellcheck disable=SC2034  # 模板保留变量，供需要时使用
scriptfile_name=$(basename "${scriptfile_path}")
# shellcheck disable=SC2034  # 模板保留变量，供需要时使用
scriptfile_dir=$(dirname "${scriptfile_path}")

#start here add your code,you need to implement the following function.
docker_compiler_platform_map2_container=${HOME}/.docker_compiler_map.conf

# parameter: $1: map_file
function _data_base_add_example() {
    cat <<-EOF >> "$1"
#Example:
# bipc_fh8626=container4_bipc_fh8626_compiler
# bipc_fh8852=container4_bipc_fh8852_compiler
# fh1x=container4_fastboot_fh885x_compiler
# jzt40=container4_fastboot_jztxx_compiler
# fh8626v3x=container4_fastboot_fh8626_compiler
# mc632x=container4_fastboot_mc632x_compiler
# new_fh8852v201=container4_newfw_fh885x_compiler
# new_fh8626v300=container4_newfw_fh8626v3x_compiler
# new_jzt23=container4_newfw_jzt23_compiler
# new_jzt33=container4_newfw_jzt33_compiler
# new_mc632x=container4_newfw_mc6321_compiler
mcu51=container4_mcu51_compiler
stm32=container4_stm32_compiler
esp32=container4_esp32_compiler
easyarm=container4_easyarm_compiler
pico=container4_pico_compiler

EOF
}

# 以 docker_compiler_platform_map2_container 为数据库文件的 key-value 操作接口
#   init           : 数据库文件不存在时创建并写入格式说明注释
#   get key        : 返回 value，key/value 缺失或未命中时返回空
#   set key value  : 修改已有键值或追加新键值对
#   del key        : 删除键值对
#   list           : 在一行中打印所有 key
#   show           : 打印数据库中有效key-value对
function _data_base_operation() {
    local cmd="${1:-}"
    local map_file="${docker_compiler_platform_map2_container}"
    local plat value
    local -a keys=()

    case "$cmd" in
        init)
            # 重建映射表：先自动备份原文件，避免 -I 误操作丢失已有映射
            if [[ -f "$map_file" ]]; then
                local bak_file
                bak_file="${map_file}.bak.$(date +%Y%m%d%H%M%S)"
                if cp -a "$map_file" "$bak_file"; then
                    echo "backup old map config -> ${bak_file}"
                else
                    echo "Warning: backup failed, old map config will be overwritten" >&2
                fi
            fi
            echo "#  key-value format：platform=container_name" > "$map_file"
            _data_base_add_example "${map_file}"
            echo "create new map config:"
            cat "${map_file}"
            return 0
            ;;
        set)
            local key="$2"
            local new_value="$3"
            local found=false
            local line plat

            [[ -z "$key" || -z "$new_value" ]] && return 0
            key="${key//[[:space:]]/}"
            new_value="${new_value//[[:space:]]/}"
            [[ -z "$key" || -z "$new_value" ]] && return 0

            if [[ ! -f "$map_file" ]]; then
                _data_base_operation init || return 1
            fi

            local tmp_file
            tmp_file=$(mktemp) || return 1
            while IFS= read -r line || [[ -n "$line" ]]; do
                if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "${line//[[:space:]]}" ]]; then
                    printf '%s\n' "$line" >> "$tmp_file"
                    continue
                fi
                plat="${line%%=*}"
                plat="${plat//[[:space:]]/}"
                if [[ -n "$plat" && "$plat" == "$key" ]]; then
                    printf '%s=%s\n' "$key" "$new_value" >> "$tmp_file"
                    found=true
                else
                    printf '%s\n' "$line" >> "$tmp_file"
                fi
            done < "$map_file"
            if [[ "$found" = false ]]; then
                printf '%s=%s\n' "$key" "$new_value" >> "$tmp_file"
            fi
            mv "$tmp_file" "$map_file"
            return 0
            ;;
        get)
            local key="$2"
            [[ -z "$key" ]] && return 0
            [[ ! -f "$map_file" ]] && return 0
            while IFS='=' read -r plat value _rest; do
                [[ "$plat" =~ ^[[:space:]]*# ]] && continue
                [[ -z "${plat//[[:space:]]}" ]] && continue
                plat="${plat//[[:space:]]/}"
                value="${value%%#*}"
                value="${value//[[:space:]]/}"
                [[ -z "$plat" || -z "$value" ]] && continue
                if [[ "$plat" == "$key" ]]; then
                    echo "$value"
                    return 0
                fi
            done < "$map_file"
            return 0
            ;;
        del)
            local key="$2"
            local line plat
            local found=false

            [[ -z "$key" ]] && return 0
            key="${key//[[:space:]]/}"
            [[ -z "$key" ]] && return 0
            if [[ ! -f "$map_file" ]]; then
                echo "Error: key not found: $key" >&2
                return 1
            fi

            local tmp_file
            tmp_file=$(mktemp) || return 1
            while IFS= read -r line || [[ -n "$line" ]]; do
                if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "${line//[[:space:]]}" ]]; then
                    printf '%s\n' "$line" >> "$tmp_file"
                    continue
                fi
                plat="${line%%=*}"
                plat="${plat//[[:space:]]/}"
                if [[ -n "$plat" && "$plat" == "$key" ]]; then
                    found=true
                    continue
                fi
                printf '%s\n' "$line" >> "$tmp_file"
            done < "$map_file"
            if [[ "$found" = false ]]; then
                rm -f "$tmp_file"
                echo "Error: key not found: $key" >&2
                return 1
            fi
            mv "$tmp_file" "$map_file"
            return 0
            ;;
        list)
            [[ ! -f "$map_file" ]] && return 0
            while IFS='=' read -r plat value _rest; do
                [[ "$plat" =~ ^[[:space:]]*# ]] && continue
                [[ -z "${plat//[[:space:]]}" ]] && continue
                plat="${plat//[[:space:]]/}"
                value="${value%%#*}"
                value="${value//[[:space:]]/}"
                [[ -z "$plat" || -z "$value" ]] && continue
                keys+=("$plat")
            done < "$map_file"
            [[ ${#keys[@]} -gt 0 ]] && echo "${keys[*]}"
            return 0
            ;;
        show)
            [[ ! -f "$map_file" ]] && return 0
            while IFS='=' read -r plat value _rest; do
                [[ "$plat" =~ ^[[:space:]]*# ]] && continue
                [[ -z "${plat//[[:space:]]}" ]] && continue
                plat="${plat//[[:space:]]/}"
                value="${value%%#*}"
                value="${value//[[:space:]]/}"
                [[ -z "$plat" || -z "$value" ]] && continue
                echo "$plat=$value"
            done < "$map_file"
            return 0
            ;;
        *)
            echo "Error: unknown database command: $cmd (supported: init, get, set, del, list, show)" >&2
            return 1
            ;;
    esac
}

function is_subpath
{
    local parent="$1"
    local child="$2"
    # 规范化路径（即使路径不存在也能处理）
    parent=$(realpath -m "$parent")
    child=$(realpath -m "$child")

    # 如果父路径是根目录，则任何路径都在其下
    if [[ "$parent" == "/" ]]; then
        return 0
    fi
    # 允许两个路径完全相等
    if [[ "$parent" == "$child" ]]; then
        return 0
    fi

    # 判断 child 是否以 parent/ 开头（防止 /home/foo 匹配 /home/foobar）
    case "$child" in
        "$parent"/*) return 0 ;;
        *) return 1 ;;
    esac
}

# 转义 sed 正则中的元字符（用于模式部分）
# parameter: $1: 原始字符串
function _sed_escape_pattern() {
    printf '%s' "$1" | sed 's/[][\\.^$*+?(){}|/&]/\\&/g'
}

# 转义 sed 替换串中的特殊字符（用于替换部分，分隔符固定为 |）
# parameter: $1: 原始字符串
function _sed_escape_replacement() {
    printf '%s' "$1" | sed 's/[\\|&]/\\&/g'
}

# 将文本中的宿主机工作目录（含 ~/ 写法）替换为容器内的映射目录
# parameter: $1: 待处理文本  $2: 宿主机路径  $3: 容器内路径
function _map_host_path_to_docker() {
    local text="$1" host_path="$2" docker_path="$3"
    local host_sed docker_sed
    host_sed=$(_sed_escape_pattern "${host_path}")
    docker_sed=$(_sed_escape_replacement "${docker_path}")
    printf '%s' "${text}" | sed -e "s|${host_sed}|${docker_sed}|g" -e "s|~/|${docker_sed}/|g"
}

# 打印所有平台名；若某平台对应的容器当前未运行，则在该平台名后追加 "*"
# 只调用一次 docker ps 取出运行中容器清单，再在 shell 内比对，避免逐平台调用 docker
function _platform_list_with_running_state() {
    local -a plats=()
    local plat ctr running_names running_list out=""
    while IFS= read -r plat; do
        [[ -n "$plat" ]] && plats+=("$plat")
    done < <(_data_base_operation list | tr ' ' '\n')
    [[ ${#plats[@]} -eq 0 ]] && return 0

    if running_names=$(docker ps --format '{{.Names}}' 2>/dev/null); then
        running_list=$'\n'"${running_names}"$'\n'
        for plat in "${plats[@]}"; do
            ctr=$(_data_base_operation get "$plat")
            if [[ -z "$ctr" || "${running_list}" != *$'\n'"${ctr}"$'\n'* ]]; then
                out+="${plat}* "
            else
                out+="${plat} "
            fi
        done
        printf '%s\n' "${out% }"
    else
        # docker 不可访问（如不在 docker 组）：无法判断，原样列出平台名，不做标注
        printf '%s\n' "${plats[*]}"
    fi
}

function docker-compiler
{
    if [ $# -lt 1 ]; then
        echo "描述：此脚本的主要功能是将\"用户命令及参数\"透传到\"docker环境\"中去执行，不用登录到容器内部，十分便捷。"
        echo "      本质上是对\"docker exec -it container bash -c your_command\"长命令的封装。"
        echo ""
        echo "版本: AI_Optimization：v1.1"
        echo "用法: "
        echo "         ${FUNCNAME[0]} [options]    command args ..."
        echo "         ${FUNCNAME[0]} [options] -- command args ... #用 -- 显式地标记用户命令的开始"
        echo ""
        echo "选项(options):"
        echo "        -d|--debug                     #调试模式：不真正执行你的命令。"
        echo "        -c|--cont  [container_name]    #指定容器名称。不带参数时：列出所有已知的运行中容器。"
        echo "        -p|--plat  [platform]          #指定平台名称。不带参数时：列出所有已知的平台-容器映射。"
        echo "        -u|--uid   [uid]               #指定容器内执行的用户uid（如 -u 0 表示 root）。缺省取当前用户uid。"
        echo ""
        echo "映射表操作(mapping table operations):"
        echo "        -I|--init                             #重新初始化 $docker_compiler_platform_map2_container "
        echo "        -A|--add   platform  container_name   #向 $docker_compiler_platform_map2_container 添加一条新的\"平台-容器\"映射"
        echo "        -D|--del   platform                   #从 $docker_compiler_platform_map2_container 删除一条\"平台-容器\"映射"
        echo "        -S|--show                             #显示 $docker_compiler_platform_map2_container 中的\"平台-容器\"映射"
        echo ""
        echo "注意1：当用户命令中含有（&&、||、;、|）时，会被外层的shell提前解析，所以正确透传方法如下："
        echo "      错误：${FUNCNAME[0]}   make clean && make all     # 只有 'make clean' 透传到docker 中执行，make all 被外层shell拦下。"
        echo "      正确：${FUNCNAME[0]}  \"make clean && make all\"    # 用双引号括起来，整体作为用户命令，阻止外部shell解析。"
        echo "      正确：${FUNCNAME[0]}  'make clean && make all'    # 用单引号括起来，整体作为用户命令，阻止外部shell解析。"
        echo ""
        echo "注意2：第一个非选项参数视为用户命令；其后的所有参数同样视为用户命令参数，（包括 -d/-p/-c/-u/-I/-A/-D/-S 等与本脚本选项同名的参数）"
        echo "      都会原样传给用户命令，本脚本不再解析。因此请把本脚本的选项放在用户命令之前。"
        echo "      例如：${FUNCNAME[0]} -p mc632x ./AllInOne4_mc632x_build.sh all -d   # -d 会传给构建脚本"
        echo "      如果用户命令本身以 '-' 开头，请用 '--' 分隔：${FUNCNAME[0]} -p mc632x -- -ls"
        echo ""
        echo "示例0 : ${FUNCNAME[0]} -p mc632x     4who  #显示容器信息"
        echo "示例1 : ${FUNCNAME[0]} -p mc632x     ./AllInOne4_fh8626v3x_build.sh all"
        echo "示例2 : ${FUNCNAME[0]} -p mc632x     ./AllInOne4_mc632x_build.sh    all --no-pack"
        echo "示例3 : ${FUNCNAME[0]} -p mc632x     ./AllInOne4_mc632x_build.sh    -pFS"
        echo "示例4 : ${FUNCNAME[0]} -p mc632x     make all"
        echo "示例5 : ${FUNCNAME[0]} -p mc632x    \"make clean && make all > build.log 2>&1\""
        echo "示例6 : ${FUNCNAME[0]} -p mc632x     ls -lh ~/Docker_Images_Build/  # 其中~/或\${HOME}会被替换"
        echo "示例7 : ${FUNCNAME[0]} -p mc632x     ls /root/  # 容器内操作没有权限可以加sudo"
        echo "示例8 : ${FUNCNAME[0]} -p mc632x     sudo apt install package  # 临时给容器安装软件，永久安装应放在构建镜像阶段。"
        echo "示例9 : ${FUNCNAME[0]} -p mc632x --  ls -lh   #'--' 标记其后是用户命令的开始,应对复杂情况"
        echo "示例10: ${FUNCNAME[0]} -p                     # 不带参数：列出所有已知的平台-容器映射：$docker_compiler_platform_map2_container"
        echo "示例11: ${FUNCNAME[0]} -c                     # 不带参数：列出所有已知的运行中容器"
        echo "示例12: ${FUNCNAME[0]} -c container_name \"make clean && make all\" "
        echo "示例13: export g_platform=mc632x;              #常驻环境变量中,可免每次加该选项。可以用-p选项覆盖"
        echo "示例14: export g_container_name=mycontainer;   #常驻环境变量中,可免每次加该选项。可以用-c选项覆盖"
        echo ""
        if [ -n "${g_container_name}" ] || [ -n "${g_platform}" ];then
            echo "注意：已检测到环境变量"
            echo "g_container_name=${g_container_name}"
            echo "g_platform=${g_platform}"
        else
            echo "默认值也可以通过环境变量修改："
            echo "export g_container_name="
            echo "export g_platform="
            echo ""
            echo "如果你打算长期或频繁使用同一个编译环境，建议把它写入 ~/.bashrc"
        fi
        if [[ ! -f "${docker_compiler_platform_map2_container}" ]]; then
            _data_base_operation init || return 1
            echo "警告：映射文件 [${docker_compiler_platform_map2_container}] 为空，"
            echo "        你需要向其中添加一些 platform=container 映射条目。"
        else
            local platform_list
            platform_list=$(_platform_list_with_running_state)
            echo ""
            echo "当前支持的平台[*未运行]: ${platform_list}"
        fi
        return 0
    fi
    # 注意：docker 可用性检查已下移到 step 2.5（选项解析、映射表操作之后），
    #       这样 -I/-A/-D/-S 等纯本地映射表操作不依赖 docker 权限即可使用。
    #default values
    local ret=0
    local docker_container_name="${g_container_name:-}"
    local platform="${g_platform:-}"
    local user_id
    local debug=false
    local sub_cmd=""
    local sub_cmd_args=()
    local i combined_consumed arg
    user_id=$(id -u)
    #================================================================#
    #step 1: process parameters,parse script options
    local remaining_args=()
    # 解析规则：第一个非选项参数即“用户命令”的开始。
    # 一旦用户命令出现，其后的所有参数（包括 -d/-p/-c/-u 等与脚本选项同名的参数）
    # 全部原样归入用户命令，不再解析为脚本选项。
    # 例: -p mc632x ./AllInOne4_mc632x_build.sh all -d 中的 -d 属于用户命令
    # 若用户命令本身以 - 开头，可用 -- 显式分隔（见 -- 分支）。
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            --)
                # POSIX 分界符：-- 之后全部归用户命令，不再解析为脚本选项
                shift
                remaining_args+=("$@")
                break
                ;;
            -d|--debug) debug=true; shift ;; #不带参数，移动1
            -c|--cont)
                if [[ -z "$2" ]]; then echo "All known running container list: ";docker ps -a --format "{{.Names}}"; return 1; fi
                docker_container_name="$2"; shift 2 ;; #带参数，移动2
            -p|--plat)
                if [[ -z "$2" ]]; then echo "All known platforms-container mapping list: ";_data_base_operation show; return 1; fi
                platform="$2"; shift 2 ;; #带参数，移动2
            -u|--uid)
                if [[ -z "$2" ]]; then echo "ERROR: -u|--uid needs a uid, e.g. -u 0 (root) or -u 1000" >&2; return 1; fi
                if [[ ! "$2" =~ ^[0-9]+$ ]]; then echo "ERROR: invalid uid: $2 (must be a number)" >&2; return 1; fi
                user_id="$2"; shift 2 ;; #带参数，移动2
            -I|--init)
                sub_cmd=INIT; sub_cmd_args=(); shift 1 ;; #不带参数，移动1
            -A|--add)
                if [[ -z "$2" || -z "$3" ]]; then echo "ERROR: not found platform or container_name" >&2; return 1; fi
                sub_cmd=ADD; sub_cmd_args=("$2" "$3"); shift 3 ;; #带2参数，移动3
            -D|--del)
                if [[ -z "$2" ]]; then echo "ERROR: not found platform" >&2; return 1; fi
                sub_cmd=DEL; sub_cmd_args=("$2"); shift 2 ;; #带1参数，移动2
            -S|--show)
                sub_cmd=LIST; sub_cmd_args=(); shift 1 ;; #不带参数，移动1
            -)
                # 单独的 "-" 视为用户命令（如 cat - 之类），不作脚本选项
                remaining_args+=("$@")
                break
                ;;
            -*)
                # 能走到这里，说明用户命令尚未开始，只可能是脚本选项区的合并短选项，如 -d
                # combined_consumed: 记录本分支是否已自行 shift，避免循环末尾重复 shift 吞掉下一个参数
                combined_consumed=0
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        d) debug=true ;;
                        c) if [[ -z "$2" ]]; then echo "ERROR: -c|--cont needs container_name" >&2; return 1; fi
                           docker_container_name="$2"; shift 2; combined_consumed=1; break ;;
                        p) if [[ -z "$2" ]]; then echo "ERROR: -p|--plat needs platform" >&2; return 1; fi
                           platform="$2"; shift 2; combined_consumed=1; break ;;
                        u) if [[ -z "$2" || ! "$2" =~ ^[0-9]+$ ]]; then echo "ERROR: -u|--uid needs a numeric uid" >&2; return 1; fi
                           user_id="$2"; shift 2; combined_consumed=1; break ;;
                        I) sub_cmd=INIT; sub_cmd_args=(); shift; combined_consumed=1; break ;;
                        A) if [[ -z "$2" || -z "$3" ]]; then echo "ERROR: -A|--add needs platform and container_name" >&2; return 1; fi
                           sub_cmd=ADD; sub_cmd_args=("$2" "$3"); shift 3; combined_consumed=1; break ;;
                        D) if [[ -z "$2" ]]; then echo "ERROR: -D|--del needs platform" >&2; return 1; fi
                           sub_cmd=DEL; sub_cmd_args=("$2"); shift 2; combined_consumed=1; break ;;
                        S) sub_cmd=LIST; sub_cmd_args=(); shift; combined_consumed=1; break ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                [[ ${combined_consumed} -eq 0 ]] && shift ;;
            *)
                # 第一个非选项参数 = 用户命令开始：剩余所有参数（含 -d/-p 等）整体归入用户命令
                remaining_args+=("$@")
                break
                ;;
        esac
    done
    #优先处理本脚本选项（纯本地映射表操作，不需要 docker 权限）
    if [ -n "${sub_cmd}" ]; then
        case "${sub_cmd}" in
            INIT) _data_base_operation init ;;
            ADD)  _data_base_operation set "${sub_cmd_args[@]}" ;;
            DEL)  _data_base_operation del "${sub_cmd_args[@]}" || return $? ;;
            LIST) _data_base_operation show "${sub_cmd_args[@]}" ;;
        esac
        return $?
    fi
    if [ ${#remaining_args[@]} -lt 1 ]; then
        echo "Error: command list is empty!"
        echo "  Usage: "
        echo "         ${FUNCNAME[0]} [options] [--] \"command args ...\""
        echo "Example: ${FUNCNAME[0]} -p $platform  make menuconfig"
        echo "Example: ${FUNCNAME[0]} -p $platform  make all"
        echo "Example: ${FUNCNAME[0]} -p $platform  ./configuer --prefix=/usr/local/"
        return 3
    fi
    #================================================================#
    # step 2: get docker container name by platform
    if [[ -z "${docker_container_name}" && -n "${platform}" ]]; then
        docker_container_name=$(_data_base_operation get "$platform")
        if [[ -z "$docker_container_name" ]]; then
            if [[ ! -f "${docker_compiler_platform_map2_container}" ]]; then
                echo "Error: platform map file not found: ${docker_compiler_platform_map2_container}" >&2
            else
                echo "Error: not found docker container name for this platform: $platform" >&2
                echo "       check map file: ${docker_compiler_platform_map2_container}" >&2
            fi
            return 4
        fi
    fi
    # check docker container name
    if [[ -z "${docker_container_name}" ]];then
        echo "Error: unknown container_name! you must give platform or container_name" >&2
        echo "Example: ${FUNCNAME[0]} -p platform \"command args ...\""
        echo "Example: ${FUNCNAME[0]} -c container_name \"command args ...\""
        return 5
    fi
    if [[ "${debug}" == true ]];then
        echo "INFO:platform=${platform}"
        echo "INFO:docker_container_name=${docker_container_name}"
    fi
    #================================================================#
    # step 2.5: check docker daemon accessibility
    # 用真实能力判断：rootless docker / socket ACL / sudo 等场景下，单纯判断 docker 组名会误判
    if ! docker ps >/dev/null 2>&1; then
        if [ "$(id -u)" -ne 0 ] && ! id -nG | grep -qw docker; then
            echo "you need to do:"
            echo "step1:sudo usermod -aG docker \$USER    # Add current user to docker group"
            echo "step2:exec newgrp docker                # Replace the current shell with a new one"
        else
            echo "Error: docker daemon is not accessible (is it running?)" >&2
        fi
        return 2
    fi
    #================================================================#
    # step 3: check if the docker container exists and is running
    # 注意：docker ps -a 会列出已停止容器，不能用它判断“运行中”
    local container_state
    container_state=$(docker inspect -f '{{.State.Status}}' "$docker_container_name" 2>/dev/null)
    if [[ -z "${container_state}" ]]; then
        echo "Error: docker container not found: $docker_container_name" >&2
        return 6
    fi
    if [[ "${container_state}" != "running" ]]; then
        echo "Error: docker container is not running (state: ${container_state}): $docker_container_name" >&2
        echo "       try: docker start $docker_container_name" >&2
        return 6
    fi
    #================================================================#
    # step 4: get docker volume mapping and convert current_dir to docker_inner_path
    #docker volume mapping: like: /home/lshm -> /home/duser/workdir
    local docker_volume_mapping
    docker_volume_mapping=$(docker inspect -f '{{ range .Mounts }}{{ if or (eq .Destination "/home/duser/workdir") (eq .Destination "/root/workdir") }}{{ .Source }} -> {{ .Destination }}{{ "\n" }}{{ end }}{{ end }}' "$docker_container_name" 2>/dev/null)
    # 同一宿主目录可能同时挂到 /home/duser/workdir 与 /root/workdir，此时会有多行，
    # 需按 uid 选一行。这里用 user_id（即容器内实际执行身份，默认取宿主 uid，可被 -u 覆盖），
    # 而不是宿主的 id -u，避免 `-u 0` 时 exec 成 root 却仍按 duser 的目录映射。
    # 注意：command substitution 会去掉结尾换行，所以不能用 wc -l 判断行数
    #       （两行文本的 wc -l 结果是 1，会误判为单行而跳过过滤），改用是否含换行符判断。
    if [[ "${docker_volume_mapping}" == *$'\n'* ]];then
        # 按“目标路径”精确匹配（而不是 grep -w root/duser 匹配整行），
        # 避免宿主源路径里恰好含 root/duser 字样时选错行
        if [ "${user_id}" -eq 0 ];then
            docker_volume_mapping=$(printf '%s\n' "${docker_volume_mapping}" | grep -F -e '-> /root/workdir' | head -1)
        else
            docker_volume_mapping=$(printf '%s\n' "${docker_volume_mapping}" | grep -F -e '-> /home/duser/workdir' | head -1)
        fi
    fi
    # 映射为空时提前给出明确错误，避免后续 sed/realpath 产生难以理解的噪音
    if [[ -z "${docker_volume_mapping}" ]]; then
        echo "Error: no usable volume mapping found in container: $docker_container_name" >&2
        echo "       expected a mount to /home/duser/workdir or /root/workdir" >&2
        return 7
    fi
    local host_workdir_path docker_workdir_path docker_inner_path
    host_workdir_path=$(printf '%s\n' "${docker_volume_mapping}" | head -1 | awk -F '->' '{print $1}' | tr -d ' ')
    docker_workdir_path=$(printf '%s\n' "${docker_volume_mapping}" | head -1 | awk -F '->' '{print $2}' | tr -d ' ')
    # 解析不出来时给出明确错误，而不是把多行/畸形文本丢给 sed
    if [[ -z "${host_workdir_path}" || -z "${docker_workdir_path}" ]]; then
        echo "Error: failed to parse docker volume mapping: ${docker_volume_mapping}" >&2
        return 7
    fi
    #convert current_dir to docker_inner_path;e.g. /home/lshm/workdir/mc632x_test/build.sh to /home/duser/workdir/mc632x_test/build.sh
    docker_inner_path=$(_map_host_path_to_docker "$(pwd)" "${host_workdir_path}" "${docker_workdir_path}")
    if [[ "${debug}" == true ]];then
        echo "INFO:docker_volume_mapping=${docker_volume_mapping}"
        echo "INFO:    host_workdir_path=${host_workdir_path}"
        echo "INFO:  docker_workdir_path=${docker_workdir_path}"
        echo "INFO:    docker_inner_path=${docker_inner_path}"
        echo "INFO:            host_path=$(pwd)"
    fi
    # 检查当前目前是否在映射的目录之下
    if ! is_subpath "${host_workdir_path}" "$PWD"; then
        echo "ERROR[EN]: your work directory must be under ${host_workdir_path}"
        echo "         : docker volume:${docker_volume_mapping}"
        echo "ERROR[CN]: 此容器的工作目录必须位于 ${host_workdir_path}"
        echo "         : 此容器卷映射为 ${docker_volume_mapping}"
        return 8
    fi
    # step 5: packaging user command
    # 将 remaining_args 编码为可在 bash -c 中安全执行的命令字符串
    #  - 单参数时视为完整 shell 命令（如 "make clean && make all"），原样嵌入，不转义
    #  - 多参数时逐个 printf '%q'，避免空格/引号等被错误拆分；
    #    但【独立的 shell 运算符】（&&、||、;、|、<、> 等）必须原样保留：
    #    %q 会把 && 转义成 \&\&，容器内 bash 会把它当字面量而非运算符，导致 make all 之类的命令不执行
    #  - 路径替换在转义之前对每个参数做完，避免 %q 把 ~ 转义成 \~ 后无法匹配
    local user_cmd=""
    if [[ ${#remaining_args[@]} -eq 1 ]]; then
        user_cmd=$(_map_host_path_to_docker "${remaining_args[0]}" "${host_workdir_path}" "${docker_workdir_path}")
    else
        local is_operator
        for arg in "${remaining_args[@]}"; do
            arg=$(_map_host_path_to_docker "${arg}" "${host_workdir_path}" "${docker_workdir_path}")
            is_operator=false
            case "${arg}" in
                '&&'|'||'|';'|'|'|'&'|'|&'|'<'|'>'|'>>'|'<<'|'<<<'|'2>&1'|'1>&2'|'&>'|'&>>') is_operator=true ;;
            esac
            if [[ "${is_operator}" == true ]]; then
                user_cmd+="${arg} "      # 运算符原样保留，交给容器内 bash 解析
            else
                user_cmd+=$(printf '%q ' "${arg}")
            fi
        done
        user_cmd=${user_cmd% }
    fi

    # 在容器内先 cd 到映射目录，再以命令组 () 执行用户命令，避免 ;、|| 与外层 && 优先级混淆
    # 保留 bash -ic：工具链本体在 Docker ENV 里（bash -c 也有），但 LANG、别名(ll/la…)定义在
    # ~/.bashrc，而 ~/.bashrc 开头有非交互 guard（case $- in *i*) ...）会直接 return，
    # 所以非交互 bash -c 会丢掉这些设置，必须继续用 -i。
    local inner_cmd
    inner_cmd="cd -- $(printf '%q' "${docker_inner_path}") && (${user_cmd})"
    # docker 的 -t 只在 stdin/stdout 均为终端时分配：
    #   有 TTY   -> bash -i 的 job control 正常，无告警
    #   无 TTY   -> （如 docker-compiler ls | grep x）bash -i 启动时会往 stderr 打印
    #               "cannot set terminal process group" 和 "no job control in this shell"
    #               两行告警，下面在无 TTY 分支里只过滤这两行，其它 stderr 原样透传
    local tty_opt="-i"
    if [ -t 0 ] && [ -t 1 ]; then tty_opt="-it"; fi
    local -a cmd_array=(docker exec -u "${user_id}" "${tty_opt}" "${docker_container_name}" bash -ic "${inner_cmd}")
    if [[ "${debug}" == true ]];then
        echo "INFO:remaining_args=${remaining_args[*]}"
        echo "INFO:      user_cmd=${user_cmd}"
        echo "INFO:     inner_cmd=${inner_cmd}"
        echo "INFO:       tty_opt=${tty_opt}"
    fi
    #================================================================#
    # step 6: execute user command in docker container
    echo "EXEC:docker exec -u ${user_id} ${tty_opt} ${docker_container_name} bash -ic \"${inner_cmd}\""
    if [[ "${debug}" == false ]];then
        if [[ "${tty_opt}" == "-it" ]]; then
            "${cmd_array[@]}"
        else
            "${cmd_array[@]}" 2> >(grep -v -e 'cannot set terminal process group' -e 'no job control in this shell' >&2)
        fi
        ret=$?
    fi
    return $ret
}
#if unnecessary, please do not modify following code
# 仅在被【执行】时运行；被 source 时只定义函数，避免末尾 exit 结束调用方的 shell
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    docker-compiler "$@"
    func_ret=$?
    if [ $func_ret -ne 0 ];then exit $func_ret;fi
    exit 0
fi
