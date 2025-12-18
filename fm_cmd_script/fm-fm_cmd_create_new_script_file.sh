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
    COMMOND_FUNC_location
    exit 0
fi
#if unnecessary, please do not modify following code
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    COMMOND_FUNC_location
    exit 0
fi

if [ $(ls -ld . | awk '{print$3}') != $(whoami) ];then
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
    echo ""
    echo "-s or --standalone            # create standalone file"
    echo "-p or --path  path            # save to other dir,e.g. -p ."
    echo "--setx or --detail            # open set -x mode"
    echo "--func   func_name  args ...                            #调试某个函数,无参数--func,显示函数列表"
    #echo "--stdin            # 从标准输入读取输入（支持heredoc和管道）"
    #echo "example:"
    #echo "$scriptname --stdin << EOF"
    #echo "  > input data here"
    #echo "  > EOF"
    #echo "cat data.txt | $scriptname --stdin"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_create_fm_cmd
{
    if [ $# -lt 1 ];then usage; return 1; fi
    local debug=false
    local func_test=false
    local mode=normal
    local standalone=false
    local setx=false
    local use_stdin=false
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数，移动1
            --func) func_test=true; shift ;; #不带参数,移动1
            -p|--path)
                if [[ -z "$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                target_dir="$2"; shift 2 ;; #带参数,移动2
            -s|--standalone) standalone=true; shift ;; #不带参数,移动1
            --setx) setx=true; shift ;; #不带参数,移动1
            --detail) setx=true; shift ;; #不带参数,移动1
            --stdin) use_stdin=true; shift ;;
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        s) standalone=true ;;
                        p) target_dir="$2"; shift;break ;; # 当 p 是合并选项的一部分时，它应该停止解析剩余的字符
                        Q) cmd_opt+=("--qr=true") ;;
                        *) echo "ERROR: invalid option: -${1:i:1}" >&2; return 1 ;;
                    esac
                done
                shift ;;
            *) remaining_args+=("$1"); shift ;; # 非选项参数全部放入数组中
        esac
    done
    #==================== print debug =============================#
    if [ ${debug} = true ];then
        echo "DEBUG:debug=${debug}"
        echo "DEBUG:func_test=${func_test}"
        echo "DEBUG:test=${test}"
        echo "DEBUG:standalone=${standalone}"
        #echo "DEBUG:realdo=${realdo}"
        #echo "DEBUG:mode=${mode}"
        echo "DEBUG:setx=${setx}"
        echo "DEBUG:use_stdin=${use_stdin}"
        echo "DEBUG:use_stdin=${use_stdin}"
        echo "DEBUG:outfile=${outfile}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    if [ ${use_stdin} = true ];then
        # Read from stdin
        if [ -t 0 ]; then
            echo "ERROR: --stdin option requires input from pipe or heredoc!" >&2
            return 2
        fi
        input_string=$(cat)
        # Remove newlines and extra whitespace
        input_string=$(echo "${input_string}" | tr '\n' ' ' | tr -s ' ')
        echo "DEBUG:input_string=${input_string}"
    else
        local remaining_argc=${#remaining_args[@]}
        if [ ${remaining_argc} -lt 1 ];then
            echo "ERROR: platform list is empty!!";usage;return 2
        fi
    fi
    if [ ${debug} = true ];then
        echo "debug=${debug}"
        echo "remaining_args=${remaining_args[@]}"
    fi
    #=================================================#
    local file_name=(${remaining_args[0]})
    if [ "x${file_name}" = "x" ];then echo "ERROR:file_name is empty!!";return 3;fi
    if [ -f ${target_dir}/${file_name} ];then
        local opt=n
        read -p "file:${file_name} already exist!! overwrite?[y/N]" opt
        if [ "x${opt}" = x ];then opt=N;fi
        if [ "x${opt}" = "xn"  ] || [ "x${opt}" = "xN"  ] || [ "x${opt}" = "xno"  ] || [ "x${opt}" = "xNO"  ];then
            return 0
        fi
        if [ ! -x ${target_dir}/${file_name} ];then
            ${maybeSUDO} chmod 755 ${target_dir}/${file_name}
        fi
    else
        ${maybeSUDO} touch ${target_dir}/${file_name}
        sudo chmod 755 ${target_dir}/${file_name}
    fi
    #common head code
    cat <<-EOF >${target_dir}/${file_name}
#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile=\$0
scriptname=\$(basename \${scriptfile})
EOF
    if [ ${standalone} = true ];then
        #独立文件
        cat ${extern_script_files[0]} | sed -n '/#start_copy4_standalone_code/,/#end_copy4_standalone_code/p' | \
        sed 's/^.*#start_copy4_standalone_code.*$//; s/^.*#end_copy4_standalone_code.*$//' >>${target_dir}/${file_name}
    else
        #依赖共享库
        cat  <<-EOF >>${target_dir}/${file_name}
fengming_dir=\$FENGMING_DIR
#if unnecessary, please do not modify following code
extern_script_files=(\${fengming_dir}/fm_cmd_script/common_share_function.sh)
if [ -f \${extern_script_files[0]} ];then
    source \${extern_script_files[0]}
fi

EOF
    fi
    #common code
    cat <<-EOF >>${target_dir}/${file_name}
#if unnecessary, please do not modify following code
if [ "\$1" = "info" ] || [ "\$1" = "-info" ] || [ "\$1" = "--info" ];then
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
if [ "\$1" = "show" ] || [ "\$1" = "-show" ] || [ "\$1" = "--show" ];then
    cat \${scriptfile}
    echo ""
    func_location
    exit 0
fi

if [ \$(ls -ld . | awk '{print\$3}') != \$(whoami) ];then
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
    echo "$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help       # help"
    echo "-d or --debug      # print variable status"
    echo "-t or --test       # test mode, no modifications"
    #echo "--realdo          # real execution"
    echo "-m or --mode       # you define"
    echo "--setx or --detail # open set -x mode"
    echo "--func   func_name  args ...                            #调试某个函数,无参数--func,显示函数列表"
    echo "--stdin            # 从标准输入读取输入（支持heredoc和管道）"
    echo "example:"
    echo "$scriptname --stdin << EOF"
    echo "    data line 1"
    echo "    data line 2"
    echo "EOF"
    echo "cat data.txt | $scriptname --stdin"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_main
{
    if [ \$# -lt 1 ];then usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local setx=false
    local use_stdin=false
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
    local remaining_args=()
    while [[ \$# -gt 0 ]]
    do
        case "\$1" in
            -h|--help) usage; return 0 ;;
            -d|--debug) debug=true; shift ;; #不带参数,移动1
            -t|--test) test=true; shift ;;
            --realdo) realdo=true; shift ;;
            --setx) setx=true; shift ;; #不带参数,移动1
            --detail) setx=true; shift ;; #不带参数,移动1
            -m|--mode)
                if [[ -z "\$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                mode="\$2"; shift 2 ;; #带参数,移动2
            --stdin) use_stdin=true; shift ;;
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<\${#1}; i++ )); do
                    case \${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="\$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        Q) cmd_opt+=("--qr=true") ;;
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
        echo "DEBUG:setx=\${setx}"
        echo "DEBUG:use_stdin=\${use_stdin}"
        echo "DEBUG:cmd_opt=\${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=\${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    # check if input is from stdin
    if [ \${use_stdin} = true ];then
        # Read from stdin
        if [ -t 0 ]; then
            echo "ERROR: --stdin option requires input from pipe or heredoc!" >&2
            return 2
        fi
        input_string=\$(cat)
        # Remove newlines and extra whitespace
        input_string=\$(echo "\${input_string}" | tr '\n' ' ' | tr -s ' ')
        echo "DEBUG:input_string=\${input_string}"
    else
        local remaining_argc=\${#remaining_args[@]}
        if [ \${remaining_argc} -lt 1 ];then
            echo "ERROR: platform list is empty!!";usage;return 2
        fi
    fi
    
    #for file in "\${remaining_args[@]}"
    #do
        #here we process each parameter
        #linux_cmd  \${cmd_opt[@]} args ....
    #done
    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "\$@"
if [ \$? -ne 0 ];then exit 0;fi

func_main "\$@"
if [ \$? -ne 0 ];then exit 1;fi
exit 0
EOF
    ls -lh ${target_dir}/${file_name}
    #create other file
    for newfilename in "${remaining_args[@]:1}"
    do
        #echo "cp -av ${target_dir}/${file_name} ${target_dir}/${newfilename}"
        cp -a ${target_dir}/${file_name} ${target_dir}/${newfilename}
        ls -lh ${target_dir}/${newfilename}
    done
    
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_create_fm_cmd "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0