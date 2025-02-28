#!/bin/bash

scriptfile=($0)
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh
if [ -f ${common_share_function} ] && [ true = false ];then
    source ${common_share_function}
    scriptfile+=(${common_share_function})
fi
#if unnecessary, please do not modify this function

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_location
{
    if [ -L ${scriptfile} ];then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}

##Parameter Counts      : >=1
# Parameter Requirements: func_name  args ...
# Example: usage
##
function func_debug_help
{
    echo "--func {function_name or index} [args ...] [--debug]  #优先级3: 列出所有子函数或调用子函数"
}
function func_debug_function
{
    local debug=false
    local func_test=false
    local remaining_args=()
    while [[ $# -gt 0 ]];do
        case "$1" in
            --debug) debug=true; shift ;; #不带参数,移动1
            --func) func_test=true; shift ;; #不带参数,移动1
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    if [ ${func_test} = false ];then return 0;fi
    if [ ${debug} = true ];then
        echo "DEBUG:script_file=${scriptfile[@]}"
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:func_test=${func_test}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    local index=0
    local func_list=($(cat  ${scriptfile[@]} | grep -E '(function\s+[a-zA-Z_][a-zA-Z0-9_]*|\w+\s*\(\s*\))' | \
                        sed -e 's/#.*//' -e '/^[[:space:]]*$/d' -e '/=/d' -e 's/function//' -e 's/{//' -e 's/(//' -e 's/)//' | \
                        sed 's/^[[:space:]]*//; s/[[:space:]]*$//'))
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "函数列表:"
        echo ""
        for func in ${func_list[@]};do echo "[${index}] ${func}";index=$((index+1));done
        echo ""
        echo "用法:";echo -n "$scriptname ";func_debug_help;return 1
    fi
    if [ ${debug} = true ];then echo "DEBUG:func_list[${#func_list[@]}]=${func_list[@]}";fi
    local call_func_name=
    if expr "${remaining_args[0]}" : '-*[0-9]\+$' > /dev/null; then
        if [ ${debug} = true ];then echo "${remaining_args[0]} is number";fi
        call_func_name=${func_list[${remaining_args[0]}]}
    else
        if [ ${debug} = true ];then echo "${remaining_args[0]} is string";fi
        for func in ${func_list[@]};do if [ ${func} = "${remaining_args[0]}" ];then call_func_name=${func};fi;done
    fi
    if [ ${debug} = true ];then echo "DEBUG:call_func_name=${call_func_name}";fi
    if [ x${call_func_name} = x ];then echo "ERROR:${remaining_args[0]} not at this scriptfile";echo "Possible Function Name:{ ${func_list[@]} }";return 2;fi
    echo -e "\e[31mcall func ....\e[0m"
    if [ ${debug} = true ];then echo "CALL: ${call_func_name}( ${remaining_args[@]:1} ) ";fi
    ${call_func_name} "${remaining_args[@]:1}"
    echo -e "\e[31m.... done\e[0m"
    return 3
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo ""
    echo "info | -info | --info                      #优先级1: 显示摘要"
    echo "show | -show | --show                      #优先级2: 打印本脚本文件"
    func_debug_help
    echo ""
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
target_file_name=${fengming_dir}/sorftware_toolket/base_software_list.json
timeout_time_s=60s
## parameter counts: 4
# parameter request: name language describe url
# Example:
##
function func_add_new_item
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ $# -ne 4 ];then echo "ERROR:parameter wrong!";return 1;fi
    tmp_file=$(mktemp)
    jq --arg app_name "$1" \
        --arg prio_level "$2" \
        --arg install_method "$3" \
        --arg describe "$4" \
        '.app_array += [{"app": $app_name, "level": $prio_level, "install": $install_method, "describe": $describe}]' \
        ${target_file_name} > ${tmp_file}
    echo "New item:${1}"
    #jq -r ".info[] | select(.name == \"${1}\")" ${tmp_file}
    diff -u ${target_file_name}  ${tmp_file}
    if [ ${debug} = true ];then
        echo "EXEC:jq --arg app_name "$1" \\
        --arg prio_level "$2" \\
        --arg install_method "$3" \\
        --arg describe "$4" \\
        '.app_array += [{"app": $app_name, "level": $prio_level, "install": $install_method, "describe": $describe}]' \\
        ${target_file_name} > ${tmp_file}"
    fi

    local opt=n
    if [ ${test} = true ];then
        echo "TEST:nothing to be change!!"
    else
        read -p "save back?[y/N]:" opt
    fi
    if [ "x${opt}" = x ];then opt=N;fi
    if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ];then
        opt=Y
    fi
    if [ "${opt}" = "Y" ];then
        cp $tmp_file $target_file_name
    fi
    rm ${tmp_file}
    return 0
}

