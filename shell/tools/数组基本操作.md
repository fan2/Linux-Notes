
[Arrays in unix shell?](https://stackoverflow.com/questions/1878882/arrays-in-unix-shell)  
[Working with Arrays in Linux Shell Scripting – Part 8](https://www.tecmint.com/working-with-arrays-in-linux-shell-scripting/)  

## 数组的定义

定义一个数组 `array`：

```
$ array=("A" "B" "ElementC" "ElementE")
```

整体打印数组内容：

```
$ echo $array
A B ElementC ElementE
```

## 数组长度

用 `${#数组名[@或*]}` 可以得到数组长度。

```
$ echo ${#array[*]}
4
```

## 访问数组元素

按索引获取数组元素：

```
$ echo "${array[0]}"

$ echo "${array[1]}"
A
$ echo "${array[2]}"
B
$ echo "${array[3]}"
ElementC
$ echo "${array[4]}"
ElementE
```

循环遍历数组元素：

```
for element in "${array[@]}"
do
    echo "$element"
done
```

遍历结果输出：

```
A
B
ElementC
ElementE
```

C 语言写法：

```
b=0
while [ $b -lt $c ]
do
  echo ${filelist[$b]}
  ((b++))
done
```

## C风格按照索引写入

[进入某个目录将目录下面的文件名存入数组](https://blog.csdn.net/u011046042/article/details/49680781)  

```Shell
cd $yourpathname
j=0
for i in `ls -1`
do
    folder_list[j]=$i
    j=`expr $j + 1`
done
```

[在shell中把ls的输出存进一个数组变量中](https://blog.csdn.net/baidu_35757025/article/details/64439508)  

```Shell
c=0
for file in `ls`
do
  filelist[$c]=$file
  ((c++))
done
```

或者：

```Shell
c=0
for file in *
do
  filelist[$c]="$file" # 为了准确起见，此处要加上双引号
  ((c++))
done
```

或者：

```Shell
set -a myfiles
index=0
for f in `ls`; do myfiles[index]=$f; let index=index+1; done
```

**注意**：用这种方法，如果文件名中有空格的话，会将一个文件名以空格为分隔符分成多个存到数组中，最后出来的结果就是错误的。

---

把filelist数组内容输出到屏幕上：

```Shell
b=0
while [ $b -lt $c ]
do
  echo ${filelist[$b]}
  ((b++))
done
```

或者

```Shell
b=0
for value in ${filelist[*]}
do
  echo $value
done
```

用 `${#数组名[@或*]}` 可以得到数组长度。

在屏幕上输出filelist数组长度：

```
echo ${#filelist[*]}
```

## Mutable Access

[How to add/remove an element to/from the array in bash?](https://unix.stackexchange.com/questions/328882/how-to-add-remove-an-element-to-from-the-array-in-bash)

[Mutable list or array structure in Bash? How can I easily append to it?](https://stackoverflow.com/questions/2013396/mutable-list-or-array-structure-in-bash-how-can-i-easily-append-to-it)  

### To add an element at head/tail

To add an element to the beginning of an array use.

```Shell
arr=("new_element" "${arr[@]}")
```

Generally, you would do.

```Shell
arr=("new_element1" "new_element2" "..." "new_elementN" "${arr[@]}")
```

To add an element to the end of an array use.

```Shell
arr=( "${arr[@]}" "new_element" )
```

Or instead

```Shell
arr+=( "new_element" )
```

Generally, you would do.

```Shell
arr=( "${arr[@]}" "new_element1" "new_element2" "..." "new_elementN")
# Or
arr+=( "new_element1" "new_element2" "..." "new_elementN" )
```

### To add an element to specific index

To add an element to specific index of an array use.

Let's say we want to add an element to the position of Index2 `arr[2]`, we would actually do **merge** on below sub-arrays:

1. Get all elements before Index position2 arr[0] and arr[1];  
2. Add an element to the array;  
3. Get all elements with Index position2 to the last arr[2], arr[3], ....  

```Shell
arr=( "${arr[@]:0:2}" "new_element" "${arr[@]:2}" )
```

### Removing an element from the array

In addition to removing an element from an array (let's say element `#2`), we need to **concatenate** two sub-arrays. 
The first sub-array will hold the elements *before* element `#2` and the second sub-array will contain the elements *after* element `#2`.

```Shell
arr=( "${arr[@]:0:2}" "${arr[@]:3}" )
```

`${arr[@]:0:2}` will get two elements `arr[0]` and `arr[1]` starts from the beginning of the array.  
`${arr[@]:3}` will get all elements from index3 arr[3] to the last.  

Another possibility to remove an element is Using `unset` (actually assign 'null' value to the element)

```
unset arr[2]
```

Use replace pattern if you know the value of your elements.

```
arr=( "${arr[@]/PATTERN/}" )
```
