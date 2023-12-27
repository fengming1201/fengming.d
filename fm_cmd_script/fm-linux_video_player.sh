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
function func_video_player
{
	local app=mpv
	local default_opt=

	if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "$scriptname  video file list"
		echo "$scriptname  a.mp4  b.mp4 ..." 
		echo ""
		return 1
	fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${funcname},${app} not exist!¨;return 1;fi;

	if [ x"$SSH_CLIENT" = x ]
	then
		for vfile in "$@"
		do
			echo "${app} ${default_opt} ${vfile}"
			${app} ${default_opt} "${vfile}"
		done
	else
		local opt="N"
		read -p "Are you sure display to remote screen？ [y/N]"  opt
		if [ "x${opt}" = "x"  ];then opt="N";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
			for vfile in "$@"
			do
				echo "DISPLAY=:0 ${app} ${default_opt} --fs ${vfile}"
				DISPLAY=:0 ${app} ${default_opt} --fs "${vfile}"
			done
		fi
	fi
	return 0
}

func_video_player "$@"
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0