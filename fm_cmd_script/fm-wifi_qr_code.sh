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
function func_wifi_qr_code
{
	local app=qrencode
	local default_opt="-o  - -t UTF8 -m 2"
	local mode="nomal"
	local ssid="none"
	local passwd=""

	#check app
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo "${app} not exist";echo "please install it first";echo "apt install ${app}";return 1;fi

	#check parameter
	if [ $# -lt 1 ] || [ $# -gt 3 ]
	then
        echo "DESCRIPTION:在终端生成二维码"
        echo "SYNOPSIS:"
        echo "         ${funcname}  [fjk]  ssid  [pass]"
		return 2
	fi
	#process param
	if [ $# -eq 1 ]
	then
		ssid=$1
	elif [ $# -eq 2 ]
	then
		if [ "x$1" = "xfjk" ]
		then
			mode=$1
			ssid=$2
			passwd=""
		else
			ssid=$1
			passwd=$2
		fi
	elif [ $# -eq 3 ]
	then
		if [ "x$1" = "xfjk" ]
		then
			mode=$1
			ssid=$2
			passwd=$3
		fi
	else
		echo "unknow format"
		return 3
	fi
	#merge qrcode format sting
	local qrcode_string="none"
	if [ "x${mode}" = "xfjk" ]
	then
		if [ "x${passwd}" = "x" ]
		then
			#fujikam open mode when password is empty
			qrcode_string="{\"s\":\"${ssid}\",\"p\":\"\",\"l\":\"zh\"}"
		else	
			qrcode_string="{\"s\":\"${ssid}\",\"p\":\"${passwd}\",\"l\":\"zh\"}"
		fi
	else
		if [ "x${passwd}" = "x" ]
		then
			#nomal open ode  when password is empty
			qrcode_string="WIFI:T:nopass;S:${ssid};P:;;"
		else
			qrcode_string="WIFI:T:WPA;S:${ssid};P:${passwd};;"
		fi
	fi
	echo "==${qrcode_string}"
	#generate qr code
	qrencode ${default_opt} ${qrcode_string}
	if [ ! $? -eq 0 ];then echo "exec qrencode wrong.";return 4;fi
	echo "mode:${mode} ssid:${ssid} pass:${passwd}"
	return 0
}
func_wifi_qr_code $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
