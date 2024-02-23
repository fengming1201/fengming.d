#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ] || [ "$1" = "-info" ]|| [ "$1" = "--info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    echo "location:${scriptfile}"
    cat ${scriptfile}
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_add_apt-sources_from_iso
{
    if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "parameter wrong!"
        echo "$scriptname  iso_file/iso_dev  mount_dir"
        echo "e.g. $scriptname  file.iso  /media/cdrom0"
        echo ""
        echo "step 1:mount iso                     (auto done)"
        echo "step 2:add path to apt sources.list  (auto done)"
        echo "step 3:apt update                    (manual)"
        echo "step 4:apt install software-pack     (manual)"
        echo ""
		return 1
    fi

    local iso="$1"
    local mount_dir="$2"
    local sources_dir=/etc/apt/sources.list.d

    if [ ! -f ${iso} ];then echo "file:${iso} not found";return 2;fi
    if [ ! -d ${mount_dir} ];then echo "mount dir not exit";return 2;fi

    echo "${maybeSUDO} mount -o loop -t iso9660 ${iso} ${mount_dir}"
    ${maybeSUDO} mount -o loop -t iso9660 ${iso} ${mount_dir}

    echo "deb [arch=$(dpkg --print-architecture)] file:${mount_dir} $(lsb_release -cs) main" | sudo tee ${sources_dir}/iso.list

    #if the above method failed
    #you can direct add iso path to /etc/apt/sources.list
    #echo "deb file:///mnt/iso $(lsb_release -cs) main"  | tee -a  /etc/apt/sources.list

    return 0
}

func_add_apt-sources_from_iso $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
