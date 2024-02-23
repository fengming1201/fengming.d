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
function func_video_mult_player
{
	local app=gridplayer
	#local default_opt=¨--player-operation-mode=pseudo-gui¨
	local default_opt=

	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "$scriptname  a.mp4 b.mp4 c.mp4  ...."
		return 1
	fi
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

func_video_mult_player $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0