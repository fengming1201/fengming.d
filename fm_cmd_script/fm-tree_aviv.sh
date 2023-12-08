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
