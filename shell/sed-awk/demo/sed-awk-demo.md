
## networksetup

以下为 macOS 下执行 `networksetup -listallhardwareports` 输出的网络接口信息：

```
$ networksetup -listallhardwareports

Hardware Port: Wi-Fi
Device: en0
Ethernet Address: 61:e8:2d:ed:34:5e

Hardware Port: Bluetooth PAN
Device: en3
Ethernet Address: 61:e8:2d:ed:34:5f

```

如果提取无线网卡（Wi-Fi）的接口名称（en0）呢？

### if

基本思路：找到 `Wi-Fi` 所在行，略过再对下一行提取第二个域值。

#### sed

可以基于 sed 实现：

```
$ networksetup -listallhardwareports | sed -n '/Wi-Fi/{n;p
pipe quote> }' | sed -n 's/^.*: //p' # sed 's/Device: //'
en0
```

sed 进行替换删减时，替换的部分尽量少用 `Device: ` 这样的具体文本，多用 `^.*: ` 这种正则表达式进行模式匹配。

#### awk

```
$ networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}'
en0
```

对于固定格式的字段分割域值提取，还是 awk 更简洁。

### SSID

可对无线网口继续调用 `networksetup -getairportnetwork en0` 获取当前连接的 Wi-Fi 网络：

```
$ networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}' | xargs networksetup -getairportnetwork
Current Wi-Fi Network: HiWiFi-5
```

#### sed

以上结果重定向给 sed，替换删除掉冒号前面的部分即可提取 SSID：

```
sed -n 's/^.*: //p'
```

#### awk

以上结果重定向给 awk，可提取 SSID：

- `awk '{print $4}'`：基于默认的空格分割，取域4；
- `awk -F ": " '{print $2}'`：基于 `: ` 分割，取域2；  

## airport

以下为 `airport -I` 输出的无线网络信息：

```
$ airport -I
     agrCtlRSSI: -35
     agrExtRSSI: 0
    agrCtlNoise: -92
    agrExtNoise: 0
          state: running
        op mode: station
     lastTxRate: 867
        maxRate: 1300
lastAssocStatus: 0
    802.11 auth: open
      link auth: wpa2-psk
          BSSID: 94:d9:b4:fe:d4:57
           SSID: HiWiFi-5
            MCS: 9
        channel: 157,80
```

假如想提取各个字段的值，按照默认的FS分割，`op mode`、`802.11 auth`、`link auth` 这些将失效。
需要按照 `: ` 作为 FS 分割。

```
$ airport -I | awk -F ': ' '{print $1}'
     agrCtlRSSI
     agrExtRSSI
    agrCtlNoise
    agrExtNoise
          state
        op mode
     lastTxRate
        maxRate
lastAssocStatus
    802.11 auth
      link auth
          BSSID
           SSID
            MCS
        channel

$ airport -I | awk -F ': ' '{print $2}'
-35
0
-92
0
running
station
867
1300
0
open
wpa2-psk
94:d9:b4:fe:d4:57
HiWiFi-5
9
157,80
```

### field 1

思考：如何去掉 `$1` 的前缀空格或制表符呢？

**思路1**：

