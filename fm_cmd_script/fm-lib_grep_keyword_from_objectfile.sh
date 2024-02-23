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
function lib_grep_keyword_from_objectfile
{
	if [ $# -lt 1  ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then 
		echo "CN:在《目标文件》中检索关键字，可以是\“函数名\”，\“变量名\”"
		echo "discripttion:grep keyword from librarys"
		echo "example:"
		echo "$scriptname    [-h or --help]"
		echo "$scriptname    obj_files [library list]"
		echo "$scriptname    obj_files"
		return 1
	fi
	local file_list=
	local target_obj=$1
	if [ $# -eq 1 ]
	then
		file_list=$(find ./ -name "*.a" -o -name "*.so")
	elif [ $# -gt 1 ]
	then
		shift 1
		file_list=$@
	fi
	
	#check tools
	local ar_toos=ar
	which ${ar_toos} > /dev/null
	if [ $? -ne 0   ];then echo "${ar_toos} not found!";return 2;fi
	
	local nm_toos=nm
	which ${nm_toos} > /dev/null
	if [ $? -ne 0   ];then echo "${nm_toos} not found!";return 3;fi

	local tmp_file=$(mktemp)
	local result=
	for file in $file_list
	do
		#check file exist
		if [ ! -e ${e_file} ]
		then
			echo "file:${file} not exist"
            continue
		fi
		
		if [ "${file##*.}" = "a"  ]
		then
			${ar_toos} -t ${file} > ${tmp_file}

		elif [ "${file##*.}" = "so"  ]
		then
			${nm_toos} -D ${file} > ${tmp_file}
		else
			echo "ERROR:unknow library  type"
			continue
		fi

        result=$(grep -i ${target_obj} ${tmp_file})
        if [ x${result} != x ]
        then
            echo "----  ${file}"
            echo ${result}
            echo "------------------------------------"

        fi
	done
    if [ -e ${tmp_file} ];then rm ${tmp_file};fi
	return 0
}

lib_grep_keyword_from_objectfile $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
