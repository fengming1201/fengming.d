#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
if [ "$1" = "info" ];then
    echo "location:${scriptfile}"
    echo "abstract:"
    echo "         crunch是一个密码生成器工具，它可以根据用户提供的参数生成自定义规则的密码字典"
    echo "1,自定义密码规则：crunch允许用户定义密码的长度、字符集和其他规则。你可以指定密码的最小和最大长度，选择包含的字符集（如字母、数字、特殊字符等），以及定义其他密码规则。"
    echo "2,字符集文件：crunch提供了一个字符集文件，其中包含了一些常见的字符集定义，如数字、字母、特殊字符等。你可以使用这些字符集文件中的定义，也可以自定义字符集。"
    echo "3,生成密码字典：使用crunch，你可以生成包含各种密码组合的字典文件。生成的字典文件可以用于密码破解、安全测试和其他需要密码字典的场景。"
    echo "4,灵活的参数选项：crunch提供了多个参数选项，可以用于进一步定制生成密码字典的方式。你可以指定密码的前缀和后缀，限制生成密码中字符的重复次数，以及设置其他生成规则。"
    echo ""
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
function func_crunch_generate_dictionary
{
    local app=crunch
    local charset=/usr/share/crunch/charset.lst
    
    if [ $# -lt 3 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "${scriptname}  <min> <max> [options]"

        echo "more detail info in <crunch_help>"
        return 1
    fi
    which ${app}  > /dev/null
    if [ $? -ne 0 ]
    then
        echo "ERROR:${app} not found!"
        echo "please install it first!"
        echo "apt install crunch"
        return 2
    fi

    if [ -f ${charset} ]
    then
        cat ${charset} | grep =
        return 2
    fi
    


    return 0
}

func_crunch_generate_dictionary $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
