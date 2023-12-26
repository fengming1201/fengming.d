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

function func_install_myvim_config
{
    local target_pack_name=vim_pack_s.tar.gz
    local download_url='http://139.9.186.120:8050/software_package'

    # help paramater
    if [ "$1" = "-h" ] || [ "$1" = "--help " ]
    then
        echo "nothing ...."
        return 1
    fi
    #check  location vim dir
    if [ -f ~/.vim/myvimrc ]
    then
        tree -L 1 ~/.vim
        echo ""
        echo "already installed"
        return 2
    fi

    local download_dir=~/vim_src_dir
    #download to home dir
    mkdir ${download_dir}
    pushd ${download_dir}
    wget -c ${download_url}/${target_pack_name}
    if [ ! -f ${target_pack_name} ];then echo "download fail.";return 3;fi
    tar -zxf ${target_pack_name}  --strip-components=1
    if [ $(id -u) = 0 ]
    then
        ./install.sh
    else
        sudo ./install.sh
    fi
    popd
    rm -rf ${download_dir}
    return 0
}

func_install_myvim_config $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
