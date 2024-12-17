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
function func_ffmpeg_videofile_merge_stream_push_2rtmpserver
{
	local push_tool=ffmpeg
	local play_times=1
	local rtmp_url=localhost

	if [ $# -lt 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "ERROR:parameter wrong"
		echo "$scriptname  rtmp_url   play_times   video_file_list"
		echo "e.g:$scriptname rtmp://106.13.34.177:1935/live/test  10  1.mp4 2.flv ..."
		return 1
	fi
	which ${push_tool} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "ERROR:${push_tool} not found,please install it first"
		echo "apt install ${push_tool}"
		return 2
	fi
    rtmp_url=$1
	play_times=$2
	if ! expr "${play_times}" : '^[0-9]\+$' >/dev/null
	then
		echo "para:${play_times} is not number"
		echo "$scriptname  play_times  video_file_lsit"
		return 3
	fi

	shift 2
	local video_list=()
	local video_count=0
	#check file exist status
	for file in "$@"
	do
		if [ -f "${file}" ]
		then 
            video_list+=("${file}")
		else
			echo "file:${file} not exist!"
		fi
	done
	video_count=${#video_list[@]}

	while [ ${play_times} -gt 0 ] && [ ${video_count} -gt 0 ]
	do
		case ${video_count} in
			1) 
			${push_tool} -re -i "${video_list[0]}" -c copy -f flv ${rtmp_url}
			;;
			2) 
            ${push_tool} -i ${video_list[0]} -i ${video_list[1]} \
            -filter_complex "[0:v]scale=640:480,pad=640:480:0:0[left];[1:v]scale=640:480,pad=640:480:0:0[right];[left][right]hstack[outv];[0:a][1:a]amerge=inputs=2[outa]" \
            -map "[outv]" -map "[outa]" \
            -c:v libx264 -c:a aac \
            -preset veryfast -tune zerolatency \
            -f flv ${rtmp_url}
			;;
			3) 
			${push_tool} -i ${video_list[0]} -i ${video_list[1]} -i ${video_list[2]} \
            -filter_complex "[0:v]scale=426:240,pad=426:240:0:0[left];[1:v]scale=426:240,pad=426:240:0:0[center];[2:v]scale=426:240,pad=426:240:0:0[right];[left][center][right]hstack=3[outv];[0:a][1:a][2:a]amerge=inputs=3[outa]" \
            -map "[outv]" -map "[outa]" \
            -c:v libx264 -c:a aac \
            -preset veryfast -tune zerolatency \
            -f flv ${rtmp_url}
			;;
			4) 
			${push_tool} -i ${video_list[0]} -i ${video_list[1]} -i ${video_list[2]} -i ${video_list[3]} \
            -filter_complex "[0:v]scale=320:240,pad=320:240:0:0[a];[1:v]scale=320:240,pad=320:240:0:0[b];[2:v]scale=320:240,pad=320:240:0:0[c];[3:v]scale=320:240,pad=320:240:0:0[d];[a][b]hstack[top];[c][d]hstack[bottom];[top][bottom]vstack[outv];[0:a][1:a][2:a][3:a]amerge=inputs=4[outa]" \
            -map "[outv]" -map "[outa]" \
            -c:v libx264 -c:a aac \
            -preset veryfast -tune zerolatency \
            -f flv ${rtmp_url}
			;;						
			*) defult 
			echo "unknow  video counts!"
			return 4
			;;
		esac
		play_times=$(expr ${play_times} - 1)
	done
	
	return 0
}

func_ffmpeg_videofile_merge_stream_push_2rtmpserver $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
