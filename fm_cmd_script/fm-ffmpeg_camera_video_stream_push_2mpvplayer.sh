#!/bin/bash
scriptfilename=$0

function func_ffmpeg_camera_video_stream_push_2mpvplayer
{
	local push_tool=ffmpeg
	local player=mpv
	local default_opt="--fs"
	local check_tool=v4l2-ctl
	local device=/dev/video
	local resol="480x320"

	if [ $# -ne 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "ERROR:parameter wrong"
		echo "$scriptfilename  dev  resolution"
		echo "e.g:$scriptfilename  /dev/video0   480x320"
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
	which ${player} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "ERROR:${player} not found,please install it first"
		echo "apt install ${player}"
		return 3
	fi
	device=$1
	resol=$2
	if [ ! -e ${device} ];then echo "device:${} not found!!";return 4;fi
	if [ x"$SSH_CLIENT" = x ]
	then
		echo "${push_tool} -f v4l2 -s ${resol} -i ${device} -c:v libx264 -preset ultrafast -tune zerolatency -f mpegts - | ${player} -"
		${push_tool} -f v4l2 -s ${resol} -i ${device} -c:v libx264 -preset ultrafast -tune zerolatency -f mpegts - | mpv -
	else
		echo "${push_tool} -f v4l2 -s ${resol} -i ${device} -c:v libx264 -preset ultrafast -tune zerolatency -f mpegts - | DISPLAY=:0 ${player} -"
		${push_tool} -f v4l2 -s ${resol} -i ${device} -c:v libx264 -preset ultrafast -tune zerolatency -f mpegts - | DISPLAY=:0 mpv -
	fi
	return 0
}
func_ffmpeg_camera_video_stream_push_2mpvplayer $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
