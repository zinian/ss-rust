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

# Installation of Nginx

```
export  NGINX_VER=1.23.4
curl -O https://nginx.org/download/nginx-$NGINX_VER.tar.gz
tar xzvf nginx-$NGINX_VER.tar.gz
cd nginx-$NGINX_VER

./configure                                        \
       --prefix=/root/nginx                        \
       --sbin-path=/root/nginx/nginx               \
       --conf-path=/root/nginx/nginx.conf          \
       --pid-path=/root/nginx/nginx.pid            \
       --error-log-path=/root/nginx/error.log      \
       --with-http_ssl_module                      \
       --with-http_v2_module 
       
make 
make install 

vim  /lib/systemd/system/nginx.service 
chmod 755 /lib/systemd/system/nginx.service 
systemctl enable nginx.service
systemctl restart nginx.service
systemctl status nginx.service

```
## nginx.service 

```
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/root/nginx/nginx.pid   
ExecStart=/root/nginx/nginx   -c  /root/nginx/nginx-ss.conf
ExecReload=/bin/sh -c "/bin/kill -s HUP $(/bin/cat /root/nginx/nginx.pid   )"
ExecStop=/bin/sh -c "/bin/kill -s TERM $(/bin/cat /root/nginx/nginx.pid)"
ExecStartPost=/bin/sleep 0.1
[Install]
WantedBy=multi-user.target
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

```
# Installation of v2ray-plugin

```
export V2rayP_VER="v1.3.2"
wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$V2rayP_VER/v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz
tar -xvf  v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz -C /usr/local/bin
rm -rf v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz
mv /usr/local/bin/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin

```
# Installation of v2ray-plugin

```
export V2rayP_VER="v5.7.0"
wget https://github.com/teddysun/v2ray-plugin/releases/download/$V2rayP_VER/v2ray-plugin-linux-amd64-$V2rayP_VER.tar.gz
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

nohup ssserver -U -s "[::]:443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "loglevel=none;server" >> /root/log_443.log 2>&1 &
nohup ssserver -U -s "[::]:443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "loglevel=none;server;tls;host=github.com" >> /root/log_443.log 2>&1 &
nohup ssserver -s "[::]:443" -m "aes-128-gcm" -k "password" --plugin "v2ray-plugin" --plugin-opts "loglevel=none;server;mode=quic;host=github.com" >> /root/log_443.log 2>&1 &

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
* 0 * * * /root/ss-rust.sh > /root/ss-rust-update.log
systemctl restart crond
systemctl status crond
```
# update 
```
rm -rf /root/ss-rust.sh
wget https://github.com/zinian/ss-rust/raw/master/ss-rust.sh
chmod 755  /root/ss-rust.sh
/root/ss-rust.sh >> /root/ss-rust-update.log
```
