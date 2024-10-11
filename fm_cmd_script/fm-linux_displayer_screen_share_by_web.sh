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
function func_share_displayer_screen
{
    local tool=Deskreen-2.0.4.AppImage
    local app=deskreen  #link to tool
    
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  param_list"
        return 1
    fi
    
    which ${app} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "ERROR:"
        echo "${app} is not exist!, please install it first by follow"
        echo "mkdir -p /opt/Deskreen && wget -P /opt/Deskreen http://101.200.135.149:8060/software_exe/Deskreen-2.0.4.AppImage"
        echo "ln -s /opt/Deskreen/Deskreen-2.0.4.AppImage  /usr/local/bin/deskreen"
        echo ""
        echo "info:https://deskreen.com/lang-zh_CN"
        return 2
    fi

	if [ x"$SSH_CLIENT" = x ]
	then
        ${app}
	else
		local opt="Y"
		read -p "Are you sure display to remote screen? [Y/n]"  opt
		if [ "x${opt}" = "x"  ];then opt="Y";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
            DISPLAY=:0 ${app}
		fi
	fi    

    return 0
}

func_share_displayer_screen "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
