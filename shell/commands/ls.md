## [ls](http://man7.org/linux/man-pages/man1/ls.1.html)

ls - list directory contents

默认按文件名排序。

### options

#### -1

`-1`: 每一项单行列出（list one file per line），便于按列统计或列选拷贝等操作。

```
     -1      (The numeric digit ``one''.)  Force output to be one entry per line.  This is
             the default when output is not to a terminal.
```

当输出不是控制台（stdout）时，默认就是单行列出，例如 `ls > ls-out.txt`。

#### -l

`-l`: 显示长列表（long listing format），每一项单行列出，显示包括文件的读写权限、所有者及日期等属性信息。

```
     -l      (The lowercase letter ``ell''.)  List in long format.  (See below.)  A total
             sum for all the file sizes is output on a line before the long listing.
```

#### all

`-a`: 显示所有文件（all），包括 `.`、`..` 和 `.git`、`.svn`、`.DS_Store` 等隐藏文件。  
`-A`: 显示几乎所有文件（almost-all），包括 `.git`、`.svn`、`.DS_Store` 等隐藏文件，但不显示 `.` 和 `..`。  

```
     -A      List all entries except for . and ...  Always set for the super-user.
     -a      Include directory entries whose names begin with a dot (.).
```

---

`-d`: 查看当前目录本身的信息，不列举目录内的文件数据。

```
-d      Directories are listed as plain files (not searched recursively).
```

`ls -ld`: 列举显示当前目录（文件夹）(`.`)的属性信息。  

---

`-F`: append indicator (one of `*/=>@|`) to entries for classify.

将在目录后面追加 `/`，在可执行文件后面追加 `*`，在软链后面追加 `@` 等特殊符号，区分普通文件。

