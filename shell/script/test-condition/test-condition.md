## if

### if-then

最基本的结构化命令就是 if-then 语句。

`if-then` 语句格式如下:

```
if command
then
    commands
fi
```

如果该命令的退出状态码是0（该命令成功运行），位于 then 部分的命令就会被执行。
如果该命令的退出状态码是其他值，then 部分的命令就不会被执行，bash shell 会继续执行脚本中的下一个命令。
`fi` 语句用来表示 `if-then` 语句到此结束。

---

你可能在有些脚本中看到过 if-then 语句的另一种形式：

```
if command; then
    commands
fi
```

通过把分号放在待求值的命令尾部，就可以将 then 语句放在同一行上了，这样看起来更像其他编程语言中的 if-then 语句。

### if-then-else

当 if 语句中的命令返回退出状态码0时，then 部分中的命令会被执行，这跟普通的 if-then 语句一样。
当 if 语句中的命令返回非零退出状态码时，bash shell 会执行 else 部分的命令。

```
if command
then
    commands
else
    commands
fi
```

### elif

可以使用 else 部分的另一种形式：`elif`。
elif 使用另一个 if-then 语句延续 else 部分，这样就不用再书写多个 if-then 语句了。

```
if command1
then
    commands
elif command2
then
    more commands
fi
```

elif 语句行提供了另一个要测试的命令，这类似于原始的 if 语句行。
如果 elif 后命令的退出状态码是0，则 bash 会执行第二个 then 语句部分的命令。
使用这种嵌套方法，代码更清晰，逻辑更易懂。

## test

到目前为止，在 if 语句中看到的都是普通 shell 命令。
你可能想问，if-then 语句是否能测试命令退出状态码之外的条件。
答案是不能。

但在 bash shell 中有个好用的工具可以帮你通过 if-then 语句测试其他条件。

**test** 命令提供了在 if-then 语句中测试不同条件的途径。

- 如果 test 命令中列出的条件成立， test 命令就会退出并返回退出状态码0。这样 if-then 语句就与其他编程语言中的 if-then 语句以类似的方式工作了。
- 如果条件不成立，test 命令就会退出并返回非零的退出状态码，这使得 if-then 语句不会再被执行（或执行 elif/else 部分）。

test 命令的格式非常简单：

```
test condition
```
condition 是 test 命令要测试的一系列参数和值。

当用在 if-then 语句中时，test 命令看起来是这样的：

```
if test condition
then
    commands
fi
```

如果不写 test 命令的 condition 部分，它会以非零的退出状态码退出，并执行 elif/else 语句块。

bash shell 提供了另一种条件测试方法，无需在 if-then 语句中声明 test 命令。

```
if [ condition ]
then
    commands
fi
```

**方括号** 定义了测试条件。

注意，第一个方括号之后和第二个方括号之前必须加上一个空格，否则就会报语法错。

test命令可以判断三类条件：

- 数值比较  
- 字符串比较  
- 文件比较  

## case

你会经常发现自己在尝试计算一个变量的值，在一组可能的值中寻找特定值。
在这种情形下，你不得不写出很长的 if-then-else 语句。
elif 语句继续 if-then 检查，为比较变量寻找特定的值。

有了 case 命令，就不需要再写出所有的 elif 语句来不停地检查同一个变量的值了。
**case** 命令会采用列表格式来检查单个变量的多个可能取值。

```
case variable in
    pattern1 | pattern2) commands1;;
    pattern3) commands2;;
    *) default commands;;
esac
```

case 命令会将指定的变量与不同模式进行比较。
如果变量和模式是匹配的，那么 shell 会执行为该模式指定的命令。
可以通过竖线操作符在一行中分隔出多个模式模式。
星号会捕获所有与已知模式不匹配的值。
