yum install -y libevent-devel wget gcc gcc-c++

wget http://memcached.org/latest
tar -zxvf memcached-1.x.x.tar.gz
cd memcached-1.x.x
./configure && make && make install
