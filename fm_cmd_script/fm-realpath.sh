#!/bin/bash

scriptfilename=$0

function func_realpath
{
	if [ $# -lt 1  ];then echo "ERROR:parmeter missing",echo "$scriptfilename file/dir";return 1;fi
	local tool=realpath
	which ${tool} > /dev/null
	if [ $? -ne 0  ];then echo "ERROR:${tool} no found!!";return 2;fi
	for path in $*
	do
		local linux_path=$(${tool} ${path})
		if [ x"${linux_path}" != "x"  ]
		then
			if [ -e ${linux_path} ]
			then
				echo "linux   --- ${linux_path}"
			fi
		fi
	done
	for path in $*
	do
		local linux_path=$(${tool} ${path})
		if [ x"${linux_path}" != "x"  ]
		then
			if [ -e ${linux_path} ]
			then
				local win_path=$(echo ${linux_path} | sed 's#/#\\#g')
				echo "windows --- ${win_path}" 
			fi				
		fi
	done
	return 0
}

func_realpath $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_realpath() fail:${ret}"
    exit 1
fi
exit 0