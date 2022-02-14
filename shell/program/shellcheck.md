
## Android Studio

Android Studio 安装 `Shell Script` 插件。

[shell-script](https://plugins.jetbrains.com/plugin/13122-shell-script):

Integration with external tools:

- [ShellCheck](https://github.com/koalaman/shellcheck),  
- [Shfmt](https://github.com/mvdan/sh),  
- [Explainshell](https://explainshell.com/)  

## vscode

macOS 下先用 brew 安装 shellcheck 和 shfmt 工具：

- [shellcheck](https://www.shellcheck.net/): Static analysis and lint tool, for (ba)sh scripts  
    - [ShellCheck wiki](https://github.com/koalaman/shellcheck/wiki/)
- [shfmt](https://github.com/mvdan/sh): Autoformat shell script source code  
    - [shfmt documentation](https://github.com/mvdan/sh/blob/master/cmd/shfmt/shfmt.1.scd)

```Shell
$ brew install shellcheck
$ brew install shfmt
```

然后在 vscode 中搜索安装 shellcheck 和 shfmt 两个插件：

- [shellcheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)  
- [shfmt](https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt)  

shellcheck 默认配置了 `"shellcheck.run": "onType"`，编写代码时实时检查。

如果遇到 shellcheck 报错，可以在 [Finding documentation for a check](https://github.com/koalaman/shellcheck/wiki/Checks) 点击查询具体某一个 SC 提示说明文档。

在 vscode 中，打开编辑 sh 脚本文件，可通过 `⇧⌘P` 调起控制面板执行 Format Document 命令（快捷键 `⇧⌥F`） 调用 *shfmt* 格式化当前文档。

## cases

以下是 [get_lan_ip.sh](../script/codes/get_lan_ip.sh) 脚本中的部分警告分析。

### SC2070

```Shell
if [ -n $eth_dev ]; then
    ...
fi
```

以上代码片段将报两个警告：

1. [SC2070](https://github.com/koalaman/shellcheck/wiki/SC2070): `-n` doesn't work with unquoted arguments. Quote or use `[[ ]]`.  
2. [SC2086](https://github.com/koalaman/shellcheck/wiki/SC2086): Double quote to prevent globbing and word splitting.  

因为 `eth_dev` 可能未定义（unset），那么此时 $eth_dev 被视为普通字符串，不符合预期。  
根据 ShellCheck 的静态语法警告提示，有两种修复方案：（1）加双引号安全解引用；（2）将单中括号改为双中括号。  

### SC2181

```Shell
        # 判断是否存在有线网口
        local has_eth=false
        networksetup -listallnetworkservices | grep -q 'Ethernet'
        if [ $? -eq 0 ]; then
            has_eth=true
        fi
```

以上代码片段将报警告 [SC2181](https://github.com/koalaman/shellcheck/wiki/SC2181): Check exit code directly with e.g. `if mycmd;`, not indirectly with `$?`.

根据提示，建议不用 `$?` 来判断命令执行状态，而是将命令语句直接放在 if 的 condition 位置：

```Shell
        # 判断是否存在有线网口
        local has_eth=false
        if networksetup -listallnetworkservices | grep -q 'Ethernet'; then
            has_eth=true
        fi
```

### disable

- [Inline ignore messages #145](https://github.com/koalaman/shellcheck/issues/145)  
- [How to suppress irrelevant ShellCheck messages?](https://stackoverflow.com/questions/52659038/how-to-suppress-irrelevant-shellcheck-messages)  

1. 在 get_lan_ip.sh 中引入同目录的脚本 aux_etc.sh，以下相对引入将会报错：

[SC1091](https://github.com/koalaman/shellcheck/wiki/SC1091): Not following: "./aux_etc.sh" was not specified as input (see shellcheck -x).

```Shell
# shellcheck source="./aux_etc.sh"
source "$(dirname "$0")"/aux_etc.sh
```

如果确认逻辑无误，可以加一个行禁用规则 SC1091 的 disable 注释，以便忽略警告：

```Shell
# shellcheck disable=SC1091
# shellcheck source="./aux_etc.sh"
source "$(dirname "$0")"/aux_etc.sh
```

2. 在工具函数脚本 aux_etc.sh 中，可能有些函数内会定义变量，此时 ShellCheck 会报错：

[SC2034](https://github.com/koalaman/shellcheck/wiki/SC2034): foo appears unused. Verify it or export it.

这些变量非 local、非 export，默认为全局变量，调用方可能会引用这些变量。
此时，我们可以注释禁用规则 SC2034，以便忽略相关警告：

```Shell
#!/bin/bash

# shellcheck disable=2034
# shellcheck disable=SC2034

```

也可在一行中忽略多条规则：

```Shell

# shellcheck disable=SC1091,SC2034

```