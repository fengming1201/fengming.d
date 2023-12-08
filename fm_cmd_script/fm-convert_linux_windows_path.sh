#!/bin/bash

scriptfilename=$0

function func_convert_linux_windows_path
{
	if [ $# -ne 1  ]
	then
		echo "ERROR:parameter wrong!!"
		echo "e.p:"
		echo "$scriptfilename  /root/test.txt    --> \\root\\test.txt"
		echo "$scriptfilename 'D:\\root\\test.txt' --> /root/test.txt"
		return 1
	fi

	local org_path=$1
	local tmp=$(echo $org_path  | grep / )
	local islinux_path=
	if [ "x$tmp" = x  ]
	then
		islinux_path=no
	else
		islinux_path=yes
	fi
	
	local new_path=
	if [ $islinux_path = yes  ]
	then
		new_path=$(echo $org_path | sed 's#/#\\#g')
	else
		new_path=$(echo $1 | sed -e 's#^[A-Z]:##' -e 's#\\#/#g')
	fi

	echo $new_path
	return 0
}

func_convert_linux_windows_path $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_convert_linux_windows_path() fail:${ret}"
    exit 1
fi
exit 0