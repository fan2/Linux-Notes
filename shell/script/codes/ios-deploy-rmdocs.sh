#!/bin/bash

################################################################################
# ./ios-deploy-rmdocs.sh com.apple.DemoApp 2015952713/FileRecv
# $1 = bundle_id
# $2 = doc_subdir, 2015952713/FileRecv, 2015952713/FileRecv/_tmp, 2015952713/FileRecv/_thumb

# 【删除沙盒 /Documents/ 指定子目录下的文件】
# 1. ios-deploy --list 遍历 APP（bundle_id）沙盒 /Documents/ 下的子目录 doc_subdir 到临时文件
# 2. ios-deploy -R 遍历临时文件，逐项删除 /Documents/doc_subdir/items
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

# 遍历沙盒目录下的文件（路径）到临时文件
ls_subdir_files()
{
    sub_dir=$2
    sub_folder="/Documents/$sub_dir/"
    file_name=${sub_dir//\//-} # 替换 / 为 -
    ls_out_file="./ios-deploy-list-Documents-$file_name.txt"
    ios-deploy -1 $1 --list=$sub_folder > $ls_out_file
    wc -l $ls_out_file
}

rm_subdir_files()
{
    sub_dir=$2
    sub_folder="/Documents/$sub_dir/"
    file_name=${sub_dir//\//-} # 替换 / 为 -
    ls_out_file="./ios-deploy-list-Documents-$file_name.txt"
    echo "ls_out_file = $ls_out_file"
    if [ -f $ls_out_file ]
    then
        while read line
        do
            if [[ $line =~ $sub_folder ]] # include
            then
                ios-deploy -1 $1 -R $line
                if [ $? -eq 0 ] # if [ "$?" = "0" ]
                then
                    echo "rm $line success"
                else
                    echo "rm $line failed"
                fi
            fi
        done < $ls_out_file
    else
        echo "$ls_out_file is not valid file!"
    fi
}

main()
{
    bundle_id=""
    doc_subdir=""

    if ! [ $# -eq 2 ]
    then
        echo "PLS input params first"
        read -p "1. input bundle_id:" bundle_id
        read -p "2. input doc_subdir:" doc_subdir
    else
        bundle_id=$1
        doc_subdir=$2
    fi

    # check parameters
    # echo $doc_subdir
    # echo $bundle_id

    # TODO: verify doc_subdir
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
                sub_dir=$doc_subdir
                if [ ${sub_dir:0:1} = "/" ]   # 去掉开头的 /
                then
                    sub_dir=${sub_dir#/}
                fi
                if [ ${sub_dir:0-1:1} = "/" ] # 去掉结尾的 /
                then
                    sub_dir=${sub_dir%/}
                fi
                echo "sub_dir = $sub_dir"     # test

                start_time=`date`
                ls_subdir_files $bundle_id $sub_dir
                rm_subdir_files $bundle_id $sub_dir
                end_time=`date`
                echo "run time = $start_time - $end_time"
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
