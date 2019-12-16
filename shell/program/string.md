
bash shell 中可通过等号（equality sign）赋值定义变量，右值如果没有引号（单/双）引用，默认都是按照字符串类型。

```Shell
faner@MBP-FAN:~|⇒  testString=define
faner@MBP-FAN:~|⇒  echo $testString
define
```

但是当右值句段遇到 **元字符**（metacharacter） 时，将自动截取第一段分组作为右值，后续句段将按照新的命令解析执行。

关于 bash shell 的元字符参考 `man 1 bash` 中 DEFINITIONS 部分的定义：

```Shell
DEFINITIONS

metacharacter
 A character that, when unquoted, separates words. One of the following:

| & ; ( ) < > space tab newline
```

以下第一个空格将右值截段，实际有效的赋值命令1为 `testString=define` ，正常有效执行；  
string 为命令2，由于找不到 `string` 命令而提示报错。

```Shell
faner@MBP-FAN:~|⇒  testString=define string in shell command line
zsh: command not found: string
faner@MBP-FAN:~|⇒  echo $testString 
define
```

如果每个分组都为有效可执行命令，一般会依次执行。

> 参考下文的 `test1='test 1' test2='test 2'` 测试用例。  

但以下示例忽略了第一条赋值命令，而只执行了第2条 cd 命令？

```Shell
faner@MBP-FAN:~|⇒  testShellVar=string cd ~/Downloads
faner@MBP-FAN:~/Downloads|⇒  echo $testShellVar

faner@MBP-FAN:~/Downloads|⇒  
```

---

另外一种常见写法是利用单反斜杠 `\\` 转义掉空格等元字符含义，显式声明采用原生字符义。

```Shell
# 原义空格
pi@raspberrypi:~ $ testString=define\ string\ in\ shell\ command\ line
pi@raspberrypi:~ $ echo $testString 
define string in shell command line

# 原义空格和分号
faner@MBP-FAN:~|⇒  testShellVar=string\;\ cd\ ~/Downloads
faner@MBP-FAN:~|⇒  echo $testShellVar 
string; cd ~/Downloads
faner@MBP-FAN:~|⇒  
```

## QUOTING

除了利用单反斜杠 `\\` 转义掉空格等元字符含义，显式声明采用原生字符义外，一种更普适的方案是**引用**。

通过单引号（`'single_quoting'`）或双引号（`"double_quoting"`）来封闭引用是编程语言中常见的字符串定义方式。

```obc-c
QUOTING

Quoting is used to remove the special meaning of certain characters or words to the shell. Quoting can be used to disable special treatment for special characters, to prevent reserved words from being recognized as such, and to prevent parameter expansion.

Each of the metacharacters listed above under DEFINITIONS has special meaning to the shell and must be quoted if it is to represent itself.
```

定义包含空格和分号等元字符的字符串：

```Shell
# 单引号定义字符串
pi@raspberrypi:~ $ testString='define string in shell command line'
pi@raspberrypi:~ $ echo $testString 
define string in shell command line

# 双引号重定义字符串
faner@MBP-FAN:~|⇒  testShellVar="string cd ~/Downloads"
faner@MBP-FAN:~|⇒  echo $testShellVar 
string cd ~/Downloads
```

引述包含空格的文件名：

```Shell
# 单引号引用
mv 'a ~file name.txt' another.txt

# 双引号引用
mv "a ~file name.txt" another.txt
```

## subcmd

通过单引号闭包的字符串中的所有字符都采用原义，但是中间不能出现单引号自身，即使采用反斜杠（backslash）也无法转义（escape）。

```Shell
Enclosing characters in single quotes preserves the literal value of each character within the quotes. A single quote may not occur between single quotes, even when preceded by a backslash.
```

通过双引号闭包的字符串中的 $、\`、\\ 等字符将具有特殊意义。

```Shell
Enclosing characters in double quotes preserves the literal value of all characters within the quotes, with the exception of $, `, \, and, when history expansion is enabled, !.
```

### $

单引号将其闭包字符串中的 `$` 视作普通字符，不会替代解引用变量值：

```Shell
pi@raspberrypi:~ $ varLANG='env LANG=$LANG'
pi@raspberrypi:~ $ echo $varLANG 
env LANG=$LANG
```

