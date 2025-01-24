#!/bin/bash

if [ "x${fengming_root_dir}" = "x" ];then
	#default
    fengming_root_dir=/opt/fengming.d
fi

#username=$(whoami)

function buildin_install_mybashrc
{
	local mybash_file=${fengming_root_dir}/mybashrc
	local home_bashrc=${HOME}/.bashrc

	#check file state
	if [ ! -f ${home_bashrc} ];then 
		echo "${home_bashrc} not exist"
		return 1
	fi

	if [ ! -f ${mybash_file} ];then
		echo "${mybash_file} not exist"
		return 2
	fi

	#check is already installed
	grep -w "${mybash_file}" ${home_bashrc}  > /dev/null
	if [ $? -eq 0 ];then
		echo "WARNNING:${FUNCNAME},allready configed."
		return 0
	fi

	#else write config to ${home_bashrc}
	tee -a ${home_bashrc} <<EOF
if [ -f ${mybash_file} ];then
    . ${mybash_file}
    if [ $LOGNAME = lshm ];then
        echo "*******************************************"
        echo "****  fengming.d  environment  loaded  ****"
        echo "*******************************************"
        if [ "x$STY" = "x" ] && [ "x$TMUX" = "x" ] && [ 1 -eq 0 ];then
            cat ${fengming_root_dir}/documents/sub_doc_embedded_engineer/How_to_quickly_learn_new_technologies.txt
        fi
    fi
fi
EOF
	return 0
}

#call function 
buildin_install_mybashrc
ret=$?
if [ ${ret} -ne 0 ]
then
	echo "FUNC:buildin_install_mybashrc() fail,ret:${ret}"
	exit 1
fi

exit 0
