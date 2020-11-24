
虽然sed编辑器是非常方便自动修改文本文件的工具，但其也有自身的限制。  
如果要格式化报文或从一个大的文本文件中抽取数据包，那么 awk 可以完成这些任务。

awk 提供了一个类编程环境来修改和重新组织文件中的数据，是一种来处理文件中的数据的更高级工具。  
awk 是一种自解释的编程语言，以发展这种语言的人 `A`ho.`W`eninberger 和 `K`ernigham 命名。  
awk 结合诸如 grep 和 sed 等其他工具，将会使shell编程更加强大。除此之外，还有 gawk、nawk 和 mawk 等扩展变种。  

为获得所需信息，文本或字符串必须格式化，意即用 `域分隔符`（Filed Separator）划分抽取域。
awk 在文本文件或字符串中基于指定规则浏览和抽取信息，然后再执行其他命令。

可以利用 awk 编程语言做下面的事情：

- 定义变量来保存数据  
- 使用算术和字符串操作符来处理数据  
- 使用结构化编程概念（比如if-then语句和循环）来为数据处理增加处理逻辑  
- 通过提取数据文件中的数据元素，将其重新排列或格式化，生成格式化报告。

awk 程序的报告生成能力通常用来从大文本文件中提取数据元素，并将它们格式化成可读的报告。其中最完美的例子是格式化日志文件。

## 模式和动作

一个 awk 脚本可能包含多条语句，任何一条 awk 语句则都由 `模式` 和 `动作` 组成。

模式部分决定动作语句何时触发及触发事件，处理即对数据进行的操作。
模式可以是任何条件语句或复合语句或正则表达式。

> 如果省略模式部分，动作将时刻保持执行状态。

模式包括两个特殊字段 BEGIN 和 END。

- `BEGIN` 语句用于设置计数和打印头，BEGIN 语句使用在任何文本浏览动作之前，之后文本浏览动作依据输入文件开始执行。  
- `END` 语句用来在 awk 完成文本浏览动作后打印输出文本总数和结尾状态标志。  

> 如果不特别指明模式，awk 总是匹配或打印行数。

**动作** 大多数用来打印，但是可以在大括号（`{}`）内书写更长的代码诸如 if 和循环（looping）语句及循环退出结构。  
大括号（`{}`）内多行语句以分号（`;`）相隔，这一点和 sed、C等其他编程语言一致。  

> 如果不指明采取动作，awk 将打印出所有浏览出来的记录。

### 模式（BEGIN/END）

默认情况下，awk 会从输入中读取一行文本，然后针对该行的数据执行程序脚本。

- `BEGIN` : 在处理数据前运行脚本，用于为报告创建标题等；  
- `END` : 在处理数据后运行脚本，awk 会在读完数据后执行它；  

一个完整的 awk 脚本由3部分组成，形如如下：

```
awk 'BEGIN {begin} {body} END {end}' file
```

> 通常 awk 控制格式相关的一些内置变量和用户自定义变量放在 BEGIN 部分，以便在读取第一行之前即初始化。

### 动作（print）

除了输出字段分隔符（`OFS`），awk 中的 print 语句在数据显示上并未提供多少控制。

### 示例

下面是一段示例：

```
$ awk 'BEGIN {print "The data2 File Contents:"; print "=========="}
    {print $0}
    END {print "=========="; print "End of File"}' data2.txt
The data2 File Contents:
==========
One line of test text.
Two lines of test text.
Three lines of test text.
==========
End of File
```

---

可以只书写 BEGIN 部分测试 awk 语法，省略 body 和 END 部分，以及 file 参数。

```
$ awk 'BEGIN {print "Hello, AWK!"}'
Hello, AWK!
```

在结尾部分，通过 END 打印处理的记录数：

```
$ awk 'END {print "end-of-record, NR="NR}' data1
end-of-record, NR=2
```

---

```
$ cat grade.txt
M.Tansley   05/99   48311   Green       8   40  44
J.Lulu      06/99   48317   green       9   24  26
P.Bunny     02/99   48      Yellow      12  35  28
J.Troll     07/99   4842    Brown-3     12  26  26
L.Tansley   05/99   4712    Brown-2     12  30  28
```

将所有学生的目前级别分加在一起，方法是 `tot += $6`，tot 即为 awk 浏览的整个文件的域6结果总和。  
所有记录读完后，在 END 部分加入一些提示信息及域6总和。

不必在 awk 中显式说明打印所有记录，每一个操作匹配时，这是缺省动作。

