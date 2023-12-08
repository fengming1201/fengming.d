#!/bin/bash

scriptfilename=$0

function func_find
{

	return 0

}

func_find $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0