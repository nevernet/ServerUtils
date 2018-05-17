# 安装

```
apk add libevent-dev wget gcc g++ make

cd ~
wget http://memcached.org/latest
tar -zxvf latest
cd memcached-1.x.x
./configure && make && make install
```

# 运行

```
/usr/local/bin/memcached -d -m 64 -c 1024 -u root -p 12010 -P /var/run/memcached-12010.pid
```
