#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
fi
function func_convert_url_to_qrcode
{
	local app=qrencode
	local default_opt="-o  - -t UTF8 -m 2"

	if [ $# -lt 1 ]
	then
		echo "ERROR:para wrong!!"
		echo "$scriptfilename  URL"
		return 1
	fi
	#check app
	which ${app} > /dev/null
	if [ $? -ne 0 ];then echo "${app} not exist";echo "please install it first";echo "apt install ${app}";return 2;fi
	
	local qrcode_string=$*
	echo "URL:${qrcode_string}"
	qrencode ${default_opt} ${qrcode_string}
	
	return 0
}

func_convert_url_to_qrcode $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
