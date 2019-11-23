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

# 启动

复制配置文件到， 把这里的 redis.conf 复制到远程机器的/etc/redis.conf

启动:

```
/usr/local/bin/redis-server /etc/redis.conf
```

添加到 `/etc/rc.local` 开机启动

```
/usr/local/bin/redis-server /etc/redis.conf
```

# 其他

如果要允许任何 ip 链接，则把`bind`注释掉(在`redis.conf`里面).
如果需要密码，则开启`requirepass`在`redis.conf`里面)

`protected-mode` 建议一直开启，默认更加安全一些。
