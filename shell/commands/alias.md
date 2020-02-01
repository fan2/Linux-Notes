
## [alias](http://man7.org/linux/man-pages/man1/alias.1p.html)

alias — define or display aliases

```
OPERANDS         top
       The following operands shall be supported:

       alias-name
                 Write the alias definition to standard output.

       alias-name=string
                 Assign the value of string to the alias alias-name.

       If no operands are given, all alias definitions shall be written to standard output.
```

不带任何参数输入 `alias` 列举所有的关联命令。

```
➜  ~ type -a ls
ls is an alias for ls -G
ls is a shell function from /Users/ifan/.oh-my-zsh/custom/plugins/ls/ls.plugin.zsh
ls is /bin/ls

➜  ~ type -a ll
ll is an alias for ls -lh
ll is a shell function from /Users/ifan/.oh-my-zsh/custom/plugins/ls/ls.plugin.zsh
```

设置关联命令：

```
➜  ~ alias ll='ls -lh'
➜  ~ alias ctags="`brew --prefix`/bin/ctags"
➜  ~ alias prefs='open /System/Applications/System\ Preferences.app'
```

查看 ll 关联的命令：

```
➜  ~ alias ll
ll='ls -lh'
```

### [How to Create and Remove alias in Linux](https://linoxide.com/linux-how-to/create-remove-alias-linux/)

Create Permanent aliases

To define a permanent alias we must add it in `~/.bashrc` file.  
Also, we can have a separate file for all aliases (`~/.bash_aliases`) but to make this file to work we must append the following lines at the end of the `~/.bashrc` file, using any text editor:

```
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases # source
fi
```

Also we can use the following command to add alias without opening the `~/.bash_aliases` file

```
echo "alias vps='ssh user@ip_address_of_the_remote_server'" >> ~/.bash_aliases
```

this alias can help us to connect to our vps server via a three-letter command

Here are some examples of permanent aliases that can help in daily work

```
alias update='sudo -- sh -c "apt update && apt upgrade"'    # update Ubuntu distro
alias netstat='netstat -tnlp'                               # set default options for netstat command
alias vnstat='vnstat -i eth0'                               # set eth0 as an interface for vnstat
alias flush_redis='redis-cli -h 127.0.0.1 FLUSHDB'          # flush redis cache for wp
```

All created aliases will work next time we log in to via ssh or open new terminal. To apply aliases immediately we can use the following command:

```
source ~/.bash_aliases
# or
. ~/.bash_aliases
```

## [unalias](http://man7.org/linux/man-pages/man1/unalias.1p.html)

```
unalias alias-name...

DESCRIPTION

The unalias utility shall remove the definition for each alias name specified. See Alias Substitution . The aliases shall be removed from the current shell execution environment; see Shell Execution Environment .

unalias -a Removes All aliases
```

解除 ll 关联命令：

```
➜  ~ unalias ll
```
