#!/bin/bash

scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ];then
    source ${common_share_function}
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
    if [ ${func_test} = true ];then
        if [ ${#remaining_args[@]} -lt 1 ];then grep -w "^function"  ${scriptfile};return 1;fi
        local func_list=($(grep -w "^function"  ${scriptfile} | awk '{print$2}'))
        local found_it=false
        for func in ${func_list[@]};do
            if [ ${func} = "${remaining_args[0]}" ];then found_it=true;fi
        done
        if [ ${found_it} = false ];then
            echo "ERROR:${remaining_args[0]} not at this scriptfile"
            echo "Possible Function Name:{ ${func_list[@]} }"
            return 2
        fi
        echo -e "\e[31mcall func call....\e[0m"
        ${remaining_args[0]} "${remaining_args[@]:1}"
        if [ ${debug} = true ];then echo "DEBUG:${remaining_args[0]} ${remaining_args[@]:1}";fi
        return 3
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo ""
    echo " [info | -info | --info]                           #优先级1: 显示摘要"
    echo " [show | -show | --show]                           #优先级2: 打印本脚本文件"
    echo " [--debug ||&& --func [function_name  args ...] ]  #优先级3: 列出所有子函数或调用子函数"
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
if [ $(id -u) -ne 0 ] && [ lshm != lshm ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
target_file_name=${fengming_dir}/documents/sub_doc_unclassified/collect_open_source_project_info.json
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
    jq --arg name "$1" \
        --arg language "$2" \
        --arg describe "$3" \
        --arg url "$4" \
        '.info += [{"name": $name, "language": $language, "describe": $describe, "URL": $url}]' \
        ${target_file_name} > ${tmp_file}
    echo "New item:${1}"
    #jq -r ".info[] | select(.name == \"${1}\")" ${tmp_file}
    diff -u ${target_file_name}  ${tmp_file}
    if [ ${debug} = true ];then
        echo "DEBUG:jq --arg name "$1" \\
        --arg language "$2" \\
        --arg describe "$3" \\
        --arg url "$4" \\
        '.info += [{"name": $name, "language": $language, "describe": $describe, "URL": $url}]' \\
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
    local delete_item=$(jq -r ".info[] | select(.name == \"${1}\")" ${target_file_name})
    if [ "x${delete_item}" = "x" ];then echo "ERROR:Not found target:${1} item!";return 2;fi

    tmp_file=$(mktemp) 
    jq "del(.info[] | select(.name == \"${1}\"))" ${target_file_name} > ${tmp_file}
    diff -u ${target_file_name}  ${tmp_file}
    if [ ${debug} = true ];then
        echo "DEBUG:jq \"del(.info[] | select(.name == \"${1}\"))\" ${target_file_name} > ${tmp_file}"
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

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_list_item
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ $# -ge 1 ];then
        for name in "$@";do
            jq -r ".info[] | select(.name == \"${name}\")" ${target_file_name}
        done
        if [ ${debug} = true ];then
            echo "DEBUG: jq -r \".info[] | select(.name == \"${name}\")\" ${target_file_name}"
        fi
    else
        #list all
        jq -r '.info[]' ${target_file_name}
        if [ ${debug} = true ];then
            echo "DEBUG: jq -r '.info[]' ${target_file_name}"
        fi
    fi
    return 0
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_check_item_status
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ ! -f ${target_file_name} ];then
        echo "${target_file_name} not exist!!"
        return 1
    fi

    local dir_list=()
    for dir in $(find -maxdepth 1 -type d -printf '%P\n')
    do
        if [ -d ${dir}/.git/ ];then
            dir_list+=("${dir}")
        fi
    done

    local name_list=$(jq -r  '.info[].name' ${target_file_name})

    for sub_dir in "${dir_list[@]}"
    do
        echo ${name_list} | grep "${sub_dir}" > /dev/null
        if [ $? -ne 0 ];then
            echo "WARNNING: ${sub_dir} not registe to ${target_file_name} yet!"
        fi
    done
    echo "=============================================================="
    local dir_list=$(echo ${dir_list[@]})
    for item_name in ${name_list}
    do
        echo ${dir_list} | grep "${item_name}" > /dev/null
        if [ $? -ne 0 ];then
            echo "WARNNING: ${item_name} not pull to local yet!"
        fi
    done

    return 0
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_git_pull_update
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ $# -eq 1 ];then
        timeout_time_s=$1
    fi
    #get dir
    local dir_list=()

    for dir in $(find -maxdepth 1 -type d -printf '%P\n')
    do
        if [ -d ${dir}/.git/ ];then
            dir_list+=("${dir}")
        fi
    done

    local remote_name="origin"
    local branch_name="masters"

    for sub_dir in "${dir_list[@]}"
    do
        echo "${item_name}:"$(jq -r ".info[] | select(.name == \"${sub_dir}\") | .describe" ${target_file_name})
        pushd ${sub_dir}
        remote_name=$(git remote -v | awk '{print $1}' | uniq)
        branch_name=$(git branch | awk '{print $2}' | uniq)
        if [ "x$timeout_time_s" = "x0" ];then
            echo -e "\e[31mgit pull ${remote_name} ${branch_name} \e[0m"
            if [ ${test} = true ];then
                git pull ${remote_name} ${branch_name}
            fi
        else
            echo -e "\e[31mtimeout ${timeout_time_s} git pull ${remote_name} ${branch_name} \e[0m"
            if [ ${test} = true ];then
                timeout ${timeout_time_s} git pull ${remote_name} ${branch_name}
            fi
        fi
        popd
    done
    return 0
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_git_clone
{
    if [ ${debug} = true ];then echo "$FUNCNAME():argc=$#,argv[]=$@";fi
    if [ $# -eq 1 ];then
        timeout_time_s=$1
    fi

    local name_list=$(jq -r  '.info[].name' ${target_file_name})

    for item_name in ${name_list}
    do
        if [ -d ${item_name} ];then
            echo "INFO:item ${item_name} already exist!"
            continue
        fi
        echo "${item_name}:"$(jq -r ".info[] | select(.name == \"${item_name}\") | .describe" ${target_file_name})
        item_url=$(jq -r ".info[] | select(.name == \"${item_name}\") | .URL" ${target_file_name})
        if [ "x${item_url}" != "x" ];then
            if [ "x$timeout_time_s" = "x0" ];then
                echo -e "\e[31mgit clone ${item_url} \e[0m"
                if [ ${test} = true ];then
                    git clone ${item_url}
                fi
            else
                echo -e "\e[31mtimeout ${timeout_time_s} git clone ${item_url} \e[0m"
                if [ ${test} = true ];then
                    timeout ${timeout_time_s} git clone ${item_url}
                fi
            fi
        else
            echo "item: ${item_name}  URL is empty!"
        fi
    done
    return 0
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "$scriptname  [opt]  args ..."
    echo ""
    echo "opt:"
    echo ""
    echo "  -h | --help                                       #帮助"
    echo "  --test                                            #不执行动作"
    echo "  -d | --debug                                      #打开调试"
    echo "  -l | --list   [item_name]                         #列出收藏[个别 / 所有]项目"
    echo "  -s | --sort                                       #简短输出"
    echo "  -c | --check                                      #检查当前目录下的收藏项目状态"
    echo ""
    echo "  --add    \"item_name\" \"language\" \"describe\" \"url\"  #添加收藏项目"
    echo "       -N | --name \"item_name\""
    echo "       -L | --language \"language\""
    echo "       -D | --describe  \"describe\""
    echo "       -U | --url \"url\""
    echo "  --delete  \"item_name\" | -N  item_name                         #删除收藏项目"
    echo "  --pull                                [-t|--time  timeout]    #逐个下拉更新已收藏的项目,time 为超时时间秒,缺省60s"
    echo "  --pull    \"item_name\" | -N item_name  [-t|--time  timeout]    #下拉某个已收藏的项目,time 为超时时间秒,缺省60s"
    echo "  --clone                               [-t|--time  timeout]    #逐个下载收藏列表中的项目,time 为超时时间秒,缺省60s"
    echo "  --clone   \"item_name\" | -N item_name  [-t|--time  timeout]    #下载某个收藏列表中的项目,time 为超时时间秒,缺省60s"
    echo "--func   func_name  args ...                                     # 单独调用函数"
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_schedule
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local cmd=
    local name=
    local language=
    local describe=
    local url=
    local timeoute=60 #60s
    local debug=false
    local test=false
    local sort=false
    local func_test=false
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -s|--sort) sort=true; shift ;; #不带参数,移动1
            --test) test=true; shift ;; #不带参数,移动1
            -l|--list) if [[ -z "$cmd" ]]; then cmd=list;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            -c|--check) if [[ -z "$cmd" ]]; then cmd=check;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            -t|--time)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                timeout="$2"; shift 2 ;; #带参数,移动2
            -N|--name)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                name="$2"; shift 2 ;; #带参数,移动2
            -L|--language)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                language="$2"; shift 2 ;; #带参数,移动2
            -D|--describe)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                describe="$2"; shift 2 ;; #带参数,移动2
            -U|--url)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                url="$2"; shift 2 ;; #带参数,移动2                                                
            --add) if [[ -z "$cmd" ]]; then cmd=add;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            --delete) if [[ -z "$cmd" ]]; then cmd=delete;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            --pull) if [[ -z "$cmd" ]]; then cmd=pull;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            --clone) if [[ -z "$cmd" ]]; then cmd=clone;else echo "ERROR: multiple commands";return 2;fi;shift ;;
            --func) func_test=true; shift ;; #不带参数,移动1
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        s) sort=true ;;
                        l) if [[ -z "$cmd" ]]; then cmd=list;else echo "ERROR: multiple commands";return 2;fi ;;
                        c) if [[ -z "$cmd" ]]; then cmd=check;else echo "ERROR: multiple commands";return 2;fi ;;
                        t) timeout="$2"; shift;break ;; # 当 D 是合并选项的一部分时，它应该停止解析剩余的字符
                        N) name="$2"; shift;break ;; # 当 D 是合并选项的一部分时，它应该停止解析剩余的字符
                        L) language="$2"; shift;break ;; # 当 D 是合并选项的一部分时，它应该停止解析剩余的字符
                        D) describe="$2"; shift;break ;; # 当 D 是合并选项的一部分时，它应该停止解析剩余的字符
                        U) url="$2"; shift;break ;; # 当 D 是合并选项的一部分时，它应该停止解析剩余的字符
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    #=================== function test ==============================#
    if [ ${func_test} = true ];then
        if [ ${#remaining_args[@]} -lt 1 ];then grep -w "^function"  ${scriptfile};return 1;fi
        local func_list=($(grep -w "^function"  ${scriptfile} | awk '{print$2}'))
        local found_it=false
        for func in ${func_list[@]};do if [ ${func} = "${remaining_args[0]}" ];then found_it=true;fi;done
        if [ ${found_it} = false ];then echo "ERROR:${remaining_args[0]} not at this scriptfile";echo "Possible Function Name:{ ${func_list[@]} }";return 2;fi
        echo -e "\e[31mcall func ....\e[0m"
        ${remaining_args[0]} "${remaining_args[@]:1}"
        if [ ${debug} = true ];then echo "DEBUG:${remaining_args[0]} "${remaining_args[@]:1}"";fi
    fi
    #=================================================#
    #if [ ${#remaining_args[@]} -lt 1 ];then
    #    echo "ERROR: platform list is empty!!";usage;return 2
    #fi
    if [ -z ${name} ];then name="${remaining_args[0]}";fi
    if [ -z ${language} ];then language="${remaining_args[1]}";fi
    if [ -z ${describe} ];then describe="${remaining_args[2]}";fi
    if [ -z ${url} ];then url="${remaining_args[3]}";fi
    #==================== print debug =============================#    
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:test=${test}"
        echo "DEBUG:cmd=${cmd}"
        echo "DEBUG:name=${name}"
        echo "DEBUG:language=${language}"
        echo "DEBUG:describe=${describe}"
        echo "DEBUG:url=${url}"
        echo "DEBUG:timeout=${timeout}"
        echo "DEBUG:[${#remaining_args[@]}],remaining_args=${remaining_args[@]}"
    fi
    #start your code
    #for file in "${remaining_args}"
    #do
        #here we process each parameter

    #done
    which jq > /dev/null
    if [ $? -ne 0 ];then
        echo "jq not found! please install it first!"
        echo "apt install jq"
        return 2
    fi

    if [ "${cmd}" = "list" ];then
        echo -e "\e[31mlist ....\e[0m"
        if [ "x${name}" != "x" ];then
            func_list_item "${name}" "${remaining_args[@]:1}"
        else
            func_list_item "${remaining_args[@]}"
        fi
    fi

    if [ "${cmd}" = "check" ];then
        echo -e "\e[31mcheck ....\e[0m"
        func_check_item_status
    fi

    if [ "${cmd}" = "add" ];then
        echo -e "\e[31madd ....\e[0m"
        if [ "x${name}" != "x" ];then
            func_add_new_item "${name}" "${language}" "${describe}" "${url}"
        else
            echo "ERROR: item_name can not empty!!"
        fi
    fi

    if [ "${cmd}" = "delete" ];then
        echo -e "\e[31mdelete ....\e[0m"
        if [ "x${name}" != "x" ];then
            func_delete_item "${name}" "${remaining_args[@]:1}"
        else
            func_delete_item "${remaining_args[@]}"
            echo "ERROR: item_name can not empty!!"
        fi
    fi

    if [ "${cmd}" = "pull" ];then
        echo -e "\e[31mpull ....\e[0m"
        if [ "x${name}" != "x" ];then
            func_git_pull_update "${name}" "${remaining_args[@]:1}"
        else
            echo "ERROR: item_name can not empty!!"
        fi
    fi

    if [ "${cmd}" = "clone" ];then
        echo -e "\e[31mclone ....\e[0m"
        if [ "x${url}" != "x" ];then
            func_git_clone "${url}" "${remaining_args[@]}"
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
