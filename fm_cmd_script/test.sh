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

function name
{
    return 0
}

name $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
