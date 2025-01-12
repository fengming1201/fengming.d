#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:下载整个网站"
    echo ""
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
function  func_help
{
    echo "等价于："
    echo "wget -r -p -np -k -N -c  URL"
    echo ""
    echo "参数解释:"
    echo "-r 或 --recursive：递归下载，即下载指定页面以及页面中链接的所有文件。"
    echo "-p 或 --page-requisites：下载页面上的所有元素，如图片、CSS、JavaScript 文件等。"
    echo "-np 或 --no-parent：不追溯到上级目录，只下载当前目录及其子目录的内容。"
    echo "-k 或 --convert-links：调整下载页面中的链接，使其指向本地文件。"
    echo "-N 或 --timestamping ：启用时间戳检查，跳过远程未更新的文件。"
    echo "-c：继续下载部分下载的文件（断点续传）。"
    echo ""
    echo "其他有用参数:"
    echo "--limit-rate=100k：限制下载速度为 100KB/s，避免占用过多带宽。"
    echo "-P /path/to/save：指定文件保存的目录。"
    echo "-A \'*.tar.gz\'：仅下载 .tar.gz 文件。,多个则用逗号隔开，-A \'*.tar.gz,*.tar.gz.sig\'"
    echo "-R \'*.html\'：排除 .html 文件。"
    echo ""
    echo "wget -r -p -np -k -N -c -e robots=off URL"
    echo "#wget 遵循 robots.txt 文件中的规则，因此如果你想下载被禁止的目录，"
    echo "需要使用 -e robots=off 来禁用该限制。不过，请确保这样做符合网站的使用条款和法律要求。"
    echo ""
    echo "为什么 -N 比 -nc 更适合？"
    echo "-nc 或 --no-clobber避免覆盖已经存在的文件，但它不会检查文件内容是否完整或是否已经下载过。"
    echo "-N ：检查文件的远程时间戳，如果本地文件已经是最新的，则跳过下载；如果文件不完整或远程文件已更新，则重新下载。"
    echo ""
    return 0
}
function func_download_whole_website
{
	local tool=wget
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then
        echo ""
        echo "$scriptname  [other_args]  URL"
        echo ""
        func_help
        return 1
    fi

	which ${tool} > /dev/null
	if [ $? != 0 ];then echo "ERROR:${tool} not found!!";return 1;fi

	echo "wget -r -p -np -k -N -c $@"
	${tool} -r -p -np -k -N -c $@

	return 0
}

func_download_whole_website $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0