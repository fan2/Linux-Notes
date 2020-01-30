[MAC终端中安装命令行工具TREE](http://coderlt.coding.me/2016/03/16/mac-osx-tree/)
[macOS 安装 tree 命令](http://www.jianshu.com/p/e038506da986)
[Mac OS X equivalent of the Ubuntu “tree” command](https://superuser.com/questions/359723/mac-os-x-equivalent-of-the-ubuntu-tree-command)

## 阅读 README

打开 `# Uncomment for OS X:` 下的针对 OS X 的编译命令：

```Shell
CC=cc
CFLAGS=-O2 -Wall -fomit-frame-pointer -no-cpp-precomp
LDFLAGS=
MANDIR=/usr/share/man/man1
OBJS+=strverscmp.o
```

## 可选修改

打开 `tree.c` 文件，

在 `setlocale(LC_CTYPE, "");` 之前添加一行：

```c
force_color=TRUE;
```

给 **tree** 命令的显示增加颜色区分效果。

如果不做以上修改，可在每次运行 tree 命令时携带 `-C` 参数: Turn colorization on always.

## 执行 `make`

```Shell
ifan@FAN-MC1:~|⇒  cd /Users/ifan/Downloads/tree-1.7.0 
ifan@FAN-MC1:~/Downloads/tree-1.7.0|
⇒  make
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o tree.o tree.c
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o unix.o unix.c
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o html.o html.c
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o xml.o xml.c
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o json.o json.c
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o hash.o hash.c
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o color.o color.c
cc -O2 -Wall -fomit-frame-pointer -no-cpp-precomp -c -o strverscmp.o strverscmp.c
cc  -o tree tree.o unix.o html.o xml.o json.o hash.o color.o strverscmp.o
```

## 执行 `make install`

```Shell
ifan@FAN-MC1:~/Downloads/tree-1.7.0|
⇒  make install
install -d /usr/bin
install: chmod 755 /usr/bin: Operation not permitted
install -d /usr/share/man/man1
install: chmod 755 /usr/share/man/man1: Operation not permitted
if [ -e tree ]; then \
		install tree /usr/bin/tree; \
	fi
install: /usr/bin/tree: Operation not permitted
make: *** [install] Error 71
```

sudo 执行：

```Shell
ifan@FAN-MC1:~/Downloads/tree-1.7.0|
⇒  sudo make install
Password:
install -d /usr/bin
install: chmod 755 /usr/bin: Operation not permitted
install -d /usr/share/man/man1
if [ -e tree ]; then \
		install tree /usr/bin/tree; \
	fi
install: /usr/bin/tree: Operation not permitted
make: *** [install] Error 71
```

### 手动拷贝

将生成的 tree 拷贝到 `/usr/local/bin/` 目录下，或 `/usr/bin/` 目录。

```Shell
ifan@FAN-MC1:~/Downloads/tree-1.7.0|
⇒  sudo cp tree /usr/local/bin/

ifan@FAN-MC1:~/Downloads/tree-1.7.0|
⇒      
```

## 修改 `.zshrc`

在 zsh 配置文件 `.zshrc` 尾部追加一行：

```Shell
alias tree="/usr/local/bin/tree"
```

执行  `source .zshrc` 使之立即生效。
