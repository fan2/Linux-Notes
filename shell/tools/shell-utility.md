## cd

cd（change directory）：切换文件目录。

- `cd` / `cd ~`：进入当前用户的家目录（$HOME）；  
- `cd ..`：返回上级目录；  
- `cd -`：返回上次访问目录（相当于 `cd $OLDPWD`），再次执行在近两次目录之间切换。  

切换到带有空格的路径，需要加转义字符（反斜杠<kbd>\\</kbd>）来标识空格。

以下示例从 `~/` 目录切换到 `/Library/Application Support/Sublime Text 3/Packages/User`：

```Shell
faner@FAN-MB0:~|⇒  cd /Users/faner/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
faner@FAN-MB0:~/Library/Application Support/Sublime Text 3/Packages/User|
⇒  
```

另外一种做法是定义 shell 字符串变量，然后使用 <kbd>$</kbd> 符号解引用变量作为 cd 的参数：

```Shell
faner@FAN-MB0:~|⇒  dir="/Users/faner/Library/Application Support/Sublime Text 3/Packages/User/"                    
faner@FAN-MB0:~|⇒  cd $dir
faner@FAN-MB0:~/Library/Application Support/Sublime Text 3/Packages/User|
```

### pushd & popd

`cd -` 可在近两次目录之间切换，当涉及3个以上的工作目录需要切换时，可以使用 pushd 和 popd 命令。

macOS 的 zsh 命令行输入 push 然后 tab 可以查看所有 push 相关命令：

```Shell
faner@MBP-FAN:~|⇒  push
pushd   pushdf  pushln
```

