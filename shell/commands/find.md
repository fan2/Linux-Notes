## help/usage

执行 `man find` 可查看 find 命令帮助手册。

find 命令的工作方式如下：沿着文件层次结构向下遍历，匹配查找符合条件的文件（夹），执行相应的操作。

```
find path [options] [expression]
```

## options

### -type

按照文件类型查找文件。

find . 

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

### -name

按照文件名查找文件。

#### case-insensitive

`-iname`：匹配名字时会忽略大小写。

#### inverse

`!` 可执行反向匹配，查找所有不是以 `.c` 结尾的文件：

```
find . \! -name "*.c" -print
```

#### or

如果想匹配多个条件中的一个，可以采用 OR 条件操作：

```
$ ls
new.txt some.jpg text.pdf 
$ find . \( -name "*.txt" -o -name "*.pdf" \) -print
./text.pdf
./new.txt
```

上面的代码会打印出所有的 .txt 和 .pdf 文件，因为这个find命令能够匹配所有这两类文件。

> `\(` 以及 `\)` 用于将 `-name "*.txt" -o -name "*.pdf` 视为一个整体。

### -path

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

### -user

按照文件属主来查找文件，查找属于该用户的所有文件。

```
find / -user $USER_ACCOUNT > $REPORT_FILE
```

### -depth

在查找文件时，首先查找当前目录中的文件，然后再在其子目录中查找。

### maxdepth/mindepth

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
这个选项可以 用来查找并打印那些距离起始路径一定深度的所有文件。
例如，打印出深度距离当前目录至少两个子目录的所有文件：

```
$ find . -mindepth 2 -name "f*" -print
```

### -prune

使用 `-prune` 选项可以使 find 命令不在当前指定的目录中查找。
如果同时使用了 `-depth` 选项，那么 `-prune` 选项将被find命令忽略。

在搜索目录并执行某些操作时，有时为了提高性能，需要跳过一些子目录。
以下命令打印出不包括在 `.git` 目录中的所有文件的名称（路径）。

```
find devel/source_path \( -name ".git" -prune \) -o \( -type f -print \)
```

### operation

find 命令默认对匹配结果执行打印（`-print`）操作，`\n` 作为用于对输出的文件名进行分隔。

> `-print0` 指明使用 `\0` 作为匹配的文件名之间的分隔符。当文件名中包含换行符时，这个方法就有用武之地了。

`-delete` 则可以用来删除 find 查找到的匹配文件。

### -exec

find 命令可以借助选项 `-exec` 与其他命名进行结合，执行命令或动作。

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

有时候我们并不希望对每个文件都执行一次命令，更希望使用文件列表作为命令参数，这样就可以少运行几次命令了。  
如果是这样，可以在 exec 中使用 `+` 来代替 `;`。

---

以下将 find 结果执行 `echo` 打印：

```
find . -type f -exec echo {} \;
```

删除 `/usr/ports/packages` 目录下所有的软链（源文件）：

```
find -L /usr/ports/packages -type l -exec rm -- {} +
```

可以用 find 找到所有的C文件，然后使用 cat 命令拼接起来写入单个文件 all_c_files.txt：

```
$ find . -type f -name "*.c" -exec cat {} \;>all_c_files.txt
```

使用 `>` 操作符将来自 find 的数据重定向到 all_c_files.txt 文件，没有使用 `>>`（追加）的原因
是因为 find 命令的全部输出就只有一个数据流（stdin），而只有当多个数据流被追加到单个文件中时才有必要使用 `>>`。

也可借助 ls-grep 等效实现：

```
ls -R | grep '.*\.c$' | xargs cat > all_c_files.txt
```

查找当前目录中的所有名为 `DerivedData` 的文件夹，并执行 `du -hs` 输出大小。

```
find . -type d -name DerivedData -exec du -hs {} \;
```

排除 `./ten/iqq` 目录：

```
find . \( -name ./ten/iqq -prune \) -o \( -type d -name DerivedData \) -exec du -hs {} \;
```

## delete file

递归查找当前目录及其子目录下所有的 `.o`/`.DS_Store` 文件，然后执行 `-delete` 删除操作。

```Shell
find . -name "*.o" -delete
find . -type f -name ".DS_Store" -delete
```

> 默认执行 `-print` 打印查找结果；  
> 可显式指定 `-type f` 只查找文件类型；  

除此之外，还可针对结果执行 `-exec rm` 或重定向作为 `rm` 的参数：

```
find . -name ".DS_Store" -exec rm {} \;
find . -name ".DS_Store" | xargs rm
```

## delete folder

查找当前目录及其子目录下所有的 `.svn`（`__MACOSX`） 目录，然后通过管道 xargs 作为参数传递给 `rm -rf` 执行删除。

```Shell
find . -type d -name ".svn" -exec rm -rf {} \;
find . -type d -name ".svn" | xargs rm -rf

find . -type d -name "__MACOSX" -exec rm -rf {} \;
find . -type d -name "__MACOSX" | xargs rm -rf
```
