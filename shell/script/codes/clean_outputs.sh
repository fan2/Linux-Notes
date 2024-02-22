#!/bin/bash

################################################################################
# 指定C/C++代码工程目录，删除文件夹下的中间产物
# 
# ./clean_outputs.sh $targetDir1
# ./clean_outputs.sh $targetDir1 $targetDir2 ...
################################################################################

clean_outputs()
{
    targetDir=$1
    echo "🎬 start clean $targetDir"

    echo "----------------------------------------"
    echo "clean folders: "
    # 删除当前目录下的所有文件夹（递归强制删除各级子文件夹下的文件）
    # find "." -maxdepth 1 ! -path "." -type d -exec rm -rf -- {} \+ -print
    # find "." -maxdepth 1 ! -path "." -type d -print0 | xargs -0 rm -rf
    find "$targetDir" -maxdepth 1 ! -path "$targetDir" -type d -exec rm -rf -- {} \+ -print

    echo "----------------------------------------"
    echo "clean files: "

    # 删除当前目录下的所有非代码文件（不包括子文件夹）
    # find . -maxdepth 1 -type f \( ! -iname '*.h' ! -iname '*.hh' ! -iname '*.hpp' ! -iname '*.c' ! -iname '*.cc' ! -iname '*.cpp' \) -delete -print
    # find . -maxdepth 1 -type f \( ! -iname '*.h' ! -iname '*.hh' ! -iname '*.hpp' ! -iname '*.c' ! -iname '*.cc' ! -iname '*.cpp' \) -exec rm -rf -- {} \+ -print
    # find . -maxdepth 1 -type f \( ! -iname '*.h' ! -iname '*.hh' ! -iname '*.hpp' ! -iname '*.c' ! -iname '*.cc' ! -iname '*.cpp' \) -print0 | xargs -0 rm -rf
    find $targetDir -maxdepth 1 -type f \( ! -iname '*.h' ! -iname '*.hh' ! -iname '*.hpp' ! -iname '*.c' ! -iname '*.cc' ! -iname '*.cpp' \) -delete -print

    echo "----------------------------------------"
    echo "clean end. 🔚"
}

main()
{
    folders=
    if [ $# -gt 0 ] # if ! [ $# -eq 0 ]
    then
        folders=$@
    else
        echo "PLS input directories you want to clean"
        read -p "input folders:" folders
    fi

    i=0
    for folder in ${folders[*]}
    do
        let i++
        if [ -d $folder ]
        then
            echo "****************************************"
            echo "📂 param[$i] = $folder"
            clean_outputs $folder
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

main $@ # $*