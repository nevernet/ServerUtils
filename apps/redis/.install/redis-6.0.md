
# 安装 redis

```
cd ~
wget https://download.redis.io/releases/redis-6.2.11.tar.gz
tar xzf redis-6.2.11.tar.gz
cd redis-6.2.11
make && make install

```

# 创建 db 路径

```
mkdir -p /var/run
mkdir -p /var/redis
mkdir -p /opt/logs/redis
mkdir -p /opt/redis/16379
```

# 启动

复制配置文件到， 把这里的 redis.conf 复制到远程机器的/etc/redis-16379.conf

启动:

```
/usr/local/bin/redis-server /etc/redis-16379.conf
```

添加到 `/etc/rc.local` 开机启动

```
/usr/local/bin/redis-server /etc/redis-16379.conf
```

docker 里面，添加到/root/init.sh 里面

```
/usr/local/bin/redis-server /etc/redis-16379.conf
```

# 测试

```
/usr/local/bin/redis-cli -p 16379
# 登录连接后，输入下面命令
set a 123
get a
del a
get a
```

# 其他

如果要允许任何 ip 链接，则把`bind`注释掉(在`redis.conf`里面).
如果需要密码，则开启`requirepass`在`redis.conf`里面)

`protected-mode` 默认关闭，开启了 `bind`了。 实际情况下，需要修改 bind 可以对应的 ip 地址。

```
bind 127.0.0.1 10.0.2.10 10.0.2.20
```
