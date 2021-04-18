#!/bin/bash
export SS_VER=`curl -s https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | grep tag_name | sed 's/"/ /g' | awk ' {print $3}'`
export V2_VER=`curl -s https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep tag_name | sed 's/"/ /g' | awk ' {print $3}'`
ss_ver="v"`ssserver -V | awk ' {print $2}'`
v2_ver=`v2ray-plugin -version | grep v2ray-plugin | awk ' {print $2}'`
restart_rc="0"

if [ $SS_VER != $ss_ver ];then
  echo shadowsocks-rust begin update $ss_ver to $SS_VER ...
  wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/$SS_VER/shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz && tar -xvJf  shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz  -C /usr/local/bin && rm -rf shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz
  restart_rc="1"
fi
if [ $V2_VER != $v2_ver ];then
  echo v2ray-plugin begin update $v2_ver to $V2_VER ...
  wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$V2_VER/v2ray-plugin-linux-amd64-$V2_VER.tar.gz && tar -xvf  v2ray-plugin-linux-amd64-$V2_VER.tar.gz -C /usr/local/bin && rm -rf v2ray-plugin-linux-amd64-$V2_VER.tar.gz && mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin
  restart_rc="1"
fi
if [ $restart_rc == "1" ];then
  echo rc-local begin restart
  systemctl restart rc-local
  sleep 5
fi
if [ $restart_rc == "0" ];then
  echo shadowsocks-rust and v2ray-plugin is latest version...
fi
systemctl status rc-local | grep Active
