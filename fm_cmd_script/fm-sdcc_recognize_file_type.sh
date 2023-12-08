
#!/bin/bash

scriptfilename=$0

function func_sdcc_recognize_file_type
{
    local type_suffix=("asm" "bin" "hex" "ihx" "lk" "lst" "map" "mem" "rel" "rst" "sym")
    local type_script=("由编译器创建的汇编文件" \
    "二进制文件" \
    "hex烧写文件" \
    "以Intel hex forma格式的加载模块" \
    "链接脚本" \
    "由汇编器创建的汇编链接文件" \
    "由链接器创建的加载模块的内存映射" \
    "带有内存使用情况的文件" \
    "由汇编器产生的目标文件，可以作链接编辑器的输入" \
    "由链接编辑器创建的具有链接信息更新的汇编链接文件" \
    "由汇编器创建的源文件链接标识，符号列表")
    local len=${#type_suffix[@]}
    local file_list=""
    len=$(expr $len - 1)

    for index in $(seq 0 $len)
    do
        file_list=$(find . -maxdepth 1 -type f -name "*.${type_suffix[${index}]}")
        if [ x"${file_list}" = "x" ];then continue;fi

        for file in ${file_list}
        do
            echo "${file} --  ${type_script[index]}"
        done
    done
    return 0
}

func_sdcc_recognize_file_type $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0