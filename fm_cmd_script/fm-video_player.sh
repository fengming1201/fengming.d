#!/bin/bash

scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
    exit 0
fi
function func_video_player
{
	local app=mpv
	local default_opt=

	if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "$scriptfilename  a.mp4   or"
		echo "$scriptfilename  rtmp://your-streaming-server:port/live/your-stream-key" 
		return 1
	fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptfilename},${app} not exist!¨;return 1;fi;

	if [ x"$SSH_CLIENT" = x ]
	then
		echo "$app ${default_opt} "$*""
		$app ${default_opt} "$*"
	else
		local opt="N"
		read -p "Are you sure display to remote screen？ [y/N]"  opt
		if [ "x${opt}" = "x"  ];then opt="N";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
			echo "DISPLAY=:0 $app ${default_opt} --fs "$*""
			DISPLAY=:0 $app ${default_opt} --fs "$*"
		fi
	fi
	return 0
}

func_video_player $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0