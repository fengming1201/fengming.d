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
function func_download_whole_website
{
	local tool=wget
	which ${tool} > /dev/null
	if [ $? != 0 ];then echo "ERROR:${tool} not found!!";return 1;fi
	
	if [ $# -lt 1 ];then echo "ERROR:paramter missing!!";echo "$scriptname URL";return 2;fi
	
	echo "wget -r -p -np -k -nc $*"
	wget -r -p -np -k -nc $*

    #wget -r -p -np -k -nc -e robots=off URL
    #wget 遵循 robots.txt 文件中的规则，因此如果你想下载被禁止的目录，
    #需要使用 -e robots=off 来禁用该限制。不过，请确保这样做符合网站的使用条款和法律要求。

    #wget -r -p -np -k -nc URL
    #-r 或 --recursive：递归下载，即下载指定页面以及页面中链接的所有文件。
    #-p 或 --page-requisites：下载页面上的所有元素，如图片、CSS、JavaScript 文件等。
    #-np 或 --no-parent：不追溯到上级目录，只下载当前目录及其子目录的内容。
    #-k 或 --convert-links：调整下载页面中的链接，使其指向本地文件。
    #-nc 或 --no-clobber：不覆盖本地已存在的文件。
    #这里添加了 -nc 参数，它告诉 wget 不要覆盖本地已存在的文件。如果本地文件已存在，wget 将跳过该文件的下载。

	return 0
}

func_download_whole_website $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0