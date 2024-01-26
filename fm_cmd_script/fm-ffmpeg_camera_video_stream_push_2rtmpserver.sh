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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_ffmpeg_camera_video_stream_push_2rtmpserver
{
	local push_tool=ffmpeg
	local check_tool=v4l2-ctl
	local rtmp_url=localhost
	local device=/dev/video0
	local resol="480x320"
	if [ $# -lt 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "ERROR:parameter wrong"
		echo "$scriptname dev resolution rtmp_url"
		echo "e.g:$scriptname /dev/video0 1366x768 rtmp://116.62.103.60:1935/live/test"
		echo "屏幕分辨率(resolution):"
		which ${check_tool} > /dev/null
		if [ $? -eq 0 ]
		then
			${check_tool} --list-formats-ext | grep -w "Size:" | awk '{print"resolution: "$3}'
		else
			echo "${check_tool} not found!!"
			echo "please install first:apt install  v4l-utils"
			echo "320x240   --常见于较早的移动电话和小型设备。"
			echo "480x320   --常见于早期智能手机和某些小型平板电脑。"
			echo "800x480   --常见于某些低成本智能手机和平板电脑。"
			echo "1024x600  --常见于某些小型平板电脑和便携式设备。"
			echp "1280x720  --高清（HD）分辨率，也称为 720p。"
			echo "1280x800  --常见于较小的平板电脑和便携式设备。"
		fi
		return 1
	fi
	which ${push_tool} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "ERROR:${push_tool} not found,please install it first"
		echo "apt install ${push_tool}"
		return 2
	fi
	device=$1
	resol=$2
	rtmp_url=$3
	if [ ! -e ${device} ];then echo "device:${device} not found!!";return 3;fi

	if false
	then
		echo "${push_tool} -f v4l2 -i ${device} -c:v libx264 -preset veryfast -tune zerolatency -f flv ${rtmp_url}"
		${push_tool} -f v4l2 -i ${device} -c:v libx264 -preset veryfast -tune zerolatency -f flv ${rtmp_url}
	else
		echo "${push_tool} -f v4l2 -video_size  ${resol} -i ${device} -c:v libx264 -preset veryfast -tune zerolatency -f flv ${rtmp_url}"
		${push_tool} -f v4l2 -video_size  ${resol} -i ${device} -c:v libx264 -preset veryfast -tune zerolatency -f flv ${rtmp_url}
	fi
	#with sound
	#ffmpeg -f v4l2 -video_size  1366x768 -i /dev/video0 -f alsa -i default  -c:v libx264 -preset veryfast -tune zerolatency -c:a aac -f flv rtmp://192.168.8.107:1935/live/test1

	return 0
}

func_ffmpeg_camera_video_stream_push_2rtmpserver $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
