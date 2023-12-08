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
function func_ffmpeg_screen_record_push_2rtmpserver
{
	local push_tool=ffmpeg
	local screenID=":0.0"
	local resol="480x320"
	local rtmp_url=rtmp://116.62.103.60:1935/live/movie1234
	if [ $# -ne 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo "ERROR:parameter wrong"
		echo "$scriptfile screenID  resolution  rtps_url"
		echo "e.g:$scriptfile :0.0 480x320 rtmp://116.62.103.60:1935/live/movie1234"
		echo "屏幕分辨率(resolution):"
		echo "320x240   --常见于较早的移动电话和小型设备。"
    	echo "480x320   --常见于早期智能手机和某些小型平板电脑。"
    	echo "800x480   --常见于某些低成本智能手机和平板电脑。"
    	echo "1024x600  --常见于某些小型平板电脑和便携式设备。"
		echp "1280x720  --高清（HD）分辨率，也称为 720p。"
    	echo "1280x800  --常见于较小的平板电脑和便携式设备。"
		echo "1366x768  --广泛用于笔记本电脑和小型显示器的分辨率。"
		echo "1600x900  --常见于较大的笔记本电脑和中等尺寸显示器的分辨率。"
		echo "2560x1440 --2K 分辨率，也称为 Quad HD（QHD）或 1440p。"
		return 1
	fi
	which ${push_tool} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "ERROR:${push_tool} not found,please install it first"
		echo "apt install ${push_tool}"
		return 2
	fi

	screen="$1"
	resol="$2"
	rtmp_url="$3"
	if false
	then
		echo "${push_tool} -f x11grab -s ${resol} -i ${screen} -c:v libx264 -preset ultrafast ${rtmp_url}"
		${push_tool} -f x11grab -s ${resol} -i ${screen} -c:v libx264 -preset ultrafast ${rtmp_url}
	else
		echo "${push_tool} -f x11grab -s ${resol} -i ${screen} -c:v libx264 -preset ultrafast -f flv ${rtmp_url}"
		${push_tool} -f x11grab -s ${resol} -i ${screen} -c:v libx264 -preset ultrafast -f flv ${rtmp_url}
	fi
	return 0
}

func_ffmpeg_screen_record_push_2rtmpserver $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
