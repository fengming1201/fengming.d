#!/bin/bash
scriptfilename=$0
if [ "$1" = "info" ];then
    echo "location:${scriptfilename}"
    echo "abstract:"
    exit 0
fi
if [ "$1" = "show" ];then
    echo "location:${scriptfilename}"
    cat ${scriptfilename}
    exit 0
fi

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
        if [ -e ${target_dir}/${file} ];then echo "file:$file already exist!! skip it!";continue;fi
        if [ -w ${target_dir} ]
        then
            touch ${target_dir}/${file}
            chmod 747 ${target_dir}/${file}
        else
            sudo touch ${target_dir}/${file}
            sudo  chmod 747 ${target_dir}/${file}
        fi
        ls -lh ${target_dir}/${file}
        cat  <<-EOF >${target_dir}/${file}
#!/bin/bash
scriptfilename=\$0

if [ "\$1" = "info" ];then
    echo "location:\${scriptfilename}"
    echo "abstract:"
    exit 0
fi
if [ "\$1" = "show" ];then
    echo "location:\${scriptfilename}"
    cat \${scriptfilename}
    exit 0
fi

function name
{
    return 0
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