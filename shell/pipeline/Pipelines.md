
# pipe(管道)

参考 BASH(1) manual page 的 `SHELL GRAMMAR > Pipelines` 部分。

11.6 管道命令（pipe）

- 11.6.1 选取命令：cut,grep  
- 11.6.2 排序命令：sort,wc,uniq  
- 11.6.3 双向重定向：tee  
- 11.6.4 字符转换命令：tr,col,join,paste,expand  
- 11.6.5 切割命令：split  
- 11.6.6 参数代换：xargs  
- 11.6.7 关于减号-的用途  

## 管道分隔界定符(|)

A `pipeline` is a sequence of one or more commands separated by one of the control operators `|` or `|&`. The format for a pipeline is:

```Shell
[time [-p]] [ ! ] command [ [|⎪|&] command2 ... ]
```

The standard output of *`command`* is connected via a pipe to the standard input of *`command2`*.  
If **`|&`** is used, *`command`*'s standard error, in addition to its standard output, is connected to *`command2`*'s standard input through the pipe; it is shorthand for `2>&1 |`.  

`ls -al /etc | less`：列举 `/etc` 目录，然后导向 less 使可翻页查看。

### demo

- [Homebrew](https://docs.brew.sh/) [Installation](https://docs.brew.sh/Installation.html) 脚本，基于 `&&` 递进执行相关命令：创建目录，下载并解压。

```Shell
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
```

## cut

cut 可以基于分隔符（separator/delimiter）将行内数据进行切割，分解出所需的信息列。

执行 `cut --version` 查看版本信息：

```Shell
pi@raspberrypi:~ $ cut --version
cut (GNU coreutils) 8.26
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by David M. Ihnat, David MacKenzie, and Jim Meyering.
```

执行 `cut --help` 可查看简要帮助（Usage）。

```Shell
-c, --characters=LIST   select only these characters
-d, --delimiter=DELIM   use DELIM instead of TAB for field delimiter
-f, --fields=LIST       select only these fields;
```

执行 `man cut` 可查看详细帮助手册（Manual Page）：

```Shell
pi@raspberrypi:~ $ man cut

CUT(1)                                  User Commands                                  CUT(1)

NAME
       cut - remove sections from each line of files

SYNOPSIS
       cut OPTION... [FILE]...

DESCRIPTION
       Print selected parts of lines from each FILE to standard output.

       With no FILE, or when FILE is -, read standard input.

       Mandatory arguments to long options are mandatory for short options too.
```

### PATH

PATH 环境变量是以 `:` 分隔多个路径，可以使用 cut 命令提取其中部分路径。

```Shell
faner@MBP-FAN:~|⇒  echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin
faner@MBP-FAN:~|⇒  echo $PATH | cut -d ':' -f 3  
/bin
faner@MBP-FAN:~|⇒  echo $PATH | cut -d ':' -f 5
/sbin
faner@MBP-FAN:~|⇒  echo $PATH | cut -d ':' -f 3,5
/bin:/sbin
```

不小心向 PATH 重复追加了 `/usr/local/sbin`：

```Shell
pi@raspberrypi:~ $ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
pi@raspberrypi:~ $ PATH=$PATH:/usr/local/sbin
pi@raspberrypi:~ $ echo $PATH 
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:/usr/local/sbin
```

如何删除刚才追加重复的 `/usr/local/sbin`？

直接 `PATH=` 赋值修改前的值 `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games`。

执行 `PATH=$(echo $PATH | cut -d : -f 1,3-)` 可移除第2项；

### export

export 声明变量排列整齐，可据此以字符为单位提取固定字符位置区间：

```Shell
# 获取 export 前4条
pi@raspberrypi:~ $ export | head -n 4
declare -x DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
declare -x HOME="/home/pi"
declare -x INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH="10"
declare -x INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="true"

# 提取12个字符及其后的部分（移除行首的11个字符(declare -x )）
## 12为起始位置，-后面未指定结束位置，表示至行尾
pi@raspberrypi:~ $ export | head -n 4 | cut -c 12-
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
HOME="/home/pi"
INFINALITY_FT_AUTOHINT_HORIZONTAL_STEM_DARKEN_STRENGTH="10"
INFINALITY_FT_AUTOHINT_INCREASE_GLYPH_HEIGHTS="true"
```

其他像 ps、last 等命令输出都由空白（空格或tab 制表符）控制排版格式，连续空白较难合适分割。

## wc,sort,uniq

### wc

**wc** - print newline, word, and byte counts for each file

```Shell
-c, --bytes
      print the byte counts

-m, --chars
      print the character counts

-w, --words
      print the word counts

-l, --lines
      print the newline counts
```

统计 Podfile 文件的行数：

```
$ wc -l Podfile
     879 Podfile
```

统计 Podfile 文件的行数和字节数：

```
$ wc -lc Podfile
     879   38508 Podfile
```

how count all lines in all files in current dir and omit empty lines with wc, grep, cut and bc commands

```Shell
echo `wc -l * | grep total | cut -f2 -d’ ‘` – `grep -in “^$” * | wc -l ` | bc
```

### sort

**sort** - sort lines of text files

### uniq

**uniq** - report or omit repeated lines

统计 `mars/mars/stn/src` 目录下类数（同名的 h/cc）

```Shell
faner@MBP-FAN:~/Projects/git/framework/mars/mars/stn/src|master⚡ 
⇒  ls | cut -d '.' -f 1 | uniq -c
   2 anti_avalanche
   2 dynamic_timeout
   2 flow_limit
   2 frequency_limit
   2 longlink
   2 longlink_connect_monitor
   2 longlink_identify_checker
   2 longlink_speed_test
   2 longlink_task_manager
   2 net_channel_factory
   2 net_check_logic
   2 net_core
   2 net_source
   2 netsource_timercheck
   2 proxy_test
   2 shortlink
   1 shortlink_interface
   2 shortlink_task_manager
   2 signalling_keeper
   2 simple_ipport_sort
   2 smart_heartbeat
   1 special_ini
   1 task_profile
   2 timing_sync
   2 zombie_task_manager
```

## xargs

unix/POSIX - [xargs](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/xargs.html)  
FreeBSD/Darwin - [xargs](https://www.freebsd.org/cgi/man.cgi?query=xargs)  

linux - [xargs(1)](http://man7.org/linux/man-pages/man1/xargs.1.html) & [xargs(1p)](http://man7.org/linux/man-pages/man1/xargs.1p.html)  
debian/Ubuntu - [xargs](https://manpages.debian.org/buster/findutils/xargs.1.en.html)  

执行 `xargs --help` 可查看简要帮助（Usage）。  
执行 `man xargs` 可查看详细帮助手册（Manual Page）：

```Shell
pi@raspberrypi:~ $ man xargs

XARGS(1)                           General Commands Manual                           XARGS(1)

NAME
     xargs -- construct	argument list(s) and execute utility

SYNOPSIS
     xargs [-0oprt] [-E	eofstr]	[-I replstr [-R	replacements] [-S replsize]]
	   [-J replstr]	[-L number] [-n	number [-x]] [-P maxprocs] [-s size]
	   [utility [argument ...]]

DESCRIPTION
     The xargs utility reads space, tab, newline and end-of-file delimited
     strings from the standard input and executes utility with the strings as
     arguments.

     Any arguments specified on	the command line are given to utility upon
     each invocation, followed by some number of the arguments read from the
     standard input of xargs.  This is repeated	until standard input is	ex-
     hausted.
```

执行 `xargs --version` 查看版本信息：

```Shell
pi@raspberrypi:~ $ xargs --version
xargs (GNU findutils) 4.7.0-git
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Eric B. Decker, James Youngman, and Kevin Dalley.
```

### options

以下列举了5个常用的命令选项：

```
     -0	     Change xargs to expect NUL	(``\0'') characters as separators, in-
	     stead of spaces and newlines.  This is expected to	be used	in
	     concert with the -print0 function in find(1).

     -I	replstr
	     Execute utility for each input line, replacing one	or more	occur-
	     rences of replstr in up to	replacements (or 5 if no -R flag is
	     specified)	arguments to utility with the entire line of input.

     -n	number
	     Set the maximum number of arguments taken from standard input for
	     each invocation of	utility.

     -p	     Echo each command to be executed and ask the user whether it
	     should be executed.  An affirmative response, `y' in the POSIX
	     locale, causes the	command	to be executed,	any other response
	     causes it to be skipped.  No commands are executed	if the process
	     is	not attached to	a terminal.

     -t	     Echo the command to be executed to	standard error immediately be-
	     fore it is	executed.
```

`xargs -I` 和 `xargs -i` 是一样的，只是 `-i` 默认使用大括号（`{}`）作为替换字符串（replstr），`-I` 则可以自定义其他字符串作为 replstr，但是必须用引号包起来（？）。

man 推荐使用 `-I` 代替 `-i`，但是一般都使用 `-i` 图个简单，除非在命令中不能使用大括号。

> macOS 下不支持 `-i` 选项！

### usage

大多数时候，xargs 命令都是跟管道一起使用的。但是，它也可以单独使用。
`xargs` 后面的命令默认是 `echo`。

`xargs` 是构建单行命令的重要组件之一，它擅长将标准输入数据转换成命令行参数。  
xargs 命令一般紧跟在管道操作符之后，以标准输入作为主要的源数据流。它使用 stdin 并通过提供 *命令行参数* 来执行其他命令。  
默认情况下 xargs 将其标准输入中的内容以空白(包括空格、tab、回车换行等)分割成多个 arguments 之后当作命令行参数传递给其后面的命令。也可以使用 `-d` 命令指定特定分隔符（macOS 貌似不支持该选项）。  

xargs 和 find 算是一对死党，两者结合使用可以让任务变得更轻松。

#### tricks

无法通过 xargs 传递数值做正确的算术扩展：

```
$ echo 1 | xargs -I "x" echo $((2*x))
```

这时只能改变方法或寻找一些小技巧，例如：

```
$ echo 1 | xargs -I {} expr 2 \* {}
```

---

默认情况下，xargs 每次只能传递一条分割的数据到命令行中作为参数。但有时候想要让 xargs 一次传递2个或2个以上参数到命令行中。如何实现呢？

例如有一个文件保存了 wget 想要下载的大量链接和对应要保存的文件名，一行链接一行文件名。格式如下：

```
https://www.xxx.yyy/a1
filename1
https://www.xxx.yyy/a2
filename2
https://www.xxx.yyy/a3
filename3
```

现在想要通过读取这个文件，将每一个URL和对应的文件名传递给wget去下载：

```
$ wget '{URL}' -O '{FILENAME}'
```

xargs 自身的功能无法一次性传递多个参数（parallel命令可以，而且方式多种），只能寻求一些技巧来实现。

```
cat url.txt | xargs -n 2 bash -c 'wget "$1" -O "$2"'
```

### refs

关于 xargs 的用法，可以参考 《Linux Shell 脚本攻略》中的 `2.5 玩转 xargs` 相关章节。

[xargs 命令教程](http://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)  
[xargs 命令详解](https://www.cnblogs.com/wangqiguo/p/6464234.html)  
[Xargs 用法详解](https://blog.csdn.net/zhangfn2011/article/details/6776925)  
[xargs 原理剖析及用法详解](https://www.cnblogs.com/f-ck-need-u/p/5925923.html)  
