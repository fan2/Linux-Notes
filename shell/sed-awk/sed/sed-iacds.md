
- i: insert before;  
- a: append after;  
- c: change line;  
- d: delete line;  

## i(nsert)

插入命令（insert）在指定行之前插入新行。  
插入文本时，不能指定范围，只允许通过一个地址模式指定插入位置。  

debian/raspberrypi 下可单行输入；  
macOS 下单行执行提示 `\` 后不能有内容：

```
$ echo "Test Line 2" | sed 'i\Test Line 1'
sed: 1: "i\Test Line 1": extra characters after \ at the end of i command
FAIL: 1
```

需要在 `\` 处换行，跨行折行输入：

```
$ echo "Test Line 2" | sed 'i\
pipe quote> Test Line 1'
Test Line 1Test Line 2

# 需要显式换行

$ echo "Test Line 2" | sed 'i\
pipe quote> Test Line 1
pipe quote> '
Test Line 1
Test Line 2
```

下面示例插入新行到文件的第三行前：

```
$ cat data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
```

```
# 需要显式换行
$ sed '3i\
quote> This is an inserted line.
quote> ' data6.txt
This is line number 1.
This is line number 2.
This is an inserted line.
This is line number 3.
This is line number 4.
```

### 插入多行

以下示例在所有find查找到的cpp文件头部补插一条标准的版权声明：

```
$ find . -name "*.cpp" -print0 | xargs -I file -0 sed -i '' '1i\
// Tencent is pleased to support the open source community by making Mars available.\
// Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.\

' file
```

> 注意：中间多行末尾需要添加反斜杠续行！

## a(ppend)

追加命令（append）在指定行之后添加新行。  
附加文本时，不能指定范围，只允许通过一个地址模式指定附加位置。  

debian/raspberrypi 下可单行输入；macOS 下需折行输入：

```
# 需要显式换行
$ echo "Test Line 2" | sed 'a\
pipe quote> Test Line 1
pipe quote> '
Test Line 2
Test Line 1
```

下面示例添加新行到文件的第三行后：

```
# 需要显式换行
$ sed '3a\
quote> This is an appened line.
quote> ' data6.txt
This is line number 1.
This is line number 2.
This is line number 3.
This is an appened line.
This is line number 4.
```

## c(hange)

修改命令（change）允许修改数据流中整行文本的内容。
它和插入、附加命令的工作机制一样，你必须在 sed 命令中单独指定新行。

debian/raspberrypi 下可单行输入；macOS 下需折行输入：

```
# 需要显式换行
$ sed '3c\
quote> This is a changed line.
quote> ' data6.txt
This is line number 1.
This is line number 2.
This is an changed line.
This is line number 4.
```

## d(elete)

删除命令（delete）可以删除文本流中的特定（匹配）行。

```
$ sed '3d' data6.txt
This is line number 1.
This is line number 2.
This is line number 4.
```

`sed '2,3d' data6.txt` : 删除特定行区间；  
`sed '/number 1/d' data6.txt` : 删除模式匹配行；  

`sed '3,$d' data6.txt` : 删除特定行至文末；  
`sed '/^$/d' data6.txt` : 删除空白行；  

### pattern range

`sed '/1/,/3/d' data6.txt` : 删除两个模式匹配区间的行；  

对于删除模式匹配区间行，第1个模式会 **打开** 行删除功能，第2个模式会 **关闭** 行删除功能。
sed 编辑器会删除两个指定行之间的所有行（包括指定的行）。

需要特别注意的是，只要匹配到了开始模式，删除功能就会打开。这可能导致意外的结果。
如果开始模式触发了删除，但是没有找到停止模式，那么会将数据流剩余行全部删除。

例如以下命令可以过滤打印 git 冲突文件中 ours 部分：

```
$ sed -n '/^<<<<<<< HEAD$/,/^=======$/p' Git-Conflict.h
```

但是将 p 替换为 d 命令，尝试删除 ours 部分？未能如愿，删除全文，输出为空。

---

[Sed – Deleting Multiline Patterns](https://gryzli.info/2017/06/26/sed-deleting-multiline-patterns/)

考虑工程根目录下有以下 code owner 的 CR 配置文件 `bak.code.yml`：

```
- path: /Classes/ui/DeviceMgr/PrinterTableView.h
  owners:
  - zhangsan
  - lisi
  - wangwu
  owner_rule: 1