##Parameter Counts      : 1
# Parameter Requirements: item_name
# Example: test
##
function func_delete_item
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ $# -ne 1 ];then echo "ERROR:parameter wrong!";return 1;fi
    echo "Delete item:${1}"
    local delete_item=$(jq -r ".app_array[] | select(.app == \"${1}\")" ${target_file_name})
    if [ "x${delete_item}" = "x" ];then echo "ERROR:Not found target:${1} item!";return 2;fi

    tmp_file=$(mktemp) 
    jq "del(.app_array[] | select(.app == \"${1}\"))" ${target_file_name} > ${tmp_file}
    diff -u ${target_file_name}  ${tmp_file}
    if [ ${debug} = true ];then
        echo "DEBUG:jq \"del(.app_array[] | select(.app == \"${1}\"))\" ${target_file_name} > ${tmp_file}"
    fi
    local opt=n

    if [ ${test} = true ];then
        echo "TEST:nothing to be change!!"
    else
        read -p "save back?[y/N]:" opt
    fi
    if [ "x${opt}" = x ];then opt=N;fi
    if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ];then
        opt=Y
    fi
    if [ "${opt}" = "Y" ];then
        cp $tmp_file $target_file_name
    fi
    rm ${tmp_file}
    return 0
}
function func_install_item
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ $# -lt 1 ];then echo "ERROR:parameter wrong!";return 1;fi

    for app_name in "$@";do
        echo "Install item:${app_name}"
        local item=$(jq -r ".app_array[] | select(.app == \"${app_name}\")" ${target_file_name})
        if [ "x${item}" = "x" ];then
            echo "ERROR:Not found target:${app_name} item!"
            continue
        fi
        local install_method=$(jq -r ".app_array[] | select(.app == \"${app_name}\") | .install" ${target_file_name})
        if [ ${debug} = true ];then echo "DEBUG: ${maybeSUDO} ${install_method}";fi
        local opt=n
        if [ ${test} = true ];then
            echo " TEST: nothing to be change!!"
        else
            read -p "EXEC: ${maybeSUDO} ${install_method} ?[y/N]:" opt
        fi
        if [ "x${opt}" = x ];then opt=N;fi
        if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ];then
            opt=Y
        fi
        if [ "${opt}" = "Y" ];then
            eval ${maybeSUDO} ${install_method}
        fi
    done
    return 0
}
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_list_item
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ $# -ge 1 ];then
        for args in "$@";do
            if expr "$args" : '-*[0-9]\+$' > /dev/null; then
                jq -r ".app_array[] | select(.level == ${args})" ${target_file_name}
                if [ ${debug} = true ];then
                    echo "EXEC: jq -r \".app_array[] | select(.level == ${args})\" ${target_file_name}"
                fi
            else
                jq -r ".app_array[] | select(.app == \"${args}\")" ${target_file_name}
                if [ ${debug} = true ];then
                    echo "EXEC: jq -r \".app_array[] | select(.app == \"${args}\")\" ${target_file_name}"
                fi
            fi
        done
    else
        #list all
        jq -r '.app_array[]' ${target_file_name}
        if [ ${debug} = true ];then
            echo "EXEC: jq -r '.app_array[]' ${target_file_name}"
        fi
    fi
    return 0
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_list_item_sort
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    #list all
    jq -r '.app_array[].app' ${target_file_name}
    if [ ${debug} = true ];then
        echo "EXEC: jq -r '.app_array[].app' ${target_file_name}"
    fi

    return 0
}


function usage
{
    echo ""
    echo "$scriptname  [opt]  args ..."
    echo ""
    echo "opt:"
    echo ""
    echo "  -h | --help                                       #帮助"
    echo "  -t | --test                                       #不执行动作"
    echo "  -d | --debug                                      #打开调试"
    echo "  -l | --list   [app_name | level]                  #列出收藏[个别 / 等级]项目"
    echo "  -s | --sort                                       #简短输出"
    echo ""
    echo "  --addapp    \"app_name\" \"prio_level\" \"install_method\" \"describe\"  #添加收藏项目"
    echo "       -N | --name     \"app_name\""
    echo "       -L | --level    \"prio_level\""
    echo "       -I | --install  \"install_method\""
    echo "       -D | --describe \"describe\""
    echo "  --deleteapp     \"app_name\" | -N app_name                          #删除收藏项目"
    echo "  --installapp                                [-T|--time  timeout]    #逐个安装已收藏的项目,time 为超时时间秒,缺省60s"
    echo "  --installapp    \"app_name\" | -N app_name  [-T|--time  timeout]    #安装某个已收藏的项目,time 为超时时间秒,缺省60s"
    echo ""
}

