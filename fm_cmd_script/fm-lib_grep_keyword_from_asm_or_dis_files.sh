#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi

#在《汇编或反汇编文件》中检索关键字，可以是“函数名”，“变量名”
function lib_grep_keyword_from_asm_or_dis_files
{
	local current_dir=$PWD
	#echo $current_dir
	if [ $# -lt 1  ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:在《汇编或反汇编文件》中检索关键字，可以是\“函数名\”，\“变量名\”"
		echo "discripttion:grep keyword from asm or dis files"
		echo "example:"
		echo "$scriptname    [-h or --help]"
		echo "$scriptname  function_name  #it will find all *.o file under current dir"
		echo "$scriptname [-w i n] function_name"
		return 1 
	fi

	local opt=
	local func_name=
	if [ $# -eq 1 ]
	then
		func_name=$1
	elif [ $# -eq 2 ]
	then
		opt=$1
		func_name=$2
	else
		echo "ERROR:format wrong"
		return 1
	fi
	
	local obj_file_list=$(find $current_dir -type f -name "*.dis" -o -name "*.asm")
	if [ x"$obj_file_list" = "x"  ]
	then
		echo "no found object file"
		return 3
	fi
	
	local total_file_counts=
	local found_in_file_counts=
	let total_file_counts=0
	let found_in_file_counts=0
	
	local tmp=
	for file in $obj_file_list
	do
		if [ ! -f $file  ]
		then
			echo "file:$file not exist"
			continue
		fi

		total_file_counts=$(($total_file_counts + 1))

		tmp=$(cat  $file | grep $opt $func_name)
		if [ x"$tmp"  != "x"  ] 
		then
			echo "$file --->>>"
			echo "$tmp"
			found_in_file_counts=$(($found_in_file_counts + 1))
		fi
	done

	echo "-------------------------------------------------------------"
	echo "            total check $total_file_counts object files"
	echo "     found function interface in  $found_in_file_counts files"
	echo "--------------------- done ----------------------------------"

	return 0
}

lib_grep_keyword_from_asm_or_dis_files $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
