# Shadowsocks-libev
Operating system:	Centos 8 x86_64 minimal  
# 系统升级
```
yum install deltarpm epel-release
yum update
\\yum install net-tools git wget gettext gcc autoconf libtool automake make c-ares-devel libev-devel
yum install netstat wget crontabs
```
# Installation of CF_CA
```
yum install socat
curl https://get.acme.sh | sh
export CF_Key="cf_key"
export CF_Email="cf_email"
~/.acme.sh/acme.sh --issue --dns dns_cf -d github.com  --force --reloadcmd "systemctl restart rc-local"
```
# Installation of shadowsocks-rust
```
export SS_VER="v1.10.6"
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/$SS_VER/shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz
tar -xvJf  shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz  -C /usr/local/bin
popd
ldconfig
```
# Installation of v2ray-plugin
```
export V2rayP_VER="v1.3.1"
wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$V2rayP_VER/v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz
tar -xvf  shadowsocks-$V2rayP_VER.x86_64-unknown-linux-gnu.tar.xz  -C /usr/local/bin
mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin
popd
ldconfig
```
## Run
<pre>
```
chmod +x /etc/rc.d/rc.local
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local
echo "nohup ssserver -U -s "443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "server" &" >> /etc/rc.d/rc.local
echo "nohup ssserver -U -s "443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "server;tls;host=github.com" &" >> /etc/rc.d/rc.local
echo "nohup ssserver -s "443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "server;mode=quic;host=github.com" &" >> /etc/rc.d/rc.local
systemctl restart rc-local
```
</pre>

# 定时重启
```
systemctl enable crond
systemctl start crond
echo "* */12 * * * root systemctl restart rc-local" >> /etc/crontab
systemctl restart crond
···
