#!/bin/bash

#comm value
fengming_root_dir=/etc/fengming.d
fengming_sorftware_pkg_dir=${fengming_root_dir}/sorftware_toolket/sorftware_pagke
sorftware_pagke_url=http://139.9.186.120:8050/software_package

function prepare_sorftware_package
{
	local tool_pkg_name=none
	local ret=1
	#check para
	if [ $# -ne 1 ];then echo "";return 1;fi
	
	tool_pkg_name="$1"
	#check tool package
	if [ ! -f ${fengming_sorftware_pkg_dir}/${tool_pkg_name} ]
	then
		#to download from server
		if [ $(id -u) -eq 0]
		then
			wget -c -P ${fengming_sorftware_pkg_dir}/ ${sorftware_pagke_url}/${tool_pkg_name}
			ret=$?
		else
			sudo wget -c -P ${fengming_sorftware_pkg_dir}/ ${sorftware_pagke_url}/${tool_pkg_name}
			ret=$?
		fi
		if [ ${ret} -ne 0 ];then echo "ERROR:wget fail!!";return 2;fi
	fi
	
	return 0
}

function buildin_install_vim_config_pkg
{
	local package_name=vim_cfg_dir.tar.gz
	local package_path=${fengming_sorftware_pkg_dir}/${package_name}
	local config_file=/etc/vim/vimrc
	local install_dir=${HOME}

	#check 
	which vim > /dev/null
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},vim not install yet.";return 1;fi
	if [ -d ${target_dir}/.vim ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	prepare_sorftware_package ${package_name}
	if [ $? -ne 0 ];then echo "ERROR:prepare_sorftware_package fail";return 2;fi

	tar -zxvf ${fengming_sorftware_pkg_dir}/${package_name} -C ${install_dir}/
	if [ ! -d ${install_dir}/.vim ];then echo "ERROR:${FUNCNAME},tar fail...";return 2;fi

	grep -w "${install_dir}/.vim/myvimrc" ${config_file} > /dev/NULL
	if [ $? -eq 0 ];then echo "WARNNING:${FUNCNAME},allready configed.";return 0;fi

	#else write config to ${config_file}
	cat >> ${config_file} << EOF
if filereadable("${install_dir}/.vim/myvimrc")
	source ${install_dir}/.vim/myvimrc
endif
EOF
	return 0
}

function buildin_install_z_pkg
{
	local package_name=z.tar.gz
	local package_path=${fengming_sorftware_pkg_dir}/${package_name}
	local config_file=
	local install_dir=/opt

	if [ -d ${install_dir}/z ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	
	prepare_sorftware_package ${package_name}
	if [ $? -ne 0 ];then echo "ERROR:prepare_sorftware_package fail";return 2;fi

	tar -zxvf package_path -C ${install_dir}
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},tar fail...";return 3;fi

	return 0
}

function buildin_install_7zz_pkg
{
	local package_name=7z2201-linux-x64.tar.xz
	local package_path=${fengming_sorftware_pkg_dir}/${package_name}
	local config_file=
	local install_dir=/opt

	local target_dir=7z
	local link_bin_dir=/usr/local/bin

	which 7zz > /dev/null
	if [ $? -eq 0 ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi

	if [ -d ${install_dir}/${target_dir} ];then echo "WARNNING:${FUNCNAME},allready installed.";return 0;fi
	#build dir
	mkdir -p ${install_dir}/${target_dir}
	if [ $? -ne 0 ];then echo "ERROR:${FUNCNAME},mkdir ${install_dir}/${target_dir} fail";return 1;fi

	prepare_sorftware_package ${package_name}
	if [ $? -ne 0 ];then echo "ERROR:prepare_sorftware_package fail";return 2;fi
	#extra pack
	tar -xJf package_path -C ${install_dir}/${target_dir}
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
	local advcpmv_pkg=advcpmv_pkg.tar.gz
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

	prepare_sorftware_package ${advcpmv_pkg}

	tar -xzf ${fengming_sorftware_pkg_dir}/${advcpmv_pkg} -C ${target_path}/${target_dir}
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