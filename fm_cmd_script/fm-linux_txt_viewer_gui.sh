#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ]
    then
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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_txt_viewer_gui
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  param_list"
        return 1
    fi

    local app=mousepad
    local default_opt=
	which ${app} > /dev/null
	if [ $? -ne 0 ] ; then echo ¨ERROR:${scriptname},${app} not exist!¨;return 1;fi;

    if [ x"$SSH_CLIENT" = x  ]
	then
		$app ${default_opt} $*
	else
		local opt="N"
		read -p "Are you sure display to remote screen？ [y/N]"  opt
		if [ "x${opt}" = "x"   ];then opt="N";fi
		if [ "x${opt}" = "xy"   ] || [ "x${opt}" = "xY"   ] || [ "x${opt}" = "xyes"   ] || [ "x${opt}" = "xYES"   ]
		then
			DISPLAY=:0 $app ${default_opt} $*
		fi
	fi

    return 0
}

func_txt_viewer_gui "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
