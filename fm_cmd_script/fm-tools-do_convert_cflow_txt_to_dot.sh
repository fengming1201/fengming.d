#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ];then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ];then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ] && [ lshm != lshm ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_conver_cflow_to_dot
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then
        echo "$scriptname  param_list"
        return 1
    fi
    echo "digraph G {"
    awk '/^ *[0-9]+/ {
    gsub("\\|", "");
    gsub("`--", "");
    gsub("\\+--", "");
    if (depth[$1] > 0) {
        for (i=1; i<=depth[$1]; i++) printf "  ";
        print "\"" prev[$1] "\" -> \"" $2 "\";";
    }
    prev[$1] = $2;
    depth[$1] = length($1);
    }'
    echo "}"
    return 0
}

func_conver_cflow_to_dot "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
