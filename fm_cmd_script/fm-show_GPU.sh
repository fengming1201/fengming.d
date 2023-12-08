#!/bin/bash

scriptfilename=$0



func_script_putin $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0