```
$ awk '(tot+=$6); END{print "Club student total points: " tot}' grade.txt
M.Tansley   05/99   48311   Green       8   40  44
J.Lulu      06/99   48317   green       9   24  26
P.Bunny     02/99   48      Yellow      12  35  28
J.Troll     07/99   4842    Brown-3     12  26  26
L.Tansley   05/99   4712    Brown-2     12  30  28
Club student total points: 155
```

如果文件很大， 你只想打印 END 中的统计结果而不是所有记录，可在语句的外面加上大括号即可。

```
# 可去掉圆括号
$ awk '{(tot+=$6)}; END{print "Club student total points: " tot}' grade.txt
Club student total points: 155
```

## 记录和域

### 记录（Record）

跟 sed 一样，awk 默认对数据流逐行读取分析，每一行即为一条记录（Record），然后针对每条记录执行程序脚本。

如果未设置 `-F` 选项，则 awk 默认采用空格为域（字段）分隔符，并保持这个设置直到发现记录分割符（默认为换行符 `\n`）。  
当新行出现时，awk 命令获悉已读完一条记录，然后在下一个记录启动读命令，这个读进程将持续到文件结尾或文件不再存在。

以下打印记录分割符 `RS`（Record Seperator）

```
$ awk 'BEGIN { printf "RS=\"%s\"\n", RS }'
RS="
"
```

```
$ cat data2.txt
One line of test text.
Two lines of test text.
Three lines of test text.
```

`awk '1 {print $0}'` 中的 pattern 永远成立，实际效果为打印所有行（记录）。

```
$ awk '1 {print}' data2.txt
One line of test text.
Two lines of test text.
Three lines of test text.
```

由于 print 为缺省动作，因此可进一步简写为 `awk 1 data2.txt`。

### 域（Field）

awk 处理一条记录时，会用预定义的分隔符划分每个域（字段，Field）。

> awk 中默认的字段分隔符是任意的空白字符（例如空格或制表符）。

以下打印域分割符 `FS`（Field Seperator）

```
$ awk 'BEGIN { printf "FS=\"%s\"\n", FS }'
FS=" "
```

awk 将分割出来的域依次标记为 `$1`,`$2`,...,`$n`，它们称为 **域标识**。

- `$0` : 代表整个文本行  
- `$1` : 代表文本行中的第1个数据字段  
- `$2` : 代表文本行中的第2个数据字段  
- `$n` : 代表文本行中的第n个数据字段  

脚本中可引用域标识可进一步对域进行处理。  
使用 `$1,$3` 表示引用第1和第3域，注意这里用逗号做域分隔。  
如果希望打印有5个域的记录的所有域，不必指明 `$1,$2,$3,$4,$5`，可使用 `$0`，意即整条记录的所有域。  
awk 浏览数据时，到达一新行，即假定到达包含域的记录末尾，然后执行新记录下一行的读动作，并重新设置域分隔。  

---

以下示例中，awk 读取文本文件，只显示第1个数据字段的值。

```
$ awk '{print $1}' data2.txt
One
Two
Three
```

以下命令摘取打印每条记录的第1、3、6三个字段：

```
$ awk '{print $1,$3,$6}' grade.txt
M.Tansley 48311 40
J.Lulu 48317 24
P.Bunny 48 35
J.Troll 4842 26
L.Tansley 4712 30
```

以下示例中，awk 引用域四并对其进行赋值修改。

```
$ awk '{$4="awk";print$0}' data2.txt
One line of awk text.
Two lines of awk text.
Three lines of awk text.
```

默认 `FS` 非顶格空格或 tab，我们也可以自行指定其他字符（串）作为域分隔符。

## 典型范式

Manual Pages 中的 SYNOPSIS 如下：

```
       awk [ -F fs ] [ -v var=value ] [ 'prog' | -f progfile ] [ file ...  ]

       awk [−F sepstring] [−v assignment]... program [argument...]

       awk [−F sepstring] −f progfile [−f progfile]... [−v assignment]...
            [argument...]
```

省略模式部分的典型 awk 调用范式如下：

```
awk options 'commands' input-file
```

也可将所有的 awk 命令保存到一个脚本文件中，然后调用 awk 时，用 `-f` 选项指定命令脚本：

```
awk -f awk-script-file input-file(s)
```

- `-f` 选项指明在文件 awk_script_file 中的 awk 脚本；  
- `input-file(s)` 是使用 awk 进行浏览的文件名。  

### options

