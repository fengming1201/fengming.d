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
function func_ffmpeg_videofile_stream_push_2rtmpserver
{
	local push_tool=ffmpeg
	local loop_times=1
	local rtmp_url=localhost

	if [ $# -lt 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "ERROR:parameter wrong"
		echo "$scriptname  loop_times  rtmp_url video_file_lsit"
		echo "e.g:$scriptname 10 rtmp://116.62.103.60:1935/live/test 1.mp4 2.flv ..."
		return 1
	fi
	which ${push_tool} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "ERROR:${push_tool} not found,please install it first"
		echo "apt install ${push_tool}"
		return 2
	fi
	loop_times=$1
	rtmp_url=$2

	if ! expr "${loop_times}" : '^[0-9]\+$' >/dev/null
	then
		echo "para:${loop_times} is not number"
		echo "$scriptname  loop_times  video_file_lsit"
		return 3
	fi

	shift 2
	while [ ${loop_times} -gt 0 ]
	do
		for file in "$@"
		do
			echo "${push_tool} -re -i "$file" -c copy -f flv ${rtmp_url}"
			${push_tool} -re -i "$file" -c copy -f flv ${rtmp_url}
		done
		loop_times=$(expr ${loop_times} - 1)
	done
	
	return 0
}

func_ffmpeg_videofile_stream_push_2rtmpserver $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0