#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
fi
function func_grep_aviv
{ 
    local app=grep
    local default_opt="-rin --exclude=*.torrent"
    local filename=none

	#check parameter
    if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "DESCRIPTION:"
        echo "SYNOPSIS:"
        echo "         ${scriptfilename}  key-word"
        return 1
    fi	
	#check exec file state
    which ${app} > /dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR:${scriptfilename},${app} not exist!"
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

func_grep_aviv $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
