# Shadowsocks-Rust
Operating system:	Centos 8 x86_64 

# PowerShell SSH

```
ssh host -p prot -l user
```
# System Password Update

```
passwd
```
# System Update

```
yum clean all
yum install kernel
reboot
yum update
yum install netstat wget crontabs
```
# Remove Old kernel

```
rpm -qa | grep kernel
export KernelOld_VER="4.18.0-80"
yum remove kernel*$KernelOld_VER*
```
# Installation of CF_CA

```
yum install socat tar
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
rm -rf shadowsocks-$SS_VER.x86_64-unknown-linux-gnu.tar.xz

```
# Installation of v2ray-plugin

```
export V2rayP_VER="v1.3.1"
wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$V2rayP_VER/v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz
tar -xvf  v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz -C /usr/local/bin
rm -rf v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz
mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin

```
## Run

```
chmod 755 /etc/rc.d/rc.local

echo "" >> /usr/lib/systemd/system/rc-local.service
echo "[Install]" >> /usr/lib/systemd/system/rc-local.service
echo "WantedBy=multi-user.target" >> /usr/lib/systemd/system/rc-local.service

systemctl daemon-reload
systemctl enable rc-local

nohup ssserver -U -s "[::]:443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "loglevel=none;server" > /root/log_443.log 2>&1 &
nohup ssserver -U -s "[::]:443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "loglevel=none;server;tls;host=github.com" > /root/log_443.log 2>&1 &
nohup ssserver -s "[::]:443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "loglevel=none;server;mode=quic;host=github.com" > /root/log_443.log 2>&1 &

systemctl start rc-local
systemctl restart rc-local
systemctl status rc-local

```

# crontab
```
systemctl enable crond
systemctl start crond
crontab -e
* */12 * * * systemctl restart rc-local >> /dev/null
systemctl restart crond
systemctl status crond
```
# crontab
```
rm -rf /root/ss-rust.sh
wget https://github.com/zinian/ss-rust/raw/master/ss-rust.sh
chmod 755  /root/ss-rust.sh
```
