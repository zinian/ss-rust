# shadowsocks-libev
Operating system:	Centos 7 x86_64 minimal  
系统升级
<pre>
yum install deltarpm
yum update 
</pre>
编译shadowsocks-libev
<pre>
yum install git gcc autoconf libtool automake make zlib-devel openssl-devel asciidoc xmlto 
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
./configure --disable-documentation && make
make install
</pre>

# for log
<pre>
nohup ss-server -p 443 -k password -m chacha20 -a nobody -n 51200 -A -v >/tmp/443-$(date "+%Y%m%d_%H%M%S").log 2>&1 &
</pre>
# for iptables
安装iptables services
<pre>
yum install net-tools iptables-services policycoreutils
</pre>
清除 iptables 规则
<pre>
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
</pre>
禁止BT
<pre>
iptables -A FORWARD -m string --string "GET /scrape?info_hash=" --algo bm --to 65535 -j DROP
iptables -A FORWARD -m string --string "GET /announce.php?info_hash=" --algo bm --to 65535 -j DROP
iptables -A FORWARD -m string --string "GET /scrape.php?info_hash=" --algo bm --to 65535 -j DROP
iptables -A FORWARD -m string --string "GET /scrape.php?passkey=" --algo bm --to 65535 -j DROP
iptables -A FORWARD -m string --hex-string "|13426974546f7272656e742070726f746f636f6c|" --algo bm --to 65535 -j DROP
</pre>
iptables rules for SHADOWSOCKS
<pre>
iptables -N SHADOWSOCKS
iptables -A SHADOWSOCKS -p tcp --syn -m connlimit --connlimit-above 20 -j REJECT --reject-with tcp-reset
iptables -A SHADOWSOCKS -d 127.0.0.0/8 -j REJECT
iptables -A SHADOWSOCKS -d 0.0.0.0/8 -j REJECT
iptables -A SHADOWSOCKS -d 10.0.0.0/8 -j REJECT
iptables -A SHADOWSOCKS -d 169.254.0.0/16 -j REJECT
iptables -A SHADOWSOCKS -d 172.16.0.0/12 -j REJECT
iptables -A SHADOWSOCKS -d 192.168.0.0/16 -j REJECT
iptables -A SHADOWSOCKS -d 224.0.0.0/4 -j REJECT
iptables -A SHADOWSOCKS -d 240.0.0.0/4 -j REJECT
iptables -A SHADOWSOCKS -p udp --dport 53 -j ACCEPT
iptables -A SHADOWSOCKS -p tcp --dport 53 -j ACCEPT
iptables -A SHADOWSOCKS -p tcp --dport 80 -j ACCEPT
iptables -A SHADOWSOCKS -p tcp --dport 443 -j ACCEPT
iptables -A SHADOWSOCKS -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A SHADOWSOCKS -p tcp -j REJECT --reject-with tcp-reset
iptables -A SHADOWSOCKS -p udp -j REJECT
iptables -A OUTPUT -j SHADOWSOCKS
</pre>
iptables save & restart & enable iptables.service
<pre>
service iptables save
service iptables restart
systemctl enable iptables.service
</pre>

