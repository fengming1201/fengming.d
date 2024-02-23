#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
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
function func_ffmpeg_videofile_stream_push_2my_mediaserver
{
	local push_tool=ffmpeg

	local server_ip=101.200.135.149
	local server_port=1935

	if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "ERROR:parameter wrong"
		echo "$scriptname  loop_times  video_file_lsit"
		echo "e.g:$scriptname 10 1.mp4 2.flv ..."
		return 1
	fi
	which ${push_tool} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "ERROR:${push_tool} not found,please install it first"
		echo "apt install ${push_tool}"
		return 2
	fi
	local loop_times=$1
	if ! expr "${loop_times}" : '^[0-9]\+$' >/dev/null
	then
		echo "first para is not number"
		echo "$scriptname  loop_times  video_file_lsit"
		return 3
	fi	
	shift 1
	while [ ${loop_times} -gt 0 ]
	do
		for file in "$@"
		do
			echo "${push_tool} -re -i "$file" -c copy -f flv rtmp://${server_ip}:${server_port}/live/movie1234"
			${push_tool} -re -i "$file" -c copy -f flv rtmp://${server_ip}:${server_port}/live/movie1234
		done
		loop_times=$(expr ${loop_times} - 1)
	done

	return 0
}

func_ffmpeg_videofile_stream_push_2my_mediaserver $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
