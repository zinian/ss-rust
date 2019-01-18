# Shadowsocks-libev
Operating system:	Centos 7 x86_64 minimal  
# 系统升级

```
yum install deltarpm epel-release
yum update
yum install net-tools git wget gettext gcc autoconf libtool automake make c-ares-devel libev-devel
```

# Installation of Libsodium

```
export LIBSODIUM_VER=1.0.17
wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
make install
popd
ldconfig
```
# Installation of MbedTLS

```
export MBEDTLS_VER=2.16.0
wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
pushd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
popd
ldconfig
```
# Installation of Shadowsocks-libev
```
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh && ./configure --disable-documentation && make
make install
```
## Run with log
<pre>
nohup ss-server -p 443 -k password -m rc4-md5 -A -a shadowsocks -v >>/tmp/ss-443.log 2>&1 &
</pre>
# 关闭111端口
```
chkconfig rpcbind off
```
## Server-multi-port

server-multi-port.json
<pre>
{
	"port_password": {
		"8387": "foobar",
		"8388": "barfoo"
	},
	"method": "aes-128-cfb",
	"timeout": 600
}
</pre>
### Run server-multi-port
<pre>
nohup ss-manager --manager-address /var/run/shadowsocks-manager.sock -A -c /server-multi-port.json &
</pre>
