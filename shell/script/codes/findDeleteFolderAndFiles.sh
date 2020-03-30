#!/bin/bash

################################################################################
#find . -type d -name __MACOSX | xargs rm -rf

folders=("__MACOSX")

echo "${#folders[*]} folders to be delete recursively"

for folder in ${folders[*]}
do
	echo '--------------------------------------------------'
	echo "find and delete $folder ..."
	find . -type d -name $folder | while read folderName
	do
		echo "rm -rf $folderName"
		rm -rf "$folderName" # 避免空格分割路径
	done
done

################################################################################
# find . -type f -name .DS_Store -delete
# find . -type f -name AVEngine.log -delete
# find . -type f -name *.mqq*_WTLOGIN.*.log -delete
# find . -type f -name *.mqq_MSF*.log -delete
# find . -type f -name *.mqq_mini*.log -delete
# find . -type f -name *.mqq_peak.*.log -delete
# find . -type f -name *.mqq_qzone.*.log -delete
# find . -type f -name *.mqq_tool.*.log -delete

files=(".DS_Store" "AVEngine.log"
		"*.mqq.*_WTLOGIN.*.log"
		"*.mqq_MSF.*.log"
		"*.mqq_mini.*.log"
		"*.mqq_peak.*.log"
		"*.mqq_qzone.*.log"
		"*.mqq_tool.*.log")

echo "${#files[*]} files to be delete recursively"

for file in ${files[*]}
do
	echo '--------------------------------------------------'
	echo "find and delete $file ..."
	find . -type f -name $file | while read fileName
	do
		echo "rm $fileName"
		rm "$fileName" # 避免空格分割路径
	done
done
