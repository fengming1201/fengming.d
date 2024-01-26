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