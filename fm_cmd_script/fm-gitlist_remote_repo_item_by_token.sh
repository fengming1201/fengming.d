#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ]
then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ]
    then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ] || [ "$1" = "-show" ] || [ "$1" = "--show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
function func_list_remote_repo_item
{
    local token_encrypt_file_path=${fengming_dir}/encrypt_files
    local tool=openssl
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname      type                    #need input password to get token from my encrypt file"
        echo "$scriptname  [github | gitlab | mygit ]  #.e.g"
        echo ""
        echo "other token"
        echo "$scriptname   [github | gitlab | mygit ]  token"
        echo ""
        return 1
    fi
    local type=$1
    local token=none

    if [ $# -eq 1 ];then
        which ${tool} > /dev/null
        if [ $? -ne 0 ];then
            echo "${tool} not found!!"
            echo "apt install openssl"
            return 2
        fi
        targetfile=${token_encrypt_file_path}/${type}_token_encrypt_file
        if [ ! -f ${targetfile} ];then echo "ERROR:file: $targetfile not exist!";return 3;fi

        read -s -p "input [decrypt] pass:" password
        if [ "x${password}" = "x" ];then echo -e "\nERROR:Password cannot be empty!";return 4;fi
        local ciphertext=$(cat ${targetfile})
        if [ "x${ciphertext}" = "x" ];then echo "ERROR:ciphertext file is empty.";return 4;fi
        token=$(echo "${ciphertext}" | openssl enc -d -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:${password})
        echo ""
    else
        token=$2
    fi
    
    local tmp=$(mktemp)
    if [ "x${type}" = "xgithub" ];then
        curl -H "Authorization: token ${token}" https://api.github.com/user/repos > ${tmp}
        if [ -f ${tmp} ];then
            cat ${tmp} | jq .
            echo "=============== brief ================="
            cat ${tmp} | jq '.[].name'
        fi
    elif [ "x${type}" = "xgitlab" ];then
        curl --header "Private-Token: ${token}" https://gitlab.com/api/v4/projects  > ${tmp}
        if [ -f ${tmp} ];then
            cat ${tmp} | jq .
            echo "=============== brief ================="
            cat ${tmp} | jq '.[].name'
        fi
    elif [ "x${type}" = "xgitee" ];then
        curl -s -H "Authorization: token ${token}" https://gitee.com/api/v5/user/repos > ${tmp} 
        if [ -f ${tmp} ];then
            cat ${tmp} | jq .
            echo "=============== brief ================="
            cat ${tmp} | jq '.[].name'
        fi      
    elif [ "x${type}" = "xmygit" ];then
        curl --header "Private-Token: ${token}" http://101.200.135.149:8080/api/v4/projects > ${tmp}
        if [ -f ${tmp} ];then
            cat ${tmp} | jq .
            echo "=============== brief ================="
            cat ${tmp} | jq '.[].name'
        fi
    else
        echo "ERROR:Unknow type"
    fi

    rm ${tmp}
    return 0
}

func_list_remote_repo_item "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
