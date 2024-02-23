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
if [ "$1" = "info" ];then
    echo "abstract:"
    echo ""
    func_location
    exit 0
fi
if [ "$1" = "show" ];then
    cat ${scriptfile}
    echo ""
    func_location
    exit 0
fi
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_use_openssl_to_encrypt_decrypt_files
{   
    local tool=openssl
    which ${tool} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "${tool} not found!!"
        echo "apt install openssl"
        return 1
    fi
    if [ $# -lt 2 ] || [ $# -gt 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname   encrypt/decrypt  in-file  [out-file]"
        echo "$scriptname   [ 1 or encrypt ] in-file  [out-file]"
        echo "$scriptname   [ 2 or decrypt ] in-file  [out-file]"
        echo ""
        echo "$scriptname   1 test.txt #if not give out-file ,it will generate test.txt.enc"
        echo "$scriptname   2 test.txt #if not give out-file ,it will generate test.txt.dec"
        echo ""
        return 2
    fi
    #check src file 
    local in_file=$2
    if [ ! -f ${in_file} ];then echo "file:${in_file} not exist!!";return 3;fi
    
    local out_file="none"
    if [ $# -eq 3 ];then out_file=$3;fi

    if [ $1 -eq 1 ] || [ "$1" = "encrypt" ]
    then
        if [ $# -ne 3 ];then out_file=${in_file}.enc;fi

        echo "${tool} enc -aes-256-cbc -salt -in ${in_file} -out ${out_file}"
        ${tool} enc -aes-256-cbc -salt -base64 -pbkdf2 -iter 100000 -in ${in_file} -out ${out_file}
        echo "encrypt/加密:${in_file} --> ${out_file}"
        echo ""
    elif [ $1 -eq 2 ] || [ "$1" = "decrypt" ]
    then
        if [ $# -ne 3 ];then out_file=${in_file}.dec;fi

        echo "${tool} enc -d -aes-256-cbc -salt -in ${in_file} -out ${out_file}"
        ${tool} enc -d -aes-256-cbc -salt -base64 -pbkdf2 -iter 100000 -in ${in_file} -out ${out_file}
        echo "encrypt/解密:${in_file} --> ${out_file}"
        echo ""
    else
        echo "ERROR:unknow opt"
    fi

    return 0
}


func_use_openssl_to_encrypt_decrypt_files "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
