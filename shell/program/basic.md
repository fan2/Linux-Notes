
## 使用多个命令

shell可以让你将多个命令串起来，一次执行完成。如果要两个命令一起运行，可以把它们放在同一行中，彼此间用分号（`;`）隔开。

```
[] ~ date
Mon Dec  9 22:39:22 CST 2019
[] ~ who
faner    console  Nov 29 07:00
faner    ttys000  Dec  7 07:48
faner    ttys002  Dec  7 07:48
faner    ttys004  Dec  8 07:02
faner    ttys006  Dec  9 22:39
```

写到一行执行：

```
[] ~ date ; who
Mon Dec  9 22:39:40 CST 2019
faner    console  Nov 29 07:00
faner    ttys000  Dec  7 07:48
faner    ttys002  Dec  7 07:48
faner    ttys004  Dec  8 07:02
faner    ttys006  Dec  9 22:39
```

使用这种办法就能将任意多个命令串连在一起使用了，只要不超过最大命令行字符数255就行。

这种技术对于小型脚本尚可，但它有一个很大的缺陷：每次运行之前，你都必须在命令提示符下输入整个命令。
可以将这些命令组合成一个简单的文本文件，这样就不需要在命令行中手动输入了。
在需要运行这些命令时，只用运行这个文本文件就行了。

## 创建 shell 脚本文件

在创建shell脚本文件时，必须在文件的第一行指定要使用的shell。其格式为：

```
#!/bin/bash

```

在通常的shell脚本中，井号（`#`）用作注释行。shell并不会处理shell脚本中的注释行。
然而，shell脚本文件的第一行是个例外，`#` 后面的惊叹号会告诉shell用哪个shell来运行脚本。
是的，你可以指定 bash 之外的其他 shell 来运行你的脚本。

```Shell
#!/bin/bash
# This script displays the date and who's logged on
date
who
```

可以根据需要，使用分号将两个命令放在一行上，但在shell脚本中，你可以在独立的行中书写命令。
shell 会按根据命令在文件中出现的顺序进行处理。

### 执行权限

```
$ ./test1
bash: ./test1: Permission denied
```

快速查看一下文件权限就能找到问题所在：

```
$ ls -l test1
-rw-rw-r-- 1 user   user    73 Sep 24 19:56 test1
```

执行 `chmod u+x test1` 可添加执行权限。

### 命令行参数

1. `$#`：参数个数；  
2. `$0`：相对或绝对的脚本名称，`$(basename $0)` 取纯脚本名称；  
3. `$1`、`$2`、...、`$9`，`${10}`、`${11}`、...：顺序位置参数；  
4. `${!#}` 代表最后一个参数；  
5. `$@`（或 `$*`）: 所有参数；  

`$@` 代表的是参数数组，那么遵循数组索引规则和切片写法，`${@:2}` 表示从索引2开始的后面所有参数。  
`exec "${@:2}"` 则将后面所有的参数当做命令执行。  

index变量赋值具体索引3，则 `${!index}` 引用第3个参数。

```Shell
#!/bin/bash

index=3
echo "${!index}"

eval opt3="\$$index"
echo "$opt3"
```

---

有时候需要抓取命令行上提供的所有参数，不需要基于变量个数 `$#` 进行遍历，而是可以基于特殊变量来解决这个问题。
`$*` 和 `$@` 这两个变量都能够在单个变量中存储所有的命令行参数，使得我们可以轻松访问所有的命令行参数。

`$*` 变量会将命令行上提供的所有参数当作一个单词保存，这个单词包含了命令行中出现的每一个参数值。也就是说，`$*` 变量会将这些参数视为一个整体，而不是多个个体。
`$@` 变量会将命令行上提供的所有参数当作同一字符串中的多个独立的单词，这样你就能够通过for遍历读取每个参数。
这两个变量的工作方式不太容易理解，通过下面的示例，可以帮助我们更好地理解二者之间的区别。

> 但是在脚本中，对于参数数组的切片写法 `${*:2:3}` 和 `${@:2:3}` 是等效的，都是读取 $2 开始的3个元素。

```Shell
$ cat test11.sh

#!/bin/bash
# testing $* and $@ 
#
echo
echo "Using the \$* method: $*"
echo
echo "Using the \$@ method: $@"
```

测试结果：

```Shell
$ ./test11.sh rich barbara katie jessica

Using the $* method: rich barbara katie jessica

Using the $@ method: rich barbara katie jessica
```

从表面上看，两个变量产生了同样的输出，都显示出了所有命令行参数。

下面的例子，通过for循环遍历可以看出二者的差异。

```Shell
#!/bin/bash
# testing $* and $@
#
echo
count=1
#
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(($count + 1))
done
#
echo
count=1
#
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(($count + 1))
done
```

测试结果：

```Shell
$ ./test12.sh rich barbara katie jessica

$* Parameter #1 = rich barbara katie jessica

$@ Parameter #1 = rich
$@ Parameter #2 = barbara
$@ Parameter #3 = katie
$@ Parameter #4 = jessica
```

通过使用for命令遍历这两个特殊变量，可以看到它们是如何不同地处理命令行参数的。
`$*` 变量会将所有参数当成单个参数；而 `$@` 变量会单独处理每个参数。
故通常基于 `$@` 遍历读取命令行参数。

## 用户输入参数

read 指定接收变量的个数应与实际输入的参数个数一致，如果变量数量不够，剩下的数据就全部分配给最后一个变量。

### echo -n + read

unix/POSIX - [echo](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/echo.html)  
FreeBSD/Darwin - [echo](https://www.freebsd.org/cgi/man.cgi?query=echo)  

linux - [echo(1)](https://man7.org/linux/man-pages/man1/echo.1.html) - [echo(1p)](https://man7.org/linux/man-pages/man1/echo.1p.html)  
debian/Ubuntu - [echo](https://manpages.debian.org/buster/coreutils/echo.1.en.html)  

[echo(1)](https://man7.org/linux/man-pages/man1/echo.1.html) - display a line of text

```
 -n    Do not print the trailing newline characte.
```

`echo -n` 不换行提示加 `read` 捕获变量：

```
#!/bin/bash

echo -n "PLS input the num (1-10): "
read num
let i=num+5
echo $i
```

### read -p

unix/POSIX - [read](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/read.html)  
FreeBSD/Darwin - read is a shell builtin  

linux - [read(1p)](https://man7.org/linux/man-pages/man1/read.1p.html) - [read(2)](https://man7.org/linux/man-pages/man2/read.2.html) - [read(3p)](https://man7.org/linux/man-pages/man3/read.3p.html)  
debian/Ubuntu - [read](https://manpages.debian.org/buster/manpages-zh/read.1.zh_CN.html)  

[read(1p)](https://man7.org/linux/man-pages/man1/read.1p.html) — read a line from standard input

SYNOPSIS: `read [−r] var...`

The read utility shall read a single line from standard input.

另外一种方式更简洁，`read` 指定 `-p` 选项，提示行续接输入捕获到变量：

```
#!/bin/bash

read -p "PLS input the num (1-10): " num
let i=num+5
echo $i
```

如果 read 不指定变量，则默认放进环境变量 `REPLY` 中。

### read 的其他选项

- `read -t seconds`：指定多少秒后提示超时；  
- `read -s`：隐藏方式读取，不回显密码等隐秘数据（实际上是将文本颜色设置和背景色一致）。  

## 脚本参数解析

如果想更专业的处理输入参数列表，可以结合 `shift` 命令、`getopts`（getopt）提取分离参数，具体参考 [argparse](./argparse.md) 一节。
