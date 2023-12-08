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
function func_tree_aviv
{
	local app=tree
	local default_opt="-sfh"

	${app}  ${default_opt} $*

	return 0
}
func_tree_aviv $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
