
## dos2unix

在 vim 下执行 `:%s/\r//g` 可将DOS文件中的回车符 `^M` 替换为空（即删除）。

dos2unix 批量替换方案：`find ./ -type f print0 | xargs -0 sed -i 's/^M$//'`。  
