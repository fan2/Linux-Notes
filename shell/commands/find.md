
unix/POSIX - [find](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html)  
FreeBSD/Darwin - [find](https://www.freebsd.org/cgi/man.cgi?query=find)  

linux - [find(1)](http://man7.org/linux/man-pages/man1/find.1.html) & [find(1p)](http://man7.org/linux/man-pages/man1/find.1p.html)  
debian/Ubuntu - [find](https://manpages.debian.org/buster/findutils/find.1.en.html)  

## help/usage

执行 `man find` 可查看 find 命令帮助手册。

```
FIND(1)			FreeBSD	General	Commands Manual		       FIND(1)

NAME
     find -- walk a file hierarchy

SYNOPSIS
     find [-H |	-L | -P] [-EXdsx] [-f path] path ... [expression]
     find [-H |	-L | -P] [-EXdsx] -f path [path	...] [expression]

DESCRIPTION
     The find utility recursively descends the directory tree for each path
     listed, evaluating	an expression (composed	of the "primaries" and
     "operands"	listed below) in terms of each file in the tree.
```

find 命令的工作方式如下：沿着文件层次结构向下遍历，匹配查找符合条件的文件（夹），执行相应的操作。

```
find path [options] [expression]
```

## options

### -name

按照文件名查找文件。

通配查找当前目录下的所有txt文件：

```
$ find . -name *.txt
find: data.txt: unknown primary or operator
```

**注意**：通配符需要转义，或者将 `-name` 参数用引号包起来：

```
find . -name \*.txt
find . -name '*.txt'
find . -name "*.txt"
```

#### case-insensitive

`-iname`：匹配名字时会忽略大小写。

大部分操作系统中，文件名中不区分大小写，`file.txt` 和 `FILE.txt` 表示同一个文件；`file.txt` 和 `file.TXT` 也表示同一个文件。

因此在执行相关 find 查找时，比如统计C语言程序代码文件，其后缀可能为 `*.c` 或 `*.C`。此时，`-iname` 比 `-name` 更实用。

#### inverse

`!` 可执行反向匹配，查找所有不是以 `.c` 结尾的文件：

```
$ find . \! -iname "*.c" -print
```

#### or

如果想匹配多个条件中的一个，可以采用 OR（`-o`） 条件操作：

```
$ ls
new.txt some.jpg text.pdf 
$ find . \( -iname "*.txt" -o -iname "*.pdf" \) -print
./text.pdf
./new.txt
./hello world.txt
```

上面的代码会打印出所有的 .txt 和 .pdf 文件，因为这个find命令能够匹配所有这两类文件。

> `\(` 以及 `\)` 用于将 `-name "*.txt" -o -name "*.pdf` 视为一个整体。

### -type

`-type ` 选项支持按照文件类型查找文件。

```
     -type t
             True if the file is of the specified type.  Possible file types are as follows:

             b       block special
             c       character special
             d       directory
             f       regular file
             l       symbolic link
             p       FIFO
             s       socket
```

当未指定 `-type ` 选项时，默认查找所有文件类型，包括文件夹、文件和软链等。

查找名为 `OfflineFile` 的文件夹：

```
$ find . -type d -name 'OfflineFile'
```

查找名为 `libOfflineFile.a` 的文件：

```
$ find . -type f -name 'libOfflineFile.a'
```

统计 `OfflineFile` 文件夹下所有参与编译的文件（Compile Sources）数量：

```
$ find OfflineFile -type f \( -iname "*.c" -o -iname "*.cpp" -o -iname "*.m" -o -iname "*.mm" \) | wc -l
     273
```

#### or

注意，`-type ` 选项不支持同时指定多种类型，可逐个类型查找。

查找项目工程中的文件 `JceObjectV2.h`：

```
$ find . -type f -name 'JceObjectV2.h'
./Classes/module/WaterMarkCamera/3rd/WirelessUnifiedProtocol/Serializable/JceObjectV2.h
./Classes/extern/Analytics/BuglyOA/BuglyCocoa/BuglyCocoa/JceProtocol/CocoaJce/JceObjectV2.h
./Pods/CocoaJCE/Include/JceObjectV2.h
```

查找项目工程中的软链 `JceObjectV2.h`：

```
$ find . -type l -name 'JceObjectV2.h'
./Pods/Headers/Public/CocoaJCE/JceObjectV2.h
./Pods/Headers/Private/CocoaJCE/JceObjectV2.h
```

当然，也可以用 `-o` 指定并列的 `-type ` 类型约束：

```
$ find . -name 'JceObjectV2.h' \( -type f -o -type l \)
./Classes/module/WaterMarkCamera/3rd/WirelessUnifiedProtocol/Serializable/JceObjectV2.h
./Classes/extern/Analytics/BuglyOA/BuglyCocoa/BuglyCocoa/JceProtocol/CocoaJce/JceObjectV2.h
./Pods/Headers/Public/CocoaJCE/JceObjectV2.h
./Pods/Headers/Private/CocoaJCE/JceObjectV2.h
./Pods/CocoaJCE/Include/JceObjectV2.h
```

如果 `JceObjectV2.h` 很明确是头文件（或软链替身），不可能为文件夹的话，也可不指定 `-type ` 选项，查找项目工程中的所有名为 `JceObjectV2.h` 的文件：

```
$ find . -name 'JceObjectV2.h'
```

### operation

find 命令默认对匹配结果执行打印（`-print`）操作，以 `\n` 作为分割符对输出的文件名进行分隔。

> `-print0` 指明使用 `\0` 作为匹配的文件名之间的分割符。当文件名中包含空格符或换行符时，这个方法就有用武之地了。

`-delete` 则可以用来删除 find 查找到的匹配文件。

### 其他选项

#### -path

```
     -path pattern
             True if the pathname being examined matches pattern.  Special shell pattern matching charac-
             ters (``['', ``]'', ``*'', and ``?'') may be used as part of pattern.  These characters may
             be matched explicitly by escaping them with a backslash (``\'').  Slashes (``/'') are treated
             as normal characters and do not have to be matched explicitly.
```

选项 `-path` 的参数可以使用通配符来匹配文件路径。  
`-name` 总是用给定的文件名进行匹配，`-path` 则将文件路径作为一个整体进行匹配。例如：

```
$ find /home/users -path "*/slynux/*" -print
```

可以匹配以下路径：

```
/home/users/list/slynux.txt
/home/users/slynux/eg.css
```

#### -user

按照文件属主来查找文件，查找属于该用户的所有文件。

```
$ find / -user $USER_ACCOUNT > $REPORT_FILE
```

#### -depth

在查找文件时，首先查找当前目录中的文件，然后再在其子目录中查找。

##### maxdepth/mindepth

find 命令在使用时会遍历所有的子目录。
大多数情况下，只需要在当前目录中进行搜索，无须再继续向下查找。

可以采用深度选项 `-maxdepth` 和 `-mindepth` 来限制 find 命令向下遍历查找的目录深度。

- 如果只允许 find 在当前目录中查找，深度可以设置为1；  
- 当需要向下两级时，深度可以设置为2；其他情况可以依次类推。  

可以用 `-maxdepth` 指定最大深度。与此相似，我们也可以指定一个最小的深度，告诉 find 应该从此处开始向下查找。  
如果我们想从第二级目录开始搜索，那么就使用 `-mindepth` 设置最小深度。使用下列命令将 find 命令向下的最大深度限制为1：

```
$ find . -maxdepth 1 -name "f*" -print
```

该命令列出当前目录下的所有文件名以 f 打头的文件。即使有子目录，也不会被打印或遍历。  
与之类似，`-maxdepth 2` 最多向下遍历两级子目录。

`-mindepth` 类似于 `-maxdepth`，不过它设置的是find开始遍历的最小深度。  
这个选项可以用来查找并打印那些距离起始路径一定深度的所有文件。  
例如，打印出深度距离当前目录至少两个子目录的所有文件：

```
$ find . -mindepth 2 -name "f*" -print
```

#### -prune

使用 `-prune` 选项可以使 find 命令不在当前指定的目录中查找。
如果同时使用了 `-depth` 选项，那么 `-prune` 选项将被find命令忽略。

在搜索目录并执行某些操作时，有时为了提高性能，需要跳过一些子目录。
以下命令打印出不包括在 `.git` 目录中的所有文件的名称（路径）。

```
$ find devel/source_path \( -name ".git" -prune \) -o \( -type f -print \)
```

## utility

### -exec

find 有一个选项 `-exec`，支持对每个find查找到的文件执行命令。

```
     -exec utility [argument ...] ;
             True if the program named utility returns a zero value as its exit status.  Optional
             arguments may be passed to the utility.  The expression must be terminated by a semicolon
             (``;'').  If you invoke find from a shell you may need to quote the semicolon if the shell
             would otherwise treat it as a control operator.  If the string ``{}'' appears anywhere in the
             utility name or the arguments it is replaced by the pathname of the current file.  Utility
             will be executed from the directory from which find was executed.  Utility and arguments are
             not subject to the further expansion of shell patterns and constructs.

     -exec utility [argument ...] {} +
             Same as -exec, except that ``{}'' is replaced with as many pathnames as possible for each
             invocation of utility.  This behaviour is similar to that of xargs(1).
```

> `{}` 表示一个匹配，对于任何匹配的文件名，`{}` 均会被该文件名所替换。

以下将 find 结果执行 `echo` 打印：

```
$ find . -type f -exec echo {} \;
```

为什么分号（`;`）需要转义呢？
因为 Bash Shell 中使用空格或分号（**`;`**）连接无相关性的连续命令，即分号本身是一个 control operator。  
如果不转义的话，将会报错：

```
$ find . -type f -exec echo {} ;
find: -exec: no terminating ";" or "+"
```

查找当前目录中的所有名为 `DerivedData` 的文件夹，并执行 `du -hs` 统计输出各个文件夹的磁盘占用大小。

```
$ find . -type d -name DerivedData -exec du -hs {} \;
385M	./Classes/base/QQBaseUtil/DerivedData
 22M	./Frameworks/WX/PublicProtocolFiles/DerivedData
 17G	./DerivedData
```

排除 `./ten/mars` 目录：

```
$ find . \( -name ./ten/mars -prune \) -o \( -type d -name DerivedData \) -exec du -hs {} \;
```

以下示例查找 `OfflineFile` 目录下所有的 cpp 文件，并将查找到的文件名存储到 `all_cpp_files.txt` 中。

```
$ find OfflineFile -type f -iname "*.cpp" > all_cpp_files.txt
```

这里使用 `>` 操作符将来自 find 的数据（CPP代码）重定向到 all_cpp_codes.cpp 文件，没有使用 `>>`（追加）的原因
是因为 find 命令的全部输出就只有一个数据流（stdin），而只有当多个数据流被追加到单个文件中时才有必要使用 `>>`。

若要将查找到的所有cpp文件拼接写入一个文件 `all_cpp_codes.cpp`，则可借助 `-exec cat` 打开查看文件内容并重定向实现拼接：

```
$ find OfflineFile -type f -iname "*.cpp" -exec cat {} \;>all_cpp_codes.cpp
```

下面对查找到的所有文件名为 `JceObjectV2.h` 的文件（包括软链替身），进一步执行 `ls -F` 列举打印各文件属性，以便区分哪些是文件哪些是软链：

```
$ find . -name 'JceObjectV2.h' \( -type f -o -type l \) -exec ls -F {} \;
./Classes/extern/Analytics/BuglyOA/BuglyCocoa/BuglyCocoa/JceProtocol/CocoaJce/JceObjectV2.h*
./Classes/module/WaterMarkCamera/3rd/WirelessUnifiedProtocol/Serializable/JceObjectV2.h*
./Pods/CocoaJCE/Include/JceObjectV2.h*
./Pods/Headers/Private/CocoaJCE/JceObjectV2.h@
./Pods/Headers/Public/CocoaJCE/JceObjectV2.h@
```

#### +

有时候并不希望对每个文件都执行一次命令，而是希望使用文件列表作为命令参数，这样就可以少运行几次命令了。  
此种场景下，可以在 exec 中使用 `+` 来代替 `;` 达到预期效果。

以下示例将删除 `/usr/ports/packages` 目录下所有的软链（源文件）：

```
$ find -L /usr/ports/packages -type l -exec rm -- {} +
```

### xargs

xargs 和 find 算是一对好基友，两者结合使用可以让任务变得更轻松。  
很多 `find -exec` 的操作，都可以改为基于 `find | xargs` 的等效表达实现。  

上述查找当前目录中的所有名为 `DerivedData` 的文件夹并执行 `du -hs` 输出大小的示例，也可改为基于 xargs 的等效实现。

```
$ find . -type d -name DerivedData | xargs du -hs
```

上面查找拼接 all_cpp_codes 示例，也可借助 ls-grep 及 xargs 等效实现：

```
# 需要先 cd 到 OfflineFile 目录
$ ls -R | grep '.*\.cpp$' | xargs cat > all_cpp_codes.cpp
# or
$ find OfflineFile -type f -iname "*.cpp" | xargs cat > all_cpp_codes.cpp
```

查找文件 `JceObjectV2.h` 并执行 `ls -F` 列举文件类型的 xargs 等效实现如下：

```
$ find . -name 'JceObjectV2.h' \( -type f -o -type l \) | xargs ls -F
```

上面统计过 `OfflineFile` 文件夹下所有参与编译的文件（Compile Sources）数量。
进一步思考，如何统计该子工程目录下所有参与编译的代码文件的代码行数呢？
借助 `xargs` 对每个文件执行 `wc -l` 行数统计即可。

```
$ find OfflineFile -type f \( -iname "*.c" -o -iname "*.cpp" -o -iname "*.m" -o -iname "*.mm" \) -print0 | xargs -0 wc -l

   98021 total
```

当然，以上统计代码行数，包括了注释和空行部分，更专业的统计工具参考 [SLOCCount](https://dwheeler.com/sloccount/) 和 [cloc](https://github.com/AlDanial/cloc/)。

#### -t

xargs 的 `-t` 选项允许每次执行 xargs 后面的命令之前，先在 stderr 上打印出扩展开的真实命令。

```
$ find . -type d -iname "xcuserdata" | xargs -t rm -rf
rm -rf ./EmptyApplication.xcodeproj/xcuserdata ./EmptyApplication.xcodeproj/project.xcworkspace/xcuserdata
```

### demos

#### delete file

递归查找当前目录及其子目录下所有的 `.o`/`.DS_Store` 文件，然后执行 `-delete` 删除操作。

```
$ find . -name "*.o" -delete
$ find . -type f -name ".DS_Store" -delete
```

> 默认执行 `-print` 打印查找结果；  
> 可显式指定 `-type f` 只查找文件类型；  

还可针对结果执行 `-exec rm` 或重定向给 xargs 作为参数执行 `rm` 命令。
以下示例清除 macOS 文件夹下自动生成的 `.DS_Store` 文件：

```
$ # find . -name ".DS_Store" -exec rm {} \;
$ find . -name ".DS_Store" | xargs rm
```

以下示例清除 visual studio 工程 sln/vcproj 下的 `*.user` 文件：

```
# delete file: *.user
echo "delete files: *.user"
#find . -name "*.user" -delete
#find . -name "*.user" -exec rm {} \;
find . -name "*.user" | xargs rm -f
```

##### xargs 安全分割

xargs 默认是以空白字元作为分割符，如果有一些档名或者是其他意义的名词内含有空白字元的时候，xargs 可能会误判分割导致参数错误。

我们没法预测分隔 find 命令输出结果的定界符究竟是什么（`\n` 或者空格）。
很多文件名中都可能会包含空格符（' '），因此 xargs 很可能会误认为它们是定界符。
例如，`hello world.txt` 会被 xargs 误解为 hello 和 world.txt。

当前目录下有3个文件，其中 `hello world.txt` 文件名包含空格：

```
$ ls -1
hello
hello world.txt
world.TXT

$ tree -L 1
.
├── hello
├── hello\ world.txt
└── world.TXT
```

将 ls 结果重定向给 xargs 进行 echo 回显，指定 `-n 1` 每次取1个参数：

```
$ ls | xargs -n 1
hello
hello
world.txt
world.TXT
```

可见，第2个文件名包含空格的 `hello world.txt` 文件被空格错误地分割为两个文件。
为 xargs 添加 `-0` 参数，指定 NUL（`\0`）作为分割符，则输出符合预期。

```
$ ls | xargs -0 -n 1
hello
hello world.txt
world.TXT
```

---

上述删除示例中，把 find 的输出作为 xargs 的输入，可对 find 指定 `-print0` 替换默认的 `-print`。
同时，`xargs -0` 与 `find -print0` 结合使用，以字符 NUL（`\0`）来分割输出。
这样就可以安全删除所有的 .txt 文件了。

```
$ find . -type f -name "*.txt" -print0 | xargs -0 rm -f
```

> 由于 find 命令默认以 `\n` 作为分割符对输出的文件名进行分隔，且 macOS 不支持 `-d delim` 选项，故该示例一般不用顾虑该问题？

#### delete folder

查找当前目录及其子目录下所有的 `.svn` 目录，然后通过管道 xargs 作为参数传递给 `rm -rf` 执行删除。

```
$ # find . -type d -name ".svn" -exec rm -rf {} \;
$ find . -type d -name ".svn" | xargs rm -rf
```

以下示例清除 macOS 文件夹下自动生成的 `__MACOSX` 文件夹：

```
$ # find . -type d -name "__MACOSX" -exec rm -rf {} \;
$ find . -type d -name "__MACOSX" | xargs rm -rf
```

以下示例清除 visual studio 工程 sln/vcproj 下编译生成的 `Debug` 文件夹：

```
# delete folder: Debug
echo "delete folder: Debug"
#find . -type d -iname "debug" -exec rm -rf {} \;
find . -type d -iname "debug" | xargs rm -rf
```

以下示例清除 xcodeproj 目录下的 `xcuserdata` 文件夹：

```
# delete folder: xcuserdata
echo "delete folder: xcuserdata"
#find . -type d -iname "xcuserdata" -exec rm -rf {} \;
find . -type d -iname "xcuserdata" | xargs rm -rf
```

以下示例清除 python 运行过程中生成的 `__pycache__` 文件夹：

```
# delete folder: __pycache__
echo "delete folder: __pycache__"
#find . -type d -iname "__pycache__" -exec rm -rf {} \;
find . -type d -iname "__pycache__" | xargs rm -rf
```

> 一般 git 仓库的 `.gitignore` 会配置忽略以上临时目录

#### copy files

以下示例，进入Xcode工程的构建目录，查找所有文件夹下的 `.d` 依赖文件，然后将全部文件拷贝到 `~/Downloads/dependencies` 目录下。

基于while循环的子shell的表达实现如下：

```
$ cd DerivedData/Mars/Build/Intermediates.noindex
$ find . -type f -name "*.d" | (while read arg; do cp -v $arg ~/Downloads/dependencies; done)
```

实际运行展开如下：

```
cp -v file1.d ~/Downloads/dependencies
cp -v file2.d ~/Downloads/dependencies
...
```

到目前为止的 utility 用例场景，都是直接为特定的命令（例如 echo,cat,du,ls,rm）提供命令行参数，这些参数都直接源于 stdin，只是借助重定向 xargs 实现管接。

但在本案例中，cp 命令的拷贝目标文件夹（`target_directory`）是固定不变的，拷贝源参（`source_file`）则需要 find | xargs 提供。

此时需要借助 `-I` 选项：

```
     -I	replstr
	     Execute utility for each input line, replacing one	or more	occur-
	     rences of replstr in up to	replacements (or 5 if no -R flag is
	     specified)	arguments to utility with the entire line of input.
```

`-I` 选项指定替换字符串为 `replstr`，将从 stdin 读取到的参数，替换掉 utility 命令中的占位参数（placeholder） `replstr`。

基于 xargs 的更加简洁高效的等效表达如下：

```
# replstr = {}
$ find . -type f -name "*.d" | xargs -I {} cp -v {} ~/Downloads/dependencies
```

使用 `-I` 的时候，命令以循环的方式执行。如果有3个参数（即 find 出了3个.d文件），那么命令就会连同 `{}` 一起被执行3次。  
在每一次的 cp 命令执行中，source_file 参数占位符 `{}` 都会被替换为相应的参数作为拷贝源。

---

为方便调试及理解，可以给 xargs 带上 `-t` 选项，查看循环执行的cp命令展开。  
再加上 cp 附加了 `-v` 选项，可以看到其执行结果。  
这样，命令行执行输出就更明了了：

```
# replstr = srcd
$ find . -type f -name "*.d" | xargs -t -I srcd cp -v srcd ~/Downloads/dependencies
cp -v ./cDACoreOperateCallBack.d /Users/faner/Downloads/dependencies
./cDACoreOperateCallBack.d -> /Users/faner/Downloads/dependencies/cDACoreOperateCallBack.d
cp -v ./cDACoreListenerCallBack.d /Users/faner/Downloads/dependencies
./cDACoreListenerCallBack.d -> /Users/faner/Downloads/dependencies/cDACoreListenerCallBack.d
...
```

> 思考：xargs 如何一次性传递多个参数给后面的 utility 命令呢？这涉及到 `xargs -n` 分段划批和 Bash Shell 命令参数列表。

#### edit files

经常需要将某个目录中的所有文件内的一部分文本替换成另一部分，例如在网站的源文件目录中替换一个URI。
解决这个问题最快的方法就是利用shell脚本。

场景：遍历项目目录下的所有.cpp文件，并将每个.cpp文件中的 Copyright 替换成 Copyleft。

可以使用find命令的 `-exec` 选项执行 sed 命令对每个查找到的文件执行查找替换：

```
# 为每个查找到的文件调用一次sed
$ find . -name "*.cpp" -exec sed -i '' 's/Copyright/Copyleft/g' {} \;
# 或者将多个文件名一并传递给sed
$ find . -name "*.cpp" -exec sed -i '' 's/Copyright/Copyleft/g' {} \+
```

当然，也可以对find结果重定向给 ` | xargs -I{}` 作为参数调用 sed 编辑替换：

```
$ find . -name "*.cpp" -print0 | xargs -I{} -0 sed -i '' 's/Copyright/Copyleft/g' {}
```

思考：如果头部没有包含 Copyright 或 Copyleft，如何在头部补插一条标准的版权声明呢？

```
$ find . -name "*.cpp" -print0 | xargs -I file -0 sed -i '' '1i\
// Tencent is pleased to support the open source community by making Mars available.\
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.\

' file
```
