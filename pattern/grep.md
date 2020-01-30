## man regex

```obj-c
faner@MBP-FAN:~|⇒  man 7 re_format
faner@MBP-FAN:~|⇒  man 3 regex
faner@MBP-FAN:~|⇒  man grep
faner@MBP-FAN:~|⇒  man sed
```

## grep

grep 过滤筛选出符合条件的行，起源于 vim（ex）编辑器中的模式匹配命令：`:g/re/p`。

执行 `grep -V` 查看版本信息：

```Shell
# macOS
> grep -V
grep (BSD grep) 2.5.1-FreeBSD

# raspberrypi
pi@raspberrypi:~ $ grep -V
grep (GNU grep) 2.27
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

### usage

执行 `grep --help` 可查看简要帮助（Usage）。  

执行 `man grep` 可查看详细帮助手册（Manual Page）：

```Shell
pi@raspberrypi:~ $ man grep

GREP(1)                            General Commands Manual                            GREP(1)

NAME
       grep, egrep, fgrep, rgrep - print lines matching a pattern

SYNOPSIS
       grep [OPTIONS] PATTERN [FILE...]
       grep [OPTIONS] [-e PATTERN]...  [-f FILE]...  [FILE...]

DESCRIPTION
       grep searches the named input FILEs for lines containing a match to the given PATTERN.
       If no files are specified, or if the file “-” is given, grep searches standard  input.
       By default, grep prints the matching lines.

       In  addition,  the  variant  programs  egrep, fgrep and rgrep are the same as grep -E,
       grep -F, and grep -r, respectively.  These variants are deprecated, but  are  provided
       for backward compatibility.
```

以下为 `man grep` 中的模式说明：

```Shell
OPTIONS

   Generic Program Information
       --help Output a usage message and exit.

       -V, --version
              Output the version number of grep and exit.

   Matcher Selection
       -E, --extended-regexp
              Interpret PATTERN as an extended regular expression (ERE, see below).

       -F, --fixed-strings
              Interpret PATTERN as a list of fixed strings (instead of regular expressions), separated by newlines, any of which is to be matched.

       -G, --basic-regexp
              Interpret PATTERN as a basic regular expression (BRE, see below).  This is the default.

       -P, --perl-regexp
              Interpret the pattern as a Perl-compatible regular expression(PCRE).  This is experimental and grep -P may warn of unimplemented features.
```

`grep`, `egrep`, `fgrep` - print lines matching a pattern

the variant programs **`egrep`** and **`fgrep`** are the same as `grep -E` and `grep -F`, respectively.  
These variants are **deprecated**, but are provided for backward compatibility.  

默认选项是 `-G`(`--basic-regexp`)，即 **BRE**。  
如果要支持 **`?`**, **`+`** 和 **`|`**，则需要显式指定 `-E` 选项，即执行 **ERE**。

### options

```Shell

-e pattern, --regexp=pattern

  Specify a pattern used during the search of the input: an input line is selected if it matches
  any of the specified patterns.  
  This option is most useful when multiple -e options are used to
  specify multiple patterns, or when a pattern begins with a dash (`-`).

Regexp selection and interpretation:
# 忽略大小写敏感
  -i, --ignore-case         ignore case distinctions
  -w, --word-regexp         force PATTERN to match only whole words
  -x, --line-regexp         force PATTERN to match only whole lines

Miscellaneous:
# 匹配补集，过滤出不包含 '查找字符串' 的行
  -v, --invert-match        select non-matching lines

Output control:
# 最多查找条目，相当于 grep | head -n NUM
  -m, --max-count=NUM       stop after NUM matches
  -b, --byte-offset         print the byte offset with output lines

# 顺便打印行号
  -n, --line-number         print line number with output lines
      --line-buffered       flush output on every line

  -a, --text                equivalent to --binary-files=text

# 只列举（不）符合条件的文件名
  -L, --files-without-match  print only names of FILEs containing no match
  -l, --files-with-matches  print only names of FILEs containing matches

# 仅仅打印匹配的行数
  -c, --count               print only a count of matching lines per FILE

# 查找结果上下文
Context control:
# 顺便打印查找结果上面 NUM 行
  -B, --before-context=NUM  print NUM lines of leading context
# 顺便打印查找结果下面 NUM 行
  -A, --after-context=NUM   print NUM lines of trailing context
# 顺便打印查找结果上面和下面各 NUM 行
  -C, --context=NUM         print NUM lines of output context
  -NUM                      same as --context=NUM

```

### Examples

To find all occurrences of the word `patricia` in a file:

    $ grep 'patricia' myfile

To find all occurrences of the pattern `.Pp` at the *beginning* of a line:

    $ grep '^\.Pp' myfile

The apostrophes ensure the entire expression is evaluated by grep instead of by the user's shell.  
The caret `^` matches the null string at the beginning of a line, and the `\` escapes the `.`, which would
otherwise match any character.

To find all lines in a file which do not contain the words `foo` or `bar`:

    $ grep -v -e 'foo' -e 'bar' myfile

A simple example of an extended regular expression:

    $ egrep '19|20|25' calendar

Peruses the file `calendar` looking for either 19, 20, or 25.

**其他例子**：

`ls -al | grep '^d'`：过滤出 ls 结果中以 d 开头的（即文件夹）。  
`svn log -l 100 | grep fan`（`svn log --search fan -l 100`）：从最近100条日志中查找 fan 提交的记录。  

查找 src/ 下所有文件编码为 ISO-8859 的文件个数：

```Shell
faner@MBP-FAN:~/Downloads/src|⇒  find . -type f -exec file {} \; | grep -c 'ISO-8859'
15
```

### multiple patterns

[How do I grep for multiple patterns with pattern having a pipe character?](https://unix.stackexchange.com/questions/37313/how-do-i-grep-for-multiple-patterns-with-pattern-having-a-pipe-character)

包含 `foo|bar`：

```
grep -- 'foo|bar' *.txt
```

包含 `foo` 或 `bar`：

```
grep -- 'foo\|bar' *.txt
grep -e 'foo' -e 'bar' myfile
grep -E 'foo|bar' # 等效于 egrep 'foo|bar'
```
