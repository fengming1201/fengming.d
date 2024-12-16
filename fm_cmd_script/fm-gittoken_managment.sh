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
if [ $(id -u) -ne 0 ] && [ ${USER} != $(ls -ld . | awk '{print$3}') ];then
    maybeSUDO=sudo
fi
token_encrypt_file_path=${fengming_dir}/encrypt_files

function func_git_mytoken_manage
{   
    local tool=openssl
    which ${tool} > /dev/null
    if [ $? -ne 0 ]
    then
        echo "${tool} not found!!"
        echo "apt install openssl"
        return 1
    fi
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname    encrypt/decrypt type"
        echo "$scriptname   [ 1 or encrypt ] type \'token stream\'"
        echo "$scriptname   [ 2 or decrypt ] type"
        echo "type: github | gitlab | mygit | gitee, dedault is github"
        echo ""
        return 2
    fi
    local type=github
    local targetfile="none"
    local password="none"

    if [ $1 -eq 1 ] || [ "$1" = "encrypt" ]
    then
        if [ $# -ne 3 ]
        then 
            echo "ERROR:input at least two parameters"
            echo "e.g:$scriptname   [ 1 or encrypt ] type \'token stream\'"
            echo "type: github | gitlab | gitee, dedault is github"
            return 3
        fi
        type=$2
        targetfile=${token_encrypt_file_path}/${type}_token_encrypt_file
        echo "type=$type"
        echo "targetfile=$targetfile"
        if [ ! -f ${targetfile} ];then echo "ERROR:can not found file!";return 4;fi

        read -s -p "input [encrypt] pass:"  password
        echo ""
        if [ "x${password}" = "x" ];then echo -e "\nERROR:Password cannot be empty!";return 4;fi
        local  ciphertext=$(echo -n "$3" |${tool} enc -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:${password} | tr -d '\n')
        echo "${type} ciphertext-->: ${ciphertext}"
        local  confirm=yes
        if [ -s ${targetfile} ]
        then
            read -p "sub_doc_git/git_my_github_token.txt already has ciphertext, do you want to overwrite it?[y/N]:" confirm
            if [ "x${confirm}" = "x" ];then confirm=N;fi
        fi
        if [ "${confirm}" = "y" ] || [ "${confirm}" = "Y" ] || [ "${confirm}" = "yes" ] || [ "${confirm}" = "YES" ]
        then
            if [ -w ${targetfile} ]
            then
                echo -n "${ciphertext}" | tee ${targetfile} > /dev/null
            else
                echo -n "${ciphertext}" | sudo tee ${targetfile} > /dev/null
            fi
            cat ${targetfile}
            echo ""
            echo "Save Success!!"
        else
            echo "Discard Save!!"
        fi
        echo ""
    elif [ $1 -eq 2 ] || [ "$1" = "decrypt" ]
    then
        if [ $# -eq 2 ];then type=$2;fi
        targetfile=${token_encrypt_file_path}/${type}_token_encrypt_file
        echo "type=$type"
        echo "targetfile=$targetfile"
        if [ ! -f ${targetfile} ];then echo "ERROR:can not found file!";return 4;fi

        read -s -p "input [decrypt] pass:" password
        if [ "x${password}" = "x" ];then echo -e "\nERROR:Password cannot be empty!";return 4;fi
        local ciphertext=$(cat ${targetfile})
        if [ "x${ciphertext}" = "x" ];then echo "ERROR:ciphertext file is empty.";return 4;fi
        echo ""
        echo -n "${type} plaintext-->: "
        echo "${ciphertext}" | openssl enc -d -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:${password}
        echo ""
    else
        echo "ERROR:unknow opt"
    fi

    return 0
}

func_git_mytoken_manage $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
