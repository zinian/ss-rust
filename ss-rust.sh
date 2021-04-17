#!/bin/bash
read -p "if you Want to update ss, press y " SS_Y
if [ $SS_Y == "y" ];then
  read -p "Enter SS_VER EX: v1.10.6 " SS_VER
  wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/$SS_VER/shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz && tar -xvJf  shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz  -C /usr/local/bin && rm -rf shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz     
fi

read -p "if you Want to update v2, press y " V2_Y
if [ $V2_Y == "y" ];then
  read -p "Enter V2rayP_VER EX: v1.3.1 " V2rayP_VER
  wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$V2rayP_VER/v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz && tar -xvf  v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz -C /usr/local/bin && rm -rf v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz && mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin
fi

if [ $SS_Y == "y" -o $V2_Y == "y" ];then
  systemctl restart rc-local
fi

systemctl status rc-local | grep Active
