#!/bin/bash

scriptfilename=$0

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