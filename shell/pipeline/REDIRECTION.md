# 数据流重定向(REDIRECTION)

参考 BASH(1) manual page 的 `REDIRECTION` 部分。

数据流重定向就是将某个命令执行后本应输出到控制台的结果数据传导到指定的地方，例如文件或打印机之类的设备。

当在shell中执行命令的时候，每个进程都和三个打开的文件相联系，并使用文件描述符来引用这些文件。
由于文件描述符不容易记忆，shell给出了相应的文件名代称。

1. 标准输入（stdin）：文件描述符fd为0，缺省从键盘接受输入。

    - 也可使用 `<`（`0<`） 或 `<<`（`0<<`）从文件或其他设备导入。

2. 标准输出（stdout）：文件描述符fd为1，缺省输出到控制台（屏幕）。

    - 也可使用 `>`（`1>`） 或 `>>`（`1>>`）重定向导出到文件或其他设备。

3. 标准错误输出（stderr）：文件描述符fd为2，缺省输出到控制台（屏幕）。

    - 也可使用 `>`（`2>`） 或 `>>`（`2>>`）重定向导出到文件或其他设备。

如果没有特别指定文件描述符，命令默认将执行信息输出到缺省“文件”——你的屏幕，更确切地说是你的终端。

**为什么会有一个专门针对错误的特殊文件stderr呢**？

当用命令处理大数据文件时，除了正常的（非错误的）输出信息，还有可能输出很多错误信息。
常见做法是先将标准输出重定向到一个文件，然后再把标准错误输出重定向到另外一个文件。
把错误信息存储到独立的日志文件，可以避免错误信息淹没正常结果输出，也便于排查问题。

- 例如 nginx 即是分开存储普通日志 access_log 和出错日志 error_log。

stdout和stderr区别在于：

1. 重定向 `>` 默认是指 `1>`，只将stdout输出重定向。
2. 管道 `|` 默认也只将stdout作为下一个命令的输入，不包括stderr；`|&` 则包括了stdout和stderr。

## >, >>

输出导向，分别是 **替换**（Redirecting Output）与 **累加**（Appending Redirected Output）。

### >

最基本的重定向将命令的输出发送到一个文件中，bash shell用大于号（`>`）来完成这项功能：

```Shell
command > outputfile
# 以上缺省了标准输出1
command 1> outputfile
```

这样之前显示器上出现的命令输出，不再输出到屏幕控制台，而是保存到指定的输出文件中。

> 如果输出文件已经存在，重定向操作符会用新的数据覆盖已有文件；否则先基于默认umask创建一个新文件。

可以将stderr单独重定向到一个文件，将stdout重定向到另一个文件：

```Shell
cmd 2>stderr.txt 1>stdout.txt
# 标准输出1可以省略
cmd 2>stderr.txt >stdout.txt
```

假设有两个审计文件，其中一个的确存在且包含一些信息，而另一个由于某种原因可能已经不存在了。
以下脚本把这两个文件合并到accounts.out中，相应的错误将会保存在accounts.err文件中。

```Shell
$ cat account_qtr.doc account_end.doc 1>accounts.out 2>accounts.err
```

### >>

有时并不想覆盖文件原有内容，而是想要将命令的输出追加到已有文件中，此时可以用双大于号（`>>`）来向现存文件末尾追加新数据。

关于累加输出导向的广泛应用是 echo 一行新配置，追加到一个配置文件中。
以下示例在 `~/.zshrc` 末尾追加一句 export 命令：

```Shell
echo export ALL_PROXY=socks5://127.0.0.1:1080 >> ~/.zshrc
```

brew install openssl 过程中，Caveats 提示可执行脚本将其可执行路径添加到 PATH 中：

```Shell
If you need to have this software first in your PATH run:
  echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.zshrc
```

### 1>&2

在编写shell脚本时，经常会在捕获错误异常时调用echo打印自定义的出错信息，并将这些错误信息重定向到stderr设备中。
如果之前已经将stderr重定向到了指定日志文件，那么自定义的echo信息也会随stderr重定向到日志文件。
可以在中途采取这种重定向策略，使标准输出尽可能简洁，以免被计算过程中的大量输出淹没。

> redirect stdout to stderr: sending the output to standard error instead of standard out.

