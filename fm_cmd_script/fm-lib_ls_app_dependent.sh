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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#列出《可执行文件》所依赖的《库》
function lib_ls_app_dependent
{
	if [ $# -lt 1  ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then 
		echo "CN:列出《可执行文件》所依赖的《库》"
		echo "discripttion:"
		echo "example:"
		echo "$scriptname    [-h or --help]"
		echo "$scriptname    exec_file"
		return 1
	fi
		
	local ldd_tools=ldd
	which ${ldd_tools} > /dev/null
	if [ $? -eq 0  ]
	then 
		echo "------------------------------------"
		echo "${ldd_tools} $*"
		${ldd_tools} $@
		echo "------------------------------------"
	else
		echo "${ldd_tools} not found!"
		return 1
	fi

	local objdump_tools=objdump
	which ${objdump_tools} > /dev/null
	if [ $? -eq 0  ]
	then 
		echo "------------------------------------"
		echo "${objdump_tools} -p $@ | grep NEEDED"
		${objdump_tools} -p $@ | grep NEEDED
		echo "------------------------------------"
	else
		echo "${objdump_tools} not found!"
		return 2
	fi

	local readelf_tools=readelf
	which ${readelf_tools} > /dev/null
	if [ $? -eq 0  ]
	then 
		echo "------------------------------------"
		echo "${readelf_tools} -p $@ | grep NEEDED"
		${readelf_tools} -a $@ | grep NEEDED
		echo "------------------------------------"
	else
		echo "${readelf_tools} not found!"
		return 3
	fi

	return 0
}

lib_ls_app_dependent $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
