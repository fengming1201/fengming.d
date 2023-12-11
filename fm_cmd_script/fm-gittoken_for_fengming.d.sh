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

function func_git_mytoken_manage
{   
    local git_token_list=("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" "end")
	
	echo "token:"
	echo "${git_token_list[*]}"
	echo "===================================="
    echo "format:"
    echo "git remote set-url origin  https://<your_token>@github.com/<USERNAME>/<REPO>.git"
    echo "<your_token>：包括<>在内的全部字符替换成你的token"
    echo "<USERNAME>：包括<>在内的全部字符替换成你的username"
    echo "<REPO>：包括<>在内的全部字符替换成你要访问的仓库名称"
	echo "e.g.:"
    echo "git remote set-url origin  https://<your token>/fengming1201/fengming.d.git"
	echo "or"
	echo "git push origin main"
	echo "username:"
	echo "password:<your token>"

    return 0
}

func_git_mytoken_manage $@
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
