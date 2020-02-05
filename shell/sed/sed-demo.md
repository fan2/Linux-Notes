## dos2unix

在 vim 下执行 `:%s/\r//g` 可将DOS文件中的回车符 `^M` 替换为空（即删除）。

dos2unix 批量替换方案：`find ./ -type f print0 | xargs -0 sed -i 's/^M$//'`。  

## extract

`ios-deploy -c` 打印连接的 iOS 设备信息，然后基于 sed [提取第二行](https://blog.csdn.net/WMSOK/article/details/78463199)，进而提取 udid：

```
$ ios_device=`ios-deploy -c`
$ second_line=`ios-deploy -c | sed -n 'n;p'`
$ echo $second_line
[....] Found ddffc8d6d298d156f23b8d8a71f4e3397c387d01 (N61AP, iPhone 6 (GSM), iphoneos, arm64) a.k.a. 'iPhone 6 ios10.1.1' connected through USB.

# 基于 awk 提取
$ udid=`echo $second_line | awk -F "Found " '{sub(/ .*/, "", $2);print$2}'`

# 基于 sed 提取（掐头去尾）
$ udid=`echo $second_line | sed 's/.* Found //' | sed 's/ (.*//'`

$ echo $udid
ddffc8d6d298d156f23b8d8a71f4e3397c387d01
$ echo ${#udid}
40
```

> udid 右边有多个括号，但是 sed 默认匹配第一处。

## ifconfig

以下综合范例，通过 grep 和 sed 命令，从 ifconfig 提取当前连接的无线网卡的 IP 地址：

```
$ wifdev=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
$ echo $wifdev
en0

# 过滤出 inet 行
$ ifconfig $wifdev | grep 'inet '
	inet 192.168.0.107 netmask 0xffffff00 broadcast 192.168.0.255

# 去头
$ ifconfig en0 | grep 'inet ' | sed 's/inet //'
	192.168.0.107 netmask 0xffffff00 broadcast 192.168.0.255

# 去尾
$ ifconfig en0 | grep 'inet ' | sed 's/inet //' | sed 's/ netmask.*//'
	192.168.0.107

# 掐头去尾
$ ifconfig en0 | grep 'inet ' | sed 's/^.*inet //' | sed 's/ netmask.*//'
192.168.0.107
```

## SSID

macOS 下基于 sed 提取 Wi-Fi 热点名称 SSID：

```
# 移除开头空格及 SSID: 
Ξ ~ → airport -I | sed -n 's/^ *SSID: //p'
HiWiFi-5

Ξ ~ → airport -I | sed -e "s/^ *SSID: //p" -e d
HiWiFi-5
```

注意 `sed -n 's/^.*SSID: //p'` 将会提取 BSSID 和 SSID。

- `sed -n 's/^ *BSSID: //p'` 将会提取 BSSID。  
- `sed -n 's/^ *SSID: //p'` 将会提取 SSID。  
