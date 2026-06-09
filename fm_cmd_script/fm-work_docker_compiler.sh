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


##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function docker-compiler
{
    if { [ -z "${g_platform}" ] && [ $# -lt 2 ]; } || { [ -n "${g_platform}" ] && [ $# -lt 1 ]; }; then
        echo "Usage: "
        echo "         $FUNCNAME [options] platform command args ..."
        echo "platform: bipc_fh8626 bipc_fh8852 fh1x fh8626v3x mc632x new_mc632x"
        echo ""
        echo "Example: $FUNCNAME fh8626v3x ./AllInOne4_fh8626v3x_build.sh all"
        echo "Example: $FUNCNAME mc632x    ./AllInOne4_mc632x_build.sh    all"
        echo "Example: $FUNCNAME mc632x make all"
        echo "Example: $FUNCNAME mc632x make clean && make all"
        echo ""
        echo "options:"
        echo "        -d|--debug: enable debug mode"
        echo "        -m|--map   map_path         #modify default workdir volume mapping path.default: /home/lshm"
        echo "        -n|--name  container_name   #overwrite container name.e.g. container4_fastboot_mc632x_compiler"
        echo "        -p|--plat  platform         #overwrite platform.e.g. mc632x"
        echo ""
        echo "Example: $FUNCNAME -m /home/mining/uboot -n mytest -p jzt33 make all"
        echo ""
        echo "The default value can also be changed through environment variables"
        echo "Example: export g_workdir_map_path=XXX"
        echo "Example: export g_container_name=XXX"
        echo "Example: export g_platform=XXX"
        return 1
    fi

    #default values
    #/home_duser=/workdir mapping path
    local workdir_volume_map_path=/home/lshm
    local docker_container_name=${g_container_name:-}
    local platform=${g_platform:-}
    local debug=false
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -d|--debug) debug=true; shift ;; #不带参数，移动1
            -m|--map)
                if [[ -z "$2" ]]; then echo "ERROR: -m|--map requires one parameter" >&2; return 1; fi
                workdir_volume_map_path="$2"; shift 2 ;; #带参数，移动2
            -n|--name)
                if [[ -z "$2" ]]; then echo "ERROR: -n|--name requires one parameter" >&2; return 1; fi
                docker_container_name="$2"; shift 2 ;; #带参数，移动2
            -p|--plat)
                if [[ -z "$2" ]]; then echo "ERROR: -p|--plat requires one parameter" >&2; return 1; fi
                platform="$2"; shift 2 ;; #带参数，移动2
            -*)
                # 处理合并的选项,如-dh
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
    if { [ -z $g_platform ] && [ ${#remaining_args[@]} -lt 2 ]; } || { [ -n $g_platform ] && [ ${#remaining_args[@]} -lt 1 ]; };then
        echo "Error: no command provided"
        echo "         $FUNCNAME [options] platform command args ..."
        echo "Example: $FUNCNAME mc632x make all"
        return 2
    fi

    if [ "x${platform}" = "x" ] && [ ${#remaining_args[@]} -ge 2 ];then
        platform="${remaining_args[0]}"
        cmd="${remaining_args[@]:1}"
    elif [ "x${platform}" != "x" ] && [ ${#remaining_args[@]} -ge 1 ];then
        cmd="${remaining_args[*]}"
    fi
    #select docker container name by platform
    if [ "x${docker_container_name}" = "x" ];then
        if [ "bipc_fh8626" = "$platform" ];then
            docker_container_name="container4_bipc_fh8626_compiler"
        elif [ "bipc_fh8852" = "$platform" ];then
            docker_container_name="container4_bipc_fh8852_compiler"
        elif [ "fh1x" = "$platform" ];then
            docker_container_name="container4_fastboot_fh885x_compiler"
        elif [ "fh8626v3x" = "$platform" ];then
            docker_container_name="container4_fastboot_fh8626_compiler"
        elif [ "mc632x" = "$platform" ];then
            docker_container_name="container4_fastboot_mc632x_compiler"
        elif [ "new_mc632x" = "$platform" ];then
            docker_container_name="container4_newfw_mc6321_compiler"
        fi
    fi
    if [ -z ${docker_container_name} ];then
        echo "Error: not found docker container name for this platform: $platform"
        return 3
    fi
    #convert current_dir to docker_inner_path;e.g. /home/lshm/workdir/mc632x_test/build.sh to /home/duser/workdir/mc632x_test/build.sh
    local docker_inner_path=$(echo $(pwd) | sed "s|${workdir_volume_map_path}|/home/duser/workdir|")
    echo "INFO:workdir_volume_map_path=${workdir_volume_map_path}"
    echo "INFO:docker_container_name=${docker_container_name}"
    echo "INFO:docker_inner_path=${docker_inner_path}"
    echo "INFO:platform=${platform}"
    echo "INFO:cmd=${cmd}"
    echo "INFO:remaining_args=${remaining_args[@]}"
    #check if the docker container is running
    docker ps -a | grep -w -q $docker_container_name
    if [ $? -ne 0 ];then
        echo "Error: docker container not running: $docker_container_name"
        return 4
    fi
    echo "EXEC:docker exec ${docker_container_name} bash -c \"cd $docker_inner_path && $cmd\""
    if [ ${debug} = false ];then
        docker exec ${docker_container_name} bash -c "cd $docker_inner_path && $cmd"
    fi
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

docker-compiler "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