awk 常用命令选项如下表：

| 选项           | 描述                          |
| -------------- | -----------------------------|
| `-F fs`        | 指定行中划分数据字段的字段分隔符   |
| `-f file`      | 从指定的文件中读取脚本程序        |
| `-v var=value` | 定义一个变量及其默认值           |
| `-mf N`        | 指定要处理的数据文件中的最大字段数 |
| `-mr N`        | 指定数据文件中的最大数据行数      |

### input from STDIN

若没有在命令行上指定文件（input-file），则 awk 将会等待从 STDIN 接受输入参数作为待处理数据。

输入一行文本并按下回车键，awk 会对这行文本运行一遍程序脚本。

以下示例 `awk '{print "Hello, AWK!"}'` 总是打印一行固定的文本字符串，因此不管你在数据流中输入什么文本，都会得到同样的文本输出。

```
$ awk '{print "Hello, AWK!"}'
stdin line 1 for awk!
Hello, AWK!
stdin line 2 for awk!
Hello, AWK!
```

稍作修改为 `awk '{print $2}'`，则打印输入文本空格分割的第2个字段：

```
$ awk '{print $2}'
Hello World
World
Hey Jude
Jude

```

按下 `<C-C>` 或 `<C-D>`（EOF）退出。

### -F 指定域分割符

`-F` 是可选的，不特别指定时，awk 使用空格作为缺省的域分隔符。

> `-F` 之后的 fs 之间可以没有空格；`fs` 如果是单个字符可以不加（双）引号；如果是多个字符或包含空格，建议添加引号。

携带 `-F` 选项的典型调用范式如下：

```
awk -F: 'commands' input-file
```

文本文件 data1 内容如下：

```
$ cat data1
P.Bunny # 02/99 # 48   # Yellow
J.Troll # 07/99 # 4842 # Brown-3
```

执行 awk 命令，`-F` 指定按 `#` 分割域，输出如下：

```
$ awk -F '#' '{print $1,$2,$3,$4}' data1
P.Bunny   02/99   48     Yellow
J.Troll   07/99   4842   Brown-3
```

参照下表，awk 每次在文件中读一行，找到域分隔符（`#`），设置其为域n，直至遇到记录分隔符（`RS` 默认是换行符 `\n`）结束。
然后，awk 再次启动下一行读取下一条记录。

| 域1     | 分隔符  | 域2   | 分隔符   | 域3   | 分隔符  | 域4     | RS |
| --------| ------ | ------| ------ | ---- | ------ | --------|----|
| P.Bunny | #      | 02/99 | #      | 48   | #      | Yellow  | \n |
| J.Troll | #      | 07/99 | #      | 4842 | #      | Brown-3 | \n |

awk 的 `-F` 选项可指定任何合法的字符串作为域分割符，对数据记录进行切割提取分析。  
典型的使用场景是利用 grep 或 sed 从文本中筛选出匹配指定模式的行，再重定向给 awk 进行切割提取指定域。  

[sed-awk-demo](../demo/sed-awk-demo.md) 中有大量 sed 与 awk 结合使用的场景示例。 

