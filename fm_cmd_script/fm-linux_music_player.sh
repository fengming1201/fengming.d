#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:moc（Music On Console）是一个简单的终端音乐播放器。"
    echo "添加音乐文件:按 a 键，然后输入音乐文件或目录的路径并按 Enter。"
    echo "控制播放:"
    echo "        q：退出 moc。"
    echo "        p：暂停/播放。"
    echo "        n：下一首曲目。"
    echo "        b：上一首曲目。"
    echo "        >：快进。"
    echo "        <：后退。"
    echo "        u：停止。"
    echo "        .：增加音量。"
    echo "        ,：减小音量。"
    echo "其他操作："
    echo "        按 Enter 键可以打开当前选择的曲目。"
    echo "        按 d 键可以从播放列表中删除当前选择的曲目。"
    echo "查看帮助：您可以在 moc 中按 h 键查看更多键盘快捷键和帮助信息。"
    echo ""
    echo "more detail to see:"
    echo "                   fm-cmd_help.sh  mocp_help"
    echo ""
    opt="N"
    read -t 5 -p "more detail to see:[y/N]?" opt
    if [ "x${opt}" = "x" ];then opt="N";fi
    if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ]
    then
        fm-cmd_help.sh  mocp_help
    fi
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
function see_other_info
{
    echo ""
    echo "(1)mplayer 是一个功能强大的命令行多媒体播放器，支持多种音频和视频格式。"
    echo "(2)MOC 或 Music On Console 是一款用于 Linux 的简约音乐播放器，它基于命令行界面，可以使用键盘浏览音频文件；也可以导航到某一个目录，用 MOC 来播放这些音频文件。"
    echo "   MOC 支持所有主流的音频格式，也能在后台工作，在听歌的同时也可以在系统上执行其他任务。"
    echo "(3)mpg123 是一款开源的命令行 专门用于播放MP3格式的音乐文件的Linux 音乐播放器。 它的命令行界面使其更加高效，并为您提供无缝的音乐播放体验，它的终端控制键允许通过键盘来使用媒体播放器。"
    echo "   mpg123 还支持音频随机播放，可以轻松创建播放列表，还可以用它的实时均衡器对声音进行微调。"
    echo "(4)cmus 是一款用于 Linux 的快速命令行音乐播放器。可以通过「cmus-remote」命令远程控制音乐播放器。"
    echo "(5)musikcube 是一款功能丰富的命令行 Linux 音乐播放器，支持来自多个在线来源的流媒体音频，可以在几乎所有 Linux 设备上流畅运行。"
    echo ""
    return 0
}


function func_linux_music_player
{
    local app=mocp
    local default_opt=
    #check param
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "usage:"
        echo "${scriptname}  info"
        echo "${scriptname}  other"
        echo ""
        echo "more detail to see:"
        echo "                   fm-cmd_help.sh  mocp_help2"
        echo ""
        local opt="N"
        read -t 5 -p "more detail to see:[y/N]?" opt
        if [ "x${opt}" = "x" ];then opt="N";fi
        if [ "x${opt}" = "xy" ] || [ "x${opt}" = "xY" ] || [ "x${opt}" = "xyes" ] || [ "x${opt}" = "xYES" ]
        then
            fm-cmd_help.sh  mocp_help2
        fi
        return 2
    fi
    if [ "$1" = "other" ]
    then
        see_other_info
        return 3
    fi

    which ${app} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "${app} not found!!,please install it first!"
        echo "apt install moc"
        return 1
    fi

    ${app} ${default_opt}  "$@"

    return 0
}

func_linux_music_player $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
