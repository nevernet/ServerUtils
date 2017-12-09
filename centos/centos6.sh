yum install -y libevent-devel wget gcc gcc-c++

cd ~
wget https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz
tar zxf m4-1.4.18.tar.gz
cd m4-1.4.18
./configure
make
make install


cd ~
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar zxf autoconf-2.69.tar.gz
cd autoconf-2.69
./configure
make
make install

autoconf --version

cd ~
wget http://ftp.gnu.org/gnu/automake/automake-1.14.1.tar.gz
tar xvzf automake-1.14.1.tar.gz
cd automake-1.14.1
./configure
make
make install

automake --version

# 服务器配置
sysctl -w net.ipv4.ip_forward=1
sysctl -p

sshd 服务
vim /etc/ssh/sshd_config
Port xx # 更换一个端口
PertRootLogin yes|no
ClientAliveInterval 60
ClientAliveCountMax 3
UseDNS no

# 重启 并重新登录
service sshd start
chkconfig sshd on