[awk - 10 examples to insert / remove / update fields of a CSV file](https://www.theunixschool.com/2012/11/awk-examples-insert-remove-update-fields.html)  

[关于使用shell在文件中查找一段字符串的问题](https://bbs.csdn.net/topics/380208443)

指定 FS=AAA，基于 AAA 分割前半部分：

```
$ echo "12312312343242AAAdfasdfasdfasdfasdfadAAAfsdgfsdfgfgfgdfgasdfg" | awk -F "AAA" '{print $1}'
12312312343242
```

指定 FS=AAA，基于 AAA 分割后半部分：

```
$ echo "12312312343242AAAdfasdfasdfasdfasdfadAAAfsdgfsdfgfgfgdfgasdfg" | awk -F "AAA" '{print $2}'
dfasdfasdfasdfasdfad
```

#### csv 文件解析

CSV（Comma-Separated Values）即逗号分隔值，有时也称为字符分隔值。
因为分隔字符也可以不是逗号，其文件以纯文本形式存储表格数据（数字和文本）。

在 CSV 文本文件中，每条记录占一行，每一行以逗号作为为分隔符，逗号前后的空格会被忽略。

[linux awk解析csv文件](https://www.cnblogs.com/htlee/p/4701961.html)  

读取CSV第1行即表头：

```
$ awk 'FNR==1' dependence.csv
SubModule,Header,Class,Method,Macro
```

读取所有记录的第1列：

```
awk -F ',' 'FNR>1{print $1}' dependence.csv
```

对第1列进行去重输出：

```
awk -F ',' 'FNR>1{print $1}' dependence.csv | uniq
```

对第1列进行合并统计和去重统计：

```
awk -F ',' 'FNR>1{print $1}' dependence.csv | uniq -c
awk -F ',' 'FNR>1{print $1}' dependence.csv | uniq | wc -l
```

## 结构化流程控制

awk 编程语言支持常见的结构化流程控制。

### if

假如想看看哪些学生可以获得升段机会，需要判断目前级别分 field-6 是否小于（`<`）最高分 field-7。

```
#不指定动作时，默认打印匹配行。
$ awk '$6<$7' grade.txt
M.Tansley   05/99   48311   Green       8   40  44
J.Lulu      06/99   48317   green       9   24  26
```

以上命令等效的 `pattern { action }` 简约格式为 `awk '$6<$7 {print $0}' grade.txt`。

在 body 部分，用 if 条件判断的完整格式为：

```
awk '{if($6<$7) print $0}' grade.txt
```

- 筛选 field-6 小于 27 的条目: `awk '$6<27' grade.txt`；  
- 判断小于等于（`<=`）：`awk '$6<=$7 {print $1}' grade.txt`；  
- 判断大于（`>`）：`awk '$6>$7 {print $1}' grade.txt`；  

---

以下筛选出低于平均成绩的记录，并输出一句鼓励的话：

```
# pattern { action } 格式
$ awk '$6<$7 {print $1, "Try better at the next comp"}' grade.txt
M.Tansley Try better at the next comp
J.Lulu Try better at the next comp
```

在 body 部分，用 if 条件判断的完整格式为：

```
awk '{if($6<$7) print $1, "Try better at the next comp"}' grade.txt
```

#### 修改域值

以上 awk 语句针对 M.Tansley 修改其成绩并 print，其他人直接 print 第1、6、7列。
修改域值动作受条件限制，print 动作不受条件限制。

```
$ #awk '{if($1=="M.Tansley") $6=$6-1; print $1,$6,$7}' grade.txt
$ awk '$1=="M.Tansley" {$6=$6-1} {print $1,$6,$7}' grade.txt
M.Tansley 39 44
J.Lulu 24 26
P.Bunny 35 28
J.Troll 26 26
L.Tansley 30 28
```

如果只想打印修改的条目，可将 print 约束到条件判断才执行：

```
# #awk '{if($1=="M.Tansley") {$6=$6-1; print $1,$6,$7}}' grade.txt
$ awk '$1=="M.Tansley"{$6=$6-1; print $1,$6,$7}' grade.txt
M.Tansley 39 44
```

修改文本域即对其重新赋值，需要做的就是赋给一个新的字符串。  
在 J.Troll 中加入字母，使其成为 J.L.Troll，表达式为 `$1="J.L.Troll"`，记住字符串要使用双引号（`""`），并用圆括号（`()`）括起整个赋值语句。

```
$ #awk '{if($1=="J.Troll") ($1="J.L.Troll"); print $1}' grade.txt
$ awk '$1=="J.Troll" { ($1="J.L.Troll") } { print $1}' grade.txt
M.Tansley
J.Lulu
P.Bunny
J.L.Troll
L.Tansley
```

修改一下，只打印修改部分：

```
$ #awk '{if($1=="J.Troll") { ($1="J.L.Troll"); print $1 } }' grade.txt
$ awk '$1=="J.Troll" { ($1="J.L.Troll"); print $1 }' grade.txt
J.L.Troll
```

#### 创建新域

在 awk 中处理数据时，基于各域进行计算时创建新域是一种好习惯。  
创建新域要通过其他域赋予新域标识符，如创建一个基于其他域的加法新域 `{$4=$2+$3}`，这里假定记录包含3个域，则域4为新建域，保存域2和域3相加结果。  
以下示例，在文件 grade.txt 中创建新域8保存域目前级别分与域最高级别分的减法值，表达式为 `{$8=$7-$6}`。

```
$ #awk 'BEGIN{print "Name\t Difference"} {if($6<$7){$8=$7-$6; print $1,$8}}' grade.txt
$ awk 'BEGIN{print "Name\t   Difference"} $6<$7 {$8=$7-$6; printf "%-10s %s\n",$1,$8}' grade.txt
Name	   Difference
M.Tansley  4
J.Lulu     2
```

### for

for 语句是许多编程语言执行循环的常见方法。
awk编程语言支持C风格的for循环。

```
for( variable assignment; condition; iteration process)
```

将多个功能合并到一个语句有助于简化循环。

示例1：for 循环数组元素

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
```

示例2: for 循环统计每条记录域5和域6平均值。

```
awk '{
    total = 0
    for (i=5; i<7; i++)
    {
        total += $i
    }
    avg = total / 2
    print "Average:",avg
}' grade.txt
Average: 24
Average: 16.5
Average: 23.5
Average: 19
Average: 21
```

### while

while 语句为 awk 程序提供了一个基本的循环功能。下面是while语句的格式。

```
while (condition) { statements }
```

while 循环允许遍历一组数据，并检查迭代的结束条件。

以下示例统计每一条记录中各个域加和平均值：

```
$ cat data5
130 120 135
160 113 140
145 170 215

$ awk '{
    total = 0
    i = 1
    while (i <= NF)
    {
        total += $i
        i++
    }
    avg = total / 3
    print "Average:",avg
}' data5
Average: 128.333
Average: 137.667
Average: 176.667
```

> awk 编程语言支持在 while 循环中使用 `break` 语句和 `continue` 语句，允许从循环中跳出。

#### do-while

do-while 语句类似于 while 语句，但会在检查条件语句之前执行命令。

下面是 do-while 语句的格式。

```
do {
    statements
} while (condition)
```

这种格式保证了语句会在条件被求值之前至少执行一次。  
当需要在求值条件前执行语句时，这个特性非常方便。

## 格式化输出控制

gawk [Examples Using printf](https://www.gnu.org/software/gawk/manual/html_node/Printf-Examples.html)  
[How can I format the output of a bash command in neat columns](https://stackoverflow.com/questions/6462894/how-can-i-format-the-output-of-a-bash-command-in-neat-columns)  

print 打印语句的多个部分（常量和变量）之间要用逗号分隔，逗号前后会自动添加空行：

```
$ awk '{if($6<$7) print $1, "Try better at the next comp"}' grade.txt
M.Tansley Try better at the next comp
J.Lulu Try better at the next comp
```

> 以上如果不加逗号，Try 和前面的名称会连在一起。

以下 `"NR="NR`，常量串和变量（不用$符号引用）可以连在一起不用插入逗号。

```
$ awk 'BEGIN{FS=","} {print $1,"FNR="FNR,"NR="NR}' data1 data1
```

for 循环示例中的 `print "Index:",test," - Value:",var[test]` 中间那个空行可以省掉。

调用 print 打印多行时，每条 print 语句以分号指示结束：

```
$ awk 'BEGIN {print "The data2 File Contents:"; print "=========="}
$ awk 'END {print "end-of-record, NR="NR}' data1
```

### 格式化输出（printf）

如果要创建详尽的报表，可以使用格式化打印命令 `printf`，为数据选择特定的格式和位置进行输出。  
如果你熟悉C语言编程的话，awk 中的 printf 命令用法也是一样，允许指定具体如何显示数据的指令。  

```
    print [ expression-list ] [ > expression ]
    printf format [ , expression-list ] [ > expression ]
```

`printf` 命令格式：

```
    printf "format string", var1, var2, ...
```

`format string` 是格式化输出的关键，它会用文本元素和格式化指定符来具体指定如何呈现格式化输出。  

格式化指定符是一种特殊的代码，会指明显示什么类型的变量以及如何显示。
awk 程序会将每个格式化指定符作为占位符，供命令中的变量使用。第一个格式化指定符对应列出的第一个变量，第二个对应第二个变量，依此类推。

`格式化指定符` 采用如下格式：

```
%[modifier]control-letter
```

以下用科学计数法输出 `10*100` 的计算结果：

```
$ awk 'BEGIN{
  x = 10 * 100;
  printf "The answer is: %e\n", x
}'
The answer is: 1.000000e+03
```

以下示例强制第一个字符串的输出宽度为16个字符，并且左对齐。

```
$ awk 'BEGIN{FS="\n"; RS=""} {printf "%-16s %s\n", $1, $4}' data2
Riley Mullen     (312)555-1234
Frank Williams   (317)555-9876
Haley Snell      (313)555-4938
```

### 格式化字符串（sprintf）

`sprintf` 函数用提供的 format 和 variables 返回一个类似于 printf 格式输出的字符串。

```
    sprintf(fmt, expr, ... )
        the string resulting from formatting expr ...  according to the printf(3) format fmt
```
