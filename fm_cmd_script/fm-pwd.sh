#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
    exit 0
fi
function func_pwd
{
	local linux_pwd=${PWD}
	local win_pwd=$(echo ${linux_pwd} | sed 's#/#\\#g')

	echo "linux   --- ${linux_pwd}"
	echo "windows --- ${win_pwd}"
	return 0
}

func_pwd $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_pwd() fail:${ret}"
    exit 1
fi
exit 0