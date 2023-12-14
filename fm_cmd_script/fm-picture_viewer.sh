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
function func_picture_viewer
{
	local app=gpicview
	local default_opt=

	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;
	
	if [ x"$SSH_CLIENT" = x ]
	then
		$app ${default_opt} "$*"
	else
		local opt="N"
		read -p "Are you sure display to remote screen？ [y/N]"  opt
		if [ "x${opt}" = "x"  ];then opt="N";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
			DISPLAY=:0 $app ${default_opt} "$*"
		fi
	fi
	return 0
}

func_picture_viewer $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0