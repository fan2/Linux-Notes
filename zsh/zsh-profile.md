
## man

关于 zsh 的加载、启动和运作机制，建议通过 `man zsh` 手册。

可以阅读 INVOCATION、COMPATIBILITY、RESTRICTED SHELL 相关章节内容。

## FILES

参考 man bash 相关配置 [bash-FILES](./../profile/bash-FILES.md)、[macOS Env PATH](./../profile/macOS%20Env%20PATH.md) 的讨论。

关于 zsh 的启动加载配置流程机制，可以阅读 `man zsh` 手册中的 STARTUP/SHUTDOWN FILES、FILES 等章节。

```Shell
$ man zsh

FILES
       $ZDOTDIR/.zshenv
       $ZDOTDIR/.zprofile
       $ZDOTDIR/.zshrc
       $ZDOTDIR/.zlogin
       $ZDOTDIR/.zlogout
       ${TMPPREFIX}*   (default is /tmp/zsh*)
       /etc/zshenv
       /etc/zprofile
       /etc/zshrc
       /etc/zlogin
       /etc/zlogout    (installation-specific - /etc is the default)
```

If `ZDOTDIR` is unset, `HOME` is used instead. Files listed above as being in `/etc` may be in another direc- tory, depending on the installation.

> 未设置环境变量 ZDOTDIR，默认就是 HOME 目录。

系统级配置文件 `/etc/zprofile` 和 `/etc/zshrc` 中有内容。

## startup

[Customizing the bash shell and its startup files](https://www.maths.cam.ac.uk/computing/linux/bash/adding)

[ohmyzsh/plugins/profiles/](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/profiles) allows you to create separate configuration files for zsh based on your long hostname (including the domain).
