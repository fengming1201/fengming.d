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
function func_fjk_add_device_QRCode
{
	local flag=NO
	local default_passwd=admin
	local id_head="ID:"
	local user=
	local passwd_head="password:"
	local passwd=

	if [ $# -eq 1  ]
	then 
		tmp=$(echo $1 | grep "^1jfieg" )
		echo $tmp
		if [  x${tmp} = x  ]
		then
			#${HELP_FUNC}  add_device_qr_code
			return 1
		else
			echo "tmp=$tmp"
			user=$1
			passwd=${default_passwd}
			flag=OK
		fi
	elif [ $# -eq 2  ]
	then
		tmp=$(echo $1 | grep "^1jfieg" )
		if [ x$tmp = x  ]
		then
			tmp=$(echo $2 | grep "^1jfieg" )
			if [ x$tmp = x  ]
			then
				#${HELP_FUNC}  add_device_qr_code
				return 1
			else
				user=$2
				passwd=$1
				flag=OK
			fi
		else
			user=$1
			passwd=$2
			flag=OK
		fi

	else
		#${HELP_FUNC}  add_device_qr_code
		return 1
	fi

	if [ -z $(which qrencode) ]
	then
		echo "please install qrencode first"
		echo "apt install qrencode"
		return 1
	fi		
	if [ $flag == "OK"  ]
	then
		qrencode -o  - -t UTF8 ${id_head}${user}${passwd_head}${passwd}
		echo "ID=${user}"
		echo "pass=${passwd}"
	fi
	return 0
}

func_fjk_add_device_QRCode $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
