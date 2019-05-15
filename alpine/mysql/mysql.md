# 由于编译不成功，所以废弃在 alpine 安装 mysql, 请参考 [ubuntu-mysql.md](../../ubuntu/mysql/ubuntu-mysql.md)

docker run -itd --privileged -h mysql8 --name mysql8 alpine:v2.1 /bin/bash

apk update

# 创建用户和用户组

```
addgroup mysql
adduser mysql -G mysql -H -D -s /sbin/nologin
```

# 安装依赖

# bison ncurses gnupg perl

```
apk add cmake make gcc g++ linux-headers

apk add boost-dev ncurses-dev libaio-dev libc-dev libedit-dev libc-dev glib-dev libc-dev libgcc libgc++ glib-lang glib-static glib-networking libevent-dev installkernel inotify-tools-dev openssl-dev rpcgen libtirpc-dev
```

# 下载和编译

```
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-8.0.11.tar.gz
tar zxf mysql-boost-8.0.11.tar.gz
cd mysql-8.0.11
```

> 编译，参考https://dev.mysql.com/doc/refman/5.7/en/source-configuration-options.html

```
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DBUILD_CONFIG=mysql_release \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DWITH_BOOST=./boost/boost_1_66_0 \
-DSYSCONFDIR=/etc \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_DEBUG=0 \
-DENABLE_DTRACE=0 \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci \
-DWITH_EMBEDDED_SERVER=1

make

make install

mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql
```

./bin/mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
