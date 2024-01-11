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

function func_svn_revert_all
{
    local app=svn

	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},${app} not exist!";return 1;fi

	# svn revert --recursive .
	local change_file_list=$(${app} st | grep ^[MCAD\!] | awk '{print $2}' | tac)
	local no_record_file_list=$(${app} st | grep ^? | awk '{print $2}')

	for file in $change_file_list
	do 
		${app} revert $file
	done

	for file in $no_record_file_list
	do
		if [ -d $file  ]
		then
			rm -rv $file
		else
			rm -v $file
		fi
	done

	echo "svn revert all files done"
}

func_svn_revert_all $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
