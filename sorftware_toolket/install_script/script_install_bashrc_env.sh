#!/bin/bash

if [ "x${fengming_root_dir}" = "x" ]
then
    fengming_root_dir=/etc/fengming.d
fi
#username=$(whoami)

function buildin_install_mybashrc
{
	local mybash_file=${fengming_root_dir}/mybashrc
	local home_bashrc=${HOME}/.bashrc

	#check file state
	if [ ! -f ${home_bashrc} ];then echo "${home_bashrc} not exist";return 1;fi

	if [ ! -f ${mybash_file} ];then echo "${mybash_file} not exist";return 2;fi

	#check is already installed
	grep -w "${mybash_file}" ${home_bashrc}  > /dev/NULL
	if [ $? -eq 0 ];then echo "WARNNING:${FUNCNAME},allready configed.";return 0;fi

	#else write config to ${home_bashrc}
	cat >> ${home_bashrc} << EOF
if [ -f ${mybash_file} ];then
	. ${mybash_file}
fi
EOF
	return 0
}

buildin_install_mybashrc
