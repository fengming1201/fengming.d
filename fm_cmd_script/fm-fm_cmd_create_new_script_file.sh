#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ];then
    source ${common_share_function}
fi

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
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
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
if [ $(id -u) -ne 0 ] && [ ${USER} != $(ls -ld . | awk '{print$3}') ];then
    maybeSUDO=sudo
fi
target_dir=${fengming_dir}/fm_cmd_script

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo "$scriptname  [opt]  script_filename"
    echo "opt:"
    echo "-h or --help                  # help"
    echo "-d or --debug                 # open debug mode"
    echo "--func   func_name  args ...  # call func_name for test"
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_create_fm_cmd
{

    if [ $# -ne 1 ];then usage; return 1; fi
    local debug=false
    local func_test=false
    local mode=normal
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数，移动1
            --func) func_test=true; shift ;; #不带参数,移动1
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
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
        if [ ${found_it} = false ];then echo "ERROR:${remaining_args[0]} not at this scriptfile";return 2;fi
        echo -e "\e[31mcall func ....\e[0m"
        ${remaining_args[0]} "${remaining_args[@]:1}"
        if [ ${debug} = true ];then echo "DEBUG:${remaining_args[0]} "${remaining_args[@]:1}"";fi
    fi
    #==================== print debug =============================#
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:func_test=${func_test}"
        echo "DEBUG:test=${test}"
        #echo "DEBUG:realdo=${realdo}"
        echo "DEBUG:mode=${mode}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    if [ ${#remaining_args[@]} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    if [ ${debug} = true ];then
        echo "debug=${debug}"
        echo "remaining_args=${remaining_args[@]}"
    fi
    #=================================================#
    local file_name=(${remaining_args[0]})
    if [ "x${file_name}" = "x" ];then echo "ERROR:file_name is empty!!";return 3;fi
    if [ -e ${target_dir}/${file_name} ];then
        local opt=n
        read -p "file:${file_name} already exist!! overwrite?[y/N]" opt
        if [ "x${opt}" = x ];then opt=N;fi
        if [ "x${opt}" = "xn"  ] || [ "x${opt}" = "xN"  ] || [ "x${opt}" = "xno"  ] || [ "x${opt}" = "xNO"  ];then
            return 0
        fi
    fi
    if [ -w ${target_dir} ];then
        touch ${target_dir}/${file_name}
        chmod 747 ${target_dir}/${file_name}
    else
        sudo touch ${target_dir}/${file_name}
        sudo chmod 747 ${target_dir}/${file_name}
    fi
    ls -lh ${target_dir}/${file_name}
    cat  <<-EOF >${target_dir}/${file_name}
#!/bin/bash

scriptfile=\$0
scriptname=\$(basename \${scriptfile})
fengming_dir=\$FENGMING_DIR
common_share_function=\${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f \${common_share_function} ] && [ "include" = "enable" ];then
    source \${common_share_function}
fi
#if unnecessary, please do not modify this function

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_location
{
    if [ -L \${scriptfile} ];then
        echo "location:\${scriptfile}  --> \$(readlink \${scriptfile})"
    else
        echo "location:\${scriptfile}"
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
    while [[ \$# -gt 0 ]];do
        case "\$1" in
            --debug) debug=true; shift ;; #不带参数,移动1
            --func) func_test=true; shift ;; #不带参数,移动1
            *) remaining_args+=("\$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    if [ \${func_test} = true ];then
        if [ \${#remaining_args[@]} -lt 1 ];then grep -w "^function"  \${scriptfile};return 1;fi
        local func_list=(\$(grep -w "^function"  \${scriptfile} | awk '{print\$2}'))
        local found_it=false
        for func in \${func_list[@]};do
            if [ \${func} = "\${remaining_args[0]}" ];then found_it=true;fi
        done
        if [ \${found_it} = false ];then
            echo "ERROR:\${remaining_args[0]} not at this scriptfile"
            echo "Possible Function Name:{ \${func_list[@]} }"
            return 2
        fi
        echo -e "\e[31mcall func call....\e[0m"
        \${remaining_args[0]} "\${remaining_args[@]:1}"
        if [ \${debug} = true ];then echo "DEBUG:\${remaining_args[0]} \${remaining_args[@]:1}";fi
        return 3
    fi
    return 0
}
if [ "\$1" = "info" ] || [ "\$1" = "-info" ] || [ "\$1" = "--info" ];then
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
if [ "\$1" = "show" ] || [ "\$1" = "-show" ] || [ "\$1" = "--show" ];then
    cat \${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ \$(id -u) -ne 0 ] && [ \${USER} != \$(ls -ld . | awk '{print\$3}') ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "\$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help     # help"
    echo "-d or --debug    # print variable status"
    echo "-t or --test     # test mode, no modifications"
    #echo "--realdo        # real execution"
    echo "-m or --mode     # you define"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_
{
    if [ \$# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local remaining_args=()
    while [[ \$# -gt 0 ]]
    do
        case "\$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            -m|--mode)
                if [[ -z "\$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="\$2"; shift 2 ;; #带参数,移动2
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<\${#1}; i++ )); do
                    case \${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="\$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        *) echo "ERROR: invalid option: -\${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("\$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    #==================== print debug =============================#
    if [ \${debug} = true ];then
        echo "DEBUG:maybeSUDO=\${maybeSUDO}"
        echo "DEBUG:debug=\${debug}"
        echo "DEBUG:test=\${test}"
        #echo "DEBUG:realdo=\${realdo}"
        echo "DEBUG:mode=\${mode}"
        echo "DEBUG:remaining_args=\${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    if [ \${#remaining_args[@]} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    #for file in "\${remaining_args[@]}"
    #do
        #here we process each parameter

    #done
    
    return 0
}

func_debug_function "\$@"
if [ \$? -ne 0 ];then exit 0;fi

func_ "\$@"
if [ \$? -ne 0 ];then exit 1;fi
exit 0
EOF
    return 0
}

func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_create_fm_cmd "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0