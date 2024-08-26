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

function func_help
{
	echo "Usage:"
	echo "${scriptname}  fjk_dev_sn     [password]"
	echo "${scriptname}  1jfiegbr4jgca   123456aa"
	echo "${scriptname}  1jfiegbr4jgca            #if not give password,default is admin"
	return 0
}

function func_check_sn_validity
{
	if [ $# -ne 1 ]
	then
		echo "ERROR:$FUNCNAME() parameter wrong!"
		return 1
	fi
	#sn validity check
	local tmp=$(echo $1 | grep "^1jfieg" )
	if [ "x${tmp}" = "x" ]
	then
		echo "ERROR:SN number is illegal!!"
		func_help
		return 2
	fi
	return 0
}
function func_fjk_add_device_QRCode
{
	local tool=qrencode
	local opt="-o  - -t UTF8"

	local id_head="ID:"
	local user=
	local passwd_head="password:"
	local passwd=

	if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		func_help
		return 1
	fi 
	if [ $# -gt 2 ]
	then
		echo "ERROR:Only accept one or two parameters"
		func_help
		return 2
	fi
	#check tool
	which ${tool} > /dev/null
	if [ $? -ne 0 ]
	then
		echo "please install qrencode first"
		echo "apt install qrencode"
		return 3
	fi

	user=$1
	passwd="admin" #default
	#new password
	if [ $# -eq 2  ];then passwd=$2;fi

	#sn validity check
	func_check_sn_validity "${user}"
	if [ $? -ne 0 ];then return 4;fi
	#generate qrcode
	${tool} ${opt} ${id_head}${user}${passwd_head}${passwd}
	echo "ID=${user}"
	echo "pass=${passwd}"

	return 0
}

func_fjk_add_device_QRCode $@
if [ $? -ne 0 ];then 
    exit 1
fi
exit 0
