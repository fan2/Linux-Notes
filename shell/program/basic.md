
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

1. `$@`（或 `$*`）: 所有参数；  
2. `$#`：参数个数；  
3. `$0`：相对或绝对的脚本名称，`$(basename $0)` 取纯脚本名称；  
4. `$1`、`$2`、...、`$9`，`${10}`、`${11}`、...：顺序位置参数；  
5. `${!#}` 代表最后一个参数；  

## 用户输入参数

方式1: `echo` 提示加 `read` 捕获变量

```
    echo -n "enter a number from 1 to 5: "
    read ANS
```

方式2: 更简洁，`read -p` 指定提示符续接变量捕获

```
    read -p "enter a number from 1 to 5: " ANS
```

如果 read 不指定变量，则默认放进环境变量 `REPLY` 中。

### 参数个数

指定接收变量的个数应与实际输入的参数个数一致，如果变量数量不够，剩下的数据就全部分配给最后一个变量。

### 其他选项

- `read -t seconds`：指定多少秒后提示超时；  
- `read -s`：隐藏方式读取，不回显密码等隐秘数据（实际上是将文本颜色设置和背景色一致）。  

### 参数解析

如果想更专业的处理输入参数列表，可以结合 shift 命令、getopts（getopt）提取分离参数。