function func_schedule
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local cmd=
    local app_name=
    local prio_level=
    local describe=
    local install_method=

    local debug=false
    local test=false
    local timeoute=60 #60s
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;; #不带参数,移动1
            -l|--list) if [[ -z "$cmd" ]]; then cmd=list;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            -s|--sort) if [[ -z "$cmd" ]]; then cmd=sort;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            -T|--time)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                timeout="$2"; shift 2 ;; #带参数,移动2
            -N|--name)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                app_name="$2"; shift 2 ;; #带参数,移动2
            -L|--level)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                prio_level="$2"; shift 2 ;; #带参数,移动2
            -I|--install)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                install_method="$2"; shift 2 ;; #带参数,移动2
            -D|--describe)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                describe="$2"; shift 2 ;; #带参数,移动2
            --addapp) if [[ -z "$cmd" ]]; then cmd=add;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            --deleteapp) if [[ -z "$cmd" ]]; then cmd=delete;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            --installapp) if [[ -z "$cmd" ]]; then cmd=install;else echo "ERROR: multiple commands";return 2;fi;shift ;;
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
                        l) if [[ -z "$cmd" ]]; then cmd=list;else echo "ERROR: multiple commands";return 2;fi ;;
                        s) if [[ -z "$cmd" ]]; then cmd=sort;else echo "ERROR: multiple commands";return 2;fi ;;
                        t) test=true ;;
                        T) timeout="$2"; shift;break ;; # 当 T 是合并选项的一部分时，它应该停止解析剩余的字符
                        N) app_name="$2"; shift;break ;; # 当 N 是合并选项的一部分时，它应该停止解析剩余的字符
                        L) prio_level="$2"; shift;break ;; # 当 L 是合并选项的一部分时，它应该停止解析剩余的字符
                        I) install_method="$2"; shift;break ;; # 当 I 是合并选项的一部分时，它应该停止解析剩余的字符
                        D) describe="$2"; shift;break ;; # 当 D 是合并选项的一部分时，它应该停止解析剩余的字符
			F) cmd_opt+=("--file $2"); shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        Q) cmd_opt+=("--qr=true") ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done

    #=================================================#
    #if [ ${#remaining_args[@]} -lt 1 ];then
    #    echo "ERROR: platform list is empty!!";usage;return 2
    #fi
    if [ -z ${app_name} ];then app_name="${remaining_args[0]}";fi
    if [ -z ${prio_level} ];then prio_level="${remaining_args[1]}";fi
    if [ -z ${install_method} ];then install_method="${remaining_args[2]}";fi
    if [ -z ${describe} ];then describe="${remaining_args[3]}";fi
    #==================== print debug =============================#    
    if [ ${debug} = true ];then
        echo "DEBUG:maybeSUDO=${maybeSUDO}"
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:test=${test}"
        echo "DEBUG:cmd=${cmd}"
        echo ""
        echo "DEBUG:app=${app_name}"
        echo "DEBUG:level=${prio_level}"
        echo "DEBUG:install=${install_method}"
        echo "DEBUG:describe=${describe}"
        echo "DEBUG:timeout=${timeout}"
        echo "DEBUG:cmd_opt=${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:[${#remaining_args[@]}],remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    #start your code
    #for file in "${remaining_args[@]}"
    #do
        #here we process each parameter
        #linux_cmd  ${cmd_opt[@]} args ....
    #done
    which jq > /dev/null
    if [ $? -ne 0 ];then
        echo "jq not found! please install it first!"
        echo "apt install jq"
        return 2
    fi

    if [ "${cmd}" = "list" ];then
        echo -e "\e[31mlist ....\e[0m"
        if [ "x${app_name}" != "x" ];then
            func_list_item "${app_name}" "${remaining_args[@]:1}"
        else
            func_list_item "${remaining_args[@]}"
        fi
    fi

    if [ "${cmd}" = "sort" ];then
        echo -e "\e[31msort ....\e[0m"
        func_list_item_sort
    fi

    if [ "${cmd}" = "add" ];then
        echo -e "\e[31madd ....\e[0m"
        if [ "x${app_name}" != "x" ];then
            func_add_new_item "${app_name}" "${prio_level}" "${install_method}" "${describe}"
        else
            echo "ERROR: app_name can not empty!!"
        fi
    fi

    if [ "${cmd}" = "delete" ];then
        echo -e "\e[31mdelete ....\e[0m"
        if [ "x${app_name}" != "x" ];then
            func_delete_item "${app_name}" "${remaining_args[@]:1}"
        else
            func_delete_item "${remaining_args[@]}"
            echo "ERROR: item_name can not empty!!"
        fi
    fi

    if [ "${cmd}" = "install" ];then
        echo -e "\e[31minstall ....\e[0m"
        if [ "x${app_name}" != "x" ];then
            func_install_item "${app_name}" "${remaining_args[@]:1}"
        else
            echo "ERROR: item_name can not empty!!"
        fi
    fi

    return 0
}

func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_schedule "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0