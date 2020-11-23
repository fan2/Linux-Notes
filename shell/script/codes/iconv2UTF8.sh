#!/bin/bash

################################################################################
# ./iconv2UTF8.sh ./include
# ./iconv2UTF8.sh src
# $1 = file_dir（pwd 下的 include, src 子目录）

# 【将指定目录下及其子目录下所有的文件编码转换为UTF-8】
# 1. file_dir 可为相对路径或绝对路径

# 调用 enca 转换如果不考虑备份和echo调试，可以单行实现：
# find include src -type f | xargs file | grep -i 'ISO-8859\|Non-ISO' | cut -d ':' -f 1 | xargs enca -V -L zh_CN -x utf-8 | tee enca-x.log
################################################################################

# $1 = folder
iconv_folder()
{
    folder=$1
    file_count_ISO8859=$(find $folder -type f | xargs file | grep -ic 'ISO-8859')
    file_count_NonISO=$(find $folder -type f | xargs file | grep -ic 'Non-ISO')
    let fileCount=file_count_ISO8859+file_count_NonISO
    if [ $fileCount -gt 0 ]
    then
        echo "----------------------------------------"
        if [ $file_count_ISO8859 -gt 0 ]
        then
            echo "find $file_count_ISO8859 files encoding with ISO-8859 before convert"
        fi
        if [ $file_count_NonISO -gt 0 ]
        then
            echo "find $file_count_NonISO files encoding with Non-ISO before convert"
        fi
        echo "----------------------------------------"

        # read -p "Are you sure to convert the $fileCount files' encoding to UTF-8? <y/N> " prompt
        # if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
        if true
        then
            find $folder -type f | xargs file | grep -i 'ISO-8859\|Non-ISO' | while read fileInfoLine;
            do
                echo $fileInfoLine
                fileName=${fileInfoLine%%:*}  # 去掉冒号及右侧的，留取左侧的相对文件名（路径）
                # fileName=$(echo $fileInfoLine | cut -d ':' -f 1)
                # fileName=`echo $fileInfoLine | awk -F: '{print $1}'`
                # echo $fileName

                # 可选备份，如不执行，直接覆盖
                # cp $fileName 0-${fileName}

                # 方案1：调用 iconv 转码
                iconv -f GB18030 -t UTF-8 $fileName > ${fileName}.utf8
                if [ $? -eq 0 ] # if [ "$?" = "0" ]
                then
                    echo "✅ $fileName: iconv -f GB18030 -t UTF-8 success"
                    mv ${fileName}.utf8 $fileName
                else
                    echo "❌ $fileName: iconv -f GB18030 -t UTF-8 failed"
                fi

                # 方案2：调用 enca 转码
                # enca -L zh_CN -x utf-8 $fileName # 可加 -V
                # if [ $? -eq 0 ] # if [ "$?" = "0" ]
                # then
                #     echo "✅ $fileName: enca -x utf-8 success"
                # else
                #     echo "❌ $fileName: enca -x utf-8 failed"
                # fi
            done

            ########################################
            # 转码结果校验
            ########################################
            let file_count_ISO8859=0
            let file_count_NonISO=0
            file_count_ISO8859=$(find $folder -type f | xargs file | grep -ic 'ISO-8859')
            file_count_NonISO=$(find $folder -type f | xargs file | grep -ic 'Non-ISO')
            echo "----------------------------------------"
            if [ $file_count_ISO8859 -gt 0 ] || [ $file_count_NonISO -gt 0 ]
            then
                if [ $file_count_ISO8859 -gt 0 ]
                then
                    echo "still find $file_count_ISO8859 files encoding with ISO-8859 after convert"
                elif [ $file_count_NonISO -gt 0 ]
                then
                    echo "still find $file_count_NonISO files encoding with Non-ISO after convert"
                fi
                find $folder -type f | xargs file | grep -i 'ISO-8859\|Non-ISO'
            else
                echo "find no files encoding with ISO-8859 or Non-ISO after convert"
            fi
            echo "----------------------------------------"
        else
            exit 0
        fi
    else
        echo "find no files encoding with ISO-8859 or Non-ISO!"
    fi
}

main()
{
    folders=
    if [ $# -gt 0 ] # if ! [ $# -eq 0 ]
    then
        folders=$@
    else
        echo "PLS input directories that contains the source files"
        read -p "input folders:" folders
    fi

    i=0
    for folder in ${folders[*]}
    do
        let i++
        if [ -d $folder ]
        then
            echo "📂 param[$i] = $folder"
            iconv_folder $folder
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
