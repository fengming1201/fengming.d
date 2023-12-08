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
function func_video_mult_player
{
	local app=gridplayer
	#local default_opt=¨--player-operation-mode=pseudo-gui¨
	local default_opt=

	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "$scriptfilename  a.mp4 b.mp4 c.mp4  ...."
		return 1
	fi
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo ¨ERROR:${scriptfilename},${app} not exist!¨;return 1;fi;

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

func_video_mult_player $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0