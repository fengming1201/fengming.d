#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile_path=$(readlink -f $0)
scriptfile_name=$(basename ${scriptfile_path})
scriptfile_dir=$(dirname ${scriptfile_path})

#start here add your code,you need to implement the following function.
docker_compiler_platform_map2_container=${HOME}/.docker_compiler_map.conf

# parameter: $1: map_file
function _data_base_add_example() {
    cat <<-EOF >> $1
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
            if [[ -f "$map_file" ]]; then echo "delete old map config:";rm -v $map_file;fi
            echo "#  key-value format：platform=container_name" > "$map_file"
            _data_base_add_example ${map_file}
            echo "create new map config:"
            cat ${map_file}
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

function docker-compiler
{
    if [ $# -lt 1 ]; then
        echo "描述：此脚本的主要功能是将\"用户命令及参数\"透传到\"docker环境\"中去执行，不用登录到容器内部，十分便捷。"
        echo "      本质上是对\"docker exec -it container bash -c your_command\"长命令的封装。"
        echo "用法: "
        echo "         $FUNCNAME [options]    command args ..."
        echo "         $FUNCNAME [options] -- command args ... #用 -- 显式地标记用户命令的开始"
        echo ""
        echo "选项(options):"
        echo "        -d|--debug                     #调试模式：不真正执行你的命令。"
        echo "        -c|--cont  [container_name]    #指定容器名称。不带参数时：列出所有已知的运行中容器。"
        echo "        -p|--plat  [platform]          #指定平台名称。不带参数时：列出所有已知的平台-容器映射。"
        echo ""
        echo "映射表操作(mapping table operations):"
        echo "        -I|--init                             #重新初始化 $docker_compiler_platform_map2_container "
        echo "        -A|--add   platform  container_name   #向 $docker_compiler_platform_map2_container 添加一条新的\"平台-容器\"映射"
        echo "        -D|--del   platform                   #从 $docker_compiler_platform_map2_container 删除一条\"平台-容器\"映射"
        echo "        -S|--show  platform                   #显示 $docker_compiler_platform_map2_container 中的\"平台-容器\"映射"
        echo ""
        echo "注意1：当用户命令中含有（&&、||、;、|）时，会被外层的shell提前解析，所以正确透传方法如下："
        echo "      错误：$FUNCNAME   make clean && make all     # 只有 'make clean' 透传到docker 中执行，make all 被外层shell拦下。"
        echo "      正确：$FUNCNAME  \"make clean && make all\"    # 用双引号括起来，整体作为用户命令，阻止外部shell解析。"
        echo "      正确：$FUNCNAME  'make clean && make all'    # 用单引号括起来，整体作为用户命令，阻止外部shell解析。"
        echo ""
        echo "注意2：第一个非选项参数视为用户命令；其后的所有参数同样视为用户命令参数，（包括 -d/-p/-c/-I/-A/-D/-S 等与本脚本选项同名的参数）"
        echo "      都会原样传给用户命令，本脚本不再解析。因此请把本脚本的选项放在用户命令之前。"
        echo "      例如：$FUNCNAME -p mc632x ./AllInOne4_mc632x_build.sh all -d   # -d 会传给构建脚本"
        echo "      如果用户命令本身以 '-' 开头，请用 '--' 分隔：$FUNCNAME -p mc632x -- -ls"
        echo ""
        echo "示例0 : $FUNCNAME -p mc632x     4who  #显示容器信息"
        echo "示例1 : $FUNCNAME -p mc632x     ./AllInOne4_fh8626v3x_build.sh all"
        echo "示例2 : $FUNCNAME -p mc632x     ./AllInOne4_mc632x_build.sh    all --no-pack"
        echo "示例3 : $FUNCNAME -p mc632x     ./AllInOne4_mc632x_build.sh    -pFS"
        echo "示例4 : $FUNCNAME -p mc632x     make all"
        echo "示例5 : $FUNCNAME -p mc632x    \"make clean && make all 2>&1 log\""
        echo "示例6 : $FUNCNAME -p mc632x     ls -lh ~/Docker_Images_Build/  # 其中~/或\${HOME}会被替换"  
        echo "示例7 : $FUNCNAME -p mc632x     ls /root/  # 容器内操作没有权限可以加sudo" 
        echo "示例8 : $FUNCNAME -p mc632x     sudo apt install package  # 临时给容器安装软件，永久安装应放在构建镜像阶段。"
        echo "示例9 : $FUNCNAME -p mc632x --  ls -lh   #'--' 标记其后是用户命令的开始,应对复杂情况"
        echo "示例10: $FUNCNAME -p                     # 不带参数：列出所有已知的平台-容器映射：$docker_compiler_platform_map2_container"
        echo "示例11: $FUNCNAME -c                     # 不带参数：列出所有已知的运行中容器"
        echo "示例12: $FUNCNAME -c container_name \"make clean && make all\" "
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
            echo ""
            echo "当前支持的平台: $(_data_base_operation list)"
        fi
        return 0
    fi
    # step 0: check docker groups
    if [ "$(id -u)" -ne 0 ] && ! id -nG | grep -qw docker;then
        echo "you need to do:"
        echo "step1:sudo usermod -aG docker \$USER    # Add current user to docker group"
        echo "step2:exec newgrp docker                # Replace the current shell with a new one"
        return 2
    fi
    #default values
    local ret=0
    local workdir_volume_map_path=${HOME}
    local docker_container_name=${g_container_name:-}
    local platform=${g_platform:-}
    local user_id=$(id -u)
    local debug=false
    local sub_cmd=""
    local sub_cmd_args=()
    #================================================================#
    #step 1: process parameters,parse script options
    local remaining_args=()
    # 解析规则：第一个非选项参数即“用户命令”的开始。
    # 一旦用户命令出现，其后的所有参数（包括 -d/-p/-n 等与脚本选项同名的参数）
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
                if [[ -z "$2" ]]; then echo "All known platforms-container mapping list: ";_data_base_operation show; return 1; fi
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
            -*)
                # 能走到这里，说明用户命令尚未开始，只可能是脚本选项区的合并短选项，如 -d
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        d) debug=true ;;
                        c) docker_container_name="$2"; shift;break ;; # 当 c 是合并选项的一部分时，它应该停止解析剩余的字符
                        p) platform="$2"; shift;break ;; # 当 p 是合并选项的一部分时，它应该停止解析剩余的字符
                        I) sub_cmd=INIT; sub_cmd_args=(); shift;break ;; # 当 I 是合并选项的一部分时，它应该停止解析剩余的字符
                        A) sub_cmd=ADD; sub_cmd_args=("$2" "$3"); shift 3;break ;; # 当 A 是合并选项的一部分时，它应该停止解析剩余的字符
                        D) sub_cmd=DEL; sub_cmd_args=("$2"); shift 2;break ;; # 当 D 是合并选项的一部分时，它应该停止解析剩余的字符
                        S) sub_cmd=LIST; sub_cmd_args=(); shift;break ;; # 当 S 是合并选项的一部分时，它应该停止解析剩余的字符
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *)
                # 第一个非选项参数 = 用户命令开始：剩余所有参数（含 -d/-p 等）整体归入用户命令
                remaining_args+=("$@")
                break
                ;;
        esac
    done
    #优先处理本脚本选项
    if [ -n "${sub_cmd}" ]; then
        if [ "${sub_cmd}" = "INIT" ]; then
            _data_base_operation init ${sub_cmd_args[@]}
        elif [ "${sub_cmd}" = "ADD" ]; then
            _data_base_operation set ${sub_cmd_args[@]}
        elif [ "${sub_cmd}" = "DEL" ]; then
            _data_base_operation del ${sub_cmd_args[@]} || return $?
        elif [ "${sub_cmd}" = "LIST" ]; then
            _data_base_operation show ${sub_cmd_args[@]}
        fi
        return 0
    fi
    if [ ${#remaining_args[@]} -lt 1 ]; then
        echo "Error: command list is empty!"
        echo "  Usage: "
        echo "         $FUNCNAME [options] [--] \"command args ...\""
        echo "Example: $FUNCNAME -p $platform  make menuconfig"
        echo "Example: $FUNCNAME -p $platform  make all"
        echo "Example: $FUNCNAME -p $platform  ./configuer --prefix=/usr/local/"
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
    if [ -z ${docker_container_name} ];then
        echo "Error: unknow container_name! you must give platform or container_name"
        echo "Example: $FUNCNAME -p platform \"command args ...\""
        echo "Example: $FUNCNAME -c container_name \"command args ...\""
        return 5
    fi
    if [ ${debug} = true ];then
        echo "INFO:platform=${platform}"
        echo "INFO:docker_container_name=${docker_container_name}"
    fi
    #================================================================#
    # step 3: check if the docker container is running
    docker ps -a | grep -w -q $docker_container_name
    if [ $? -ne 0 ];then
        echo "Error: docker container not running: $docker_container_name"
        return 6
    fi
    #================================================================#
    # step 4: get docker volume mapping and convert current_dir to docker_inner_path
    #docker volume mapping: like: /home/lshm -> /home/duser/workdir
    local docker_volume_mapping=$(docker inspect -f '{{ range .Mounts }}{{ if or (eq .Destination "/home/duser/workdir") (eq .Destination "/root/workdir") }}{{ .Source }} -> {{ .Destination }}{{ "\n" }}{{ end }}{{ end }}' ${docker_container_name} )
    if [ $(echo "${docker_volume_mapping}" | wc -l ) -gt 1 ];then
        if [ $(id -u) -eq 0 ];then
            docker_volume_mapping=$(echo "${docker_volume_mapping}" | grep -w root)
        else
            docker_volume_mapping=$(echo "${docker_volume_mapping}" | grep -w duser)
        fi
    fi
    local host_workdir_path=$(echo ${docker_volume_mapping} | awk -F '->' '{print $1}' | tr -d ' ')
    local docker_workdir_path=$(echo ${docker_volume_mapping} | awk -F '->' '{print $2}' | tr -d ' ')
    #convert current_dir to docker_inner_path;e.g. /home/lshm/workdir/mc632x_test/build.sh to /home/duser/workdir/mc632x_test/build.sh
    local docker_inner_path=$(echo $(pwd) | sed "s|${host_workdir_path}|${docker_workdir_path}|")
    if [ ${debug} = true ];then
        echo "INFO:docker_volume_mapping=${docker_volume_mapping}"
        echo "INFO:    host_workdir_path=${host_workdir_path}"
        echo "INFO:  docker_workdir_path=${docker_workdir_path}"
        echo "INFO:    docker_inner_path=${docker_inner_path}"
        echo "INFO:            host_path=$(pwd)"
    fi
    # 检查当前目前是否在映射的目录之下
    is_subpath ${host_workdir_path} $PWD
    if [ $? -ne 0 ];then
        echo "ERROR[EN]: your work directory must be under ${host_workdir_path}"
        echo "         : docker volume:${docker_volume_mapping}"
        echo "ERROR[CN]: 此容器的工作目录必须位于 ${host_workdir_path}"
        echo "         : 此容器卷映射为 ${docker_volume_mapping}"
        return 7
    fi
    # step 5: packaging user command
    # 将 remaining_args 编码为可在 bash -c 中安全执行的命令字符串
    # 单参数时视为完整 shell 命令（如 "make clean && make all"），直接嵌入不转义
    # 多参数时对每个参数 printf '%q'，避免空格/引号等被错误拆分
    local user_cmd=""
    if [[ ${#remaining_args[@]} -eq 1 ]]; then
        user_cmd="${remaining_args[0]}"
    else
        for arg in "${remaining_args[@]}"; do
            user_cmd+=$(printf '%q ' "$arg")
        done
        user_cmd=${user_cmd% }
    fi
    # 将用户命令中的 ~/ or $HOME 转换成映射工作目录，
    #local user_cmd=$(echo $user_cmd | sed -e "s#${HOME}#${docker_workdir_path}#g" -e "s#~/#${docker_workdir_path}#g")
    local user_cmd=$(echo $user_cmd | sed "s|${host_workdir_path}|${docker_workdir_path}|g")

    # 在容器内先 cd 到映射目录，再以命令组 () 执行用户命令，避免 ;、|| 与外层 && 优先级混淆
    local cmd_array=(bash -ic "cd -- $(printf '%q' "$docker_inner_path") && (${user_cmd})")
    local cmd_array4_echo=(bash -ic \""cd -- $(printf '%q' "$docker_inner_path") && (${user_cmd})"\")
    if [ ${debug} = true ];then
        echo "INFO:remaining_args=${remaining_args[@]}"
        echo "INFO:      user_cmd=${user_cmd}"
        echo "INFO:     cmd_array=${cmd_array[@]}"
    fi
    #================================================================#
    # step 6: execute user command in docker container
    echo "EXEC:docker exec -u ${user_id} -it "${docker_container_name}" ${cmd_array4_echo[@]}"
    if [ ${debug} = false ];then
        docker exec -u ${user_id} -it "${docker_container_name}" "${cmd_array[@]}"
        ret=$?
    fi
    return $ret
}
#if unnecessary, please do not modify following code
docker-compiler "$@"
func_ret=$?
if [ $func_ret -ne 0 ];then exit $func_ret;fi
exit 0
