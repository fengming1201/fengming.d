#!/bin/bash

function buildin_install_vim_config_pkg
{
	local vim_comfig_pack=${fengming_tools_dir}/vim_cfg_dir.tar.gz
	local vim_cfg_file=/etc/vim/vimrc
	if [ -d ${HOME}/.vim ];then echo "allready installed.";return 0;fi
	tar -zxf ${vim_comfig_pack} -C ${HOME}/
	if [ ! -d ${HOME}/.vim ];then echo "tar fail...";return 1;fi

	cat >> ${vim_cfg_file} << EOF
if filereadable("${HOME}/.vim/myvimrc")
	source ${HOME}/.vim/myvimrc
endif
EOF
	return 0
}

function buildin_install_z_pkg
{
	local z_pkg=${fengming_tools_dir}/z.tar.gz
	local target_dir=/opt

	if [ -d ${target_dir}/z ];then echo "allready installed.";return 0;fi
	tar -zxvf ${z_pkg} -C ${target_dir}
	if [ ! -d ${target_dir}/z ];then echo "tar fail...";return 1;fi
	return 0;
}