- 其中 **pushdf** 表示切换到当前 Finder 目录（`pushd` to the current Finder directory）。  
- 关于 **pushln** 可参考 zsh-manual [Shell Builtin Commands](http://bolyai.cs.elte.hu/zsh-manual/zsh_toc.html#TOC65) 中的说明。  

> 在 macOS 终端中执行 `man pushd` 或 `man popd` 可知，他们为 BASH 内置命令（Shell builtin commands）。

**`pushd`** 和 **`popd`** 可以用于在多个目录（directory）之间进行切换（push/pop）而无需复制并粘贴目录路径。 

`pushd` 和 `popd` 以栈的方式来运作，后进先出（Last In First Out, LIFO）。目录路径被存储在栈中，然后用 push 和 pop 操作在目录之间进行切换。

```Shell

# 执行 dirs -c 清理栈之后，只剩当前目录
faner@MBP-FAN:~|⇒  dirs
~

# 将 ~/Downloads 目录压栈
faner@MBP-FAN:~|⇒  pushd Downloads 
~/Downloads ~

# 将 ~/Documents 目录压栈
faner@MBP-FAN:~/Downloads|⇒  pushd ../Documents 
~/Documents ~/Downloads ~

# 依次执行 pushd ../Movies、pushd ../Pictures、pushd ../AppData、pushd ../Applications、pushd ../Desktop

# 将 ~/Music 目录压栈
faner@MBP-FAN:~/Desktop|⇒  pushd ../Music 
~/Music ~/Desktop ~/Applications ~/AppData ~/Pictures ~/Movies ~/Documents ~/Downloads ~
```

**`dirs`**：查看当前 Shell 窗口操作过的目录栈记录，索引0表示栈顶。

 选项 | 含义
-----|------
-p  | 每行显示一条记录
-v  | 每行显示一条记录，同时展示该记录在栈中的index
-c  | 清空目录栈

```Shell
# 查看当前栈，0为栈顶，8为栈底
faner@MBP-FAN:~/Music|⇒  dirs -v
0   ~/Music
1   ~/Desktop
2   ~/Applications
3   ~/AppData
4   ~/Pictures
5   ~/Movies
6   ~/Documents
7   ~/Downloads
8   ~
```

- 不带参数输入 **pushd** 会将栈顶目录和下一目录对调，相当于 `cd -` 的效果。  

	> pushd 还可以带索引选项 +n，**切换**到当前栈中从栈底开始计数的某个目录。

- 不带参数输入 **popd** 会移除栈顶（当前）目录，切换到上一次访问的目录。  

	> popd 还可以带索引选项 +n，移除当前栈中从栈底开始计数的某个目录。

对于 `pushd +n` 和 `popd +n`，索引顺序与 `dirs -v` 相反，从栈底开始计数；  
反过来 `pushd -n` 和 `popd -n` 索引顺序与 `dirs -v` 相同，从栈顶开始计数。

```Shell
# 从栈底（索引为0）右往左数第3个目录 ~/Movies 重新压入栈顶，相当于切换到该目录
faner@MBP-FAN:~/Music|⇒  pushd +3
~/Movies ~/Documents ~/Downloads ~ ~/Music ~/Desktop ~/Applications ~/AppData ~/Pictures

# 从栈顶（索引为-0）左往右数第3个目录 ~ 移除出栈
faner@MBP-FAN:~/Movies|⇒  popd -3
~/Movies ~/Documents ~/Downloads ~/Music ~/Desktop ~/Applications ~/AppData ~/Pictures

# 从栈顶（索引为-0）左往右数第3个目录 ~/Music 重新压入栈顶，相当于切换到该目录
faner@MBP-FAN:~/Movies|⇒  pushd -3
~/Music ~/Desktop ~/Applications ~/AppData ~/Pictures ~/Movies ~/Documents ~/Downloads

# 从栈底（索引为0）右往左数第3个目录 ~/Pictures 移除出栈
faner@MBP-FAN:~/Music|⇒  popd +3
~/Music ~/Desktop ~/Applications ~/AppData ~/Movies ~/Documents ~/Downloads
```

[Linux中的pushd和popd](https://www.jianshu.com/p/53cccae3c443)  
[在命令行中使用pushd和popd进行快速定位](http://blog.sina.com.cn/s/blog_b6b704ef0102wjdk.html)  

## du

关于磁盘统计涉及到两个命令：

- `df` (Disk FileSystem)  
- `du` (Disk Usage)  

```
$ df -lh
Filesystem       Size   Used  Avail Capacity iused      ifree %iused  Mounted on
/dev/disk1s1s1  466Gi   15Gi   16Gi    48%  567381 4882909539    0%   /
/dev/disk1s4    466Gi   12Gi   16Gi    42%       9 4883476911    0%   /System/Volumes/VM
/dev/disk1s2    466Gi  507Mi   16Gi     3%    2991 4883473929    0%   /System/Volumes/Preboot
/dev/disk1s6    466Gi  2.3Mi   16Gi     1%      17 4883476903    0%   /System/Volumes/Update
/dev/disk1s5    466Gi  422Gi   16Gi    97% 4976082 4878500838    0%   /System/Volumes/Data
```

[How to Get the Size of a Directory in Linux](https://linuxize.com/post/how-get-size-of-file-directory-linux/)  
[How To Find The Size Of A Directory In Linux](https://www.ostechnix.com/find-size-directory-linux/)  
[How to Get the Size of a Directory from Command Line](http://osxdaily.com/2017/03/09/get-size-directory-command-line/)  
[How do I get the size of a directory on the command line?](https://unix.stackexchange.com/questions/185764/how-do-i-get-the-size-of-a-directory-on-the-command-line)  
[3 Simple Ways to Get the Size of Directories in Linux](https://www.2daygeek.com/how-to-get-find-size-of-directory-folder-linux/)  

进入指定文件夹执行 `du`，列举指定目录下的文件及所有递归文件夹占用磁盘的大小。

```
du ~/Documents
du ~/Library/Developer
du Pods
```

- 添加 `-c` 选项，最后会输出一条总占用大小；  
- 添加 `-s` 选项，相当于 `-d 0` 指定一级目录，不递归子目录；  
- 添加 `-h` 选项，是输出的 fileSize 更易阅读；  

```
$ du -sh ~/Documents
or
$ du -h -d 0 ~/Documents
$ du -h --max-depth=0 ~/Documents
```

统计目录 `~/Library/Developer` 占用磁盘空间大小：

```
$ du -sh ~/Library/Developer
 66G	/Users/faner/Library/Developer
```

统计目录 `~/Library/Developer` 子目录占用磁盘空间大小：

```
$ du -csh ~/Library/Developer/*
 23G	/Users/faner/Library/Developer/CoreSimulator
1.4G	/Users/faner/Library/Developer/XCTestDevices
 39G	/Users/faner/Library/Developer/Xcode
425M	/Users/faner/Library/Developer/chromium
2.2G	/Users/faner/Library/Developer/flutter
 66G	total
```

按占用磁盘空间降序（由大到小）排序：

```
$ du -csh ~/Library/Developer/* | sort -rh
 66G	total
 39G	/Users/faner/Library/Developer/Xcode
 23G	/Users/faner/Library/Developer/CoreSimulator
2.2G	/Users/faner/Library/Developer/flutter
1.4G	/Users/faner/Library/Developer/XCTestDevices
425M	/Users/faner/Library/Developer/chromium
```

当子目录太多时，可重定向给 `more` 滚动查看，或重定向给 `head -n 10` 查看前10条。

列举 Pods 目录下所有的一级子目录（不递归）：

```
ls -1 -d Pods/* | tee ~/Downloads/Pods-tree-L1.log
```

查看 Pods 目录下所有的一级子目录占用磁盘空间大小：

```
du -csh Pods/* | more
du -csh Pods/* | tee ~/Downloads/Pods-tree-L1-du.log
ls -1 -d Pods/* | xargs du -chs | tee ~/Downloads/Pods-tree-L1-du.log
```

---

The `tree` command is a recursive directory listing program that produces a depth indented listing of files and directories in a tree-like format.

```
tree --du -h /opt/ktube-media-downloader
```

## [bc](https://en.wikipedia.org/wiki/Bc_(programming_language))

[bc](https://www.gnu.org/software/bc/manual/html_mono/bc.html)(basic calculator) - An arbitrary precision calculator language  

bc is typically used as either a `mathematical scripting language` or as an `interactive mathematical shell`.  

There are four special variables, `scale`, `ibase`, `obase`, and `last`.  

支持输入数学表达式的解释型计算语言  

在终端输入 `bc` 即可进入 bc 命令行解释器；输入 `quit` 或者 `<C-d>` 发送 EOF 结束退出 bc。

> [COMMAND LINE CALCULATOR, BC](http://linux.byexamples.com/archives/42/command-line-calculator-bc/)  
> [How to Use the "bc" Calculator in Scripts](https://www.lifewire.com/use-the-bc-calculator-in-scripts-2200588)  
> [Linux下的计算器(bc、expr、dc、echo、awk)知多少？](http://blog.csdn.net/linco_gp/article/details/4517945)  
> [Linux中的super pi(bc 命令总结)](http://www.linuxidc.com/Linux/2012-06/63684.htm)  
> [我使用过的Linux命令之bc - 浮点计算器、进制转换](http://codingstandards.iteye.com/blog/793734)  

### basic

1. 在 bash shell 终端输入 `bc` 即可启动 bc 计算器。

输入表达式 `56.8 + 77.7`，再按回车键即可在新行得到计算结果：

```Shell
pi@raspberrypi:~ $ bc
bc 1.06.95
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 

56.8 + 77.7
134.5
```

也可书写代数表达式，用变量承载计算结果，作为进一步计算的操作数：

```Shell
$ bc -q # -q 不显示冗长的欢迎信息
a=2+3;
a
5
b=a*4;
b
20
```

2. 可通过 bc 内置的 **`scale`** 变量可指定浮点数计算输出精度：

```Shell
$ bc -q
5 * 7 /3
11
scale=2; 5 * 7 /3
11.66
```

3. 在终端可基于[数据流重定向或管道](https://www.cnblogs.com/mingcaoyouxin/p/4077264.html)作为 `bc` 的输入表达式：

```Shell
$ echo "56.8 + 77.7" | bc
134.5
```

### inline

对于简单的单行运算，可用 echo 重定向或内联重定向实现：

```
$ bc <<< "56.8 + 77.7"
134.5
```

如果需要进行大量运算，在一个命令行中列出多个表达式就会有点麻烦。  
bc命令能识别输入重定向，允许你将一个文件重定向到bc命令来处理。  
但这同样会叫人头疼，因为你还得将表达式存放到文件中。  

最好的办法是使用内联输入重定向，它允许你直接在命令行中重定向数据。  
在shell脚本中，你可以将输出赋给一个变量。

```
variable=$(bc << EOF
           options
           statements
           expressions
           EOF)
```

`EOF` 文本字符串标识了内联重定向数据的起止。

以下在终端测试这种用法：

```
$ bc << EOF
heredoc> 56.8 + 77.7
heredoc> EOF
134.5
```

### script

在shell脚本中，可调用bash计算器帮助处理浮点运算。可以用命令替换运行bc命令，并将输出赋给一个变量。基本格式如下：

```
variable=$(echo "options; expression" | bc)
```

第一部分 options 允许你设置变量。 如果你需要不止一个变量， 可以用分号将其分开。 expression参数定义了通过bc执行的数学表达式。

以下为在 shell scripts 调用 bc 对常量表达式做计算的示例:

```Shell
$ result=$(echo "scale=2; 5 * 7 /3;" | bc)
$ echo $result
11.66
```

以下为在 shell scripts 调用 bc 对变量表达式做计算的示例:

```
$ var1=100
$ var2=45
$ result=`echo "scale=2; $var1 / $var2" | bc`
$ echo $result
2.22
```

如果在脚本中使用，可使用内联重定向写法，将所有bash计算器涉及的部分都放到同一个脚本文件的不同行。  
将选项和表达式放在脚本的不同行中可以让处理过程变得更清晰，提高易读性。  
当然，一般需要用命令替换符号将 bc 命令的输出赋给变量，以作后用。  

`EOF` 字符串标识了重定向给bc命令的数据的起止，bc 内部可创建临时变量辅助计算（定义辅助变量或承接中间计算结果），但总是返回最后一条表达式的计算结果。

下面是在脚本中使用这种写法的例子。

```
$ cat test12.sh
#!/bin/bash

var1=10.46
var2=43.67
var3=33.2
var4=71
var5=$(bc << EOF
scale = 4
a1 = ( $var1 * $var2)
b1 = ($var3 * $var4)
a1 + b1
EOF)

echo The final answer for this mess is $var5
```

```
$ chmod u+x test12.sh
$ ./test12.sh
The final answer for this mess is 2813.9882
```

**注意**：在bash计算器中创建的局部变量只在内部有效，不能在shell脚本中引用！

### last

**`last`**  (an  extension)  is a variable that has the value of the *last* printed number.

bc 内置的 **`last`** 变量代表上个表达式的计算结果，可将 last 变量作为后续表达式的操作数，进行二次计算：

```
$ bc -q
2+3
5
last*4
20
```

### ibase/obase

默认输入和输出都是基于十进制：

```Shell
$ bc -q
ibase
10
obase
10
```

在 bc 命令解释器中输入 `ibase=10;obase=16;2017`，转换输出2017（十进制）的十六进制：

```Shell
ibase=10;obase=16;2017
7E1
```

或者 echo 分号相隔的表达式重定向作为 bc 的输入进行解释运行：

```Shell
$ echo "ibase=10;obase=16;2017" | bc
7E1
```

以下示例用 `bc` 计算器实现进制转换。

先将十进制转换成二进制：

```
$ no=100
$ echo "obase=2;$no" | bc 
1100100
```

再将二进制转换回十进制

```
$ no=1100100
$ echo "obase=10;ibase=2;$no" | bc
100
```

需要注意先写obase再写ibase，否则出错：

```
$ no=1100100
$ echo "ibase=2;obase=10;$no" | bc
1100100
```

## Checksum

### cksum

cksum, sum -- display file checksums and block counts

### CRC32

crc32 - Perform a 32bit Cyclic Redundancy Check

计算从 [crx4chrome](https://www.crx4chrome.com/) 离线下载的 [Vimium CRX 1.60.3 for Chrome](https://www.crx4chrome.com/crx/731/)  插件的 crc32 校验和：

```Shell
faner@FAN-MB0:~/Downloads/crx|
⇒  crc32 dbepggeogbaibhgnhhndojpepiihcmeb-1.60.3-Crx4Chrome.com.crx 
db950177
```

与官网给出的 CRC32 Checksum 值一致，则说明未被篡改，可放心安装。

### MD5

md5 -- calculate a message-digest fingerprint (checksum) for a file

md5 命令后的默认输入参数为文件名，也可通过 `-s` 选项指定计算字符串参数的MD5。

```Shell
     -s string
             Print a checksum of the given string.
```

计算从 [crx4chrome](https://www.crx4chrome.com/) 离线下载的 [Vimium CRX 1.60.3 for Chrome](https://www.crx4chrome.com/crx/731/)  插件的 MD5：

```Shell
faner@FAN-MB0:~/Downloads/crx|
⇒  md5 dbepggeogbaibhgnhhndojpepiihcmeb-1.60.3-Crx4Chrome.com.crx 
MD5 (dbepggeogbaibhgnhhndojpepiihcmeb-1.60.3-Crx4Chrome.com.crx) = c98057821ee3cede87d911ead832dcc1
```

与官网给出的 MD5 Checksum 值一致，则说明未被篡改，可放心安装。

---

计算下载到本地的 Vimium CRX 1.60.3 for Chrome 插件所在路径字符串的 MD5 值：

```Shell
faner@FAN-MB0:~/Downloads/crx|
⇒  md5 -s "/Users/faner/Downloads/crx/dbepggeogbaibhgnhhndojpepiihcmeb-1.60.3-Crx4Chrome.com.crx" 
MD5 ("/Users/faner/Downloads/crx/dbepggeogbaibhgnhhndojpepiihcmeb-1.60.3-Crx4Chrome.com.crx") = 2f6f9a98b561f995564793765c205a66
```

### SHA1

shasum - Print or Check SHA Checksums

```Shell
SYNOPSIS
        Usage: shasum [OPTION]... [FILE]...
        Print or check SHA checksums.
        With no FILE, or when FILE is -, read standard input.

          -a, --algorithm   1 (default), 224, 256, 384, 512, 512224, 512256
          -b, --binary      read in binary mode
          -c, --check       read SHA sums from the FILEs and check them
          -t, --text        read in text mode (default)
```

When verifying SHA-512/224 or SHA-512/256 checksums, indicate the **algorithm** explicitly using the `-a` option, e.g.

`shasum -a 512224 -c checksumfile`

---

计算从 [crx4chrome](https://www.crx4chrome.com/) 离线下载的 [Vimium CRX 1.60.3 for Chrome](https://www.crx4chrome.com/crx/731/)  插件的 SHA：

```
faner@FAN-MB0:~/Downloads/crx|
⇒  shasum dbepggeogbaibhgnhhndojpepiihcmeb-1.60.3-Crx4Chrome.com.crx 
476c61437d3c34e38ed1ee15950d202ded0902c8  dbepggeogbaibhgnhhndojpepiihcmeb-1.60.3-Crx4Chrome.com.crx
```

与官网给出的 SHA1 Checksum 值一致，则说明未被篡改，可放心安装。

## hexdump

### od

Linux/Unix（macOS）下的命令行工具 `od` 可按指定进制格式查看文档：

```Shell
pi@raspberrypi:~ $ od --version
od (GNU coreutils) 8.26
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Jim Meyering.
```

```Shell
pi@raspberrypi:~ $ man od

NAME
       od - dump files in octal and other formats

SYNOPSIS
       od [OPTION]... [FILE]...
       od [-abcdfilosx]... [FILE] [[+]OFFSET[.][b]]
       od --traditional [OPTION]... [FILE] [[+]OFFSET[.][b] [+][LABEL][.][b]]
```

**`-A`**, --address-radix=RADIX

> output format for file offsets; RADIX is one of [doxn], for Decimal, Octal, Hex or None  
>> 输出左侧的地址格式，默认为 o（八进制），可指定为 x（十六进制）。   

**`-j`**, --skip-bytes=BYTES

> skip BYTES input bytes first（跳过开头指定长度的字节）

**`-N`**, --read-bytes=BYTES

> limit dump to BYTES input bytes（只 dump 转译指定长度的内容）

**`-t`**, --format=TYPE

> select output format or formats（dump 输出的级联复合格式：`[d|o|u|x][C|S|I|L|n]`）

- `[doux]` 可指定有符号十、八、无符号十、十六进制；  
- `[CSIL]` 可指定 sizeof(char)=1, sizeof(short)=2, sizeof(int)=4, sizeof(long)=8 作为 group_bytes_by_bits；或直接输入数字[1,2,4,8]。

- `a`：Named characters (ASCII)，打印可见 ASCII 字符。

***`-x`***: same as `-t x2`, select hexadecimal 2-byte units

>  默认 group_bytes_by_bits = 16，两个字节（shorts）为一组。  

---

以下示例 hex dump `tuple.h` 文件开头的64字节：

```Shell
# 等效 od -N 64 -A x -t xCa tuple.h
faner@MBP-FAN:~/Downloads|⇒  od -N 64 -A x -t x1a tuple.h
0000000    ef  bb  bf  0d  0a  23  70  72  61  67  6d  61  20  6f  6e  63
           ?   ?   ?  cr  nl   #   p   r   a   g   m   a  sp   o   n   c
0000010    65  0d  0a  0d  0a  6e  61  6d  65  73  70  61  63  65  20  41
           e  cr  nl  cr  nl   n   a   m   e   s   p   a   c   e  sp   A
0000020    73  79  6e  63  54  61  73  6b  0d  0a  7b  0d  0a  0d  0a  2f
           s   y   n   c   T   a   s   k  cr  nl   {  cr  nl  cr  nl   /
0000030    2f  20  e5  85  83  e7  bb  84  28  54  75  70  6c  65  29  e6
           /  sp   ?  85  83   ?   ?  84   (   T   u   p   l   e   )   ?
0000040
```

### hexdump

Linux/Unix（macOS）下的命令行工具 `hexdump` 可按指定进制格式查看文档：

```Shell
pi@raspberrypi:~ $ man hexdump

NAME
     hexdump, hd — ASCII, decimal, hexadecimal, octal dump

SYNOPSIS
     hexdump [-bcCdovx] [-e format_string] [-f format_file] [-n length] [-s skip] file ...
     hd [-bcdovx] [-e format_string] [-f format_file] [-n length] [-s skip] file ...
```

**`-b`**      One-byte octal display.  
**`-c`**      One-byte character display.  
**`-C`**      Canonical hex+ASCII display.  
**`-d`**      Two-byte decimal display.  
**`-o`**      Two-byte octal display.  
**`-x`**      Two-byte hexadecimal display.  

**`-s`** offset: Skip offset bytes from the beginning of the input（跳过开头指定长度的字节）  
**`-n`** length: Interpret only length bytes of input（ 只 dump 转译指定长度的内容）  

---

可以 hexdump 出 UTF-8 编码的文本文件，通过开头3个字节来判断是否带BOM：

> 如果开头3个字节为 `ef bb bf`，则为带 BOM 编码；否则为不带 BOM 编码。

```Shell
# 等效 hexdump -C litetransfer.cpp | head -n 4
faner@MBP-FAN:~/Downloads|⇒  hexdump -n 64 -C tuple.h
00000000  ef bb bf 0d 0a 23 70 72  61 67 6d 61 20 6f 6e 63  |.....#pragma onc|
00000010  65 0d 0a 0d 0a 6e 61 6d  65 73 70 61 63 65 20 41  |e....namespace A|
00000020  73 79 6e 63 54 61 73 6b  0d 0a 7b 0d 0a 0d 0a 2f  |syncTask..{..../|
00000030  2f 20 e5 85 83 e7 bb 84  28 54 75 70 6c 65 29 e6  |/ ......(Tuple).|
00000040
```

### strings

```Shell
pi@raspberrypi:~ $ man strings

STRINGS(1)                          GNU Development Tools                          STRINGS(1)

NAME
       strings - print the strings of printable characters in files.

SYNOPSIS
       strings [-afovV] [-min-len]
               [-n min-len] [--bytes=min-len]
               [-t radix] [--radix=radix]
               [-e encoding] [--encoding=encoding]
               [-] [--all] [--print-file-name]
               [-T bfdname] [--target=bfdname]
               [-w] [--include-all-whitespace]
               [-s] [--output-separatorsep_string]
               [--help] [--version] file...

```
