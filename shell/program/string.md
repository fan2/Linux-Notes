
[linux shell 字符串操作详解](https://www.iteye.com/blog/justcoding-1963463)  
[shell 变量的高级用法](https://www.cnblogs.com/crazymagic/p/11067147.html)  

## 字符串长度

字符串长度计算表达式：`${#string}`

```
$ file_path=/Users/faner/Downloads/iosdeploy_download/Documents/2905558360/image_original_flash
$ echo $file_path
/Users/faner/Downloads/iosdeploy_download/Documents/2905558360/image_original_flash
```

字符串长度：

```
# echo ${#file_path}
83
$ strlen=${#file_path}
$ echo $strlen
83
```

`unset string1` 或 `string1=""` 时，字符串长度为0。
`string1=" "` 时，字符串长度为1。

```
$ if [ ${#string1} -gt 0 ]
then
    print 'hello'
else
    print 'world'
fi
```

## 索引区间

表达式 | 含义
-------|---
`${string:position}`          | 在 $string 中, 从位置 $position 开始提取子串
`${string:position:length}`   | 在 $string 中, 从位置 $position 开始提取长度为$length的子串

```
${var:n1:n2}
```

**解释**：截取n1和n2之间的字符串  

例如：

`${var:0:5}`：表示从左边第1个字符开始，截取5个字符。  
`${var:7}`：表示从左边第8个字符开始，一直到结尾。  
`${var:0-7:5}`：表示从右边第7个字符开始，截取5个字符。  
`${var:0-5}`：表示从右边第5个字符开始，一直到结尾。

- `${str:0:1}`: 第一个字符  
- `${str:0-1:1}`: 最后一个字符  
- `${str:0-2:2}`: 末尾两个字符  

判断以某个字符开头、结尾？？？

## 索引位置

[Linux shell 获得字符串所在行数及位置](https://www.cnblogs.com/xiaolincoding/p/11366274.html)

可以借助 awk 中的 `index` 函数，在 awk 的 BEGIN 中针对 shell 字符串变量进行操作：

```
$ str='uellevcmpottcap'
$ str1='ott'
$ awk 'BEGIN{print index("'${str}'","'${str1}'") }'
```

当然，也可以将 shell 变量传递作为 awk 变量，在 awk 脚本内部操作变量：

> [shell 查找字符串中字符出现的位置](https://www.cnblogs.com/sea-stream/p/11403014.html)

```
$ a="The cat sat on the mat"
$ test="cat"
$ index=`awk -v a="$a" -v b="$test" 'BEGIN{print index(a,b)}'`
$ echo $index
5
```

## [字符串拼接](https://www.cnblogs.com/wuac/p/11121709.html)

字符串五种拼接模式：

```Shell
#!/bin/bash
name="Shell"
str="Test"

str1=$name$str      #中间不能有空格
str2="$name $str"   #如果被双引号包围，那么中间可以有空格
str3="$name: $str"
str4=$name": "$str  #中间可以出现别的字符串
str5="${name}Script: ${str}" #这个时候需要给变量名加上大括号

echo $str1
echo $str2
echo $str3
echo $str4
echo $str5
```

运行结果：

```
ShellTest
Shell Test
Shell: Test
Shell: Test
ShellScript: Test
```

经常需要在shell环境变量 `PATH` 中头插或追加第三方工具的路径：

```
# testPATH 初始值
pi@raspberrypi:~ $ testPATH=/usr/bin:/bin:/usr/sbin:/sbin

# 头部插入
pi@raspberrypi:~ $ testPATH=/usr/local/bin:$testPATH

# 尾部追加
pi@raspberrypi:~ $ testPATH=${testPATH}:/usr/local/sbin
```

## 字符串包含

[Shell判断字符串包含关系的几种方法](https://blog.csdn.net/iamlihongwei/article/details/59484029)  
[Shell判断字符串是否包含小结](https://blog.csdn.net/Primeprime/article/details/79625306)  
[shell判断字符串包含关系](https://zhuanlan.zhihu.com/p/51708411)  

### 利用通配符

`[[ ]]`: 判断命令  

```Shell
#!/bin/bash

A="helloworld"
B="low"
if [[ $A == *$B* ]]
then
    echo "包含"
else
    echo "不包含"
fi
```

### 利用字符串运算符

`=~`: 正则式匹配符号  

```Shell
#!/bin/bash

strA="helloworld"
strB="low"
if [[ $strA =~ $strB ]]
then
    echo "包含"
else
    echo "不包含"
fi
```

### 利用grep查找

```Shell
#!/bin/bash

strA="long string"
strB="string"
result=$(echo $strA | grep "${strB}")
#if [[ "$result" != "" ]]
#if [ "$result" != "" ]
#if [ -n "$result" ]
if [ $? -eq 0 ] && [ -n "$result" ]
then
    echo "包含"
else
    echo "不包含"
fi
```

### 利用 case in 语句

```Shell
#!/bin/bash

thisString="1 2 3 4 5" # 源字符串
searchString="1 2" # 搜索字符串
case $thisString in 
    *"$searchString"*) echo Enemy Spot ;;
    *) echo nope ;;
esac
```

### 运用替换运算

```Shell
#!/bin/bash

STRING_A=$1
STRING_B=$2
if [[ ${STRING_A/${STRING_B}//} == $STRING_A ]]
then
    ## is not substring.
    echo N
    return 0
else
    ## is substring.
    echo Y
    return 1
fi
```

## [字符串截取](https://blog.csdn.net/qq_33951180/article/details/68059098)

### 截左留右

`#` 和 `##` 号截断左边留取右边子串（非贪婪模式，贪婪模式） 
表达式 | 含义
---------|----------
`${string#substring}`	| 从变量 $string 的开头, 删除最短匹配 $substring 的子串
`${string##substring}`	| 从变量 $string 的开头, 删除最长匹配 $substring 的子串

> 其中 substring 可以是一个正则表达式。

```
$ file_path=/Users/faner/Downloads/iosdeploy_download/Documents/2905558360/image_original_flash
$ suffix=${file_path#*iosdeploy_download}
$ echo $suffix
/Documents/2905558360/image_original_flash
```

### 截右留左

`%` 和 `%%` 号截断右边留取左边子串（非贪婪模式，贪婪模式） 
表达式 | 含义
---------|----------
`${string%substring}`	| 从变量 $string 的结尾, 删除最短匹配 $substring的子串
`${string%%substring}`	| 从变量 $string 的结尾, 删除最长匹配 $substring 的子串

> 其中 substring 可以是一个正则表达式。

```
$ file_path=/Users/faner/Downloads/iosdeploy_download/Documents/2905558360/image_original_flash
$ prefix=${file_path%/Documents/*}
$ echo $prefix
/Users/faner/Downloads/iosdeploy_download
```

### refs

[bash shell字符串的截取](https://www.cnblogs.com/liuweijian/archive/2009/12/27/1633661.html)  
[Shell字符串截取](http://c.biancheng.net/view/1120.html) - 非常详细  
[shell截取字符串的方法](https://www.jianshu.com/p/4ceca1a2d265)  

[Linux Shell 截取字符串](https://www.cnblogs.com/fengbohello/p/5954895.html)  
[Shell脚本8种字符串截取方法总结](https://www.jb51.net/article/56563.htm)
[shell脚本查找、抽取指定字符串的方法](https://blog.csdn.net/u011006622/article/details/85048488)  

[extract substring using regex in shell script](https://stackoverflow.com/questions/40422067/extract-substring-using-regex-in-shell-script)  
[How to extract a value from a string using regex and a shell?](https://stackoverflow.com/questions/3320416/how-to-extract-a-value-from-a-string-using-regex-and-a-shell)  

[Extract word from string using grep/sed/awk](https://askubuntu.com/questions/697120/extract-word-from-string-using-grep-sed-awk)  
[How to extract string following a pattern with grep, regex or perl](https://stackoverflow.com/questions/5080988/how-to-extract-string-following-a-pattern-with-grep-regex-or-perl)  

## 字符串替换

[字符串操作 ${} 的截取，删除和替换](https://www.jianshu.com/p/2305fc9351c2)

[Shell脚本中替换字符串等操作](https://blog.csdn.net/jeffiny/article/details/83271889)

expr    | note
--------|--------
`${string/substring/replacement}`  | 使用 $replacement, 代替第一个匹配的 $substring
`${string//substring/replacement}` | 使用 $replacement, 代替所有匹配的 $substring
`${string/#substring/replacement}` | 如果 $string 的前缀匹配 $substring, 那么就用 $replacement 来代替匹配到的 $substring
`${string/%substring/replacement}` | 如果 $string 的后缀匹配 $substring, 那么就用 $replacement 来代替匹配到的 $substring

### 普通替换

`${string/match_string/replace_string}`: 将 string 中第一个 match_string 替换成 replace_string；  
`${string//match_string/replace_string}`: 将 string 中的 match_string 全部替换成 replace_string；  

```
$ str=123abc123
$ echo "${str/123/r}"
rabc123
$ echo "${str//123/r}"
rabcr
```

将 `2905558360/FileRecv` 中的 / 替换为 -；

```
> str='2905558360/FileRecv'
> echo $str
2905558360/FileRecv

> echo "${str/\//-}"
2905558360-FileRecv
```

### 前后缀替换

`${string/#match_string/replace_string}`: 将 string 中第一个 match_string 替换成 replace_string  
`${string/%match_string/replace_string}`: 将 string 中最后一个 match_string 替换成 replace_string  

```
$ str=123abc123
$ echo "${str/#123/r}"
rabc123
$ echo "${str/%123/r}"
123abcr
```

### demo

doc_subdir 字符串值为 "2015952713/FileRecv" 或 "/2015952713/FileRecv/"，如果是后者需要移除首尾的 `/`：

1. 去掉开头的 `/` 两种方法：

- 截左留右：`sub_dir=${sub_dir#/}`;  
- 前缀替换为空：`sub_dir=${sub_dir/#\//}`;  

2. 去掉结尾的 `/` 两种方法：

- 截右留左：`sub_dir=${sub_dir%/}`;  
- 后缀替换为空：`sub_dir=${sub_dir/%\//}`;  

```Shell
    sub_dir=$doc_subdir
    if [ ${sub_dir:0:1} = "/" ]   # 去掉开头的 /
    then
        sub_dir=${sub_dir#/} # sub_dir=${sub_dir/#\//}
    fi
    if [ ${sub_dir:0-1:1} = "/" ] # 去掉结尾的 /
    then
        sub_dir=${sub_dir%/} # sub_dir=${sub_dir/%\//}
    fi
    
    sub_folder="/Documents/$sub_dir/" # 拼接沙盒路径
```

移除首尾的 `/` 后，要生成临时文件名，中间的 `/` 需要全部替换为 `-`：

```Shell
    file_name=${sub_dir//\//-} # 替换 / 为 -
    ls_out_file="./ios-deploy-list-Documents-$file_name.txt"
```
