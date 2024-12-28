
#format: COMMOND_FUNC_check_ip [-d/--debug 1] [-m--method 1/2] ip_address
#return: 0  -- OK，ip is a valid IP address.
#        1  -- NO, ip is not IP format.
#        2  -- NO, ip is not a valid IP address.
function COMMOND_FUNC_check_ip
{
    #check_ip  ip  method  debug 
    local method=1
    local debug=0
    local IP=8.8.8.8

    # 手动解析长选项
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--debug)
                debug="$2"
                shift 2
                ;;
            -m|--method)
                method="$2"
                shift 2
                ;;
            *)
                IP="$1"
                shift
                ;;
        esac
    done
    test ${debug} = "1" && echo "method=$method"
    test ${debug} = "1" && echo "debug=$debug"
    test ${debug} = "1" && echo "IP=$IP"

    if [ ${method} -eq 1 ]
    then
        #方法1
        # 正则表达式匹配 IPv4 地址
        ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

        # 检查参数是否符合 IP 地址格式
        if [[ $IP =~ $ip_regex ]]; then
            # 检查每个数字是否在 0-255 范围内
            IFS='.' read -r -a octets <<< "$IP"
            valid=true
            for octet in "${octets[@]}"; do
                if (( octet < 0 || octet > 255 )); then
                    valid=false
                    break
                fi
            done

            if $valid; then
                test ${debug} = "1" && echo "$IP :参数是一个有效的 IP 地址。"
                return 0
            else
                test ${debug} = "1" && echo "$IP 参数不是一个有效的 IP 地址。"
                return 2
            fi
        else
            test ${debug} = "1" && echo "$IP 参数不是 IP 格式。"
            return 1
        fi
    elif [ ${method} -eq 2 ];then
        #方法2
        local VALID_CHECK=$(echo $IP|awk -F. '$1<=255 && $2<=255 && $3<=255 && $4<=255 {print "yes"}')
        if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
            if [[ $VALID_CHECK == "yes" ]]; then
                    test ${debug} = "1" && echo "$IP :参数是一个有效的 IP 地址。"
                    return 0
            else
                    test ${debug} = "1" && echo "$IP 参数不是一个有效的 IP 地址。"
                    return 2
            fi
        else
            test ${debug} = "1" && echo "$IP 参数不是 IP 格式。"
            return 1
        fi
    else
        echo "ERROR:not support this method:$method value!!"        
    fi
    return 0
}

#format: COMMOND_FUNC_quick_ping_ip  IP_Address
#descript: Check whether the IP address can be pinged
#return: 0  -- 成功
#        1  -- 主机不可达或超时
#        2  -- 命令错误
function COMMOND_FUNC_quick_ping_ip
{
    local IP=$1
    ping -c 1 -W 1 ${IP} > /dev/null 2>&1
    return $?
}


function COMMOND_FUNC_check_vim_dictionary_env_variable
{
    if [ $# -ne 1 ]
    then
        echo "parameter wrong!!"
        return 1
    fi
    local target_file=$1
	#check vim enviroment
	local myvim_rc=~/.vim/myvimrc
	if [ ! -f ${myvim_rc} ]
	then
		echo "ERROR: vim config pack not install yet"
		echo "you can:fm-install_myvim_config_pack.sh"
		echo ""
		return 2
	fi
	local isinstalled=$(cat ${myvim_rc} | grep ${target_file})
	if [ "x${isinstalled}" = "x" ]
	then
		echo "add the following content to ${myvim_rc}"
		echo ""
        local ishavecur_work_dir=$(cat ${myvim_rc} | grep -w "cur_work_dir")
        if [ "x${ishavecur_work_dir}" = "x" ]
        then
		    cat <<EOF | tee -a ${myvim_rc}
let cur_work_dir = getcwd()
let dict_file = cur_work_dir . '/${target_file}'
if filereadable(dict_file)
    execute 'set dictionary+=' . dict_file
endif

EOF
        else
		    cat <<EOF | tee -a ${myvim_rc}
let dict_file = cur_work_dir . '/${target_file}'
if filereadable(dict_file)
    execute 'set dictionary+=' . dict_file
endif

EOF
        fi
	fi
    echo ""
    echo "how to use dictionary :在vim插入模式下 Ctrl + x 然后再按下 Ctrl + k"
    echo ""
    return 0
}

#descript: 获取主机IP
#调用: IP=$(COMMOND_FUNC_get_host_ip)
function COMMOND_FUNC_get_host_ip
{
    hostname -I | awk '{print$1}'
    return 0
}
