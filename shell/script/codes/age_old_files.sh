#!/bin/bash

################################################################################
# 删除指定文件夹下1天前的文件: 恋词考研英语-全真题源报刊7000词-索引红版-YYYYMMDDHH.pdf
# 
# ./age_old_files.sh $targetDir1
# ./age_old_files.sh $targetDir1 $targetDir2 ...
################################################################################

age_old_files()
{
    fileprefix=恋词考研英语-全真题源报刊7000词-索引红版
    filesuffix=.pdf
    targetDir=$1
    echo "🎬 start clean $targetDir"

    echo "----------------------------------------"

    for file in "$targetDir"/*
    do
        if [ -f "$file" ]
        then
            filename=${file#"$targetDir/"}
            if [[ $filename == *$fileprefix*$filesuffix ]]
            then
                suffix=${filename##*-}
                # 提取后缀前的时间戳
                timestamp=${suffix%.pdf*}
                # 日期字符串形如 YYYYMMDDHH，预期长度为10
                if [ ${#timestamp} -ne 10 ]
                then
                    echo "unexpected filename: $filename!"
                else
                    # 取前8位：YYYYMMDD
                    filedate=${timestamp:0:8}
                    # 当前日期：YYYYMMDD
                    curdate=$(date +\%Y\%m\%d)
                    # 计算日期差：单位为天（月份权位为 100）
                    delta=$((curdate - filedate))
                    # >=1d：昨天及之前的
                    if [ $delta -ge 1 ]
                    then
                        echo "rm -f $filename"
                        rm -f "$file"
                    fi
                fi
            fi
        fi
    done

    echo "----------------------------------------"
    echo "clean end. 🔚"
}

main()
{
    folders=()
    if [ $# -gt 0 ] # if ! [ $# -eq 0 ]
    then
        folders=( "$@" )
    else
        echo "PLS input directories you want to clean"
        read -p "input folders:" folders
    fi

    i=0
    for folder in "${folders[@]}"
    do
        ((i++))
        if [ -d "$folder" ]
        then
            echo "****************************************"
            echo "📂 param[$i] = $folder"
            age_old_files "$folder"
        else
            echo "⚠️ param[$i] = $folder, invalid directory"
        fi
    done
}

################################################################################
# main entry
################################################################################
# echo "param count = $#"
# echo "params = $@"

main "$@" # $*