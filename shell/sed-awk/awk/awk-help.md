
unix/POSIX - [awk](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html)  
FreeBSD/Darwin - [awk](https://www.freebsd.org/cgi/man.cgi?query=awk)  

linux - [awk(1p)](http://man7.org/linux/man-pages/man1/awk.1p.html)  
debian/Ubuntu - [awk](https://manpages.debian.org/buster/9base/awk.1plan9.en.html)  

`awk` -- pattern-directed scanning and processing language

[AWK](https://en.wikipedia.org/wiki/AWK)  
[The GNU Awk User’s Guide](https://www.gnu.org/software/gawk/manual/gawk.html)  
[Awk - A Tutorial and Introduction](https://www.grymoire.com/Unix/Awk.html)  

## version

macOS 下执行 `awk --version` 查看版本信息：

```
$ awk --version
awk version 20070501
```

## man

执行 `man awk` 可查看帮助手册。  

### macOS

```
# man awk

AWK(1)                                                                                                AWK(1)



awk

NAME
       awk - pattern-directed scanning and processing language

SYNOPSIS
       awk [ -F fs ] [ -v var=value ] [ 'prog' | -f progfile ] [ file ...  ]

DESCRIPTION
       Awk  scans  each input file for lines that match any of a set of patterns specified literally in prog
       or in one or more files specified as -f progfile.  With each  pattern  there  can  be  an  associated
       action  that  will  be  performed  when  a  line of a file matches the pattern.  Each line is matched
       against the pattern portion of every pattern-action statement; the associated action is performed for
       each  matched  pattern.  The file name - means the standard input.  Any file of the form var=value is
       treated as an assignment, not a filename, and is executed at the time it would have been opened if it
       were a filename.  The option -v followed by var=value is an assignment to be done before prog is exe-
       cuted; any number of -v options may be present.  The -F fs option defines the input  field  separator
       to be the regular expression fs.

       An  input  line  is normally made up of fields separated by white space, or by regular expression FS.
       The fields are denoted $1, $2, ..., while $0 refers to the entire line.  If FS  is  null,  the  input
       line is split into one field per character.
```

### raspberrypi

```
# man awk

MAWK(1)                                             USER COMMANDS                                             MAWK(1)

NAME
       mawk - pattern scanning and text processing language

SYNOPSIS
       mawk [-W option] [-F value] [-v var=value] [--] 'program text' [file ...]
       mawk [-W option] [-F value] [-v var=value] [-f program-file] [--] [file ...]

DESCRIPTION
       mawk  is an interpreter for the AWK Programming Language.  The AWK language is useful for manipulation of data
       files, text retrieval and processing, and for prototyping and experimenting with algorithms.  mawk  is  a  new
       awk  meaning  it  implements the AWK language as defined in Aho, Kernighan and Weinberger, The AWK Programming
       Language, Addison-Wesley Publishing, 1988.  (Hereafter referred to as the AWK book.)   mawk  conforms  to  the
       Posix  1003.2  (draft  11.3) definition of the AWK language which contains a few features not described in the
       AWK book,  and mawk provides a small number of extensions.

       An AWK program is a sequence of pattern {action} pairs and function definitions.  Short programs  are  entered
       on  the  command  line  usually enclosed in ' ' to avoid shell interpretation.  Longer programs can be read in
       from a file with the -f option.  Data  input is read from the list of files on the command line or from  stan‐
       dard  input  when  the  list is empty.  The input is broken into records as determined by the record separator
       variable, RS.  Initially, RS = "\n" and records are synonymous with lines.  Each record  is  compared  against
       each pattern and if it matches, the program text for {action} is executed.

OPTIONS
       -F value       sets the field separator, FS, to value.

       -f file        Program  text  is  read  from  file  instead of from the command line.  Multiple -f options are
                      allowed.

       -v var=value   assigns value to program variable var.

       --             indicates the unambiguous end of options.

       The above options will be available with any Posix compatible implementation of AWK, and  implementation  spe‐
       cific options are prefaced with -W.  mawk provides six:

       -W version     mawk writes its version and copyright to stdout and compiled limits to stderr and exits 0.

       -W dump        writes  an  assembler  like listing of the internal representation of the program to stdout and
                      exits 0 (on successful compilation).

       -W interactive sets unbuffered writes to stdout and line buffered reads from stdin.  Records  from  stdin  are
                      lines regardless of the value of RS.

       -W exec file   Program  text is read from file and this is the last option. Useful on systems that support the
                      #!  "magic number" convention for executable scripts.

       -W sprintf=num adjusts the size of mawk's internal sprintf buffer to num bytes.  More than rare  use  of  this
                      option indicates mawk should be recompiled.

       -W posix_space forces mawk not to consider '\n' to be space.

       The  short  forms  -W[vdiesp] are recognized and on some systems -We is mandatory to avoid command line length
       limitations.
```

## options

sed 主要有3个常用命令选项：

选项         | 描述
------------|--------------------
`-F`        | 指定分隔符（分割字符串）
`-f file`   | 加载执行 file 中指定 awk 脚本
`-v`        | 设置变量

FreeBSD Manual Pages:

```
     -F	fs   Define the	input field separator to be the	regular	expression fs.

     -f	progfile
	     Read program code from the	specified file progfile	instead	of
	     from the command line.

     -v	var=value
	     Assign value to variable var before prog is executed; any number
	     of	-v options may be present.
```

unix/linux Manual Pages:

```
       −F sepstring
                 Define the input field separator. This option shall be
                 equivalent to:

                     -v FS=sepstring

                 except that if −F sepstring and −v FS=sepstring are both
                 used, it is unspecified whether the FS assignment resulting
                 from −F sepstring is processed in command line order or is
                 processed after the last −v FS=sepstring.  See the
                 description of the FS built-in variable, and how it is
                 used, in the EXTENDED DESCRIPTION section.

       −f progfile
                 Specify the pathname of the file progfile containing an awk
                 program. A pathname of '−' shall denote the standard input.
                 If multiple instances of this option are specified, the
                 concatenation of the files specified as progfile in the
                 order specified shall be the awk program. The awk program
                 can alternatively be specified in the command line as a
                 single argument.

       −v assignment
                 The application shall ensure that the assignment argument
                 is in the same form as an assignment operand. The specified
                 variable assignment shall occur prior to executing the awk
                 program, including the actions associated with BEGIN
                 patterns (if any). Multiple occurrences of this option can
                 be specified.
```

## statements

### macOS

```
# man awk
       A pattern-action statement has the form

              pattern { action }

       A  missing  { action } means print the line; a missing pattern always matches.  Pattern-action state-
       ments are separated by newlines or semicolons.

       An action is a sequence of statements.  A statement can be one of the following:

              if( expression ) statement [ else statement ]
              while( expression ) statement
              for( expression ; expression ; expression ) statement
              for( var in array ) statement
              do statement while( expression )
              break
              continue
              { [ statement ... ] }
              expression              # commonly var = expression
              print [ expression-list ] [ > expression ]
              printf format [ , expression-list ] [ > expression ]
              return [ expression ]
              next                    # skip remaining patterns on this input line
              nextfile                # skip rest of this file, open next, start at top
              delete array[ expression ]# delete an array element
              delete array            # delete all elements of array
              exit [ expression ]     # exit immediately; status is expression
```

### raspberrypi

```
# man awk

   1. Program structure
       An AWK program is a sequence of pattern {action} pairs and user function definitions.

       A pattern can be:
              BEGIN
              END
              expression
              expression , expression

       One, but not both, of pattern {action} can be omitted.   If {action} is omitted it is implicitly  {  print  }.
       If pattern is omitted, then it is implicitly matched.  BEGIN and END patterns require an action.

       Statements are terminated by newlines, semi-colons or both.  Groups of statements such as actions or loop bod‐
       ies are blocked via { ... } as in C.  The last statement in a block doesn't need a  terminator.   Blank  lines
       have  no  meaning; an empty statement is terminated with a semi-colon. Long statements can be continued with a
       backslash, \.  A statement can be broken without a backslash after a comma, left brace, &&, ||, do, else,  the
       right  parenthesis  of  an  if, while or for statement, and the right parenthesis of a function definition.  A
       comment starts with # and extends to, but does not include the end of line.

       The following statements control program flow inside blocks.

              if ( expr ) statement

              if ( expr ) statement else statement

              while ( expr ) statement

              do statement while ( expr )

              for ( opt_expr ; opt_expr ; opt_expr ) statement

              for ( var in array ) statement

              continue

              break
```

## Variable

macOS 下的内置变量：

```
# man awk

       The special patterns BEGIN and END may be used to capture control before the first input line is read
       and after the last.  BEGIN and END do not combine with other patterns.

       Variable names with special meanings:

       CONVFMT
              conversion format used when converting numbers (default %.6g)

       FS     regular expression used to separate fields; also settable by option -Ffs.

       NF     number of fields in the current record

       NR     ordinal number of the current record

       FNR    ordinal number of the current record in the current file

       FILENAME
              the name of the current input file

       RS     input record separator (default newline)

       OFS    output field separator (default blank)

       ORS    output record separator (default newline)

       OFMT   output format for numbers (default %.6g)

       SUBSEP separates multiple subscripts (default 034)

       ARGC   argument count, assignable

       ARGV   argument array, assignable; non-null members are taken as filenames

       ENVIRON
              array of environment variables; subscripts are names.
```

raspberrypi 下多了以下2个：

```
        RLENGTH   length set by the last call to the built-in function, match().
        RSTART    index set by the last call to match().
```

## functions

macOS 下 awk 支持的内置函数：

```
# man awk

       The  mathematical  functions  exp, log, sqrt, sin, cos, and atan2 are built in.  Other built-in func-
       tions:

       length the length of its argument taken as a string, or of $0 if no argument.

       rand   random number on (0,1)

       srand  sets seed for rand and returns the previous seed.

       int    truncates to an integer value

       substr(s, m, n)
              the n-character substring of s that begins at position m counted from 1.

       index(s, t)
              the position in s where the string t occurs, or 0 if it does not.

       match(s, r)
              the position in s where the regular expression r occurs, or 0 if it does not.   The  variables
              RSTART and RLENGTH are set to the position and length of the matched string.

       split(s, a, fs)
              splits  the string s into array elements a[1], a[2], ..., a[n], and returns n.  The separation
              is done with the regular expression fs or with the field separator FS if fs is not given.   An
              empty string as field separator splits the string into one array element per character.

       sub(r, t, s)
              substitutes  t  for the first occurrence of the regular expression r in the string s.  If s is
              not given, $0 is used.

       gsub   same as sub except that all occurrences of the regular expression are replaced; sub  and  gsub
              return the number of replacements.

       sprintf(fmt, expr, ... )
              the string resulting from formatting expr ...  according to the printf(3) format fmt

       system(cmd)
              executes cmd and returns its exit status

       tolower(str)
              returns  a copy of str with all upper-case characters translated to their corresponding lower-
              case equivalents.

       toupper(str)
              returns a copy of str with all lower-case characters translated to their corresponding  upper-
              case equivalents.

        The  ``function'' getline sets $0 to the next input record from the current input file;
```

raspberrypi man page 中归纳为数学运算函数和字符串处理函数。

### Arithmetic

数学运算函数：

```
       Arithmetic functions

              atan2(y,x)     Arctan of y/x between -pi and pi.
              cos(x)         Cosine function, x in radians.
              exp(x)         Exponential function.
              int(x)         Returns x truncated towards zero.
              log(x)         Natural logarithm.
              rand()         Returns a random number between zero and one.
              sin(x)         Sine function, x in radians.
              sqrt(x)        Returns square root of x.
              srand(expr)  srand()
```

### String

字符串处理函数：

```
       String functions

              gsub(r,s,t)  gsub(r,s)
                     Global  substitution, every match of regular expression r in variable t is replaced by string s.
                     The number of replacements is returned.  If t is omitted, $0 is used.  An & in  the  replacement
                     string  s  is  replaced  by the matched substring of t.  \& and \\ put  literal & and \, respec‐
                     tively, in the replacement string.

              index(s,t)
                     If t is a substring of s, then the position where t starts is returned, else 0 is returned.  The
                     first character of s is in position 1.

              length(s)
                     Returns the length of string s.

              match(s,r)
                     Returns  the index of the first longest match of regular expression r in string s.  Returns 0 if
                     no match.  As a side effect, RSTART is set to the return value.  RLENGTH is set to the length of
                     the  match  or  -1  if  no match.  If the empty string is matched, RLENGTH is set to 0, and 1 is
                     returned if the match is at the front, and length(s)+1 is returned if the match is at the back.

              split(s,A,r)  split(s,A)
                     String s is split into fields by regular expression r and the fields are loaded  into  array  A.
                     The number of fields is returned.  See section 11 below for more detail.  If r is omitted, FS is
                     used.

              sprintf(format,expr-list)
                     Returns a string constructed from  expr-list  according  to  format.   See  the  description  of
                     printf() below.

              sub(r,s,t)  sub(r,s)
                     Single substitution, same as gsub() except at most one substitution.

              substr(s,i,n)  substr(s,i)
                     Returns  the substring of string s, starting at index i, of length n.  If n is omitted, the suf‐
                     fix of s, starting at i is returned.

              tolower(s)
                     Returns a copy of s with all upper case characters converted to lower case.

              toupper(s)
                     Returns a copy of s with all lower case characters converted to upper case.
```

### getline

```
# raspberrypi

       The input function getline has the following variations.

              getline
                     reads into $0, updates the fields, NF, NR and FNR.

              getline < file
                     reads into $0 from file, updates the fields and NF.

              getline var
                     reads the next record into var, updates NR and FNR.

              getline var < file
                     reads the next record of file into var.

               command | getline
                     pipes a record from command into $0 and updates the fields and NF.

               command | getline var
                     pipes a record from command into var.

       Getline returns 0 on end-of-file, -1 on error, otherwise 1.
```