- path: /Classes/ui/DeviceMgr/PrinterTableView.m
  owners:
  - zhangsan
  - lisi
  - wangwu
  owner_rule: 1
- path: /Classes/ui/DeviceMgr/PrinterDeviceCell.h
  owners:
  - zhangsan
  - lisi
  - wangwu
  owner_rule: 1
- path: /Classes/ui/DeviceMgr/PrinterDeviceCell.m
  owners:
  - zhangsan
  - lisi
  - wangwu
  owner_rule: 1

```

以下 sed 语句从 bak.code.yml 中查找匹配目录 `/Classes/ui/DeviceMgr/` 对应的 CR 规则区块：

```
sed -n '/- path: \/Classes\/ui\/DeviceMgr\//,/owner_rule/p' bak.code.yml
```

移除以上匹配的 CR owner 规则区块，并直接回写到原文件：

```
# 回写之前，备份到 bak.code.yml.bak
sed -i '.bak' '/- path: \/Classes\/ui\/DeviceMgr\//,/owner_rule/d' bak.code.yml

# 指定备份扩展名为空，即不备份
sed -i '' '/- path: \/Classes\/ui\/DeviceMgr\//,/owner_rule/d' bak.code.yml
```

## s(ubstitue)

替换命令（substitue）在行中替换文本。

```
s/pattern/replacement/flags

[address[，address]] s/pattern-to-find/replacement-pattern/[n g p w]
```

> 当 replacement 为空时，相当于删除效果。

有4种可用的替换标记：

- `n`：表明新文本将替换第几处模式匹配的地方；  
- `g`：表明新文本将会替换所有匹配的文本；  
- `p`：表明原先行的内容要打印出来，一般搭配 `-n` 使用；  
- `w`：file，将匹配替换的结果写到文件中。  

sed 中的 s 命令默认只替换每行中出现的第一处。

- `n` 标记可指定替换每行中出现的第n处；  
- `g` 标记指定替换每行中匹配的所有地方。  

以下示例，用 `s` 命令实现字符串替换：

```
$ echo "This is a test" | sed 's/test/big test/'
This is a big test
```

以下示例将文件中的 `dog` 替换为 `cat`。

```
$ cat detail.txt
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.

$ sed 's/dog/cat/' detail.txt
The quick brown fox jumps over the lazy cat.
The quick brown fox jumps over the lazy cat.
The quick brown fox jumps over the lazy cat.
The quick brown fox jumps over the lazy cat.
```

以下示例将 AAA 替换为空，相当于移除：

```
$ echo "12312312343242AAAdfasdfasdfasdfasdfadAAAfsdgfsdfgfgfgdfgasdfg" | sed 's/AAA//g'
12312312343242dfasdfasdfasdfasdfadfsdgfsdfgfgfgdfgasdfg
```

### 多个模式

当需要同时匹配多个模式时，可以使用连续重定向管道传递：

```
$ cat detail.txt | sed 's/brown/green/' | sed 's/dog/cat/'
```

执行两次 s 替换命令，多条命令之间用分号（`;`）隔开：

```
$ sed 's/brown/green/; s/dog/cat/' detail.txt
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
The quick green fox jumps over the lazy cat.
```

也可基于次提示符来跨行输入，每一行是一条独立命令，行尾不用输入分号。

```
$ sed '
quote> s/brown/green/
quote> s/fox/elephant/
quote> s/dog/cat/' detail.txt
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat.
The quick green elephant jumps over the lazy cat.
```

也可以使用 `-e` 选项：

```
$ sed -e 's/brown/green/' -e 's/fox/elephant/' -e 's/dog/cat/' detail.txt
```

### 替换字符

有时你会在文本字符串中遇到一些不太方便在替换模式中使用的字符。  
替换文件中的路径名会比较麻烦。例如，用 csh 替换 /etc/passwd 文件中的 bash：

```
sed 's/\/bin\/bash/\/bin\/csh/' /etc/passwd
```

由于正斜线通常用作字符串分隔符，因而如果它出现在了模式文本中的话，必须用反斜线来转义。  
sed 编辑器允许指定其他字符作为替换分隔标记符：

```
sed 's!/bin/bash!/bin/csh!' /etc/passwd
```

上述例子中，感叹号被用作字符串分隔符。

### 追加内容

如果想引用替换命令中匹配的模式部分，可以使用 `&` 符号引用。  

基于 `&` 符号引用，也可在匹配的模式前后附加内容。  
典型的例子是，对匹配的文本添加括号、引号等对称封闭标签。  

以下示例，给单词 cat 和 hat 添加双引号：

```
$ echo "The cat sleeps in his hat." | sed 's/.at/"&"/g'
The "cat" sleeps in his "hat".
```

#### before

在匹配部分的前面插入内容：

```
$ sed 's/line number/head &/g' data6.txt
This is head line number 1.
This is head line number 2.
This is head line number 3.
This is head line number 4.

