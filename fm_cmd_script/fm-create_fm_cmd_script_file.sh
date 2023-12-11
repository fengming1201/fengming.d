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

target_dir=${fengming_dir}/fm_cmd_script

function func_create_fm_cmd
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "$scriptname  file_list"
        echo "$scriptname  file1 file2 ..."
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
scriptfile=\$0
scriptname=\$(basename \${scriptfile})
fengming_dir=\$FENGMING_DIR
if [ "\$1" = "info" ];then
    echo "location:\${scriptfile}"
    echo "abstract:"
    exit 0
fi
if [ "\$1" = "show" ];then
    echo "location:\${scriptfile}"
    cat \${scriptfile}
    exit 0
fi

function func_
{
    return 0
}

func_ \$@
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