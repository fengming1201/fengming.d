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
function func_update_time_zone
{
	local ret=0

	if [ $# -ne 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
	then
		echo ""
		echo "$scriptname  time    #use ntpdate to get time from net"
		echo "$scriptname  zone    #use timedatectl to change timezone"
		echo "$scriptname  all     #update time and zone"
		echo ""
		return 1
	fi
	
	#update time
	if [ "$1" = "time" ] || [ "$1" = "all" ]
	then
		local app=ntpdate
		#1,check tool
		${maybeSUDO} which ${app} > /dev/null
		if [ $? -ne 0 ]
		then
			echo "ERROR:${scriptname},${app} not found"
			echo "please install ${app}"
			echo "sudo apt install ${app}"
			return 2
		fi
		#2,update time from net
		local time_server_array=("ntp.ntsc.ac.cn" "ntp1.aliyun.com" "ntp.fudan.edu.cn")
		for server in $(echo ${time_server_array[*]})
		do
			echo "try to connecting time server:${server}"
			${maybeSUDO} ${app} -u  ${server}
			if [ $? -eq 0 ];then break;fi
		done
	fi

	#set timezone
	if [ "$1" = "zone" ] || [ "$1" = "all" ]
	then
		local setzone=timedatectl
		local zonefile=/usr/share/zoneinfo/Asia/Shanghai
		local zone_default=Asia/Shanghai
		local target_file=/etc/localtime 
		#1,check tool
		which ${setzone} > /dev/null
		ret=$?
		if [ ${ret} -ne 0 ]
		then
			echo "ERROR:${scriptname},${app} not found"
			echo "please install ${app}"
			return 2
		fi

		if [ ${ret} -eq 0 ]
		then
			echo "set time zone to ${zone_default}"
			${maybeSUDO} ${setzone} set-timezone  ${zone_default}
		else
			echo "cp time zone file to ${target_file}"
			${maybeSUDO} cp -vf ${zonefile} ${target_file}
		fi
	fi
	return 0
}

func_update_time_zone $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    echo "func_update_time_zone() fail:${ret}"
    exit 1
fi
exit 0
