#!/bin/bash

#comm value
fengming_root_dir=/etc/fengming.d
fengming_sorftware_pkg_dir=${fengming_root_dir}/sorftware_toolket/sorftware_pagke
sorftware_pagke_url=http://139.9.186.120:8050/software_package/
sorftware_pagke_path=none
local_dir_for_download=sorftware_pkg

function __find_tool_package_path
{
	local tool_pkg_name=none
	#check para
	if [ $# -ne 1 ]
	then
		echo ""
		return 1
	fi
	tool_pkg_name="$1"
	#check local first
	#check tool package
	if [ ! -f ${sorftware_pagke_path}/${tool_package} ] && [ ! -f ./${tool_package} ]
	then
		#to download from server
	fi

	#if local not have,then download from server
	
	sorftware_pagke_path=

	return 0
}

function buildin_install_vim_config_pkg
{
	local tool_package=vim_cfg_dir.tar.gz
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
	local z_pkg=${sorftware_pagke_path}/z.tar.gz
	local target_path=/opt
	local target_dir=z

	if [ -d ${target_path}/${target_dir} ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	tar -zxvf ${z_pkg} -C ${target_path}
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},tar fail...";return 1;fi

	return 0
}

function buildin_install_7zz_pkg
{
	local z7z_pkg=${sorftware_pagke_path}/7z2201-linux-x64.tar.xz
	local target_path=/opt
	local target_dir=7z
	local link_bin_dir=/usr/local/bin

	which 7zz > /dev/null
	if [ $? -eq 0 ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi

	if [ -d ${target_path}/${target_dir} ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	#build dir
	mkdir -p ${target_path}/${target_dir}
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},mkdir ${target_path}/${target_dir} fail";return 1;fi
	#extra pack
	if [ ! -f ${z7z_pkg} ];then echo "ERROR:${FUNCNAME},file:${z7z_pkg} no exist!";return 2;fi
	tar -xJf ${z7z_pkg} -C ${target_path}/${target_dir}
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},tar fail...";return 3;fi
	
	#build link
	if [ -e ${target_path}/${target_dir}/7zz ]
	then
		rm ${link_bin_dir}/7zz
		ln -s ${target_path}/${target_dir}/7zz  ${link_bin_dir}/7zz
	else
		echo "ERROR:${FUNCNAME},build link fail,file:${target_path}/${target_dir}/7zz no exist!"
	fi
	if [ -e ${target_path}/${target_dir}/7zzs ]
	then
		rm ${link_bin_dir}/7zzs
		ln -s ${target_path}/${target_dir}/7zzs  ${link_bin_dir}/7zzs
	else
		echo "ERROR:${FUNCNAME},build link fail,file:${target_path}/${target_dir}/7zzs no exist!"		
	fi
	return 0
}

function build_install_advcpmv_pkg
{
	local advcpmv_pkg=${sorftware_pagke_path}/advcpmv_pkg.tar.gz
	local target_path=/opt
	local target_dir=advcpmv
	local binaries_dir=off-the-shelf-binaries
	local link_bin_dir=/usr/local/bin
	
	if [ -d ${target_path}/${target_dir} ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	#build dir
	mkdir -p ${target_path}/${target_dir}
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},mkdir ${target_path}/${target_dir} fail";return 1;fi
	#extra pack
	if [ ! -f ${advcpmv_pkg} ];then echo "ERROR:${FUNCNAME},file:${advcpmv_pkg} no exist!";return 2;fi
	tar -xzf ${advcpmv_pkg} -C ${target_path}/${target_dir}
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},tar fail...";return 3;fi

	#check version 
	local current_version=$(cp --version  | grep -w cp  | awk '{print $4 }')
	
	#build link
	if [ -e ${target_path}/${target_dir}/${binaries_dir}/cp.${current_version} ]
	then
		rm ${link_bin_dir}/cp
		ln -s ${target_path}/${target_dir}/${binaries_dir}/cp.${current_version}  ${link_bin_dir}/cp
	else
		echo "ERROR:${FUNCNAME},build link fail,file:${target_path}/${target_dir}/${binaries_dir}/cp.${current_version} no exist!"
	fi
	if [ -e ${target_path}/${target_dir}/${binaries_dir}/mv.${current_version} ]
	then
		rm ${link_bin_dir}/mv
		ln -s ${target_path}/${target_dir}/${binaries_dir}/mv.${current_version}  ${link_bin_dir}/mv
	else
		echo "ERROR:${FUNCNAME},build link fail,file:${target_path}/${target_dir}/${binaries_dir}/mv.${current_version} no exist!"		
	fi
	echo "maybe you need to menu change owner for dir ${target_path}/${target_dir}"
	return 0
}

function exe_func
{
	if [ $# -ne 1 ];then echo "ERROR:${FUNCNAME},paramter wrong!!";return 1;fi
	$1
	local ret=$?
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

function install_scheduler_func
{
	local select=$1

	if [ ${select} = "A" ] || [ ${select} = "a" ] || [ ${select} = "all" ]
	then
		exe_func buildin_install_vim_config_pkg
	fi		
	if [ ${select} = "B" ] || [ ${select} = "b" ] || [ ${select} = "all" ]
	then
		exe_func buildin_install_z_pkg
	fi		
	if [ ${select} = "C" ] || [ ${select} = "c" ] || [ ${select} = "all" ]
	then
		exe_func buildin_install_7zz_pkg
	fi
	if [ ${select} = "D" ] || [ ${select} = "d" ] || [ ${select} = "all" ]
	then
		exe_func build_install_advcpmv_pkg
	fi

	return 0
}

if [ $# -lt 1 ]
then
	echo "parameter error"
	echo "A --install_vim_config_pkg"
	echo "B --install_z_pkg"
	echo "C --install_7zz_pkg"
	echo "D --install_advcpmv_pkg"
	echo "all install ABCD"
	exit 1
fi
for opt in $@
do
	install_scheduler_func $opt
done
exit 0