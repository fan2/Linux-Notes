
## networksetup(if)

以下为 `networksetup -listallhardwareports` 输出的网络接口信息：

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

基本思路是，找到 `Wi-Fi` 所在行，略过再对下一行提取第二个域值。

```
$ networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}'
en0
```

当然，也可以基于 sed 等效实现：

```
[scripts] networksetup -listallhardwareports | sed -n '/Wi-Fi/{n;p
pipe quote> }' | sed 's/Device: //'
en0
```

对比发现，对于固定格式的字段分割域值提取，还是 awk 更简洁。

## airport(SSID)

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

---

进一步思考，如何去掉 `$1` 的前缀空格或制表符呢？

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

---

进一步思考，如何提取指定域 SSID 的值，即获取当前连接的 Wi-Fi 名称呢？

基本思路：基于 grep 过滤出 SSID 那一行，再基于默认 FS 提取第二个域即可。

```
$ airport -I | grep ' SSID' | awk '{print $2}'
```

## udid

```
$ ios_device=`ios-deploy -c`
$ second_line=`ios-deploy -c | sed -n 'n;p'`
$ echo $second_line
[....] Found ddffc8d6d298d156f23b8d8a71f4e3397c387d01 (N61AP, iPhone 6 (GSM), iphoneos, arm64) a.k.a. 'iPhone 6 ios10.1.1' connected through USB.
```

基于 sed 对第2行掐头去尾提取:

```
$ udid=`echo $second_line | sed 's/.* Found //' | sed 's/ (.*//'`
```

基于 awk 对第2行指定 FS=`Found ` 分割提取：

```
# sub 替换空格后面的部分为空
$ udid=`echo $second_line | awk -F "Found " '{sub(/ .*/, "", $2);print$2}'`
# 重定向二次基于默认的空格分割提取
$ udid=`echo $second_line | awk -F "Found " '{print$2}' | awk '{print $1}'`
```

最简洁明了的方案是基于 awk 正则过滤出包含 `Found` 的第2行，再打印分割域 field 3。

```
$ udid=`ios-deploy -c | awk '/Found/{print $3}'`
```
