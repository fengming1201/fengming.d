#!/bin/bash

#comm value
fengming_root_dir=/etc/fengming.d
tools_dir=${fengming_root_dir}/linux_tools

function buildin_install_mybashrc
{
	local myvash_filename=mybashrc
	local home_bashrc=${HOME}/.bashrc
	#check file state
	if [ ! -f ${home_bashrc} ];then echo "${home_bashrc} not exist";return 1;fi

	if [ ! -f ${fengming_root_dir}/${myvash_filename} ];then echo "${fengming_root_dir}/${myvash_filename} not exist";return 2;fi

	#check is already installed
	grep -w "${fengming_root_dir}/${myvash_filename}" ${home_bashrc}  > /dev/NULL
	if [ $? -eq 0 ];then echo "WARNNING:${FUNCNAME},allready configed.";return 0;fi

	#else write config to ${home_bashrc}
	cat >> ${home_bashrc} << EOF
if [ -f ${fengming_top_dir}/${myvash_filename} ];then
	. ${fengming_top_dir}/${myvash_filename}
fi
EOF
	return 0
}

function buildin_install_vim_config_pkg
{
	local vim_comfig_pack=${tools_dir}/vim_cfg_dir.tar.gz
	local config_file=/etc/vim/vimrc
	local target_dir=${HOME}

	#check 
	which vim > /dev/null
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},vim not install yet.";return 1;fi
	if [ -d ${target_dir}/.vim ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	tar -zxvf ${vim_comfig_pack} -C ${target_dir}/
	if [ ! -d ${target_dir}/.vim ];then echo "ERROR:${FUNCNAME},tar fail...";return 2;fi

	grep -w "${target_dir}/.vim/myvimrc" ${config_file} > /dev/NULL
	if [ $? -eq 0 ];then echo "WARNNING:${FUNCNAME},allready configed.";return 0;fi

	#else write config to ${config_file}
	cat >> ${config_file} << EOF
if filereadable("${target_dir}/.vim/myvimrc")
	source ${target_dir}/.vim/myvimrc
endif
EOF
	return 0
}

function buildin_install_z_pkg
{
	local z_pkg=${fengming_tools_dir}/z.tar.gz
	local target_dir=/opt

	if [ -d ${target_dir}/z ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	tar -zxvf ${z_pkg} -C ${target_dir}
	if [ ! -d ${target_dir}/z ];then echo "ERROR:${FUNCNAME},tar fail...";return 1;fi
	return 0
}

function exe_func
{
	if [ $# -ne 1 ];then echo "ERROR:${FUNCNAME},paramter wrong!!";return 1;fi
	$1
	ret=$?
	if [ ${ret} -ne 0 ]
	then 
		echo "ERROR:${1} fail,ret=${ret}"
		echo "abort,please fix to continue"
		return ${ret}
	else 
		echo "${1} ------------done!!"
	fi
	return 0
}

function tool_scheduler_func
{
	exe_func buildin_install_mybashrc

	exe_func buildin_install_vim_config_pkg

	exe_func buildin_install_z_pkg

	return 0
}

tool_scheduler_func $*
ret=$?
if [ ${ret} -ne 0 ]
then
	echo "ERROR:tool_scheduler_func fail,ret=%{ret}"
	exit 1
fi 
exit 0