双引号可识别闭包字符串中的特殊字符 `$`，解引用变量值并替换。

```Shell
pi@raspberrypi:~ $ varLC_CTYPE="LC_CTYPE = $LC_CTYPE"
pi@raspberrypi:~ $ echo ${varLC_CTYPE}
LC_CTYPE = UTF-8
```

双引号中若要打印普通的 `$` 符号，可使用反斜杠 `\$` 转义为普通字符。

```Shell
pi@raspberrypi:~ $ varLC_CTYPE="LC_CTYPE = \$LC_CTYPE"
pi@raspberrypi:~ $ echo ${varLC_CTYPE}
LC_CTYPE = $LC_CTYPE
```

以下右值引用中的 `$testPATH` 和 `${testPATH}` 可加双引号。

```Shell
# testPATH 初始值
pi@raspberrypi:~ $ testPATH=/usr/bin:/bin:/usr/sbin:/sbin

# 头部插入
pi@raspberrypi:~ $ testPATH=/usr/local/bin:$testPATH

# 尾部追加
pi@raspberrypi:~ $ testPATH=${testPATH}:/usr/local/sbin
```

以下 [brew 的官网首页](http://brew.sh/index.html) 给出的 Homebrew 安装命令：

```Shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

1. 调用 **curl** 下载 Homebrew 的 安装脚本 [install.rb](https://github.com/Homebrew/install/blob/master/install)  

	> `-f`, --fail: (HTTP)  Fail  silently (no output at all) on server errors.  
	> `-s`, --silent: Silent or quiet mode. Don't show progress meter or  error  messages. Makes  Curl mute.  
	> `-S`, --show-error: When used with -s, --silent, it makes curl show an error message if it fails.  
	> `-L`, --location: (HTTP)  If  the  server  reports  that the requested page has moved to a different location (indicated with a Location: header and a 3XX response code), this  option will  make  curl  redo  the  request  on  the new place.  

2. 调用 **ruby** 执行下载的安装脚本（install.rb）。

	> `-e` 'command': one line of script.  

以下选自 [清华大学开源软件镜像站](https://mirror.tuna.tsinghua.edu.cn/) 的 [Homebrew 镜像使用帮助](https://mirror.tuna.tsinghua.edu.cn/help/homebrew/)：

```Shell
# $(brew --repo) 可加双引号
faner@THOMASFAN-MB0:~|⇒  cd $(brew --repo)
faner@THOMASFAN-MB0:/usr/local/Homebrew|stable

# $(brew --repo) 可加双引号
⇒  cd $(brew --repo)/Library/Taps/homebrew/homebrew-core
faner@THOMASFAN-MB0:/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core|master
⇒  
```

### \`

在 shell 命令中，往往需要将其他命令执行结果作为输入信息，此时可使用 “\`command\`” 或 “$(command)” 引用 command 执行结果。

Linux Distributions 都可能拥有多个内核版本，且几乎 distribution 的所有内核版本都不相同。  
若想进入当前内核的模块目录，可以先执行 `uname -r` 获取发行版本信息（-r, --kernel-release），然后 cd 进入目前内核的驱动程序所放位置。

```Shell
pi@raspberrypi:~ $ uname -r
4.9.59-v7+
pi@raspberrypi:~ $ cd /lib/modules/`uname -r`/kernel
pi@raspberrypi:/lib/modules/4.9.59-v7+/kernel $ ls
arch  crypto  drivers  fs  kernel  lib  mm  net  sound
pi@raspberrypi:/lib/modules/4.9.59-v7+/kernel $ ls | wc -l
9
```

以上 \`uname -r\` 可替换为 `$(uname -r)` 或 `"$(uname -r)"`。

1. 先执行反单引号内的命令 `uname -r` 获取内核版本为 `4.9.59-v7+`；  
2. 将上述结果代入 cd 命令的目录中，得到实际命令 `/lib/modules/4.9.59-v7+/kernel`。  

鉴于反单引号容易打错或弄错，建议使用 **`$(uname -r)`** 这种解引用格式。

相比反引号，`$()` 可以区分左右，因此支持嵌套。

---

以下为查看和复位（reset） `brew --repo` 的 git url 信息：

```
git -C `brew --repo` remote get-url origin

git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git

brew update
```