以下是来自 [transfer.sh](https://transfer.sh/) 中的一段脚本，是典型的判断文件是否存在的错误捕获处理：

```Shell
        if [ ! -e "$file" ]; then
            echo "$file: No such file or directory" >&2
            return 1
        fi
```

重定向符号 `>` 正常情况，连接左侧的源头和右侧的目标，左侧源头缺省是1-stdout。因此 `>&2` 实际上是 `1>&2` 的简略写法。
右侧的 `&2` 中的`&`类似C语言中的地址引用（denote），而后面的数字`2`为stderr的文件描述符。
因此，`>&2` 表示将1（stdout，标准输出）重定向到2（stderr，标准错误）中。

**注意**：`>2`表示重定向到普通文件2中，`>&2`则表示重定向到fd=2的设备stdout中。

相关参考：

- [shell中>&2的含义及用法](https://blog.csdn.net/huangjuegeek/article/details/21713809)  
- [echo >&2 "some text" what does it mean in shell scripting](https://stackoverflow.com/questions/23489934/echo-2-some-text-what-does-it-mean-in-shell-scripting)  

### 2>&1

当运行某些命令的时候，出错信息往往也很重要，以便用于分析问题。
那么，如何错误信息也和正常输出一样，都写入同一个文件中呢？

以下是 man bash 中关于 Redirecting Standard Output and Standard Error 的使用说明：

```Shell
Bash allows both the standard output (file descriptor 1) and the standard error output (file descriptor 2) to be redirected to the file whose name is the expansion of word with this construct.

There are two formats for redirecting standard output and standard error:

&>word

and

>&word

Of the two forms, the first is preferred. This is semantically equivalent to

>word 2>&1
```

以下的写法，两条数据交叉写入，可能导致错乱：

```Shell
$ find /home -name .bashrc 1> file 2> file
```

根据 manpage 文档，正确的写法如下：

```Shell
$ find /home -name .bashrc &> file
$ find /home -name .bashrc 2>&1 file
$ find /home -name .bashrc > file 2>&1
```

第一种写法 `command &> file`：其中的 `&` 省略了被引用的1和2，表示stdout和stderr都重定向到文件file中。
第二种写法 `command > file 2>&1`：前面将标准输出1-stdout重定向到file中，后面的 `2>&1` 怎么理解呢？

`2>&1` 表示将2-stderr重定向到1-stdout，这样错误信息和正常结果输出都重定向到了文件file中。

我们再来看一组对比写法，可以加深理解：

```Shell
# greplog1：只有正常输出内容
grep pattern file > greplog1
# greplog2：内容为空，stdout被导向了stderr
grep pattern file > greplog2 1>&2
# greplog3、greplog4：既有正常输出内容，又有错误输出内容。
grep pattern file > greplog3 2>&1  # stdout > file, stderr same as stdout
grep pattern file 2> greplog4 1>&2 # stderr > file, stdout same as stderr
echo 'df' 2> test.txt >&2
```

以下脚本将1-stdout重定向到2-stderr，也就是在终端屏幕上显示hello。
`| grep world` 搜素左边传来的1-stdout为空，匹配world无果，故没有结果输出，最终屏幕只echo到stderr显示hello。

```Shell
$ echo hello 1>&2 | grep world
hello
```

以下脚本将2-stderr重定向到1-stdout，不过echo执行正确，没有错误信息输出到stderr。
`| grep world` 搜素左边传来的1-stdout为字符串 `hello`，匹配world无果，故没有结果输出，最终屏幕无输出。

```Shell
# 基本等效于 echo hello | grep world，只不过顺便把stderr重定向到stdout。
$ echo hello 2>&1 | grep world

```

以下是 man bash 中的经典对比示例：

```Shell
# Note that the order of redirections is significant. For example, the command
# directs both standard output and standard error to the file dirlist,
ls > dirlist 2>&1

# while the command directs only the standard output to file dirlist,
# because the standard error was duplicated as standard output before the standard output was redirected to dirlist.
ls 2>&1 > dirlist
```

第二种写法 `ls 2>&1 > dirlist` 和第一种写法的区别在于 `2>&1` 在重定向 `1 > dirlist` 前面。

1. 先执行 `2>&1`，此时stdout默认还是输出到终端，所以stderr同stdout一样都输出到终端控制台；  
2. 再执行 `> dirlist`，只有stdout会被重定向到dirlist文件中。  

### 2>/dev/null

有时候，在输出中可能包含一些不必要的信息（如调试信息）。
如果不想让终端充斥着有关stderr的繁枝末节，可考虑将stderr输出重定向到 `/dev/null`，予以忽略。

在使用 grep 查找时，当传入的文件或文件夹不存在时，可以指定 `-s` 选项屏蔽 No such file or directory 之类的错误信息输出。
find 命令则没有类似的选项，当查找的文件（夹）没有读权限时，可能会有大量的 Permission denied 报错信息输出到控制台。
find 执行输出的错误信息可以重定向到一个单独的日志文件，也可导向垃圾桶黑洞设备，被吞噬不输出到控制台。

- [Linux / Unix Find Command Avoid Permission Denied Messages](https://www.cyberciti.biz/faq/bash-find-exclude-all-permission-denied-messages/)  
- [How can I exclude all "permission denied" messages from "find"?](https://stackoverflow.com/questions/762348/how-can-i-exclude-all-permission-denied-messages-from-find)  

```Shell
# 将错误信息重定向到日志文件，不输出到控制台
$ find /home -name .bashrc 2> finderrors.log
# 将错误信息重定向到系统垃圾桶，不输出到控制台
$ find /home -name .bashrc 2> /dev/null
$ find / -type f -name "*.conf" -maxdepth 4 2>/dev/null
```

## <, <<

输入重定向和输出重定向正好相反：输入重定向将文件的内容重定向到命令，而非将命令的输出重定向到文件。

```Shell
command < inputfile
```

一个简单的区分记忆方法是：在命令行上，命令总是在左侧，而重定向符号“指向”数据流动的方向。

- 输出重定向符号是大于号（>），意味着数据从命令流向输出文件。
- 输入重定向符号是小于号（<），意味着数据从输入文件流向命令。

### <

输入导向符号 `<` 可以将原本应由键盘输入的数据源改为从文件读取。

`cat > catfile`：命令将创建 `catfile` 文件，并把标准输出重定向到文件中，这时cat命令将从标准输入（键盘）接受输入，输入 `<C-C>` 或 `<C-D>` 结束。

```Shell
# 用 stdin 替代键盘的输入以创建新文件
cat > catfile < ~/.bash_logout
```

不过，以上示例的写法有点令人费解，更常见的等效写法如下：

- `cat ~/.bash_logout > ~/Documents/catfile`  
- `cp ~/.bash_logout Documents/catfile`  

以下脚本从file1读入内容到stdin作为enca的输入参数，然后将执行结果重定向到file2中。

```Shell
$ enca -L zh_CN -x UTF-8 < file1 > file2
```

> `[n]<>file2`：n缺省为0-stdin，省略了file1，读取file2到stdin给命令操作，然后将结果覆写到file中。

### <<

远小于号（`<<`）也称作内联输入重定向符号，后面需要续接终止输入控制标记单词（字符串），用于划分输入数据的开始和结尾。

`Here Documents`: This type of redirection instructs the shell to read input from the current source *until* a line containing only word (with no trailing blanks) is seen. All of the lines read up to that point are then used as the standard input for a command.

The format of here-documents is:

```Shell
<<[−]word
    here-document
delimiter
```

以下示例中当输入 `eof` 时，则结束输入。

```Shell
# 用 stdin 替代键盘的输入以创建新文件
cat > catfile << "eof"
```

以下是完整示例：

```Shell
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

以下函数用于输出一段帮助信息（Usage），这样写的好处是可以保持排版格式：

```Shell
show_help() {
    cat <<EOF
$(basename "$0") version: 1.0.0
Usage: $(basename "$0") [-?hvSPdpr]

Options:
    -?,-h,--help            : show help and exit
    -v, --version           : show version and exit
    -S, --server            : start as server, default
    -P, --proxy             : start as proxy daemon
    -d, --debug             : run in debug mode, default
    -p, --profile           : run in profile mode
    -r, --release           : run in release mode
EOF
}
```

在使用tr进行转换时，需要接受stdin输入，通常是echo string或cat file管道传给tr处理。
如果多次复制的段落中有空格需要移除，可以在预设命令末尾指定 `command << eof`。
采用heredoc逐行粘贴待处理文本，最后一行输入eof结束输入执行处理。

```Shell
$ tr -d '[:space:]' << eof
heredoc> 我 们 的 爱
heredoc> 一旦 错过 就 不再
heredoc> eof
我们的爱一旦错过就不再%
```

这样在命令行输入预处理shell指令后，即时输入文本行（段落）做一些预处理，比每次先保存临时文件再cat管传方便得多！

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

### <<<

`Here Strings`: A variant of here documents, the format is:

```Shell
command <<< string
```

The word is expanded and supplied to the command on its standard input.

在使用tr进行转换时，需要接受stdin输入，通常是echo string或cat file管道传给tr处理。
如果有字符串文本行需要执行一些转换处理，可以采用herestr在预设命令末尾输入待处理字符串。

```Shell
# echo "dos2unix" | tr '[:lower:]' '[:upper:]'
$ tr '[:lower:]' '[:upper:]' <<< "dos2unix"
```

这样先在命令行输入预处理shell指令后，即时输入字符串做一些预处理，比每次echo管传方便得多！

> Here Documents 和 Here Strings 机制实现了类似read等待用户输入待处理数据的效果。
