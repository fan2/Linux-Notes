
[oh-my-zsh插件推荐](https://www.jianshu.com/p/9189eac3e52d)  
[一些实用常用插件推荐 for zsh（oh-my-zsh）](https://blog.e9china.net/lesson/yixieshiyongchangyongchajiantuijianforzshoh-my-zsh.html)  
[**awesome-zsh-plugins**](https://github.com/unixorn/awesome-zsh-plugins)  

## builtin

https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins

### osx

This plugin provides a few utilities to make it more enjoyable on OSX.

| Command       | Description                                                 |
| :------------ | :---------------------------------------------------------- |
| `tab`         | Open the current directory in a new tab                     |
| `split_tab`   | Split the current terminal tab horizontally                 |
| `vsplit_tab`  | Split the current terminal tab vertically                   |
| `ofd`         | Open the current directory in a Finder window               |
| `pfd`         | Return the path of the frontmost Finder window              |
| `pfs`         | Return the current Finder selection                         |
| `cdf`         | `cd` to the current Finder directory                        |
| `pushdf`      | `pushd` to the current Finder directory                     |
| `quick-look`  | Quick-Look a specified file                                 |
| `man-preview` | Open a specified man page in Preview app                    |
| `showfiles`   | Show hidden files                                           |
| `hidefiles`   | Hide the hidden files                                       |
| `itunes`      | Control iTunes. User `itunes -h` for usage details          |
| `spotify`     | Control Spotify and search by artist, album, track and etc. |

`tab`：Terminal.app - Preferences - General - New tabs open with `Same Working Directory`，`⌘T` 打开新 tab 默认打开当前工作目录。  
`ofd`：在 Finder 中定位到当前工作目录（reveal in finder），等效于执行 `open .` 命令。  
`man-preview zsh`：等效于 `man -t zsh | open -fa "Preview"`，用 Preview.app 以 PDF 格式打开 zsh 的 man page。  
`showfiles`/`hidefiles`：定位到 Finder 中 显示/隐藏 隐藏文件（Show/Hide hidden files）。  

### brew

Homebrew 已经默认提供了针对 zsh 的智能完成提示，故在 zsh 中无需再启用 brew 插件了，除了提供部分 aliases。

```Shell
 ✘ faner@MBP-FAN  ~/.oh-my-zsh/plugins   master  source ~/.zshrc
Oh My Zsh brew plugin:

  With the advent of their 1.0 release, Homebrew has decided to bundle
  the zsh completion as part of the brew installation, so we no longer
  ship it with the brew plugin; now it only has brew aliases.

  If you find that brew completion no longer works, make sure you have
  your Homebrew installation fully up to date.

  You will only see this message once.
```

### svn

This plugin adds some utility functions to display additional information regarding your current
svn repository.

`svn` 插件提供了几个快捷函数命令：

| command               | Descriptions                                |
| --------------------- | ------------------------------------------- |
| `svn_prompt_info`     | Shows svn prompt in themes                  |
| `in_svn`              | Checks if we're in an svn repository        |
| `svn_get_repo_name`   | Get repository name                         |
| `svn_get_branch_name` | Get branch name (see [caveats](#caveats))   |
| `svn_get_rev_nr`      | Get revision number                         |
| `svn_dirty`           | Checks if there are changes in the svn repo |

### git

The git plugin provides many aliases and a few useful functions.

See the [wiki](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git) for a list of aliases and functions provided by the plugin.

`git` 插件提供了一系列的命令快捷缩写关联（Alias for Commands）。

| Command                  | Description                             |
| ------------------------ | --------------------------------------- |
| `current_branch`         | Return the name of the current branch   |
| `current_repository`     | Return the names of the current remotes |
| `git_current_user_name`  | Returns the user.name config value      |
| `git_current_user_email` | Returns the user.email config value     |

其他相关插件：

- git-flow  
- gitignore  

### dir nav

#### copydir

Copies the path of your current folder to the system clipboard.

Then use the command `copydir` to copy the $PWD.

#### dircycle

enables cycling through the directory stack using `Ctrl+Shift+Left/Right`

left/right direction follows the order in which directories were visited, like left/right arrows do in a browser

相关：`last-working-dir`

#### dirhistory

Navigate directory history using **`ALT-LEFT`** and **`ALT-RIGHT`**.  

`ALT-LEFT` moves back to directories that the user has changed to in the past, and `ALT-RIGHT` undoes `ALT-LEFT`.

Navigate directory hierarchy using **`ALT-UP`** and **`ALT-DOWN`**. (mac keybindings not yet implemented)

- `ALT-UP` moves to higher hierarchy (cd ..)  
- `ALT-DOWN` moves into the first directory found in alphabetical order  

相关：`per-directory-history`。

#### z(autojump)

如果你不想额外安装 `autojump`，可使用 oh-my-zsh 内置的类似组件 `z`。  
**`z`**（jump around） 和 `autojump` 除了名字不一样，基本雷同。  

**语法**（SYNOPSIS）：`z [-chlrtx] [regex1 regex2 ... regexn]`  

```Shell
Tracks your most used directories, based on 'frecency'.

After a short learning phase, z will take you to the most 'frecent' directory that matches ALL of the regexes given on the command line, in order.  
For example, z foo bar would match /foo/bar but not /bar/foo.  
```

选项参数（OPTIONS）：

- `-c`: restrict matches to subdirectories of the current directory  
- `-h`: show a brief help message  
- `-l`: list only  
- `-r`: match by rank only  
- `-t`: match by recent access only  
- `-x`: remove the current directory from the datafile  

示例（EXAMPLES）：

- `z foo`: cd to most frecent dir matching foo  
- `z foo bar`: cd to most frecent dir matching foo, then bar  
- `z -r foo`: cd to highest ranked dir matching foo  
- `z -t foo`: cd to most recently accessed dir matching foo  
- `z -l foo`: list all dirs matching foo (by frecency)  

输入 `z -h` 查看命令参数：

```Shell
[MBP-FAN:~]
[faner]% z -h
z [-cehlrtx] args
```

输入 `z -l` 查看最近访问的高频文件夹列表：

```Shell
[MBP-FAN:~]
[faner]% z -l
0.5        /Users/faner/.oh-my-zsh/plugins
1.5        /Users/faner/.oh-my-zsh/plugins/colorize
3          /Users/faner/Downloads
4          /Users/faner/Projects/git
14         /Users/faner/Projects/git/Utilities&Usages/SCM
20         /Users/faner/.oh-my-zsh/custom
20         /Users/faner/.oh-my-zsh/custom/plugins
28         /Users/faner/Projects/git/softwareConfig
36         /Users/faner/.oh-my-zsh/custom/scripts
42         /Users/faner/Projects/git/web
236        /Users/faner/.oh-my-zsh
```

#### jump

Easily jump around the file system by manually adding marks  
marks are stored as symbolic links in the directory `$MARKPATH` (default `$HOME/.marks`)  

- `jump FOO`: jump to a mark named FOO  
- `mark FOO`: create a mark named FOO  
- `unmark FOO`: delete a mark  
- `marks`: lists all marks  

#### wd

`wd` (*warp directory*) lets you jump to custom directories in zsh, without using `cd`.  
Why? Because `cd` seems inefficient when the folder is frequently visited or has a long path.  

**warp point** 等同于 **jump mark**，但 **wd** 支持更强大的跳转点支持。

查看 wd 版本：

```Shell
@MBP-FAN ➜ ~  wd -v
wd version 0.4.6
```

查看 wd 命令帮助：

```Shell
@MBP-FAN ➜ ~  wd help
Usage: wd [command] [point]

Commands:
    add <point>     Adds the current working directory to your warp points
    add             Adds the current working directory to your warp points with current directory's name
    add! <point>    Overwrites existing warp point
    add!            Overwrites existing warp point with current directory's name
    rm <point>      Removes the given warp point
    rm              Removes the given warp point with current directory's name
    show <point>    Print path to given warp point
    show            Print warp points to current directory
    list            Print all stored warp points
    ls  <point>     Show files from given warp point (ls)
    path <point>    Show the path to given warp point (pwd)
    clean!          Remove points warping to nonexistent directories

    -v | --version  Print version
    -d | --debug    Exit after execution with exit codes (for testing)
    -c | --config   Specify config file (default ~/.warprc)
    -q | --quiet    Suppress all output

    help            Show this extremely helpful text
```

常用命令：

- `wd add foo`: Add warp point to current working directory  

    > If a warp point with the same name exists, use `add!` to overwrite it.  
    > You can **omit** point name to use the <u>current directory's name</u> instead.  

- `wd foo`: warp to `foo` from an other directory (not necessarily)  
- `wd ..`/`wd ...`: warp back to previous directory with dot syntax, and so on.  
- `wd rm foo`: Remove warp point test point.  

    > You can **omit** point name to use the <u>current directory's name</u> instead.

- `wd list`: List all warp points (stored in `$HOME/.warprc`).  
- `wd ls foo`: List files in given warp point.  
- `wd path foo` Show path of given warp point.  
- `wd show`: List warp points to current directory, or optionally, path to given warp point.  
- `wd clean`: Remove warp points to non-existent directories.  

### history

#### history

Provides a couple of convenient aliases for using the `history` command to examine your command line history.

- If `h` is called, your command history is listed. Equivalent to using `history`  
- If `hsi` is called with an argument, a **case insensitive** `grep` search is performed on your command history, looking for commands that match the argument provided  

#### history-substring-search

This is a clean-room implementation of the [Fish shell](https://fishshell.com)'s history search feature, where you can type in any part of any previously entered command and press the UP and DOWN arrow keys to cycle through the matching commands.  
You can also use <kbd>K</kbd> and <kbd>J</kbd> in VI mode or `^P` and `^N` in EMACS mode for the same.

### utilities

#### encode64

Base64 编解码快捷命令：

- alias e64=encode64  
- alias d64=decode64  

#### extract

This plugin defines a function called `extract` that extracts the archive file you pass it, and it supports a wide variety of archive filetypes.

This way you don't have to know what specific command extracts a file, you just do `extract <filename>` and the function takes care of the rest.

**`extract`** 是万能解压命令插件，一条 **extract** 命令搞定所有解压，无需记忆 tar 等命令的复杂解压参数。

#### jsontools

Handy command line tools for dealing with json data.

- **pp_json** - pretty prints json  
- **is_json** - returns true if valid json; false otherwise  
- **urlencode_json** - returns a url encoded string for the given json  
- **urldecode_json** - returns decoded json for the given url encoded string  

Usage is simple...just take your json data and pipe it into the appropriate jsontool.

```Shell
<json data> | <jsontools tool>
```

#### colorized

##### colorized

Plugin for **`highlighting file content`**

Plugin highlights file content based on the filename extension.  
If no highlighting method supported for given extension then it tries guess it by looking for file content.

> 基于 `pygmentize`，需要执行 `pip3 search Pygments` 安装 **Pygments** 插件。

##### colored-man-pages

`colored-man-pages`：man page 页面彩色化。

[Manpages 彩色版](https://linuxtoy.org/archives/colored-manpages.html)  
[让bash的man看上去多姿多彩](https://blog.csdn.net/rainysia/article/details/8673199)  

#### ssh-agent

This plugin starts automatically `ssh-agent` to set up and load whichever credentials you want for ssh connections.

#### thefuck

[The Fuck](https://github.com/nvbn/thefuck) plugin — magnificent app which corrects your previous console command.

首先需要执行 `pip install thefuck` 或 `brew install thefuck` 安装 `thefuck` 校准工具。

启用该插件后，输入 `fuck` 或连按两次 `ESC` 可纠正上次控制台输入的错误并执行。

### tools

#### iterm2

除默认的 item2 插件外，有以下第三方相关插件：

- [**zsh-tab-colors**](https://github.com/tysonwolker/iterm-tab-colors) - Automatically changes iTerm tab color based on the current working directory.  
- [iterm-touchbar](https://github.com/iam4x/zsh-iterm-touchbar) - Display iTerm2 feedback in the MacbookPro TouchBar (Current directory, git branch & status).  
- [iterm2colors](https://github.com/shayneholmes/zsh-iterm2colors) - Manage your iterm2's color scheme from the command line.  
- [iterm2-tabs](https://github.com/gimbo/iterm2-tabs.zsh) - Set colors and titles of iTerm2 tabs.  

`iterm2-tabs.zsh` 的安装使能参考 `vimman.zsh`。

#### sublime

Plugin for Sublime Text

- `st`: launch Sublime Text  
- `stt`: equivalent to `st .`, opening the current folder in Sublime Text  
- `sst`: like `sudo st`, opening the file or folder in Sublime Text. Useful for editing system protected files.  

#### vscode

This plugin makes interaction between the command line and the code editor easier.

Common aliases

| Alias                   | Command                        | Description                                                                                                 |
| ----------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| vsc                     | code .                         | Open the current folder in VS code                                                                          |
| vsca `dir`              | code --add `dir`               | Add folder(s) to the last active window                                                                     |
| vscd `file` `file`      | code --diff `file` `file`      | Compare two files with each other.                                                                          |
| vscg `file:line[:char]` | code --goto `file:line[:char]` | Open a file at the path on the specified line and character position.                                       |
| vscn                    | code --new-window              | Force to open a new window.                                                                                 |
| vscr                    | code --reuse-window            | Force to open a file or folder in the last active window.                                                   |
| vscw                    | code --wait                    | Wait for the files to be closed before returning.                                                           |
| vscu `dir`              | code --user-data-dir `dir`     | Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code. |

**`vsc`**：相当于 `code .`，新开 vscode 窗口打开当前工作目录。  
**`vscn`**：相当于 `code -n`，新开 vscode 窗口，其后可接 `.`、`file` 或 `folder`。  
**`vscr`**：相当于 `code -r`，复用（覆盖）最后一个活跃窗口，其后可接 `.`、`file` 或 `folder`。  
**`vscd`**：相当于 `code -d`，在最后一个活跃窗口打开文件对比。  

#### marked2

Plugin for [Marked 2](http://marked2app.com), a previewer for Markdown files on Mac OS X 

- If `marked` is called without an argument, open Marked  
- If `marked` is passed a file, open it in Marked  

#### node

Open the node api for your current version to the optional section.

`node-docs` 命令快速打开当前版本的 Node 帮助文档主页 —— Node.js v10.9.0 Documentation。

#### httpie

This plugin adds completion for [HTTPie](https://httpie.org/), which is a command line HTTP client, a user-friendly cURL replacement.

#### web-search

web_search from terminal：直接在命令行发起搜索。

- alias bing='web_search bing'
- alias google='web_search google'
- alias yahoo='web_search yahoo'
- alias ddg='web_search duckduckgo'
- alias sp='web_search startpage'
- alias yandex='web_search yandex'
- alias github='web_search github'
- alias baidu='web_search baidu'
- alias ecosia='web_search ecosia'
- alias goodreads='web_search goodreads'
- alias qwant='web_search qwant'

**搜索示例**：`google oh-my-zsh`、 `bing zsh plugins`、 `baidu zsh 插件`

## custom

第三方 **`plugin.zsh`** 插件的 安装、启用/禁用、卸载 可参考 `git-open`。

- `git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open`  
- `cd $ZSH_CUSTOM/plugins && git clone https://github.com/paulirish/git-open.git`  

第三方 **`zsh`** 插件的 安装、启用/禁用、卸载 可参考 `vimman`。

1. 克隆 git repo 到本地目录（`$ZSH_CUSTOM/scripts/`）：

	- `git clone https://github.com/yonchu/vimman.git $ZSH_CUSTOM/scripts/vimman`

2. 然后再在 `~/.zshrc` 中 source 脚本，重启 zsh 生效：

	- `source ~/.oh-my-zsh/custom/scripts/vimman/vimman.zsh`

### [git-open](https://github.com/paulirish/git-open)

Type `git open` to open the repo website (GitHub, GitLab, Bitbucket) in your browser.

将插件从 git clone 到 `$ZSH_CUSTOM/plugins/git-open` 下即可完成安装：

```Shell
faner on MBP-FAN in ~
$ git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open
Cloning into '/Users/faner/.oh-my-zsh/custom/plugins/git-open'...
remote: Counting objects: 651, done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 651 (delta 5), reused 10 (delta 3), pack-reused 635
Receiving objects: 100% (651/651), 151.67 KiB | 72.00 KiB/s, done.
Resolving deltas: 100% (310/310), done.
Checking connectivity... done.
```

下载安装后配置到 `~/.zshrc` 的 **plugins** 中，再执行 `source .zshrc` 即可生效。

进入 git 分支目录，执行 `git open` 或 `git-open` 即可调起浏览器打开 remote 仓库。

在 `~/.zshrc` 的 **plugins** 中移除该插件即可禁用，当然也可执行 `rm -rf $ZSH_CUSTOM/plugins/git-open` 移除卸载。

### [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

在 zsh 中，输入部分单词，输入 **tab** 自动补齐或列举所有可能选项：

```Shell
# git 空格 tab 列举建议选项
faner on MBP-FAN in ~
$ git
zsh: do you wish to see all 148 possibilities (148 lines)?
```

通过上箭头 <kbd>↑</kbd> 可回溯历史匹配命令，有点类似 bash completion 的 reverse-search-history (C-r：`^r`)。

---

**`zsh-autosuggestions`** 插件基于历史输入命令提供智能匹配建议。

[Fish](http://fishshell.com/)-like fast/unobtrusive autosuggestions for zsh.  
It suggests commands as you type, based on command history.  

执行 git clone 命令将插件下载到 `$ZSH_CUSTOM/plugins/zsh-autosuggestions` 目录中，再在 `~/.zshrc` 中配置启用。

通过右箭头 <kbd>→</kbd> 可选中当前建议匹配，再按回车键或 C-j（`^j`）执行，或按 C-g（`^g`）放弃。

### [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

This package provides syntax highlighting for the shell zsh.  
It enables highlighting of commands whilst they are typed at a zsh prompt into an interactive terminal.  
This helps in reviewing commands before running them, particularly in catching syntax errors.

执行 git clone 命令将插件下载到 `$ZSH_CUSTOM/plugins/zsh-syntax-highlighting` 目录中，再在 `~/.zshrc` 中配置启用。

相关：[zsh-url-highlighter](https://github.com/ascii-soup/zsh-url-highlighter)  

### [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)

ZSH port of Fish history search (up arrow)

### [zsh-256color](https://github.com/chrissicool/zsh-256color)

This ZSH plugin enhances the terminal environment with 256 colors.  
It looks at the chosen `TERM` environment variable and sees if there is respective (n-)curses' termcap/terminfo descriptors for 256 colors available.  
The result is a multicolor terminal, if available.

### [ls](https://github.com/zpm-zsh/ls)

- `l` - similar to ls  
- `la` - similar to ls, but show all files  
- `lsd` - show only directories  
- `ll` - show files line by line  

### [vimman](https://github.com/yonchu/vimman)

vimman - View vim plugin manuals (help) like man in zsh

git clone 到 `$ZSH_CUSTOM/scripts/vimman` 后，在 `~/.zshrc` 中 source 该 zsh 脚本重启生效。

示例：**`vimman number`** 查看 `number` 相关帮助主题：

```Shell
MBP-FAN ~ » vimman number
:help number
```

## plugins

`~/.zshrc` 中配置启用的 plugins 列表：

```Shell
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
## custom plugins are after web-search
plugins=(osx svn git copydir z wd encode64 extract jsontools colored-man-pages thefuck sublime vscode marked2 node httpie web-search git-open zsh-256color zsh-autosuggestions zsh-syntax-highlighting iterm2colors zsh-tab-colors ls)

# bare zsh script, not plugin.zsh
source ~/.oh-my-zsh/custom/scripts/vimman/vimman.zsh
source ~/.oh-my-zsh/custom/scripts/iterm2-tabs/iterm2-tabs.zsh
```

也可分行填写：

```Shell
plugins=(
    osx
    svn
    git
    copydir
    z
    wd
    encode64
    extract
    jsontools
    colored-man-pages
    thefuck
    sublime
    vscode
    marked2
    node
    httpie
    web-search
    # custom below
    ls
    git-open
    zsh-256color
    zsh-autosuggestions
    zsh-syntax-highlighting
    iterm2colors
    zsh-tab-colors)
```

## aliases

alias go="git-open"  
alias cp="cp -i"  
alias rm="trash" # rmtrash  
