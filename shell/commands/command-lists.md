# Lists(;, &&, ||)

## continuous

使用空格或分号（**`;`**）可执行无相关性的连续命令：

```
faner@FAN-MB0:~|⇒  test1='test 1' test2='test 2'
faner@FAN-MB0:~|⇒  echo $test1
test 1
faner@FAN-MB0:~|⇒  echo $test2
test 2
faner@FAN-MB0:~|⇒  echo $test1;echo $test2
test 1
test 2

faner@MBP-FAN:~|⇒  testShellVar=string; cd ~/Downloads
faner@MBP-FAN:~/Downloads|⇒  echo $testShellVar 
string
faner@MBP-FAN:~/Downloads|⇒ 
```

> Commands separated by a `;` are executed sequentially

## AND/OR

**`&&`** 和 **`||`** 则可连续执行相关性的命令。

> AND and OR lists are sequences of one or more pipelines separated by the **&&** and **||** control operators, respectively. AND and OR lists are executed with left associativity.

`command1 || command2`：在逻辑上只要有第一条命令执行成功就不会执行第二条命令，只有第一条命令执行失败才会启动执行第二条命令。

> command2 is executed if and only if command1 returns a non-zero exit status.

`command1 && command2`：只有在第一条命令执行成功时才会启动执行第二条命令。

> command2 is executed if, and only if, command1 returns an exit status of zero.

```Shell
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master
```

`mkdir homebrew` 正确执行完毕，即成功创建目录 `homebrew`，才会启动执行后面的 `curl -L` 命令。  

这些符号为 BASH 的 token(control operator)。
