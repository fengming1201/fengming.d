#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile_path=$(readlink -f $0)
scriptfile_name=$(basename ${scriptfile_path})
scriptfile_dir=$(dirname ${scriptfile_path})

#start here add your code,you need to implement the following function.
docker_compiler_platform_map2_container=${HOME}/.docker_compiler_platform_map2_container.conf
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
# 以 docker_compiler_platform_map2_container 为数据库文件的 key-value 操作接口
#   get key  : 返回 value，key/value 缺失或未命中时返回空
#   list     : 在一行中打印所有 key
function _data_base_operation() {
    local cmd="${1:-}"
    local map_file="${docker_compiler_platform_map2_container}"
    local plat value
    local -a keys=()

    case "$cmd" in
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
        list_all)
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
            echo "Error: unknown database command: $cmd (supported: get, list)" >&2
            return 1
            ;;
    esac
}

function docker-compiler
{
    if [ $# -lt 1 ]; then
        echo "Usage: "
        echo "         $FUNCNAME [options] [-p|--plat platform] [--] \"command args ...\""
        echo ""
        echo "options:"
        echo "        -d|--debug                    #debug mode:not truly executing your command."
        echo "        -m|--map   map_path           #modify default workdir volume mapping path.default: ${HOME}"
        echo "        -n|--name  [container_name]   #overwrite container name. no para: list all known running containers"
        echo "        -p|--plat  [platform]         #select container_name by platform. no para: list all known platforms-container mapping"
        echo ""
        echo "support platform: $(_data_base_operation list)"
        echo ""
        echo "Example1:  $FUNCNAME -p mc632x     ./AllInOne4_fh8626v3x_build.sh all"
        echo "Example1b: $FUNCNAME -p mc632x     ./AllInOne4_mc632x_build.sh    all --no-pack"
        echo "Example2:  $FUNCNAME -p mc632x     make all"
        echo "Example2:  $FUNCNAME -p mc632x     command --help"
        echo "Example2b: $FUNCNAME -p mc632x     ls -lh"
        echo "Example2c: $FUNCNAME -p mc632x --  ls -lh"
        echo "Example2c: $FUNCNAME -p                      # no para: list all known platforms-container mapping"
        echo "Example2c: $FUNCNAME -n                      # no para: list all known running containers"
        echo "Example4:  $FUNCNAME -n container_name \"make clean && make all\" "
        echo "Example5:  $FUNCNAME \"make clean && make all\" -m /home/mining/uboot -n mytest"
        echo "Example6:  export g_platform=mc632x;$FUNCNAME \"make clean && make all\""
        echo "Example7:  export g_container_name=mycontainer;$FUNCNAME \"make clean && make all\""
        echo ""
        echo "Note: shell operators (&&, ||, ;, |) are parsed by your shell BEFORE this script runs."
        echo "      Wrong:  $FUNCNAME -n mycontainer make clean && make all   # only 'make clean' runs in docker"
        echo "      Right:  $FUNCNAME -n mycontainer \"make clean && make all\""
        echo "      Also:   $FUNCNAME -n mycontainer make clean '&&' make all"
        echo ""
        if [ -n "${g_workdir_map_path}" ] || [ -n "${g_container_name}" ] || [ -n "${g_platform}" ];then
            echo "Note: Current environment variables have been detected"
            echo "g_workdir_map_path=${g_workdir_map_path}"
            echo "g_container_name=${g_container_name}"
            echo "g_platform=${g_platform}"
        else
            echo "The default value can also be changed through environment variables"
            echo "export g_workdir_map_path="
            echo "export g_container_name="
            echo "export g_platform="
        fi
        return 1
    fi
    #check dockr groups
    if ! id -nG | grep -qw docker;then
        echo "you need to do:"
        echo "sudo usermod -aG docker $USER"
        return 2
    fi
    #default values
    local ret=0
    #docker volume mapping: -v /home/lshm:/home/duser/workdir
    local docker_workdir_path=/home/duser/workdir
    local workdir_volume_map_path=${HOME}
    local docker_container_name=${g_container_name:-}
    local platform=${g_platform:-}
    local debug=false
    # remaining_args: 解析完脚本选项后，留给容器内执行的用户命令参数
    local remaining_args=()
    # 区分脚本选项(-p/-n/-m/-d)与用户命令参数；已知脚本选项(-p等)在case中优先匹配
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
            -m|--map)
                if [[ -z "$2" ]]; then echo "ERROR: -m|--map requires one parameter" >&2; return 1; fi
                workdir_volume_map_path="$2"; shift 2 ;; #带参数，移动2
            -n|--name)
                if [[ -z "$2" ]]; then echo "All known running container list: ";docker ps -a --format "{{.Names}}"; return 1; fi
                docker_container_name="$2"; shift 2 ;; #带参数，移动2
            -p|--plat)
                if [[ -z "$2" ]]; then echo "All known platforms-container mapping list: ";_data_base_operation list_all; return 1; fi
                platform="$2"; shift 2 ;; #带参数，移动2
            -*)
                # 用户命令已出现(如 ls)后，未知的 - 开头参数不再当脚本选项
                # 例: -p mc632x ls -lh 中的 -lh 应交给 ls，而非报 invalid option
                if [[ ${#remaining_args[@]} -gt 0 ]]; then
                    remaining_args+=("$1"); shift
                    continue
                fi
                # 脚本选项区的合并短选项，如 -d
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        d) debug=true ;;
                        m) workdir_volume_map_path="$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        n) docker_container_name="$2"; shift;break ;; # 当 n 是合并选项的一部分时，它应该停止解析剩余的字符
                        p) platform="$2"; shift;break ;; # 当 p 是合并选项的一部分时，它应该停止解析剩余的字符
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done

    if [ ${#remaining_args[@]} -lt 1 ]; then
        echo "Error: command list is empty!"
        echo "         $FUNCNAME [options] [-p|--plat platform] [--] \"command args ...\""
        echo "Example: $FUNCNAME -p mc632x make all"
        return 3
    fi

    # shell 在调用本脚本前就会解析 &&，未加引号时只有 make clean 能传进来
    # 误用: docker-compiler ... make clean && make all  (make all 在宿主机执行)
    # 正确: docker-compiler ... "make clean && make all"
    if [[ ${#remaining_args[@]} -eq 2 && "${remaining_args[0]}" == "make" && "${remaining_args[1]}" == "clean" ]]; then
        echo "WARN: only 'make clean' will run inside docker." >&2
        echo "      For compound commands use quotes: $FUNCNAME [options] \"make clean && make all\"" >&2
        echo "      Or pass && as an argument:       $FUNCNAME [options] make clean '&&' make all" >&2
    fi

    # 未指定 -n 时，按 -p 平台名查配置文件获取容器名
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
    #convert current_dir to docker_inner_path;e.g. /home/lshm/workdir/mc632x_test/build.sh to /home/duser/workdir/mc632x_test/build.sh
    local docker_inner_path=$(echo $(pwd) | sed "s|${workdir_volume_map_path}|${docker_workdir_path}|")
    if [ ${debug} = true ];then
        echo "INFO:workdir_volume_map_path=${workdir_volume_map_path}"
        echo "INFO:docker_container_name=${docker_container_name}"
        echo "INFO:docker_inner_path=${docker_inner_path}"
        echo "INFO:platform=${platform}"
        echo "INFO:user_cmd=${remaining_args[*]}"
        echo "INFO:remaining_args=${remaining_args[@]}"
    fi
    if [ -z ${docker_container_name} ];then
        echo "Error: unknow container_name! you must give platform or container_name"
        echo "Example: $FUNCNAME -p platform \"command args ...\""
        echo "Example: $FUNCNAME -n your_container_name \"command args ...\""
        return 5
    fi

    #check if the docker container is running
    docker ps -a | grep -w -q $docker_container_name
    if [ $? -ne 0 ];then
        echo "Error: docker container not running: $docker_container_name"
        return 6
    fi
    # 将 remaining_args 编码为可在 bash -c 中安全执行的命令字符串
    # printf '%q' 对每个参数做 shell 转义，避免空格/引号/&& 等被错误拆分
    local user_cmd="" arg
    for arg in "${remaining_args[@]}"; do
        user_cmd+=$(printf '%q ' "$arg")
    done
    user_cmd=${user_cmd% }  # 去掉末尾空格
    # 在容器内先 cd 到映射目录，再执行用户命令
    local cmd_array=(bash -c "cd -- $(printf '%q' "$docker_inner_path") && ${user_cmd}")
    echo "EXEC:docker exec -it "${docker_container_name}" "${cmd_array[@]}""
    if [ ${debug} = false ];then
        docker exec -it "${docker_container_name}" "${cmd_array[@]}"
        ret=$?
        if [ $ret -ne 0 ];then echo "Error: docker exec exit code:$ret";fi
    fi
    return $ret
}
#if unnecessary, please do not modify following code
docker-compiler "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
