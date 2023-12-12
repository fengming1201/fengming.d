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

token_encrypt_file=${fengming_dir}/documents/sub_doc_git/git_my_github_token.txt

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
        echo "$scriptname   encrypt/decrypt"
        echo "$scriptname   [ 1 or encrypt ] \'token stream\'"
        echo "$scriptname   [ 2 or decrypt ]"
        echo ""
        return 2
    fi
    local password="none"

    if [ $1 -eq 1 ] || [ "$1" = "encrypt" ]
    then
        if [ $# -ne 2 ];then echo "ERROR:input at least two parameters";return 3;fi
        read -s -p "input [encrypt] pass:"  password
        echo -n "ciphertext-->: "
        if [ -w ${token_encrypt_file} ]
        then
            #echo "echo -n "$2" |${tool} enc -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:****** | tr -d '\n' | tee ${token_encrypt_file}"
            echo -n "$2" |${tool} enc -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:${password} | tr -d '\n' | tee ${token_encrypt_file}
        else
            #echo "echo -n "$2" |${tool} enc -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:****** | tr -d '\n' |sudo tee ${token_encrypt_file}"
            echo -n "$2" |${tool} enc -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:${password} | tr -d '\n' |sudo tee ${token_encrypt_file}
        fi
        echo " "
    elif [ $1 -eq 2 ] || [ "$1" = "decrypt" ]
    then
        read -s -p "input [decrypt] pass:" password
        local ciphertext=$(cat ${token_encrypt_file})
        if [ "x${ciphertext}" = "x" ];then echo "ERROR:ciphertext file is empty.";return 4;fi
        echo -n "plaintext-->: "
        echo "${ciphertext}" | openssl enc -d -aes-256-cbc -base64 -pbkdf2 -iter 100000 -pass pass:${password}
        echo " "
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
