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
function func_aviv_grep
{ 
    local app=grep
    local default_opt="-rin --exclude=*.torrent"
    local filename=none

	#check parameter
    if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:"
        echo "SYNOPSIS:"
        echo "         ${scriptname}  key-word"
        return 1
    fi	
	#check exec file state
    which ${app} > /dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR:${scriptname},${app} not exist!"
        return 2
    fi
	if [ $# -eq 1 ]
	then 
		
		local tmp=$(echo $1 | sed -n 's/-/00/p')
		if [ "$1" != "${tmp}" ]
		then
			filename=${tmp}
		fi
	fi

	local tmp_file=$(mktemp)
    find > ${tmp_file}
    $app ${default_opt} $*
	$app -in $* ${tmp_file}
	
	if [ "x${filename}" != "x" ]
	then
		$app ${default_opt} ${filename}
		$app -in ${filename} ${tmp_file}
	fi
	
    rm ${tmp_file}

    return 0
}

func_aviv_grep $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
