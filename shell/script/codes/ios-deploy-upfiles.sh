#!/bin/bash

################################################################################
# ./ios-deploy-upfiles.sh ~/Downloads/Documents/ com.apple.DemoApp
# $1 = bundle_id
# $2 = file_dir

# 【上传本地文件到沙盒对应目录】
# 1. 本地路径 file_dir 下按照沙盒目录布局存放：/Users/fan/Downloads/Documents/uin/files/test.doc
# 2. 扫描 file_dir 目录下的所有文件，并上传到沙盒对应目录（/Documents/uin/files/test.doc）：
################################################################################

is_iosdeploy_installed()
{
    # ios-deploy -V | read ios_deploy_version # wrong???
    ios_deploy_version=$(ios-deploy -V)
    if [ $? -eq 0 -a $ios_deploy_version ]
    # if test $ios_deploy_version
    # if [ -n "$ios_deploy_version" ]
    then
        echo "ios-deploy version: $ios_deploy_version"
        return 0
    else
        echo "ios-deploy not found, PLS install first!!!"
        return 1
    fi
}

# $1 = bundle_id
# $2 = file_dir
upload_local_files_to_sandbox()
{
    find $2 -type f | grep -v \.DS_Store | while read filename
    do
        # echo $filename                          # 本地绝对路径
        file_prefix=${filename%/Documents*}     # 沙盒路径前缀
        # echo $file_prefix
        file_relpath=${filename#*$file_prefix}  # 沙盒路径(/Documents/...)
        # echo $file_relpath
        ios-deploy -o $filename -1 $1 -2 $file_relpath
        if [ $? -eq 0 ] # if [ $? = "0" ]
        then
            echo "$file_relpath upload success"
        else
            echo "$file_relpath upload failed"
        fi
    done
}

main()
{
    bundle_id=""
    file_dir=""

    if ! [ $# -eq 2 ]
    then
        echo "PLS input params first"
        read -p "1. input bundle_id:" bundle_id
        read -p "2. input local file dir:" file_dir
    else
        bundle_id=$1
        file_dir=$2
    fi

    # check parameters
    # echo $file_dir
    # echo $bundle_id

    if [ -d $file_dir ]
    then
        # if [ $bundle_id -a -n "$bundle_id"] # wrong???
        if [[ $bundle_id ]] && [[ -n "$bundle_id" ]] # right
        then
            ios-deploy -B | grep $bundle_id -q
            if [ $? -eq 0 ]
            then
                # try to create dir for test sandbox accessibility
                ios-deploy -1 $bundle_id -D /tmp/ios-deploy-dir
                if [ $? -eq 0 ]
                then
                    upload_local_files_to_sandbox $file_dir $bundle_id
                else
                    echo "APP[$bundle_id]: sandbox not-accessible!"
                    exit 1
                fi
            else
                echo "APP[$bundle_id] not exist!"
                exit 1
            fi
        else
            echo "empty bundle_id!"
            exit 1
        fi
    else
        echo "invalid directory!"
        exit 1
    fi
}

if is_iosdeploy_installed
then
    ios_deploy_device=`ios-deploy -c`
    # if [ $? -eq 0 -a $ios_deploy_device ] # [: too many arguments ???
    # if [ $? -eq 0 ] && [ $ios_deploy_device ] # wrong
    if [[ $? -eq 0 ]] && [[ $ios_deploy_device ]] # right
    then
        echo $ios_deploy_device # TODO: extract udid in 'Found <udid> '?
        main $@ # $*
    else
        echo "ios-deploy detect failed!"
    fi
fi
