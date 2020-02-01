# 数据流重定向(REDIRECTION)

参考 BASH(1) manual page 的 `REDIRECTION` 部分。

数据流重定向就是将某个命令执行后本应输出到控制台的结果数据传导到指定的地方，例如文件或打印机之类的设备。

## >, >>

输出导向，分别是 **替换** 与 **累加**

1. 标准输入（STDIN）：代码为0，使用 `<` 或 `<<`；  
2. 标准输出（STDOUT）：代码为1，使用 `>` 或 `>>`；  
3. 标准错误输出（STDERR）：代码为2，使用 `2>` 或 `2>>`。  

将 find 执行的正确结果输出到 list_right 文件中；错误信息输出到 list_error 文件中。

```Shell
$ find /home -name .bashrc > list_right 2> list_error
```

将 find 执行的正确结果输出到控制台；错误信息导向到垃圾桶黑洞设备，被吞噬不输出。

```Shell
$ find /home -name .bashrc 2> /dev/null
```

> `clang -dM -E -arch i386 -x c /dev/null` ？

如何将正确和错误的数据都写入同一文件呢？

```Shell
# 错误，两条数据可能交叉写入导致错乱
$ find /home -name .bashrc 2> list 2> list
# 正确
$ find /home -name .bashrc > list 2>&1
$ find /home -name .bashrc &> list
```

**案例**：`ls 2>&1 > dirlist` 

1. 先执行 `2>&1`，stderr 被复制到 stdout，在控制台输出；  
2. 在执行 `ls > dirlist`，只有 stdout 才会被重定向到 dirlist 文件。  

### tee

双向重定向：同时将数据送与文件与控制台（stdout）。  
输出到控制台的部分可以传导给下个命令继续处理。

`-a`: Append the output to the files rather than overwriting(default).

```Shell
# 将 ls -l 结果追加到文件，同时输出到控制台用more分页显示。
faner@MBP-FAN:~|⇒  ls -l / | tee -a ~/homefile | more
```

**经典示例**：

执行 `shadowsocks.sh` 脚本安装 shadowsocks，将执行的 stdout 和 stderr 在控制台输出，并同时写入日志文件 shadowsocks.log： 

```Shell
./shadowsocks.sh 2>&1 | tee shadowsocks.log
```

## <, <<

### <

输入导向就是将原本应由键盘输入的数据源改为文件。

`cat > catfile` 将创建 `catfile` 文件，同时需要从键盘输入内容，输入 `<C-C>` 或 `<C-D>` 结束。

```Shell
# 用 stdin 替代键盘的输入以创建新文件
cat > catfile < ~/.bashrc
```

### <<

远小于号（`<<`）也称作内联输入重定向符号。`<<` 后面需要续接终止输入控制标记。

以下示例中当输入 `eof` 时，则结束输入。

```Shell
# 用 stdin 替代键盘的输入以创建新文件
cat > catfile << "eof"
```

以下是完整示例：

```
$ cat > catfile.txt << eof
heredoc> line1
heredoc> line2
heredoc> line3
heredoc> eof

$ cat catfile.txt
line1
line2
line3
```

#### bc

另外一个经典的例子是，字符串表达式传给 `bc` 执行数学运算。

```
$ bc <<< "scale=4;3.44/5"
.6880
```

一种方式是重定向：

```
$ var1=$(echo "scale=4;3.44/5" | bc)
$ echo $var1
.6880
```

这种方式适用于较短的运算表达式，当需进行大量运算、涉及更多的数字时，在一个命令行中列出多个表达式会很麻烦。
第二种方式是使用内联输入重定向，它允许直接在命令行中重定向数据。

```
variable=$(bc << EOF
options
statements
expressions
EOF
)
```

这样，可以将所有涉及 bash 计算器的部分都放到同一个脚本文件的不同行。

```Shell
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

## demos

`enca -L zh_CN -x UTF-8 < file1 > file2`
