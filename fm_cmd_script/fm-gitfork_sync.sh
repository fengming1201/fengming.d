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
    echo "要让 GitHub 上你 fork 的项目自动保持与原始仓库同步，你需要设置一个“远程跟踪分支”来定期从上游（原始）仓库拉取更新。"
    echo "以下是详细步骤："
    echo "1,# 克隆你的 fork 到本地"
    echo "      git clone https://github.com/your-username/example-repo.git"
    echo "2,# 进入仓库目录"
    echo "      cd example-repo"
    echo "3,# 添加上游仓库:"
    echo "      git remote add upstream https://github.com/original-owner/example-repo.git"
    echo "4,# 获取上游仓库的更新"
    echo "      git fetch upstream"
    echo "5,# 切换到主分支"
    echo "      git checkout main"
    echo "6,# 合并上游仓库的更改"
    echo "      git merge upstream/main"
    echo "      解决冲突（如果有）"
    echo "7,# 推送更新到你的 fork"
    echo "      git push origin main"
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
function func_git_sync_fork
{
    if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname  forked_URL            origin_URL"
        echo "$scriptname  forked_respository    origin_respository"
        echo ".e.g http://192.168.254.121:8080/fromgithub/zephyr.git  https://github.com/fengming1201/zephyr.git"
        echo ""
        return 1
    fi
    local forked_URL=$1
    local origin_URL=$2
    local dir_name=$(basename ${forked_URL} .git)
    if [ -d ${dir_name} ]
    then
		local opt="N"
		read -p "dir:$dir_name already exist! do you want to force to sync fork? [y/N]"  opt
		if [ "x${opt}" = "x"  ];then opt="N";fi
		if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ]
		then
            echo "${dir_name}"
            rm -rf ${dir_name}
        else
            echo "nothing to do!!"
            return 2
        fi
    fi

    # 克隆你的 fork 到本地
    echo "[1]: git clone $forked_URL"
    git clone $forked_URL
    if [ $? -ne 0 ];then echo "[1]: fail!!";return 2;fi
    echo "[1]: done!!"

    # 进入仓库目录
    pushd $dir_name

	local remote_name="origin"
	local branch_name="main"
    remote_name=$(git remote -v | awk '{print $1}' | uniq)
	branch_name=$(git branch | awk '{print $2}' | uniq)

    # 添加上游仓库
    echo "[2]: git remote add upstream $origin_URL"
    git remote add upstream $origin_URL
    if [ $? -ne 0 ];then echo "[2]: fail!!";return 3;fi
    echo "[2]: done!!"

    # 获取上游仓库的更新
    echo "[3]: git fetch upstream"
    git fetch upstream
    if [ $? -ne 0 ];then echo "[3]: fail!!";return 4;fi
    echo "[3]: done!!"
    # 切换到主分支
    #git checkout main

    # 合并上游仓库的更改
    echo "[4]: git merge upstream/${branch_name}"
    git merge upstream/${branch_name}
    if [ $? -ne 0 ];then echo "[4]: fail!!";return 5;fi
    echo "[4]: done!!"
    # 解决冲突（如果有）

    # 推送更新到你的 fork
    echo "[5]: git push ${remote_name} ${branch_name}"
    git push ${remote_name} ${branch_name}
    if [ $? -ne 0 ];then echo "[5]: fail!!";return 6;fi
    echo "[5]: done!!"
    popd
    return 0
}

func_git_sync_fork "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
