#!/bin/bash
read -p "Enter SS_VER: " SS_VER
read -p "Enter V2rayP_VER: " V2rayP_VER
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/$SS_VER/shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz && tar -xvJf  shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz  -C /usr/local/bin && rm -rf shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz

wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$V2rayP_VER/v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz && tar -xvf  v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz -C /usr/local/bin && rm -rf v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz && mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin

systemctl restart rc-local
