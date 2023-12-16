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

function func_git_pull_update
{
    local target_dir=${fengming_dir}

    pushd ${target_dir}

    if [ $(id -u) -eq 0 ]
    then
        for num in  1 2 3
        do
            git pull origin main  2>&1 /dev/null
            if [ $? -eq 0 ];then
                break
            fi
        done
    else
        sudo git pull origin main
    fi
    popd
    return 0
}

func_git_pull_update $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
