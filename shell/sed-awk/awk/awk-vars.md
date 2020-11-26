
## FS/OFS/RS

以下是控制格式相关的一些内置变量：

 变量        | 描述
------------|-----------------
FIELDWIDTHS | 由空格分隔的一列数字，<br>定义了每个数据字段确切宽度
RS          | 输入记录分隔符，默认为换行符
FS          | 输入字段分隔符，默认为空格
ORS         | 输出记录分隔符，默认为换行符
OFS         | 输出字段分隔符，默认为空格

以下打印 awk 默认的输入记录/字段分割符、输出记录/字段分割符：

```
$ awk 'BEGIN { printf "RS=\"%s\"\nFS=\"%s\"\nORS=\"%s\"\nOFS=\"%s\"\n", RS, FS, ORS, OFS }'
RS="
"
FS=" "
ORS="
"
OFS=" "
```

[Linux 中 awk 后面的 RS, ORS, FS, OFS 用法](https://www.cnblogs.com/xuaijun/p/7902757.html)  
[Explanation about awk command using ORS, NR, FS, RS](https://stackoverflow.com/questions/55997954/explanation-about-awk-command-using-ors-nr-fs-rs)  
[8 Powerful Awk Built-in Variables – FS, OFS, RS, ORS, NR, NF, FILENAME, FNR](https://www.thegeekstuff.com/2010/01/8-powerful-awk-built-in-variables-fs-ofs-rs-ors-nr-nf-filename-fnr/)  

### OFS

变量 FS 和 OFS 定义了 awk 如何处理数据流中的数据字段。

- 变量 `FS` 用来定义记录中的字段分隔符；  
- 变量 `OFS` 用于 `print` 命令输出多变量间隔。  

默认情况下，awk 将 `OFS` 设成一个空格。
执行命令 `print $1,$2,$3`，会看到输出 `field1 field2 field3`。

```
$ awk '{print $1, $2}' data2.txt
One line
Two lines
Three lines
```

可以通过 BEGIN 模块在输出前预设输出分隔符 OFS：

```
$ awk 'BEGIN {OFS=", "} {print $1, $2}' awk-data2.txt
One, line
Two, lines
Three, lines
```

### FIELDWIDTH

在一些应用程序中，数据并没有使用字段分隔符，而是被放置在了记录中的特定列。
这种情况下，必须设定 `FIELDWIDTHS` 变量来匹配数据在记录中的 *位置*，按照列宽来分割各个域。

> 一旦设置了 FIELDWIDTH 变量，awk 就会忽略 FS 变量。

### RS

变量 RS 和 ORS 定义了 awk 程序如何处理数据流中的字段。
默认情况下，awk 将 RS 和 ORS 设为换行符（`\n`），即以行作为记录裁决单位。

有时会遇到较长的单行文本，但包含固定的分隔符，典型的例子是 PATH 环境变量。
此时，可将分隔符设置为 RS，将其切割为多条记录按行输出。

例如，以下脚本将 PATH 环境变量按冒号分割成多条记录，再逐行列举打印：

```
echo $PATH | awk 'BEGIN{RS=":"} {print}'
```

更多的时候，你会在数据流中碰到占据多行的结构化信息。  
典型的例子是包含地址和电话号码的数据，其中地址和电话号码各占一行。

```
Riley Mullen
123 Main Street
Chicago, IL 60601
(312)555-1234
```

如果你用默认的 FS 和 RS 变量值来读取这组数据，awk 就会把每行作为一条单独的记录来读取，并将记录中的空格当作字段分隔符。
但实际上，每四行组成的结构化区块为一条完整的记录，每条记录中的每一行对应一个字段域。

结构化的记录之间留一个空白行相间，可以将 `RS` 变量设置成空字符串，将 `FS` 设置为换行符（`\n`）。
然后 awk 会把每个空白行当作一个记录分隔符，把文件中的每行当成一个字段。

data2 中有三条记录：

```
$ cat data2
Riley Mullen
123 Main Street
Chicago, IL 60601
(312)555-1234

Frank Williams
456 Oak Street
Indianapolis, IN 46201
(317)555-9876

Haley Snell
4231 Elm Street
Detroit, MI 48201
(313)555-4938
```

awk 提取姓名和电话号码打印输出：

```
$ awk 'BEGIN {RS=""; FS="\n"; OFS=": " } {print $1,$4}' data2
Riley Mullen: (312)555-1234
Frank Williams: (317)555-9876
Haley Snell: (313)555-4938
```

## NF/NR/FNR

当要在 awk 程序中跟踪数据字段和记录时，变量 FNR、NF 和 NR 用起来就非常方便。

 变量  | 描述
------|-----------------
`NF`  | number of fields in the current record
`NR`  | ordinal number of the current record
`FNR` | ordinal number of the current record in the current file

有时并不知道记录中到底有多少个数据字段，NF 变量存储了数据文件中数据字段的个数。
可以 `$NF` 形式引用数据记录中最后一个字段，RS 例程中的电话号码字段（`$4`）也可以 `$NF` 形式引用。

### FNR

FNR 和 NR 变量虽然类似，但又略有不同。

- FNR 变量含有当前数据文件中已处理过的记录数；  
- NR 变量则含有已处理过的记录总数。  

```
$ cat data1
data11,data12,data13,data14,data15
data21,data22,data23,data24,data25
data31,data32,data33,data34,data35

$ awk 'BEGIN{FS=","} {print $1,"FNR="FNR}' data1 data1
data11 FNR=1
data21 FNR=2
data31 FNR=3
data11 FNR=1
data21 FNR=2
data31 FNR=3
```

在以上示例中，awk 程序的命令行定义了两个输入文件（两次指定的是同样的输入文件）。

这个脚本会打印第一个数据字段的值和 `FNR` 变量的当前值（注意不要加 `$` 引用）。  
注意：当 awk 程序处理第二个数据文件时，`FNR` 值被设回了1。

> 默认 `RS="\n"`，每一行为一条记录，记录数也为 `FNR` 为当前行数（从1开j计数）。

### NR

现在，让我们加上 `NR` 变量看看会输出什么。

```
$ awk 'BEGIN{FS=","} {print $1,"FNR="FNR,"NR="NR}' data1 data1
data11 FNR=1 NR=1
data21 FNR=2 NR=2
data31 FNR=3 NR=3
data11 FNR=1 NR=4
data21 FNR=2 NR=5
data31 FNR=3 NR=6
```

FNR 变量的值在 awk 处理第二个数据文件时被重置了，而 NR 变量则在处理第二个数据文件时继续计数。  

1. 如果只使用一个数据文件作为输入，FNR 和 NR 的值是相同的；  
2. 如果使用多个数据文件作为输入，FNR 的值会在处理每个数据文件时被重置，而 NR 的值则会继续计数直到处理完所有的数据文件。  

以下脚本，打印除第1行之外的所有行（记录）：

```
$ awk 'NR==1 { next; } {print $0}' data2.txt
Two lines of test text.
Three lines of test text.
```

可进一步省略默认的 action，简写为 `awk 'NR>1' data2.txt`。

## user-defined

跟其他典型的编程语言一样，awk 允许定义自己的变量在程序代码中使用。  
awk 自定义变量名可以是任意数目的字母、数字和下划线，但不能以数字开头，且区分大小写。  

### assign var

在 awk 中直接引用 shell 上下文的变量报错：

```
$ test="cat"
$ sentence="The cat sat on the mat"
$ awk 'BEGIN {print index($sentence, $test)}'
awk: illegal field $(), name "sentence"
 source line number 1
```

可通过 `-v` 选项将 shell 变量赋值给 awk 内部变量，再引用。

```
$ index=`awk -v a="$sentence" -v b="$test" 'BEGIN{print index(a,b)}'`
$ echo $index
5
```

### local var

在 awk 程序脚本中给变量赋值和在 shell 脚本中赋值类似，都用赋值语句。

```
$ awk 'BEGIN{testing="This is a test"; print testing}'
This is a test

$ awk 'BEGIN{x=4; x= x * 2 + 3; print x}'
11
```

> awk 引用内部变量和 C 语言相似，不用 `$` 符号。

也可以用 awk 命令行来给程序中的变量赋值，这允许你在正常的代码之外赋值，即时改变变量的值。

### cmd var

以下示例使用命令行变量传参，来显示文件中特定数据字段。

```
$ cat script1.awk
BEGIN{FS=","}
{print $n}

$ awk -f script1.awk n=2 data1
data12
data22
data32

$ awk -f script1.awk n=3 data1
data13
data23
data33
```

但是，使用命令行参数来定义变量值会有一个问题，命令行传参其值在 BEGIN 部分不可用。

```
$ cat script2.awk
BEGIN{print "The starting value is",n; FS=","}
{print $n}

$ awk -f script2.awk n=3 data1
The starting value is
data13
data23
data33
```

可以用 `-v` 命令行参数来解决这个问题。它允许在 BEGIN 代码之前设定变量。  
在命令行上，`-v` 命令行参数必须放在脚本代码之前。

```
$ awk -v n=3 -f script2.awk data1
The starting value is 3
data13
data23
data33
```

### array

for 语句会在每次循环时将关联数组array的下一个索引值赋给变量var，然后执行一 遍statements。

**注意**：

1. 这个变量中存储的是 *索引值* 而不是数组元素值；  
2. 索引值不会按任何特定顺序返回，只能保证索引值和数据值的对应关系；  

```
$ awk 'BEGIN{
    var["a"] = 1
    var["g"] = 2
    var["m"] = 3
    var["u"] = 4
    for (test in var)
    {
        print "Index:",test," - Value:",var[test]
    }
}'
Index: g  - Value: 2
Index: m  - Value: 3
Index: u  - Value: 4
Index: a  - Value: 1
```

这里的“数组”，更像是“字典”的概念。索引为字符串，并非整数。

```
$ awk 'BEGIN{
    STR="mydoc.txt"
    print split(STR,components,".")
    print "prefix="components["1"]
    print "suffix="components["2"]
}'
2
prefix=mydoc
suffix=txt
```

#### delete

从关联数组中删除数组索引要用一个特殊的命令。

```
delete array[index]
```

删除命令会从数组中删除关联索引值和相关的数据元素值。

```
$ awk 'BEGIN{
    var["a"] = 1
    var["g"] = 2
    var["m"] = 3
    var["u"] = 4
    for (test in var)
    {
        print "Index:",test," - Value:",var[test]
    }

    delete var["g"]

    print "---"
    for (test in var)
    {
        print "Index:",test," - Value:",var[test]
    }
}'
Index: g  - Value: 2
Index: m  - Value: 3
Index: u  - Value: 4
Index: a  - Value: 1
---
Index: m  - Value: 3
Index: u  - Value: 4
Index: a  - Value: 1
```