基于 [sed](https://unix.stackexchange.com/questions/102008/how-do-i-trim-leading-and-trailing-whitespace-from-each-line-of-some-output) 首尾正则替换：

```
$ airport -I | awk -F ': ' '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//'
```

**思路2**：

基于 awk 的 sub 函数进行替换：

```
$ airport -I | awk -F ': ' '{sub(/^[ \t\r\n]+/, "", $1); sub(/[ \t\r\n]+$/, "", $1); print $1}'
```

或编写 awk [trim](https://gist.github.com/andrewrcollins/1592991) 函数。

```
$ airport -I | awk -F ': ' '
    function ltrim(s) {
        sub(/^[ \t\r\n]+/, "", s)
        return s
    }
    function rtrim(s) {
        sub(/[ \t\r\n]+$/, "", s)
        return s
    }
    function trim(s) {
        return rtrim(ltrim(s))
    }
    { print trim($1) }'
```

### SSID

进一步思考，如何提取指定域 SSID 的值，即获取当前连接的 Wi-Fi 名称呢？

基本思路：过滤出 SSID 那一行，再提取第二个域。

#### sed

```
# 移除开头空格及 SSID: 
$ airport -I | sed -n 's/^ *SSID: //p'
HiWiFi-5

$ airport -I | sed -e "s/^ *SSID: //p" -e d
HiWiFi-5
```

注意 `sed -n 's/^.*SSID: //p'` 将会提取 SSID 和 BSSID。

- `sed -n 's/^ *SSID: //p'` 将会匹配 SSID；  
- `sed -n 's/^ *BSSID: //p'` 将会匹配 BSSID；  

#### awk

```
$ airport -I | grep ' SSID' | awk '{print $2}'
HiWiFi-5
```

可省掉 grep，进一步简写为基于 awk 进行模式匹配过滤的表达式：

```
$ airport -I | awk '/ SSID/{print $2}'
HiWiFi-5
```

## system_profiler

在 macOS 下，除了基于 networksetup 和 airport 之外，还可以基于 system_profiler 来获取当前连接的网络名称：

```
$ system_profiler SPAirPortDataType | grep 'Current Network Information:' -A 2
          Current Network Information:
            HiWiFi-5:
              PHY Mode: 802.11ac
```

### sed

基于 sed 查找到 `Current Network Information:` 的下一行，再进行掐头去尾：

```
$ system_profiler SPAirPortDataType | sed -n '/Current Network Information:/{n;p
}' | sed -n 's/^ *//p' | sed -n 's/:$//p'
```

### awk

基于 awk 的 sub 函数进行替换；

```
system_profiler SPAirPortDataType | awk '/Current Network Information:/{getline; sub(/:/,"",$1); print $1}'
```

## ifconfig

基于 networksetup 获取无线网口名称，再调用 ifconfig 获取网络地址等信息（可通过重定向 xargs 传参）。

基本思路：找到对应网口 `en0`，提取第二个域值。

### sed

基于 sed 掐头去尾，可提取 IP 地址信息：

```
$ ifconfig en0 | grep 'inet ' | sed 's/^.*inet //' | sed 's/ netmask.*//'
$ ifconfig en0 | sed -n '/inet /p' | sed 's/^.*inet //' | sed 's/ netmask.*//'
192.168.0.107
```

> `grep 'inet '` 也可用 `sed -n '/inet /p'` 替代。

### awk

用 awk 提取更加简洁：

```
ifconfig en0 | awk '/inet /{print $2}'
192.168.0.107
```

## udid

`ios-deploy -c` 打印连接的 iOS 设备信息：

```
$ ios_device=`ios-deploy -c`
$ echo $ios_device
[....] Waiting up to 5 seconds for iOS device to be connected
[....] Found f45d8fa32cab22b136c86116f20d875f7e93ef52 (D10AP, iPhone 7, iphoneos, arm64) a.k.a. 'iPhone7Fan' connected through USB.
```

### sed

基于 sed 的 n 命令，[提取第二行](https://blog.csdn.net/WMSOK/article/details/78463199)：

```
$ second_line=`echo $ios_device| sed -n 'n;p'`
$ echo $second_line
[....] Found f45d8fa32cab22b136c86116f20d875f7e93ef52 (D10AP, iPhone 7, iphoneos, arm64) a.k.a. 'iPhone7Fan' connected through USB.
```

再基于 sed 对第2行掐头去尾提取:

```
$ udid=`echo $second_line | sed 's/.* Found //' | sed 's/ (.*//'`
$ echo $udid
f45d8fa32cab22b136c86116f20d875f7e93ef52
$ echo ${#udid}
40
```

### awk

基于 awk 对第2行指定 FS=`Found ` 分割提取：

```
# sub 替换空格后面的部分为空
$ udid=`echo $second_line | awk -F "Found " '{sub(/ .*/, "", $2);print$2}'`
# 重定向二次基于默认的空格分割提取
$ udid=`echo $second_line | awk -F "Found " '{print$2}' | awk '{print $1}'`
```

仔细观察可知，包含 udid 的第二行本身就是基于空格排版的，可进一步精简 awk 语句。
直接基于 awk 正则过滤出包含 `Found` 的第2行，再打印分割域 field 3 即可。

```
$ udid=`ios-deploy -c | awk '/Found/{print $3}'`
```