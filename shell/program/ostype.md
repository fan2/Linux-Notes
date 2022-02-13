
本文列举了一些获取系统类型和版本信息的命令和方式。

## uname

```Shell
# macOS
$ uname
Darwin
$ uname -mrs
Darwin 20.6.0 x86_64
$ uname -a
Darwin THOMASFAN-MB1 20.6.0 Darwin Kernel Version 20.6.0: Thu Jan 20 21:02:14 PST 2022; root:xnu-7195.141.20~1/RELEASE_X86_64 x86_64
```

```Shell
# ubuntu
$ uname
Linux
$ uname -mrs
Linux 5.13.0-1016-raspi aarch64
$ uname -a
Linux rpi4b-ubuntu 5.13.0-1016-raspi #18-Ubuntu SMP PREEMPT Thu Jan 20 08:53:01 UTC 2022 aarch64 aarch64 aarch64 GNU/Linux
```

```Shell
# raspbian
pi@raspberrypi:~$ uname
Linux

pi@raspberrypi:~$ uname -mrs
Linux 4.9.41-v7+ armv7l

pi@raspberrypi:~ $ uname -a
Linux raspberrypi 4.9.41-v7+ #1023 SMP Tue Aug 8 16:00:15 BST 2017 armv7l GNU/Linux
```

## OSTYPE

```Shell
# macOS
$ echo $OSTYPE
darwin20.0

# ubuntu
$ echo $OSTYPE
linux-gnu

# raspbian
$ echo $OSTYPE
linux-gnueabihf
```

## /proc/version

```Shell
# macOS 不存在
$ cat /proc/version
cat: /proc/version: No such file or directory
$ echo $?
1

# ubuntu
$ cat /proc/version
Linux version 5.13.0-1016-raspi (buildd@bos02-arm64-077) (gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37) #18-Ubuntu SMP PREEMPT Thu Jan 20 08:53:01 UTC 2022

# raspbian
$ cat /proc/version
Linux version 4.9.41-v7+ (dc4@dc4-XPS13-9333) (gcc version 4.9.3 (crosstool-NG crosstool-ng-1.22.0-88-g8460611) ) #1023 SMP Tue Aug 8 16:00:15 BST 2017
```

## /etc/issue

```Shell
# macOS 不存在
$ cat /etc/issue
cat: /etc/issue: No such file or directory

# ubuntu
$ cat /etc/issue
Ubuntu 21.10 \n \l

# raspbian
$ cat /etc/issue
Raspbian GNU/Linux 9 \n \l
```

## get_ostype

[Bash: Check Operating System is Mac](https://remarkablemark.org/blog/2020/10/31/bash-check-mac/)

```Shell
[[ $OSTYPE == 'darwin'* ]] && echo 'macOS'
```

[Detect operating system in shell script](https://megamorf.gitlab.io/2021/05/08/detect-operating-system-in-shell-script/)

[How to detect the OS from a Bash script?](https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script)

- [如何从Bash脚本中检测操作系统？](https://blog.csdn.net/asdfgh0077/article/details/104083650)  
- [检测三种不同操作系统的Bash脚本](https://www.cnblogs.com/fnlingnzb-learner/p/10657285.html)  

具体参考整理的 [get_ostype.sh](../script/codes/get_ostype.sh)。
