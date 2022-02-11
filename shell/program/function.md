
## 函数定义

bash shell 提供函数支持，方便将代码模块封装为函数，以便复用。

有两种创建函数的格式：

1. 函数名加括号；  
2. 采用关键字 function，后跟函数名；  

```
#方式1
name() {
    commands
}

#方式2
function name {
    commands
}
```

### 函数调用

在脚本中使用函数，只需要像其他shell命令一样，在行中指定函数名就行，无需括号。
如果想传递参数，直接通过空格分割指定位置参数即可。

### 函数参数

参考 [basic](./basic.md) 中的命令行参数。

对于脚本，`$0` 为脚本名称；对于函数调用，`$0` 为函数名称。
空格相间的 $1,...,$9 为函数的位置参数，如果参数个数超过9个，可以以 `${10}`,`${11}` 这种形式引用。

1. `$#`：参数个数；  
2. `$1`、`$2`、...、`$9`，`${10}`、`${11}`、...：顺序位置参数；  
3. `${!#}` 代表最后一个参数；  

如果脚本的所有命令行参数，需要传递给函数，可通过 `func $@` 或 `func $*` 形式传递。

### 函数返回

bash shell 会把函数当作一个小型脚本，运行结束时会返回一个退出状态码。
函数的退出状态码，实际上是最后一条命令执行的退出状态。
可以用标准变量 `$?` 来获取函数调用的返回状态码。

也可以用 return 命令指定返回一个 0～255 之间的整数值。
然后调用方通过 `if [ $? -eq 0 ]` 测试函数返回值。

如果想返回超过256的整数值或字符串类型，则可以考虑使用函数输出。

### 函数输出

正如可以这样 result=`dbl` 将命令的输出保存到shell变量中一样，也可以对函数的输出采用同样的处理办法。
下面是在脚本中使用这种方法的例子。

```Shell
#!/bin/bash
# using the echo to return a value

function dbl
{
    read -p "Enter a value: " value
    echo $[ $value * 2 ]
}

result=$(dbl)
echo "The new value is $result"
```

dbl 函数会用 echo 语句来显示计算的结果。

## 跨脚本调用

[Shell 脚本调用另一个脚本的三种方法](https://blog.csdn.net/K346K346/article/details/86751705)  

source、点号以及sh命令

[在 Shell 脚本中调用另一个 Shell 脚本的三种方式](https://blog.csdn.net/simple_the_best/article/details/76285429)  

- fork: 如果脚本有执行权限的话，`path/to/foo.sh`。如果没有，`sh path/to/foo.sh`。  
- exec: `exec path/to/foo.sh`  
- source: `source path/to/foo.sh`  

### 跨脚本调用函数

[Bash编程入门-4：函数](https://zhuanlan.zhihu.com/p/59528626)

`source` 命令的作用是在同一个进程中执行另一个文件中的Bash脚本。
在Bash中使用 `source` 命令，可以实现函数的跨脚本调用。

比如说，有两个脚本 `my_info.bash` 和 `app.bash`。

脚本my_info.sh中的内容是：

```Shell
#!/bin/bash

function my_info()
{
    lscpu >> $1
    uname –a >> $1
    free –h >> $1
}
```

脚本 `app.bash` 中的内容是：

```Shell
#!/bin/bash

source ./my_info.bash  #引入另一个脚本
my_info output.file    #调用另一个脚本中的函数
```

运行 app.bash 时，执行到 source 命令那一行时，就会执行 my_info.bash 脚本。
在 app.bash 的后续部分，就可以调用 my_info.bash 中的 my_info 函数。

如果不是在脚本所在目录，而是在外层目录执行sh，那么 source 引入脚本需要相对路径。

除了绝对路径，安全引入同目录下的其他脚本的写法如下：

```Shell
#!/bin/bash

source $(dirname $0)/aux_etc.sh

```

### 脚本封装函数

```Shell
~/Projects/shell | cat test-function.sh
#!/bin/bash

use_python38()
{
	echo "which python3 = `which python3`"
	export PATH=/usr/local/opt/python@3.8/bin:$PATH
	echo "use_python38..."
	echo "which python3 = `which python3`"
}

file_name=$0
script_dir=$(dirname $0)
script_name=$(basename $0)
echo "file_name=$file_name"
echo "script_dir=$script_dir"
echo "script_name=$script_name"
```

执行加载脚本到当前 shell：

```Shell
~/Projects/shell | ./test-function.sh
file_name=./test-function.sh
script_dir=.
script_name=test-function.sh

# 回退一级执行该sh，查验相对路径
~/Projects/shell | cd ..
~/Projects | ./shell/test-function.sh
file_name=./shell/test-function.sh
script_dir=./shell
script_name=test-function.sh
```

可以在终端命令行source引入脚本然后调用，以便在当前 shell 启用 python3.8：

```Shell
~ | source ~/Projects/shell/test-function.sh
~ | use_python38
which python3 = /usr/local/bin/python3
use_python38...
which python3 = /usr/local/opt/python@3.8/bin/python3
```