$ sed 's/line number.*/head &/g' data6.txt
This is head line number 1.
This is head line number 2.
This is head line number 3.
This is head line number 4.
```

如果想在行首插入，则要这么写：

```
$ sed 's/.*line number.*/head &/g' data6.txt
head This is line number 1.
head This is line number 2.
head This is line number 3.
head This is line number 4.
```

#### after

在匹配部分的后面插入内容：

```
$ sed 's/line number/& tail/g' data6.txt
This is line number tail 1.
This is line number tail 2.
This is line number tail 3.
This is line number tail 4.
```

在行尾后面插入内容：

```
$ sed 's/line number.*/& tail/g' data6.txt
This is line number 1. tail
This is line number 2. tail
This is line number 3. tail
This is line number 4. tail
```

### 分组前向引用

`&` 符号会提取匹配替换命令中指定模式的整个字符串。但有时候可能只想提取这个字符串的一部分。

sed 编辑器用圆括号来定义替换模式中的子模式，替代表达式中用反斜杠和数字表明子模式位置。

```
$ echo "The System Administrator manual" | sed 's/\(System\) Administrator/\1 User/'
The System User manual

$ echo "That furry cat is pretty" | sed 's/furry \(.at\)/\1/'
That cat is pretty
$ echo "That furry hat is pretty" | sed 's/furry \(.at\)/\1/'
That hat is pretty
```

---

以下示例通过 sed 的正则循环匹配，在数字之间添加千位分隔符（Thousands Separators）。

Thousands-Separators

```
$ echo "12345678" | sed '{
pipe quote> :start
pipe quote> s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/
pipe quote> t start
pipe quote> }'
12,345,678
```

以上正则表达式匹配两个子模式：

1. 第一个子模式是以数字结尾的任务长度字符；  
2. 第二个子模式是三位数字；  

如果这两种模式匹配找到了，则在它们之间添加一个逗号：`12345,678` - `12,345,678`。

这里用到了跳转标签和测试命令：

1. 如果匹配成立，满足 t 测试条件，则回跳到标签 start 处循环执行下一次匹配。  
2. 直到最后一次，未匹配上不满足 t 测试条件，运行至大括号结束。  

### 综合示例

其他例程：

`sed 's/##*//g' dos.txt`：删除两个及以上的 `#` 号；  
`sed 's/^0*//g docs.txt'`：删除行首的0；  
`sed 's/^.//g docs.txt'`：删除第一个字符；  
`sed 's/-*//g docs.txt'`：删除横线-；  
`sed 's/^[0-9]//g docs.txt'`：删除行首的数字；  

`sed 's/\.$//g' docs.txt`：删除行为的句点；  
