#!/bin/bash

#if unnecessary, please do not modify following code
scriptfile_path=$(readlink -f $0)
scriptfile_name=$(basename ${scriptfile_path})
scriptfile_dir=$(dirname ${scriptfile_path})


function func_term_size
{
	local size
	#优先从真实 tty 读，避免被管道/重定向干扰
	if [ -r /dev/tty ]; then
		size=$(stty size < /dev/tty 2>/dev/null)
		if [ -n "${size}" ]; then
			rows=${size%% *}
			cols=${size##* }
			return 0
		fi
	fi
	if command -v tput >/dev/null 2>&1; then
		rows=$(tput lines)
		cols=$(tput cols)
		return 0
	fi
	rows=24
	cols=80
}

function func_qr_fit_terminal
{
	local payload="$1"
	local rows cols h w scale pad_x pad_y i k ch out
	local -a lines

	#ASCII：每模块 2 列 x 1 行，正好抵消终端字符约 1:2 的宽高比，放大后仍是正方形
	#不要用 UTF8 半块（▄▀）整行复制，否则会拉出横纹、定位点被拉扁
	if ! qr_out=$(qrencode -o - -t ASCII -m 1 -l L "${payload}"); then
		echo "exec qrencode wrong."
		return 4
	fi
	qr_out="${qr_out%$'\n'}"
	mapfile -t lines <<< "${qr_out}"
	h=${#lines[@]}
	w=${#lines[0]}
	if [ "${h}" -lt 1 ] || [ "${w}" -lt 1 ]; then
		echo "exec qrencode wrong."
		return 4
	fi

	func_term_size
	#留一行给结束后的提示符，避免把二维码顶出屏幕
	rows=$((rows - 1))
	[ "${rows}" -lt 1 ] && rows=1
	[ "${cols}" -lt 1 ] && cols=1

	scale=$((rows / h))
	(( cols / w < scale )) && scale=$((cols / w))
	(( scale < 1 )) && scale=1

	pad_y=$(( (rows - h * scale) / 2 ))
	[ "${pad_y}" -lt 0 ] && pad_y=0
	#靠左显示，不水平居中
	pad_x=0

	[ -t 1 ] && clear
	for ((k=0; k<pad_y; k++)); do
		printf '\n'
	done

	#用背景色铺满格子，避免 █ 字形在行距里留缝
	for line in "${lines[@]}"; do
		out=""
		for ((i=0; i<${#line}; i++)); do
			ch="${line:i:1}"
			if [ "${ch}" = '#' ]; then
				out+=$'\033[40m'
			else
				out+=$'\033[47m'
			fi
			for ((k=0; k<scale; k++)); do
				out+=' '
			done
		done
		out+=$'\033[0m'
		for ((k=0; k<scale; k++)); do
			printf '%*s%s\n' "${pad_x}" '' "${out}"
		done
	done
	return 0
}

function func_fjk_wifi_qr_code
{
	local ssid=
	local passwd=
	if [ $# -eq 1 ];then
		ssid=$1
		passwd=""
	elif [ $# -eq 2 ];then
		ssid=$1
		passwd=$2
	else
		echo "unknow format"
		return 1
	fi
	#merge qrcode format sting
	local qrcode_string="none"
	if [ "x${passwd}" = "x" ];then
		#fujikam open mode when password is empty
		qrcode_string="{\"s\":\"${ssid}\",\"p\":\"\",\"l\":\"zh\"}"
	else	
		qrcode_string="{\"s\":\"${ssid}\",\"p\":\"${passwd}\",\"l\":\"zh\"}"
	fi
	
	func_qr_fit_terminal "${qrcode_string}"
	echo "EXEC:qrencode -o  - -t UTF8 -m 2 '${qrcode_string}'"
	echo "wifi ssid:${ssid} pass:${passwd}"
	return $?
}


function func_check_sn_validity
{
	if [ $# -ne 1 ];then
		echo "ERROR:$FUNCNAME() parameter wrong!"
		return 1
	fi
	#sn validity check
	local tmp=$(echo $1 | grep "^1jfieg" )
	if [ "x${tmp}" = "x" ];then
		echo "ERROR:SN number is illegal!!"
		func_help
		return 2
	fi
	return 0
}

function func_fjk_dev_qr_code
{
	local id_head="ID:"
	local user=
	local passwd_head="password:"
	local passwd=
	user=$1
	passwd="admin" #default
	#new password
	if [ $# -eq 2  ];then passwd=$2;fi

	#sn validity check
	func_check_sn_validity "${user}"
	if [ $? -ne 0 ];then return 4;fi
	#generate qrcode
	func_qr_fit_terminal ${id_head}${user}${passwd_head}${passwd}
	echo "EXEC:qrencode -o  - -t UTF8 '${id_head}${user}${passwd_head}${passwd}'"
	echo "ID=${user}"
	echo "pass=${passwd}"
	
	return 0
}


function func_print_help
{
    echo "DESCRIPTION:在终端生成二维码"
    echo "Usage:"
	echo "         ${scriptfile_name}  type  args ...             #格式：类型 参数1 参数2 ..."
	echo ""
	echo "supported type: wifi, dev"
	echo "Examples:"
    echo "         ${scriptfile_name}  wifi  ssid  [pass]         #生成fjk的wifi二维码，方便设备连接wifi。"
	echo "         ${scriptfile_name}  dev   dev_id               #生成fjk的设备二维码，方便app添加设备。"
	echo ""
	return 0
}

function func_generate_qrcode
{
	#check app
	which qrencode > /dev/null
	if [ $? -ne 0 ];then echo "qrencode not exist";echo "please install it first";echo "apt install qrencode";return 1;fi
	which tput > /dev/null
	if [ $? -ne 0 ];then echo "tput not exist";echo "please install it first";echo "apt install tput";return 1;fi

	#check parameter
	if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
        func_print_help
		return 2
	fi

	local type=$1
	local args="$2 $3 $4 $5 $6 $7 $8 $9"
	if [ "x${type}" = "xwifi" ]
	then
		func_fjk_wifi_qr_code ${args}
		return $?
	elif [ "x${type}" = "xdev" ]
	then
		func_fjk_dev_qr_code ${args}
		return $?
	else
		echo "unknow type"
		return 3
	fi

	return 0
}
func_generate_qrcode $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
