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

# Installation of Nginx-quic
##   install  boringssl
```
git clone https://github.com/google/boringssl.git
cd boringssl
mkdir build
cd build
cmake ../
make
cd ../..
```
## install nginx-quic
```
export  NGINX_VER=1.20.2
curl -O https://hg.nginx.org/nginx-quic/archive/$NGINX_VER.tar.gz
tar xzvf $NGINX_VER.tar.gz
mv nginx-quic-$NGINX_VER nginx-quic-src
cd nginx-quic-src

./auto/configure	                              \
       --prefix=/root/nginx-quic                     \
       --sbin-path=/root/nginx-quic/nginx                  \
       --conf-path=/root/nginx-quic/nginx.conf                  \
       --pid-path=/root/nginx-quic/nginx.pid                  \
       --error-log-path=/root/nginx-quic/error.log                  \
       --with-http_ssl_module                  \
       --with-http_v2_module  		\
       --with-http_v3_module \
       --with-cc-opt="-I../boringssl/include" \
                       --with-ld-opt="-L../boringssl/build/ssl \
                       -L../boringssl/build/crypto" 
                       
make 
make install                        
                       

```
# Installation of Nginx

```
export  NGINX_VER=1.23.0
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
       
       
./configure     \
       --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -flto=auto -ffat-lto-objects -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -march=x86-64-v2 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'


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
export SS_VER="v1.14.3"
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
