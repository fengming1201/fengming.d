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
function do_search_and_rename
{
    local step1_result_file=org_file_name_list.txt
    local step2_result_file=map_extra_number_list.txt
    local step3_result_file=search_resault_list.txt
    local tmp_dir=tmp

    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "Usage:"
        echo "${scriptname}  [step] [dir]"
        echo "${scriptname}  1      org_dir      #get org file name with \"-\""
        echo "${scriptname}  2                   #extra aviv_num from org"
        echo "${scriptname}  3      search_dir   #"
        echo "${scriptname}  4                   #check new  name"
        echo "${scriptname}  5   rename_file   target_dir  [real_do]   #default test reame,only give "exe_rename" will be real do rename"
        echo "${scriptname}  6         #clean tmp/* file"
        echo ""
        return 1
    fi  
    # create tmp dir
    if [ ! -d ${tmp_dir} ];then mkdir ${tmp_dir};fi

    local opt_step=$1
    
    if [ "x${opt_step}" = "x1" ] && [ $# -eq 2 ]
    then
        #step 1:
        #check
        local target_dir=$2
        if [ ! -d ${target_dir} ];then echo "ERROR:dir:${target_dir} not exist!";return 2;fi
        if [ -f ${tmp_dir}/${step1_result_file} ];then rm -v ${tmp_dir}/${step1_result_file};fi
        #add head
        echo "##info={hostname:${HOSTNAME},dir:${target_dir}}" > ${tmp_dir}/${step1_result_file}
        #get org info
        echo "ls ${target_dir} | grep \"-\" >> ${tmp_dir}/${step1_result_file}"
        ls ${target_dir} | grep "-" > ${tmp_dir}/${step1_result_file}
        echo ""
        echo "done:${tmp_dir}/${step1_result_file}"
    elif [ "x${opt_step}" = "x2" ]
    then
        #check 
        if [ ! -f ${tmp_dir}/${step1_result_file} ];then echo "ERROR:please run step 1 first!";return 3;fi
        if [ -f ${tmp_dir}/${step2_result_file} ];then rm -v ${tmp_dir}/${step2_result_file};fi
        #head 
        echo "##info={hostname:${HOSTNAME},dir:${target_dir}}" > ${tmp_dir}/${step2_result_file}

        for org in $(cat ${tmp_dir}/${step1_result_file})
        do
            local flag="FC2-PPV-"
            if [ "x$(echo "${org}" | grep -i ${flag})" != "x" ]
            then
                local new=$(echo "${org}" | awk -F . '{print$1}' | awk -F - '{print$3}')
            else
                local new=$(echo "${org}" | awk -F . '{print$1}' | awk -F - '{print$1"-"$2}')
            fi
            echo "${org}   ${new} >> ${tmp_dir}/${step2_result_file}"
            echo "${org}   ${new}" >> ${tmp_dir}/${step2_result_file}
        done
        echo ""
        echo "done:${tmp_dir}/${step2_result_file}"
    elif [ "x${opt_step}" = "x3" ] && [ $# -eq 2 ]
    then
        #accordding num to search info
        local search_dir=$2
        if [ ! -d ${search_dir} ];then echo "ERROR:dir:${search_dir} not exist!";return 2;fi
        #check
        if [ ! -f ${tmp_dir}/${step2_result_file} ];then echo "ERROR:please run step 2 first!";return 3;fi
        if [ -f ${tmp_dir}/${step3_result_file} ];then rm -v ${tmp_dir}/${step3_result_file};fi
        #head
        echo "##info={hostname:${HOSTNAME},dir:${target_dir}}" > ${tmp_dir}/${step3_result_file}

        oldIFS="$IFS"
        IFS=$'\n'
        for line in $(cat ${tmp_dir}/${step2_result_file})
        do
            echo "line=${line}"
            local org_name=$(echo "${line}" | awk -F " " '{print$1}')
            local num=$(echo "${line}" | awk -F " " '{print$2}')
            echo "===${org_name}  -->${num}"
            local search_result=$(grep -rin --exclude=*.torrent ${num} ${search_dir})
            if [ "x${search_result}" != "x" ]
            then
                echo "${org_name}   ${org_name}" >> ${tmp_dir}/${step3_result_file}
                echo "{" >> ${tmp_dir}/${step3_result_file}
                echo "${search_result}" >>  ${tmp_dir}/${step3_result_file}
                echo "}" >> ${tmp_dir}/${step3_result_file}
            fi
        done
        IFS="$oldIFS"
        echo ""
        echo "done:${tmp_dir}/${step3_result_file}"
    elif [ "x${opt_step}" = "x4" ]
    then
        #check 
        if [ ! -f ${tmp_dir}/${step3_result_file} ];then echo "ERROR:please run step 3 first!";return 3;fi
        cat search_resault_list.txt  | awk '{print$2}' | grep -v "\."

    elif [ "x${opt_step}" = "x5" ] && [ $# -ge 3 ]
    then
        #check
        local rename_rule=${PWD}/$2
        local target_dir=$3
        if [ ! -d ${target_dir} ];then echo "ERROR:dir:${target_dir} not exist!";return 2;fi
        if [ ! -f ${rename_rule} ];then echo "ERROR:please run step 3 first!";return 3;fi
        local test_flag="none"
        if [ $# -eq 4 ];then test_flag=$4;fi
        pushd ${target_dir}
        oldIFS="$IFS"
        IFS=$'\n'
        for line in $(cat ${rename_rule})
        do
            local org_name=$(echo "${line}" | awk -F " " '{print$1}')
            local new_name=$(echo "${line}" | awk -F " " '{print$2}')
            if [ ! -f ${org_name} ];then echo "ERROR:file:${org_name} not exist";continue;fi
            if [ ${test_flag} = "real_do" ]
            then
                mv -v ${org_name}  ${new_name}
            else
                echo "test:mv -v ${org_name}  ${new_name}"
            fi
        done
        IFS="$oldIFS"
        popd
    elif [ "x${opt_step}" = "x6" ]
    then
        rm -v ${tmp_dir}/$step1_result_file
        rm -v ${tmp_dir}/$step2_result_file
        rm -v ${tmp_dir}/$step3_result_file
    else
        echo "Unknow opt !!"
    fi
    return 0
}

do_search_and_rename "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
