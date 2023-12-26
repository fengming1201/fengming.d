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
function func_rtmp_stream_video_player
{
	local app=mpv
	local default_opt=

	if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "$scriptname  rtmp_url"
		echo "$scriptname  rtmp://your-streaming-server:port/live/your-stream-key" 
		echo ""
		return 1
	fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${funcname},${app} not exist!¨;return 1;fi;

	if [ x"$SSH_CLIENT" = x ]
	then
		echo "$app ${default_opt} "$1""
		$app ${default_opt} "$1"
	else
		local opt="N"
		read -p "Are you sure display to remote screen？ [y/N]"  opt
		if [ "x${opt}" = "x"  ];then opt="N";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
			echo "DISPLAY=:0 $app ${default_opt} --fs "$1""
			DISPLAY=:0 $app ${default_opt} --fs "$1"
		fi
	fi
	return 0
}

func_rtmp_stream_video_player $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0