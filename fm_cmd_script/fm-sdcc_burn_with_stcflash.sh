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
if [ $(id -u) -ne 0 ];then
    maybeSUDO=sudo
fi
function func_sdcc_burn_with_stcflash
{
    local burn_tool=stcflash.py
    local tool_path=/root/stcflash
    local com=/dev/ttyUSB0
    local baud_rate=2400
    local protocol=89
    local hex_file=main.hex
    local test_flag=no
    #check param
    if [ $# -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then 
        echo "$scriptname  [-p com] [-l baud][-r {89,12c5a,12c52,12cx052,auto}]  hex_image"
        echo "$scriptname hex_image    #default:-v -p ${com} -l ${baud_rate} -r ${protocol}"
        echo "$scriptname -t  hex_image   #test , not real to burn!!"
        echo ""
        echo "89 	    STC89C52RC (v4.3C), STC89C54RD+ (v4.3C), STC90C52RC (v4.3C)"
        echo "12cx052 	STC12C2052 (v5.8D)"
        echo "12c52 	STC12C5608AD (v6.0G), STC12C5204AD (v6.0H)"
        echo "12c5a 	STC10F04XE (v6.5J), STC12C5A16S2 (v6.2I), STC11F02E (v6.5K)"
        return 1
    fi
    #opt 
#    while getopts "p:r:" opt
#    do
#        case $opt in
#            p)
#                com=$OPTARG
#                ;;
#            l)
#                baud=$OPTARG
#                ;;
#            r)
#                protocol=$OPTARG
#                ;;
#            \?)
#                echo "Invalid option: -$OPTARG" >&2
#                exit 1
#                ;;
#        esac
#    done
#    shift $((OPTIND-1))
#    hex_file=${1}

    while [[ $# -gt 0 ]]
    do
        case "$1" in
            -p)
                com="$2"
                shift 2
                ;;
            -l)
                baud_rate="$2"
                shift 2
                ;;
            -r)
                protocol="$2"
                shift 2
                ;;
            -t)
                test_flag=yes
                shift 1
                ;;
            *)
                hex_file="$1"
                shift
                ;;
        esac
    done
    #check tool exist
    if [ ! -f ${tool_path}/${burn_tool} ];then echo "burn tool not found!";return 1;fi
    if [ ! -e  ${com} ];then echo "device not found!";return 2;fi
    if [ ! -f ${hex_file} ];then echo "image:${hex_file} not found!";return 3;fi

    if [ "${test_flag}" = "no" ]
    then
        echo "exec:python3 ${tool_path}/${burn_tool} -v -p ${com}  -l ${baud_rate} -r ${protocol} ${hex_file}"
        python3 ${tool_path}/${burn_tool} -v -p ${com}  -l ${baud_rate} -r ${protocol} ${hex_file}
        echo "done ....."
    fi
    if [ "${test_flag}" = "yes" ]
    then
        echo "test:python3 ${tool_path}/${burn_tool} -v -p ${com}  -l ${baud_rate} -r ${protocol} ${hex_file}"
        echo "nothing to do ..."
        echo "done ....."
    fi
    return 0
}
func_sdcc_burn_with_stcflash $@
ret=$?
if [ ${ret} -ne 0 ]
then 
    exit 1
fi
exit 0
