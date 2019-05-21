# 安装

```
apk add libevent-dev wget gcc g++ make

cd ~
wget http://memcached.org/files/memcached-1.5.15.tar.gz
tar -zxvf memcached-1.5.15.tar.gz
cd memcached-1.5.15
./configure && make && make install
```

# 运行

```
/usr/local/bin/memcached -d -m 64 -c 1024 -u root -p 12010 -P /var/run/memcached-12010.pid
```
