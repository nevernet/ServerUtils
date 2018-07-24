# 拉取最新的alpine，目前是3.6
docker pull alpine latest

# 启动容器
docker run --network br0 --ip 10.0.20.100 -itd --privileged -h alpine --name alpine alpine:base ash
docker run --network br0 --ip 10.0.20.104 -itd --privileged -h alpine_java --name alpine_java alpine:base ash

docker run --network br0 --ip 10.0.20.100 -itd --privileged -h java --name java 10.0.20.200:5000/centos:v2 /bin/bash

# 更新apk索引
apk update

# 安装rc-update管理
apk add --no-cache openrc

# 安装 ssh server
apk add openssh openssh-server
rc-update add sshd
rc-status # 查看启动级别状态
touch /run/openrc/softlevel
/etc/init.d/sshd start # 启动

apk add wget

# 时区设置
apk add tzdata
cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

# 添加 .ashrc
vi .ashrc # 添加下面内容
PS1='\[\033[0;32m\]\u@\h:\[\033[36m\]\W\[\033[0m\] \$ '
alias ll="ls -alh"
#保存后，重载.ashrc
source .ashrc

# 添加 init.sh
vi ~/init.sh
# >>>>>>>>>>>>>>>>>>
#!/bin/sh
source /root/.ashrc

while true; do
echo 1
sleep 5s
done
# <<<<<<<<<<<<<<<<<<

# install java
apk add openjdk8-jre openjdk8-jre-base

# install mysql
apk add make cmake gcc g++ bison ncurses gnupg linux-headers perl pwgen

apk add boost-dev ncurses-dev libaio-dev libc-dev libedit-dev libc-dev glib glib-dev
apk add libevent libevent-dev installkernel inotify-tools inotify-tools-dev

# 添加编译依赖:
apk add vim
apk add gcc libc-dev g++ libgcc libgc++ glib glib-dev glib-lang glib-static glib-networking

# 创建用户和用户组
addgroup mysql
adduser mysql -G mysql -H -D -s /sbin/nologin

# 下载mysql
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.18.tar.gz
tar zxf mysql-boost-5.7.18.tar.gz

# 编译，参考https://dev.mysql.com/doc/refman/5.7/en/source-configuration-options.html
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DBUILD_CONFIG=mysql_release \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DWITH_BOOST=./boost/boost_1_59_0 \
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

# 删除编译依赖
apk del vim gcc libc-dev g++ libgcc libgc++ glib glib-dev glib-lang glib-static glib-networking
apk del perl-gd
