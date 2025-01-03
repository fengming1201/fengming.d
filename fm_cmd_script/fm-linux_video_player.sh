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
function func_video_player
{
	local app=mpv
	local default_opt=

	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "$scriptname  video file list or  rtmp_url #参数支持三种模式"
		echo "$scriptname  a.mp4  b.mp4 ..." 
		echo "$scriptname  rtmp://IP:PORT/live/movie123"
		echo "$scriptname  player_list.txt"  
		echo "  cat player_list.txt"
		echo "    /pathto/video1.mp4"
		echo "    ./pathto/video2.mp4"
		echo "    ...."
		echo ""
		return 1
	fi
	#which ${app} > /dev/null
	#if [ $? -ne 0 ];then echo ¨ERROR:${funcname},${app} not exist!¨;return 1;fi;
	
	if [ $# -eq 1 ] && [ -f $1 ] && [ "x$(file "$1" | grep -w "text")" != "x" ]
	then
		# 使用 set 命令将文件内容作为参数列表
		set -- $(cat $1)
	fi

	local play_list=()
	for file in "$@"
	do
		if [ -f "${file}"  ] || [ "x$(echo "${file}" | grep -w "rtmp:")" != "x" ]
		then 
			play_list+=("${file}")
		else
			echo "file:${file} not exist!"
		fi
	done
	if [ ${#play_list[@]} -eq 0 ];then echo "play_list is empty!";return 2;fi
	
	if [ x"$SSH_CLIENT" = x ]
	then
		for vfile in "${play_list[@]}"
		do
			echo "${app} ${default_opt} ${vfile}"
			${app} ${default_opt} "${vfile}"
		done
	else
		local opt="Y"
		read -p "Are you sure display to remote screen? [Y/n]"  opt
		if [ "x${opt}" = "x"  ];then opt="Y";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
			for vfile in "${play_list[@]}"
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
