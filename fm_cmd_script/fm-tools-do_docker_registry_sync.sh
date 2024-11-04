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
function func_sync_images
{
    local tool=skopeo
    #check param
    if [ $# -lt 2 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo ""
        echo "$scriptname  source_registry                target_registry / list / check"
        echo ".e.g:"
        echo "$scriptname  http://luoshengming.top:8080   http://localhost:8040"
        echo ""
        echo "$scriptname  http://luoshengming.top:8080   list                       #list remote repository item"
        echo ""
        echo "$scriptname  http://luoshengming.top:8080   check                      #use curl to check URL validity"
        echo ""
        return 1
    fi

    #check tool
    which ${tool} > /dev/null
    if [ $? -ne 0 ]
    then 
        echo "${tool} not exist,please install it first!"
        echo "apt install skopeo"
        exit 1
    fi
    local ORG_SOURCE_REGISTRY="$1"
    local ORG_TARGET_REGISTRY="$2"

    if [ "x${ORG_TARGET_REGISTRY}" = "xlist" ];then
        curl -s ${ORG_SOURCE_REGISTRY}/v2/_catalog | jq -r '.repositories[]?'
        return 0
    elif [ "x${ORG_TARGET_REGISTRY}" = "xcheck" ];then
        curl -I ${ORG_SOURCE_REGISTRY}
        return 0
    fi

    local SOURCE_REGISTRY=$(echo ${ORG_SOURCE_REGISTRY} | sed 's/http:\/\///')
    local TARGET_REGISTRY=$(echo ${ORG_TARGET_REGISTRY} | sed 's/http:\/\///')

    #echo "ORG_SOURCE_REGISTRY=${ORG_SOURCE_REGISTRY}"
    #echo "ORG_TARGET_REGISTRY=${ORG_TARGET_REGISTRY}"
    #echo "SOURCE_REGISTRY=${SOURCE_REGISTRY}"
    #echo "TARGET_REGISTRY=${TARGET_REGISTRY}"
    
    # 获取镜像列表
    IMAGES=$(curl -s ${ORG_SOURCE_REGISTRY}/v2/_catalog | jq -r '.repositories[]?')
    #echo "${IMAGES}"

    for IMAGE in ${IMAGES}
    do
        # 获取每个镜像的标签
        TAGS=$(curl -s ${ORG_SOURCE_REGISTRY}/v2/$IMAGE/tags/list | jq -r '.tags[]?')
        
        for TAG in ${TAGS}
        do
            # 同步每个标签的镜像
            echo "Syncing ${IMAGE}:${TAG}"
            ## https
            #skopeo copy docker://$SOURCE_REGISTRY/$IMAGE:$TAG docker://$TARGET_REGISTRY/$IMAGE:$TAG
            ## http , 源和目的去安全认证,(源：--src-tls-verify=false)，（目的：--dest-tls-verify=false）
            skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://$SOURCE_REGISTRY/$IMAGE:$TAG docker://$TARGET_REGISTRY/$IMAGE:$TAG
        done
    done

    return 0
}

func_sync_images "$@"
ret=$?
if [ ${ret} -ne 0 ];then 
    exit 1
fi
exit 0