```
     -F      Display a slash (`/') immediately after each pathname that is a directory, an
             asterisk (`*') after each that is executable, an at sign (`@') after each
             symbolic link, an equals sign (`=') after each socket, a percent sign (`%')
             after each whiteout, and a vertical bar (`|') after each that is a FIFO.
```

---

`ls -lR`：递归列举当前及所有子文件夹。

```
     -R      Recursively list subdirectories encountered.
```

#### size & sort

`-h`: 以 KB、MB、GB 等易读方式显示文件大小（human-readable size）。

```
     -h      When used with the -l option, use unit suffixes: Byte, Kilobyte, Megabyte,
             Gigabyte, Terabyte and Petabyte in order to reduce the number of digits to
             three or less using base 2 for sizes.
```

ls 默认按文件名排序，可以 `-S` 指定按文件大小降序排列，或 `-Sr` 按照文件大小升序排列。

```
     -r      Reverse the order of the sort to get reverse lexicographical order or the
             oldest entries first (or largest files last, if combined with sort by size

     -S      Sort files by size
```

`ls -lS`：按大小（**降序**）列出文件和文件夹详细信息。  
`ls -lSr`：按大小**升序**列出文件和文件夹详细信息。  

---

`-t`：通过最后修改时间排序。

```
     -t      Sort by time modified (most recently modified first) before sorting the oper-
             ands by lexicographical order.
```

`ls -lt`：按修改时间（**降序**）列出文件和文件夹详细信息。  
`ls -ltr`：按修改时间**升序**列出文件和文件夹详细信息。  

#### 常用组合

最常用组合：`ls -lhF`

- `ls -lhFA`：显示隐藏文件（夹）；  
- `ls -lhFSr`：按文件大小升序排列；  
- `ls -lhFtr`：按修改时间升序排列；  

ls 递归列举当前目录下的文件，然后按照文件名匹配过滤出部分文件予以删除：

```
rm $(ls -AR | grep -e .DS_Store -e AVEngine.log -e *_WTLOGIN.*.log)
```

### ls only file/dir

- `ls -d */`：通配符语法  
- `ls -l | grep '^d'`：grep 正则表达式，过滤出以 d 开头的**文件夹**  
- `ls -al | grep '^[^d]'`：grep 正则表达式，过滤出非 d 开头的**文件**  

其他命令：

- `find . -maxdepth 1 -type d`  
- `tree -d -L 1`  

> [Listing only directories in UNIX](https://stackoverflow.com/questions/3667329/listing-only-directories-in-unix)  
> [ls to view directories only](https://www.linuxquestions.org/questions/linux-newbie-8/ls-to-view-directories-only-156254/)  
> [List Directories in Unix and Linux Systems](https://www.cyberciti.biz/faq/linux-list-just-directories-or-directory-names/list-dirs-in-unix-linux/)  
> [first two results from ls command](https://stackoverflow.com/questions/10520120/first-two-results-from-ls-command)  

### file count

[Counting files in a directory from the terminal](http://hints.macworld.com/article.php?story=20010508182132282)  

```Shell
# （递归）统计当前目录下(.)文件夹数量
## 比 ls -lR | grep '^d' 多1个
$ find . -type d -print | wc -l
       7

# （递归）统计当前目录下(.)文件数量
## 等效于 ls -lR | grep -c '^-'
$ find . -type f -print | wc -l
       93
```

### file size

[How to Get the Size of a Directory in Linux](https://linuxize.com/post/how-get-size-of-file-directory-linux/)  
[How To Find The Size Of A Directory In Linux](https://www.ostechnix.com/find-size-directory-linux/)  
[How to Get the Size of a Directory from Command Line](http://osxdaily.com/2017/03/09/get-size-directory-command-line/)  
[How do I get the size of a directory on the command line?](https://unix.stackexchange.com/questions/185764/how-do-i-get-the-size-of-a-directory-on-the-command-line)  
[3 Simple Ways to Get the Size of Directories in Linux](https://www.2daygeek.com/how-to-get-find-size-of-directory-folder-linux/)  

`du` command (Disk Usage) and `df` (Disk FileSystem) command.

进入指定文件夹执行 `du -sh`

Use the below du command format to get the total size of a given directory.

```
$ du -hs /home/daygeek/Documents
or
$ du -h --max-depth=0 /home/daygeek/Documents/

$ du -sh ~/Library/Developer
107G	/Users/faner/Library/Developer
```

get the total size of each directory, including sub-directories.

```
du -hc /home/daygeek/Documents/ | sort -rh | head -20

~/Library/Developer $ du -hc | sort -rh | head -20
107G	total
107G	.
 89G	./Xcode
 87G	./Xcode/iOS DeviceSupport
 14G	./CoreSimulator
8.8G	./CoreSimulator/Devices
5.7G	./CoreSimulator/Caches/dyld/19F62f
5.7G	./CoreSimulator/Caches/dyld
5.7G	./CoreSimulator/Caches
3.2G	./Xcode/iOS DeviceSupport/13.4.5 (17F5044d) arm64e/Symbols
3.2G	./Xcode/iOS DeviceSupport/13.4.5 (17F5044d) arm64e
3.2G	./Xcode/iOS DeviceSupport/13.4 (17E5255a) arm64e/Symbols
3.2G	./Xcode/iOS DeviceSupport/13.4 (17E5255a) arm64e
3.2G	./Xcode/iOS DeviceSupport/13.4 (17E5233g) arm64e/Symbols
3.2G	./Xcode/iOS DeviceSupport/13.4 (17E5233g) arm64e
3.1G	./Xcode/iOS DeviceSupport/13.4 (17E5223h) arm64e/Symbols
3.1G	./Xcode/iOS DeviceSupport/13.4 (17E5223h) arm64e
3.1G	./Xcode/iOS DeviceSupport/13.4 (17E255) arm64e/Symbols
3.1G	./Xcode/iOS DeviceSupport/13.4 (17E255) arm64e
3.0G	./Xcode/iOS DeviceSupport/13.4.5 (17F5044d) arm64e/Symbols/System/Library
```

> The above command will print the size of each file and the actual size of each directory, including their subdirectory and total size.

If you want to get the size of the first-level sub-directories, including their sub-directories, for a given directory on Linux, use the du command format below.

```
$ du -shc /home/daygeek/Documents/*
$ du -h --max-depth=1 /home/daygeek/Documents/
```

The `tree` command is a recursive directory listing program that produces a depth indented listing of files and directories in a tree-like format.

```
tree --du -h /opt/ktube-media-downloader
```

### cat

假如当前目录下有几个日志文件，并且是按照时间和大小排序的：

```
Logs $ ls
1001-10K.log 1003-20K.log 1004-30K.log 1006-40K.log 1007-50K.log 1009-60K.log 1010-70K.log
Logs $ ls -1
1001-10K.log
1003-20K.log
1004-30K.log
1006-40K.log
1007-50K.log
1009-60K.log
1010-70K.log
```

可将所有文件（名）作为 cat 的列表参数，将它们拼接成一个大的日志进行综合分析：

```
Logs $ ls | xargs cat > ../1001-1010-10K_70K.log
```

> 如果要从多层目录中筛检文件，需要 `ls -R | grep ` 或借助 `find` 命令。
