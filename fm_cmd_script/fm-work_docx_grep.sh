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
function func_main2
{
  local file="$1"
  shift
  echo ">>> $file"
  pandoc "$file" -t plain | grep "$@"
}

#grep in .docx file
function func_main
{
	local recursive=false
	local word_match=false
	local line_numbers=false
	local grep_options=""
	local keyword=""
	local files=()

	# 解析命令行选项
	while [[ $1 == -* ]]; do
		 case "$1" in
			 -r)
				 recursive=true
				 ;;
			 -w)
				 word_match=true
				 grep_options+=" -w"
				 ;;
			 -n)
				 line_numbers=true
				 grep_options+=" -n"
				 ;;
			 *)
				 echo "未知选项: $1"
				 echo "用法: wgrep [-rwn] keyword [file...]"
				 echo "  -r  递归搜索当前目录下的所有.docx文件"
				 echo "  -w  只匹配整个单词"
				 echo "  -n  显示行号"
				 return 1
				 ;;
		 esac
		 shift
	 done

	# 获取关键词
	if [ $# -lt 1 ]; then
		 echo "用法: wgrep [-rwn] keyword [file...]"
		 return 1
	fi

	keyword="$1"
	shift

	# 处理文件列表
	if [ "$recursive" = true ]; then
		 # 递归搜索当前目录下的所有.docx文件
		 files=( $(find . -type f -name "*.docx" 2>/dev/null) )
		 if [ ${#files[@]} -eq 0 ]; then
			 echo "未找到.docx文件"
			 return 1
		 fi
	else
		 # 使用提供的文件列表
		 if [ $# -eq 0 ]; then
			 echo "用法: wgrep [-rwn] keyword [file...]"
			 return 1
		 fi
		 files=( "$@" )
	fi

	local file
	local found=1  # 初始化found为1(没找到)，如果找到任何匹配就设置为0

	for file in "${files[@]}"; do
		 if [ -f "$file" ]; then
			 echo ">>> $file"
			 pandoc "$file" -t plain | grep $grep_options "$keyword"
			 if [ $? -eq 0 ]; then
				 found=0  # 找到匹配项
			 fi
		 else
			 echo "警告: 文件不存在或不是普通文件: $file"
		 fi
	 done

	return $found
}
#if unnecessary, please do not modify following code
func_debug_function "$@"
if [ $? -ne 0 ];then exit 0;fi

func_main "$@"
if [ $? -ne 0 ];then exit 1;fi
exit 0
