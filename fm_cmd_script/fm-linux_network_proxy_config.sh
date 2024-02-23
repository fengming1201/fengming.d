#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_network_proxy_config
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "方法一：设置环境变量"
        echo "       设置代理服务器的 IP 地址和端口号："
        echo "       #export http_proxy=http://proxy-ip:port"
        echo "       #export https_proxy=http://proxy-ip:port"
        echo ""
        echo "如果代理服务器需要认证，还需要设置用户名和密码："
        echo "       #export http_proxy=http://username:password@proxy-ip:port"
        echo "       #export https_proxy=http://username:password@proxy-ip:port"
        echo ""
        echo "方法二：全局代理设置"
        echo "       如果想要所有的网络访问都通过代理服务器，可以在 /etc/environment 文件中设置全局代理"
        echo "       #sudo vi /etc/environment"
        echo "在文件中添加以下内容："
        echo "http_proxy=http://proxy-ip:port"
        echo "https_proxy=http://proxy-ip:port"
        echo ""
        echo "例如："
        echo "http_proxy=http://101.200.135.149:7890"
        echo "https_proxy=http://101.200.135.149:7890"
        echo ""
        echo "如果您只想让 wget 和 curl 这两个工具使用代理服务器进行下载，而不影响其他网络访问，可以通过设置环境变量的方式来实现。"
        echo "使用方法一中的设置即可。"
        echo ""
        echo "要在 Linux 系统上使用 SOCKS v5 代理，您可以通过 SSH 连接或使用专门的 SOCKS 代理软件（如 Shadowsocks、Tor 等）来实现。"
        echo "以下是使用 SSH 连接作为 SOCKS v5 代理的步骤："
        echo "step 1:建立SSH连接"
        echo "在终端中建立一个 SSH 连接,并将本地端口(比如1080)转发到远程服务器上的 SOCKS 代理端口(通常是1080或其他端口)。"
        echo "#ssh -D 1080 -C -q -N user@remote_server_ip"
        echo "    -D 1080：指定本地端口为1080，用于 SOCKS 代理连接。"
        echo "    -C：启用压缩。"
        echo "    -q：静默模式，减少输出。"
        echo "    -N：不执行远程命令。"
        echo "step 2:配置应用程序"
        echo "配置您的应用程序（如浏览器、curl、wget 等）以使用本地端口1080作为 SOCKS 代理服务器。"
        echo "您可以在应用程序的设置中找到代理设置，并将其配置为 SOCKS v5 代理，地址为 127.0.0.1，端口为 1080。"
        echo ""
        echo "请注意，使用 SSH 连接作为 SOCKS 代理的方式需要保持 SSH 连接的开启状态，代理也会随之保持开启。"
        echo "如果您希望在后台运行 SSH 代理连接，可以使用 -f 参数，例如："
        echo "#ssh -f -D 1080 -C -q -N user@remote_server_ip"
        echo "要关闭代理连接，您可以使用 kill 命令终止对应的进程。"
        echo ""

        return 1
    fi


    return 0
}

func_network_proxy_config "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
