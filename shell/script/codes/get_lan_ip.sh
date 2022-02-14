#!/bin/bash

# shellcheck disable=2034

# 获取 macOS 本机网口的局域网地址（LAN IP）
# 支持 Ethernet、Wi-Fi，暂未支持 Thunderbolt Bridge
## output: lan_ip
get_lan_ip() {
    # 简单正则匹配一下IP地址，无法判错 192.168 这种半截地址，
    # 包含了 [ -z "$lan_ip" ] 未定义或为空等情况。
    if ! [[ $lan_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        # 获取有线网卡接口名称
        local has_eth=false
        if networksetup -listallnetworkservices | grep -q 'Ethernet'; then
            has_eth=true
        fi
        local eth_dev=''
        local eth_status='inactive'
        local eth_inet=''
        if [ $has_eth = true ]; then
            eth_dev=$(networksetup -listallhardwareports | awk '/Hardware Port: Ethernet/{getline; print $NF}')
            if [ -n "$eth_dev" ]; then
                eth_status=$(ifconfig "$eth_dev" | awk '/status:/{print $NF}')
                if [ "$eth_status" = active ]; then
                    eth_inet=$(ifconfig "$eth_dev" | awk '/inet /{print $2}')
                    echo "Ethernet $eth_dev : status=$eth_status, inet=$eth_inet"
                else
                    echo "Ethernet $eth_dev : status=$eth_status"
                fi
            fi
        fi
        # 获取无线网卡接口名称
        local has_wlan=false
        if networksetup -listallnetworkservices | grep -q 'Wi-Fi'; then
            has_wlan=true
        fi
        local wlan_dev=''
        local wlan_status='inactive'
        local wlan_inet=''
        if [ $has_wlan = true ]; then
            wlan_dev=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $NF}')
            if [ -n "$wlan_dev" ]; then
                wlan_status=$(ifconfig "$wlan_dev" | awk '/status:/{print $NF}')
                if [ "$wlan_status" = active ]; then
                    # 获取Wi-Fi SSID
                    # local wlan_ssid=$(airport -I | awk '/ SSID/{print $2}')
                    local wlan_ssid=''
                    wlan_ssid=$(networksetup -getairportnetwork "$wlan_dev" | awk '{print $NF}')
                    # 获取 IPv4 地址
                    wlan_inet=$(ifconfig "$wlan_dev" | awk '/inet /{print $2}')
                    echo "Wi-Fi $wlan_dev : status=$wlan_status, ssid=$wlan_ssid, inet=$wlan_inet"
                else
                    echo "Wi-Fi $wlan_dev : status=$wlan_status"
                fi
            fi
        fi

        # 根据网口活跃状态，优先获取有线网络
        # if eth not bootped, try get wlan
        if [ $has_eth = true ] && [ "$eth_status" = active ]; then
            if [ -n "$eth_inet" ]; then
                lan_ip=$eth_inet
            elif [ $has_wlan = true ] && [ "$wlan_status" = active ]; then
                if [ -n "$wlan_inet" ]; then
                    lan_ip=$wlan_inet
                fi
            fi
        elif [ $has_wlan = true ] && [ "$wlan_status" = active ]; then
            if [ -n "$wlan_inet" ]; then
                lan_ip=$wlan_inet
            fi
        fi
    fi
}