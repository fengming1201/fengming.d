


function COMMOND_FUNC_file_password_cracking_tools_list
{
    echo "pdfcrack  --Pdfcrack是一款用于破解PDF文件密码的工具。Pdfcrack使用暴力破解方法，通过尝试不同的密码组合来破解密码。它支持多种密码破解模式和选项，可以根据需要进行自定义配置。"
    echo "rarcrack  --Rarcrack是一款用于破解RAR文件密码的工具。它专门针对RAR格式的压缩文件进行密码破解。Rarcrack使用暴力破解或字典攻击的方法。"
    echo "fcrackzip --Fcrackzip是一款用于破解ZIP文件密码的工具。它可以尝试恢复被密码保护的ZIP压缩文件的密码。支持暴力破解和字典攻击两种破解模式，并提供了多种参数选项以进行密码破解的配置。"
    return 0
}

function COMMOND_FUNC_check_vim_dictionary_env_variable
{
    if [ $# -ne 1 ]
    then
        echo "parameter wrong!!"
        return 1
    fi
    local target_file=$1
	#check vim enviroment
	local myvim_rc=~/.vim/myvimrc
	if [ ! -f ${myvim_rc} ]
	then
		echo "ERROR: vim config pack not install yet"
		echo "you can:fm-install_myvim_config_pack.sh"
		echo ""
		return 2
	fi
	local isinstalled=$(cat ${myvim_rc} | grep ${target_file})
	if [ "x${isinstalled}" = "x" ]
	then
		echo "add the following content to ${myvim_rc}"
		echo ""
        local ishavecur_work_dir=$(cat ${myvim_rc} | grep -w "cur_work_dir")
        if [ "x${ishavecur_work_dir}" = "x" ]
        then
		    cat <<EOF | tee -a ${myvim_rc}
let cur_work_dir = getcwd()
let dict_file = cur_work_dir . '/${target_file}'
if filereadable(dict_file)
    execute 'set dictionary+=' . dict_file
endif

EOF
        else
		    cat <<EOF | tee -a ${myvim_rc}
let dict_file = cur_work_dir . '/${target_file}'
if filereadable(dict_file)
    execute 'set dictionary+=' . dict_file
endif

EOF
        fi
	fi
    echo ""
    echo "how to use dictionary :在vim插入模式下 Ctrl + x 然后再按下 Ctrl + k"
    echo ""
    return 0
}
function COMMOND_FUNC_get_host_ip
{
    hostname -I | awk '{print$1}'
    return 0
}
