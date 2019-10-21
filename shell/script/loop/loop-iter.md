
## for

for 命令允许创建一个遍历一系列值的循环，每次迭代都使用其中一个值来执行已定义好的一组命令。

```
for var in {list}
do
    command1
    command2
    ...
done
```

> 在 list 参数中，你需要提供迭代中要用到的一系列值。

### args

在 for 循环中省去 in 列表选项时，它将接受命令行位置参数作为参数，等效于：

```
for params in "$@"
```

或

```
for params in "$*"
```

## while

while 命令某种意义上是 if-then 语句和 for 循环的混杂体。

while 命令允许定义一个要测试的命令，然后循环执行一组命令，只要定义的测试命令返回的是退出状态码为0。
它会在每次迭代的一开始测试 test 命令，在 test 命令返回非零退出状态码时，while 命令会停止执行那组命令。

```
while test command
do
    other commands
done
```

## until

和 while 命令类似，你可以在 until 命令语句中放入多个测试命令。
只有最后一个命令的退出状态码决定了 bash shell 是否执行已定义的 other commands。

1. 只有测试命令的退出状态码 **不为0**，bash shell 才会执行循环中列出的命令。
2. 当首次测试命令的退出状态码为0时，将一次也不执行循环体。

```
until test commands
do
    other commands
done
```
