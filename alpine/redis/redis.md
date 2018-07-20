# 安装工具

```
apk add gcc make g++ jemalloc-dev linux-headers coreutils musl-dev
```

# 安装 redis

```
wget http://download.redis.io/releases/redis-4.0.10.tar.gz
tar xzf redis-4.0.10.tar.gz
cd redis-4.0.10
make
make install
```

# 创建 db 路径

```
mkdir -p /var/run
mkdir -p /var/log
mkdir -p /opt/redis
```
