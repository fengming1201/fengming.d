#!/bin/bash

scriptfilename=$0

target_dir=$fengming_cmd_dir

function func_create_fm_cmd
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptfilename  file_list"
        echo "$scriptfilename  file1 file2 ..."
        return 1
    fi
    local file_list=$@

    for file in ${file_list}
    do 
        if [ -e ${file} ];then echo "file:$file already exist!! skip it!";continue;fi
        if [ -w ${target_dir} ]
        then
            touch ${file}
            chmod 747 ${file}
        else
            sudo touch ${file}
            sudo  chmod 747 ${file}
        fi
        ls -lh ${file}
        cat  <<-EOF >${file}
#!/bin/bash
scriptfilename=\$0

function name
{

}

name \$@
ret=\$?
if [ \${ret} -ne 0 ];then 
    exit 1
fi
exit 0
EOF
    done
    return 0
}


func_create_fm_cmd $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0