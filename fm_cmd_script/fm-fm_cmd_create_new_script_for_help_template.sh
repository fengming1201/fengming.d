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
    echo ""
    echo "-s or --standalone            # create standalone file"
    echo "-p or --path  path            # save to other dir,e.g. -p ."
    echo "--setx or --detail            # open set -x mode"
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
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<${#1}; i++ )); do
                    case ${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        s) standalone=true ;;
                        p) target_dir="$2"; shift;break ;; # 当 p 是合并选项的一部分时，它应该停止解析剩余的字符
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
        echo "DEBUG:outfile=${outfile}"
        echo "DEBUG:remaining_args=${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    local remaining_argc=${#remaining_args[@]}
    if [ ${remaining_argc} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
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
        ${maybeSUDO} chmod 755 ${target_dir}/${file_name}
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

if [ \$(id -u) -ne 0 ] && [ \${USER} != \$(ls -ld . | awk '{print\$3}') ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
target_dir=\${fengming_dir}/documents
##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function usage
{
    echo ""
    echo "\$scriptname  [opt]  files"
    echo "opt:"
    echo "-h or --help          # help"
    echo "-d or --debug         # print variable status"
    echo "-t or --test          # test mode, no modifications"
    #echo "--realdo             # real execution"
    echo "-a or --add     file  # add new help files"
    echo "-d or --delete  file  # delete file"

    echo "-m or --mode          # you define"
    echo "--setx or --detail    # open set -x mode"
    echo ""
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_
{
    if [ \$# -lt 1 ];then tree -FL 1 \${target_dir};usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local setx=false
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
            -F|--file)
                if [[ -z "\$2" ]]; then echo "ERROR: this opt requires one parameter" >&2; return 1; fi
                cmd_opt+=("--file \$2"); shift 2 ;; #带参数,移动2
            -Q|--qr) cmd_opt+=("--qr=true"); shift ;;
            -*)
                # 处理合并的选项,如-dh
                for (( i=1; i<\${#1}; i++ )); do
                    case \${1:i:1} in
                        h) usage; return 0 ;;
                        d) debug=true ;;
                        t) test=true ;;
                        m) mode="\$2"; shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
                        F) cmd_opt+=("--file \$2"); shift;break ;; # 当 m 是合并选项的一部分时，它应该停止解析剩余的字符
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
        echo "DEBUG:cmd_opt=\${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=\${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    local remaining_argc=\${#remaining_args[@]}
    if [ \${remaining_argc} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code
    local file_list=()
    local file_list_size=0
    #[optional] check sub dir first
    if [ -d \${target_dir}/\${remaining_args[0]} ];then
        #only dir
        if [ \${remaining_argc} -lt 2 ];then
            tree -F \${target_dir}/\${remaining_args[0]}
            return 0
        fi
        #dir/file
        #file_list+=(\$(find \${target_dir}/\${remaining_args[0]} -type f -iname "\${remaining_args[1]}*"))  #前缀
        file_list+=(\$(find \${target_dir}/\${remaining_args[0]} -type f -iname "*\${remaining_args[1]}"))  #后缀
        #file_list+=(\$(find \${target_dir}/\${remaining_args[0]} -type f -iname "\${remaining_args[1]}*" -o -type l -iname "\${remaining_args[1]}*"))  #包括链接文件
        #no found
        if [ \${#file_list[@]} -lt 1 ];then 
            echo "no found help file with prefix \${remaining_args[0]}"
            local maybe_file=\$(find \${target_dir}/\${remaining_args[0]} -type f -iname "*\${remaining_args[1]}*")
            #local maybe_file=\$(find find \${target_dir}/\${remaining_args[0]} -type f -iname "*\${remaining_args[0]}*" -o -type l -iname \${remaining_args[0]}*")  #包括链接文件
            if [ "x\${maybe_file}" != x ];then
                echo "maybe you looking for: "
                echo "\${maybe_file}"
            fi
            return 2
        fi
    elif [ -f \${target_dir}/\${remaining_args[0]} ];then
        #complete filename
        file_list+=(\${target_dir}/\${remaining_args[0]})
    else
        #borth not dir and file
        file_list+=(\$(find \${target_dir}/ -type f -iname "\${remaining_args[0]}*"))  #前缀
        file_list+=(\$(find \${target_dir}/ -type f -iname "*\${remaining_args[0]}"))  #后缀
        file_list+=(\$(find \${target_dir}/\${remaining_args[0]} -type f -iname "\${remaining_args[0]}*" -o -type l -iname "\${remaining_args[1]}*"))  #包括链接文件
    fi

    #readarray -t file_array <<< "\${file_list}"
    file_list_size=\${#file_list[@]}
    if [ \${debug} = true ];then echo "DEBUG:file_list[\${file_list_size}]=\${file_list[@]}";fi

    local sub_num=1
    if [ \${file_list_size} -eq 1 ];then
        for file_each in "\${file_list[@]}"
        do
            echo "start[\$sub_num/\$file_list_size] ..."
            echo ""
            cat \${file_each}
            echo ""
            echo "end[\$sub_num/\$file_list_size] file:\${file_each}"
            echo "-----------------------------------------------------------[\${sub_num}]"
            sub_num=\$(expr \$sub_num + 1)
        done
        echo "==============================================================="
    fi
    sub_num=1
    for file_each in "\${file_list[@]}"
    do 
        echo "file[\$sub_num/\$file_list_size]: \${file_each}"
        sub_num=\$(expr \$sub_num + 1)
    done

    #select by number
    if [[ \${remaining_args[-1]} =~ ^[0-9]+$ ]] ;then
        if [ \${remaining_args[-1]} -gt \${file_list_size} ];then 
            echo "ERROR: input number is larger than file list size"
            return 3
        fi
        sub_num=\$(expr \${remaining_args[-1]} - 1)
        echo "file[\${sub_num}] start..."
        echo ""
        cat \${file_list[\${sub_num}]}
        echo ""
        echo "file[\${sub_num}] end"
        echo "--------------------------------------------------------------"
    fi
    echo ""
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "\$@"
if [ \$? -ne 0 ];then exit 0;fi

func_ "\$@"
if [ \$? -ne 0 ];then exit 1;fi
exit 0
EOF

    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_create_fm_cmd "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0