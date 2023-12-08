#!/bin/bash

scriptfilename=$0

function func_update_time_zone
{
	local app=ntpdate
	local setzone=timedatectl
	local zonefile=/usr/share/zoneinfo/Asia/Shanghai
	local zone_default=Asia/Shanghai
	local target_file=/etc/localtime 
	local is_root=$(id -u)
	local ret=0
	if [ ${is_root} -eq 0 ]
	then
		which ${app} > /dev/null
		ret=$?
	else
		sudo which ${app} > /dev/null
		ret=$?
	fi
	if [ ${ret} -ne 0 ]
	then
		echo "ERROR:${scriptfilename},${app} not found"
		echo "please install ${app}"
		echo "sudo apt install ${app}"
		return 1
	fi

	which ${setzone} > /dev/null
	ret=$?
	if [ ${ret} -ne 0 ]
	then
		echo "ERROR:${scriptfilename},${app} not found"
		echo "please install ${app}"
		return 2
	fi
	#set timezone
	if [ ${ret} -eq 0 ]
	then
	    echo "set time zone to ${zone_default}"
		if [ ${is_root} -eq 0 ]
		then
			${setzone} set-timezone  ${zone_default}
		else
			sudo ${setzone} set-timezone  ${zone_default}
		fi
	else
		echo "cp time zone file to ${target_file}"
		if [ ${is_root} -eq 0 ]
		then
			cp -vf ${zonefile} ${target_file}
		else
			sudo cp -vf ${zonefile} ${target_file}
		fi
	fi
	#update time from servers
	local time_server_array=("ntp.ntsc.ac.cn" "ntp1.aliyun.com" "ntp.fudan.edu.cn")
	for server in $(echo ${time_server_array[*]})
	do
		echo "try to connecting time server:${server}"
		if [ ${is_root} -eq 0 ]
		then
			${app} -u  ${server}
			ret=$?
		else
			sudo ${app} -u  ${server}
			ret=$?
		fi
		if [ ${ret} -eq 0 ]
		then
			break
		fi
	done
	
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
