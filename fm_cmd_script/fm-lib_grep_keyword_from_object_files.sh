#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#在《目标文件》中检索关键字，可以是“函数名”，“变量名”
function lib_grep_keyword_from_object_files
{
	local ARM_NM=nm
	local NMFLAG="-a" #"--defined-only"

	local current_dir=$PWD
	#echo $current_dir

	if [ $# -lt 1  ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "CN:在《目标文件》中检索关键字，可以是\“函数名\”，“变量名\”"
		echo "discripttion:grep keyword from object files,e.g.:function_name or variable_ame"
		echo "example:"
		echo "$scriptname    [-h or --help]"
		echo "$scriptname  function_name  keyword   #only keyword,then it will find all *.o file under current dir"
		echo "$scriptname  function_name  keyword  a.o b.o c.o"
		return 1 
	fi

	which $ARM_NM > /dev/null
	if [ $? -ne 0  ]
	then
		echo "NM=$ARM_NM not found"
		return 2
	fi

	local func_name=$1
	local obj_file_list=
	if [ $# -ge 2  ]
	then
		shift
		obj_file_list=$*
	else
		obj_file_list=$(find $current_dir -type f -name "*.o")
	fi

	#echo "function_name=$func_name"
	#echo "obj_file_list=$obj_file_list"

	if [ x"$obj_file_list" = "x"  ]
	then
		echo "no found object file"
		return 3
	fi

	local total_file_counts=
	local found_in_file_counts=
	let total_file_counts=0
	let found_in_file_counts=0
	
	local file_type=
	local tmp=
	for file in $obj_file_list
	do
		if [ ! -f $file  ]
		then
			echo "file:$file not exist"
			continue
		fi

		total_file_counts=$(($total_file_counts + 1))

		file_type=$(file $file | grep -i arm )
		if [ x"$file_type" = "x"  ]
		then
			which nm > /dev/null
			if [ $? -ne 0  ]
			then
				continue
			fi
			tmp=$(nm $NMFLAG  $file | grep -wi $func_name)
		else
			tmp=$($ARM_NM $NMFLAG  $file | grep -wi $func_name)
		fi

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

lib_grep_keyword_from_object_files $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
