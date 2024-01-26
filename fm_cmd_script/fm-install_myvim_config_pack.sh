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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_install_myvim_config
{
    local vim_pack=vim.tar.gz
    local download_url='http://139.9.186.120:8050/software_package'

    # help paramater
    if [ "$1" = "-h" ] || [ "$1" = "--help " ]
    then
        echo "nothing ...."
        return 1
    fi
    local reinstall=no
    #check  location vim dir
    if [ -f ~/.vim/myvimrc ]
    then
        tree -L 1 ~/.vim
        echo ""
        echo "already installed"
        read -p "force to re install?[y/N]"  reinstall
        if [ "x${reinstall}" = "x" ];then reinstall=no;fi
        if [ ${reinstall} != "y" ] && [ ${reinstall} != "Y" ] && [ ${reinstall} != "yes" ] && [ ${reinstall} != "YES" ]
        then
            return 2
        fi
        rm -rf ~/.vim
    fi
    #download to home dir
    pushd ~/
    if [ ! -f ${vim_pack} ]
    then
        echo "download vim cfg pack from myserver ..."
        wget -c ${download_url}/${vim_pack}
        if [ ! -f ${vim_pack} ];then echo "download fail.";popd;return 3;fi
    fi
    #tar -zxvf ${target_pack_name} --strip-components=1
    tar -zxvf ${vim_pack}

    #write vim config to /etc/vim/vimrc
    if [ "x$(grep "${HOME}/.vim/myvimrc" /etc/vim/vimrc)" != "x" ];then popd;return 4;fi

    cat << EOF | ${maybeSUDO} tee -a /etc/vim/vimrc
if filereadable("${HOME}/.vim/myvimrc")
  source ${HOME}/.vim/myvimrc
endif
EOF

    popd
    return 0
}

func_install_myvim_config $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
