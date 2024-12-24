#!/bin/bash
scriptfile=$0
scriptname=$(basename ${scriptfile})
fengming_dir=$FENGMING_DIR
common_share_function=${fengming_dir}/fm_cmd_script/common_share_function.sh

if [ -f ${common_share_function} ] && [ "include" = "enable" ];then
    source ${common_share_function}
fi
#if unnecessary, please do not modify this function
function func_location
{
    if [ -L ${scriptfile} ];then
        echo "location:${scriptfile}  --> $(readlink ${scriptfile})"
    else
        echo "location:${scriptfile}"
    fi
    return 0
}
if [ "$1" = "info" ] || [ "$1" = "-info" ] || [ "$1" = "--info" ];then
    echo "abstract:"
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
if [ $(id -u) -ne 0 ] && [ lshm != lshm ];then
    maybeSUDO=sudo
fi
#start here add your code,you need to implement the following function.
target_file_name=${fengming_dir}/documents/sub_doc_unclassified/collect_open_source_project_info.json

function func_add_new_item
{
    if [ $# -lt 4 ];then echo "ERROR:parameter wrong!";return 1;fi
	tmp_file=$(mktemp) 
	jq --arg name "$1" \
		--arg language "$2" \
		--arg describe "$3" \
		--arg url "$4" \
		'.info += [{"name": $name, "language": $language, "describe": $describe, "URL": $url}]' \
		${target_file_name} > ${tmp_file}
    echo "New item:${1}"
    #jq -r ".info[] | select(.name == \"${1}\")" ${tmp_file}
    diff -u ${target_file_name}  ${tmp_file}
	opt=n
	read -p "save back?[y/N]:" opt
	if [ "x${opt}" = x ];then opt=N;fi
	if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ];then
		opt=Y
	fi
	if [ "${opt}" = "Y" ];then
		cp $tmp_file $target_file_name
	fi
	rm ${tmp_file}
    return 0
}

function func_delete_item
{
    if [ $# -lt 1 ];then echo "ERROR:parameter wrong!";return 1;fi
    echo "Delete item:${1}"
    local delete_item=$(jq -r ".info[] | select(.name == \"${1}\")" ${target_file_name})
    if [ "x${delete_item}" = "x" ];then echo "ERROR:Not found target:${1} item!";return 2;fi
    
    tmp_file=$(mktemp) 
    jq "del(.info[] | select(.name == \"${1}\"))" ${target_file_name} > ${tmp_file}
    diff -u ${target_file_name}  ${tmp_file}
	opt=n
	read -p "save back?[y/N]:" opt
	if [ "x${opt}" = x ];then opt=N;fi
	if [ "x${opt}" = "xy"  ] || [ "x${opt}" = "xY"  ] || [ "x${opt}" = "xyes"  ] || [ "x${opt}" = "xYES"  ];then
		opt=Y
	fi
	if [ "${opt}" = "Y" ];then
		cp $tmp_file $target_file_name
	fi
	rm ${tmp_file}
    return 0
}

function func_check_item_status
{
	if [ ! -f ${target_file_name} ];then
		echo "${target_file_name} not exist!!"
		return 1
	fi

	local dir_list=()
	for dir in $(find -maxdepth 1 -type d -printf '%P\n')
	do
		if [ -d ${dir}/.git/ ];then
			dir_list+=("${dir}")
		fi
	done
	
	local name_list=$(jq -r  '.info[].name' ${target_file_name})

	for sub_dir in "${dir_list[@]}"
	do
		echo ${name_list} | grep "${sub_dir}" > /dev/null
		if [ $? -ne 0 ];then
			echo "WARNNING: ${sub_dir} not registe to ${target_file_name} yet!"
		fi
	done
	echo "=============================================================="
	local dir_list=$(echo ${dir_list[@]})
	for item_name in ${name_list}
	do
		echo ${dir_list} | grep "${item_name}" > /dev/null
		if [ $? -ne 0 ];then
			echo "WARNNING: ${item_name} not pull to local yet!"
		fi
	done

	return 0
}

function func_git_pull_update
{
	#get dir
	local dir_list=()

	for dir in $(find -maxdepth 1 -type d -printf '%P\n')
	do
		if [ -d ${dir}/.git/ ];then
			dir_list+=("${dir}")
		fi
	done

	local remote_name="origin"
	local branch_name="masters"

	for sub_dir in "${dir_list[@]}"
	do
		pushd ${sub_dir}
		remote_name=$(git remote -v | awk '{print $1}' | uniq)
		branch_name=$(git branch | awk '{print $2}' | uniq)
	
		echo "timeout 60s git pull ${remote_name} ${branch_name}"
		timeout 60s git pull ${remote_name} ${branch_name}
		popd
	done
	return 0
}

function func_git_clone
{
	local name_list=$(jq -r  '.info[].name' ${target_file_name})

	for item_name in ${name_list}
	do
		if [ -d ${item_name} ];then
			echo "INFO:item ${item_name} already exist!"
			continue
		fi
		echo "${item_name}:"$(jq -r ".info[] | select(.name == \"${item_name}\") | .describe" ${target_file_name})
		item_url=$(jq -r ".info[] | select(.name == \"${item_name}\") | .URL" ${target_file_name})
		if [ "x${item_url}" != "x" ];then
			echo "timeout 60s git clone ${item_url}"
			timeout 60s git clone ${item_url}
		else
			echo "item: ${item_name}  URL is empty!"
		fi
	done
	return 0
}

function func_schedule
{
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ];then
        echo "$scriptname  cmd  args ..."
        echo ""
        echo "$scriptname  [-h | --help | all=(check & update)]"
        echo ""
        echo "$scriptname  list                                        #列出所有收藏项目"
        echo "$scriptname  update                                      #逐个下拉收藏项目"             
        echo "$scriptname  check                                       #检查当前目录下的收藏项目状态"      
        echo "$scriptname  add     \"name\" \"language\" \"describe\" \"url\"  #添加收藏项目"
        echo "$scriptname  delete  \"name\"                              #删除收藏项目"      
        echo "$scriptname  clone                                       #下载收藏项目"
        echo ""
        return 1
    fi
    which jq > /dev/null
    if [ $? -ne 0 ];then
        echo "jq not found! please install it first!"
        echo "apt install jq"
        exit 2
    fi

    if [ "$1" = "list" ];then
        jq -r '.info[]' ${target_file_name}
        exit 0
    fi

    if [ "$1" = "add" ] && [ $# -eq 5 ];then
        echo "\e[31madd ....\e[0m"
        func_add_new_item "$2" "$3" "$4" "$5" 
    fi
    if [ "$1" = "delete" ] && [ $# -eq 2 ];then
        echo "\e[31mdelete ....\e[0m"
        func_delete_item "$2"
    fi

    if [ "$1" = "clone" ];then
        echo "\e[31mclone ....\e[0m"
        func_git_clone
    fi

    if [ "$1" = "check" ] || [ "$1" = "all" ];then
        echo "\e[31mcheck ....\e[0m"
        func_check_item_status
    fi

    if [ "$1" = "update" ] || [ "$1" = "all" ];then
        echo "\e[31mupdate ....\e[0m"
        func_git_pull_update $@
    fi
    return 0
}

func_schedule "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
