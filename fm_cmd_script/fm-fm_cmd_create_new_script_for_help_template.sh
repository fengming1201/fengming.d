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
    echo "-p or --path  path            # save to other dir,e.g. -p ."
}

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_create_fm_cmd
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  file_list"
        echo "$scriptname  file1 file2 ..."
        return 1
    fi
    local file_list=$@

    for file in ${file_list}
    do 
        if [ -e ${target_dir}/${file} ];then echo "file:$file already exist!! skip it!";continue;fi
        if [ -w ${target_dir} ]
        then
            touch ${target_dir}/${file}
            chmod 747 ${target_dir}/${file}
        else
            sudo touch ${target_dir}/${file}
            sudo  chmod 747 ${target_dir}/${file}
        fi
        ls -lh ${target_dir}/${file}
        cat  <<-EOF >${target_dir}/${file}

#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile=\$0
scriptname=\$(basename \${scriptfile})
fengming_dir=\$FENGMING_DIR
#if unnecessary, please do not modify following code
extern_script_files=(\${fengming_dir}/fm_cmd_script/common_share_function.sh)
if [ -f \${extern_script_files[0]} ];then
    source \${extern_script_files[0]}
fi
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
#特殊根目录
special_root_dir=\${fengming_dir}/documents

##Parameter Counts      : 0
# Parameter Requirements: none
# Example:
##
function func_
{
    if [ \$# -lt 1 ];then tree -FhL 1 \${special_root_dir};usage; return 1; fi
    local debug=false
    local test=false
    local realdo=false
    local mode=normal
    local cmd_opt=() #命令自身累加选项，,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
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
        echo "DEBUG:cmd_opt=\${cmd_opt[@]} "#累加选项,如-F test.txt 加--file test.txt,-Q 加 --qr=true。
        echo "DEBUG:remaining_args=\${remaining_args[@]}"
    fi
    #=================== start your code ==============================#
    if [ \${#remaining_args[@]} -lt 1 ];then
        echo "ERROR: platform list is empty!!";usage;return 2
    fi
    #start your code

    local dir_list="none"
    local file_list="none"
    local file_array=()
    local file_list_size=0
    local num=1
    for one_arg in \${remaining_args[@]}
    do
        #[optional] check sub dir first
        dir_list=\$(find \${special_root_dir} -type d -iname "*\${one_arg}*")
        if [ "x\${dir_list}" != x ]
        then
            for one_dir in \${dir_list}
            do
                if [ -d \${one_dir} ];then
                    tree -sh \${one_dir}
                fi
            done
            continue
        fi

        #check file
        file_list=\${special_root_dir}/\${one_arg}
        if [ ! -f \${file_list} ]
        then
            file_list=\$(find \${special_root_dir} -type f -iname "\${one_arg}*")  #前缀
            #file_list=\$(find \${special_root_dir} -type f -iname "*\${one_arg}")  #后缀
            #file_list=\$(find \${special_root_dir} -type f -iname "\${one_arg}*" -o -type l -iname "\${one_arg}*")  #包括链接文件
        fi
        if [ "x\${file_list}" = x ]
        then 
            echo "no found help file with prefix \${one_arg}"
            local maybe_file=\$(find \${special_root_dir} -type f -iname "*\${one_arg}*")
            #local maybe_file=\$(find \${special_root_dir} -type f -iname "*\${one_arg}*" -o -type l -iname "*\${one_arg}*")  #包括链接文件
            if [ "x\${maybe_file}" != x ]
            then
                echo "maybe you looking for: "
                echo "\${maybe_file}"
            fi
            return 2
        fi
        readarray -t file_array <<< "\${file_list}"
        file_list_size=\${#file_array[@]}
        
        local sub_num=1
        for file_each in \${file_list}
        do
            echo "start[\$sub_num/\$file_list_size] ..."
            echo ""
            cat \${file_each}
            echo ""
            echo "end[\$sub_num/\$file_list_size] file:\${file_each}"
            sub_num=\$(expr \$sub_num + 1)
            echo "-----------------------------------------------------------"
        done
        echo "[\$num]=====================================================[\$num]"
        num=\$(expr \$num + 1)
        sub_num=1
        for file_each in \${file_list}
        do 
            echo "file[\$sub_num/\$file_list_size]: \${file_each}"
            sub_num=\$(expr \$sub_num + 1)
        done
        echo ""
    done
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "\$@"
if [ \$? -ne 0 ];then exit 0;fi

func_ "\$@"
if [ \$? -ne 0 ];then exit 1;fi
exit 0
EOF
    done
    return 0
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_create_fm_cmd "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0