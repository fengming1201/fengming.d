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
function func_show_CPU
{
    which lscpu > /dev/null
    if [ $? -eq 0 ];then
        lscpu
        echo "======== end lscpu =============="
    fi
    cat /proc/cpuinfo
    echo "======== end /proc/cpuinfo =============="
    which inxi > /dev/null
    if [ $? -eq 0 ];then
	 	#you can "apt install inxi" to install it
        inxi -C
        echo "======== end inxi -C =============="
    fi
	which dmidecode > /dev/null
	if [ $? -eq 0 ];then
		#apt install dmidecode
		sudo dmidecode --type  processor
		echo "======== end dmidecode =============="
	fi
    return 0
}

func_show_CPU $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0