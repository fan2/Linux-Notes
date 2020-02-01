
## split

[How to split a large text file into smaller files with equal number of lines?](https://stackoverflow.com/questions/2016894/how-to-split-a-large-text-file-into-smaller-files-with-equal-number-of-lines)

```
✗ split -h
split: illegal option -- h
usage: split [-a sufflen] [-b byte_count] [-l line_count] [-p pattern]
             [file [prefix]]
```

将大文件 `mybigfile.txt` 分割成小文件，每个小文件最多20万行：

```
split -l 200000 mybigfile.txt
```

基于 `sed` 提取 1~100 行内容到文件：

```
sed -n '1,100p' filename > output.txt
```

[How to Split Large Text File into Smaller Files in Linux](https://linoxide.com/linux-how-to/split-large-text-file-smaller-files-linux/)

[11 Useful split command examples for Linux/UNIX systems](https://www.linuxtechi.com/split-command-examples-for-linux-unix/)

## merge

### Windows

Merge a text (.txt) file in the Windows command line

Type in the following command to merge all TXT files in the current directory into the file named newfile.txt (any name could be used).

```
copy *.txt newfile.txt
```

### Linux

Merge a file in the Linux command line

Linux users can merge two or more files into one file using the merge command or lines of files using the paste command.

[Linux merge command](https://www.computerhope.com/unix/merge.htm)

[Linux paste command](https://www.computerhope.com/unix/upaste.htm)

#### stackoverflow

[How can I concatenate two files in Unix?](https://superuser.com/questions/228878/how-can-i-concatenate-two-files-in-unix)

```
cat file1.txt file2.txt > new.txt
```

if new.txt is not empty, and you want to keep its content as it is, and just want to append the concatenated output of two files into it then use this:

```
cat file1.txt file2.txt >> new.txt
```

[How can I cat multiple files together into one without intermediary file?](https://stackoverflow.com/questions/4072361/how-can-i-cat-multiple-files-together-into-one-without-intermediary-file)

```
for file in file1 file2 file3 ... fileN; do
  cat "$file" >> bigFile && rm "$file"
done
```

#### cat

[Linux: Putting two or more files together using cat](http://www.techpository.com/linux-putting-two-or-more-files-together-using-cat/)

[How to Combine Text Files Using the “cat” Command in Linux](https://www.howtogeek.com/278599/how-to-combine-text-files-using-the-cat-command-in-linux/)

将 file1、file2、file3 合并成 file4（新建或覆盖）:

```
cat file1.txt file2.txt file3.txt > file4.txt
```

将3个文件合并为 file4.txt（新建或追加）：

```
cat file1.txt file2.txt file3.txt > file4.txt
```

通过命令行在 file4 末尾追加输入：

```
cat >> file4.txt
```

#### tee

如果文件不存在，则会新建文件；
如果文件已存在，则会 Truncate/Overwrite 覆写已有文件：

```
cat file1.txt file2.txt file3.txt | tee file4.txt
```

如果想追加到已存在文件尾部，可指定 `-a` 选项：

```
cat file1.txt file2.txt file3.txt | tee -a file4.txt
```
