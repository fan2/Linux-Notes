
[Bash字符串判断](https://blog.csdn.net/weihongrao/article/details/11028231)  
[逻辑判断和字符串比较](https://blog.csdn.net/wxc_qlu/article/details/82826106)  

考虑这样一种场景：根据连接 Wi-Fi 的 SSID 来判断是在家还是在公司。

```
$ wSSID=$(airport -I | grep ' SSID' | awk '{print $2}')

$ isAtHome=`echo $wSSID | grep HiWiFi`
$ echo $? #命令返回值
0
$ echo $isAtHome #grep匹配结果
HiWiFi-5
$ echo ${#isAtHome} #grep匹配结果长度
8

$ isAtOffice=`echo $wSSID | grep Office`
FAIL: 1
$ echo $? #命令返回值
1
$ echo $isAtOffice #grep匹配结果（为空）

$ echo ${#isAtOffice} #grep匹配结果长度
0
```

## 返回值判断

对于命令执行的返回状态码，可按数值或字符串形式进行判断：

1. 按数值判断：`if [ $? -eq 0 ]` or `if [ $? -ne 0 ]`  
2. 按字符串判断：`if [ "$?" = "0" ]` or `if [ "$?" != "0" ]`  

## 变量非空判断

方括号 `if [ condition ]`（等效 `test condition`），可用于变量判空：

1. 变量 set 有值，则返回 TRUE；  
2. 变量 unset 为空，则返回 FALSE；  

```
Ξ ~ → if [ $isAtHome ] ; then echo "isAtHome" ; fi
isAtHome
Ξ ~ → if [ $isAtOffice ] ; then echo "isAtOffice" ; fi
Ξ ~ →
```

## 字符串判断

1. `[ -n string ]`：测试字符串非空；  
2. `[ -z string ]`：测试字符串为空；  

以下针对 `$isAtOffice` 的 `-n`/`-z` 判断均成立！？

```
Ξ ~ → if [ -z $isAtOffice ] ; then echo "not isAtOffice" ; fi
not isAtOffice
Ξ ~ → if [ -n $isAtOffice ] ; then echo "isAtOffice" ; fi
isAtOffice
```

需要对变量引用添加双引号字符串化，再判断：

```
Ξ ~ → if [ -z "$isAtOffice" ] ; then echo "not isAtOffice" ; fi
not isAtOffice
Ξ ~ → if [ -n "$isAtOffice" ] ; then echo "isAtOffice" ; fi
Ξ ~ →

```

当然，还可以这样判空：`"$isAtOffice" = ""`。

## demo

返回值和执行结果综合判断示例：

```Shell
is_iosdeploy_installed()
{
    # ios-deploy -V | read ios_deploy_version # wrong???
    ios_deploy_version=$(ios-deploy -V)
    if [ $? -eq 0 -a $ios_deploy_version ]
    # if test $ios_deploy_version
    # if [ -n "$ios_deploy_version" ]
    then
        echo "ios-deploy version: $ios_deploy_version"
        return 0
    else
        echo "ios-deploy not found, PLS install first!!!"
        return 1
    fi
}
```

注意以下复合条件测试的综合示例：

```Shell
if is_iosdeploy_installed
then
    ios_deploy_device=`ios-deploy -c`
    # if [ $? -eq 0 -a $ios_deploy_device ]         # [: too many arguments
    # if [ $? -eq 0 ] && [ $ios_deploy_device ]     # [: too many arguments
    # if [[ $? -eq 0 ]] && [[ $ios_deploy_device ]] # right, not recommended
    if [ $? -eq 0 ] && [ -n "$ios_deploy_device" ]
    then
        echo $ios_deploy_device
        main $@ # $*
    else
        echo "ios-deploy detect failed!"
    fi
fi
```
