#!/bin/bash
yum -y install deltarpm epel-release
yum clean all
yum  -y update
yum -y install git net-tools iptables-services policycoreutils gettext gcc autoconf libtool automake make asciidoc xmlto udns-devel libev-devel pcre-devel
#libsodium
export LIBSODIUM_VER=1.0.17
wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
make install
popd
ldconfig
rm -rf libsodium-$LIBSODIUM_VER.tar.gz libsodium-$LIBSODIUM_VER
#mbedtls
export MBEDTLS_VER=2.16.0
wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
pushd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
popd
ldconfig
rm -rf mbedtls-$MBEDTLS_VER-gpl.tgz mbedtls-$MBEDTLS_VER
#shadowsocks-libev
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh && ./configure --disable-documentation && make
make install
popd
rm -rf shadowsocks-libev
#rc.local
chmod +x /etc/rc.d/rc.local
echo "nohup ss-server -p 443 -k password -m rc4-md5 -u >>/tmp/ss-libev-443.log 2>&1 &" >> /etc/rc.d/rc.local
echo "yum clean all" >> /etc/rc.d/rc.local
#authorized_keys
mkdir /root/.ssh
chmod 0700 /root/.ssh
cat > /root/.ssh/authorized_keys <<- EOF
ssh-rsa root@localhost.localdomain

EOF
chmod 0600 /root/.ssh/authorized_keys
#iptables
iptables -t filter -F
iptables -t filter -X
iptables -t filter -Z
iptables -t mangle -F
iptables -t mangle -X
iptables -t mangle -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables -t raw -F
iptables -t raw -X
iptables -t raw -Z
service iptables save
systemctl enable iptables.service
#rpcbind
systemctl disable rpcbind.service
