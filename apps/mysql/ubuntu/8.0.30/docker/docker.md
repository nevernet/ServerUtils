# 运行 docker
```
docker run -itd ubuntu:2204 /bin/bash
```

```bash
apt-get update
apt-get install -y vim wget

```

# 通过 dpkg -l | grep mysql 查看已经安装的mysql和安装的包名

采用dpkg的方式安装

```
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-server_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
# 如果下载慢，可以在其他地方下载完成，然后复制到容器里面 docker cp src_path container:dest_path

tar -xvf mysql-server_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar

apt --fix-broken install -y
apt-get install -y libaio1 libmecab2 libnuma1 libsasl2-2 perl psmisc libjson-perl mecab-ipadic-utf8 apt-utils

dpkg-preconfigure mysql-community-server_*.deb

// 安装过程默认密码：Abcd@1234

dpkg -i mysql-{common,community-client-plugins,community-client-core,community-client,client,community-server-core,community-server,server}_*.deb

// 删除安装包
dpkg --purge mysql-testsuite
dpkg --purge mysql-community-test
dpkg --purge mysql-server
dpkg --purge mysql-community-server
dpkg --purge mysql-client
dpkg --purge mysql-community-server-core
dpkg --purge mysql-community-client
dpkg --purge mysql-community-client-core
dpkg --purge libmysqlclient21
dpkg --purge libmysqlclient-dev
dpkg --purge mysql-community-client-plugins
dpkg --purge mysql-common

#
# dpkg -i mysql-community-server-debug_8.0.30-1ubuntu22.04_amd64.deb
# dpkg -i mysql-community-test-debug_8.0.30-1ubuntu22.04_amd64.deb

```

# 更新配置和创建目录

## 创建目录

```bash
mkdir -p /opt/mysql/innodb_file/
mkdir -p /opt/mysql/log/slow_query_log/
mkdir -p /opt/mysql/log/relay_log/
mkdir -p /opt/mysql/log/
mkdir -p /opt/mysql/data
chown -R mysql:mysql /opt/mysql/

# apparmor 配置
vim /etc/apparmor.d/usr.sbin.mysqld
# 增加
    /opt/mysql/ r,
    /opt/mysql/** rwk,
```

## 复制这里的 [my.cnf](../cnf/my.cnf) 到你的 `/etc/mysql/mysql.conf.d/my.cnf`

1. `vim /etc/mysql/mysql.cnf` 注意先注释掉原来的内容，包括!includedir
2. 启动 mysql 的时候，会重新初始化 mysql，因为 `datadir` 变了。

# 初始化
```
/lib/apparmor/profile-load usr.sbin.mysqld
/usr/sbin/mysqld --defaults-file=/etc/mysql/mysql.conf.d/my.cnf --initialize
```

# 启动
```
/usr/sbin/mysqld --defaults-file=/etc/mysql/mysql.conf.d/my.cnf --daemonize
```

## 日常管理

从 vim /etc/my.cnf 找到默认的日志文件 #从 log 里面找到默认的初始密码：
`vim /var/log/mysqld.log` 或者 `vim /opt/mysql/log/error.log`


- 重启后，默认是 root 用户，空密码，用下面的方式添加用户或者修改密码

- 如果忘记密码或者找不到初始密码，则在`mysqld`的节点下面添加`skip-grant-tables`

- 然后重新启动 `service mysql start`

- 在进入 `mysql -u root`

- 更新密码： `update mysql.user set authentication_string='*F7423DC08C0709F47ABD66B780A90A4989C80E2E' ,plugin='mysql_native_password' where user='root' and Host ='localhost';`

(这里设置的默认密码是 abcd@1234)
然后把`my.cnf`的 skip-grant-tables 去掉，再重启 mysql，就可以用上面的密码进入了.

## 创建用户

```
CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'abcd@1234'; // 这是默认密码
GRANT ALL PRIVILEGES ON *.* TO root@'%';
flush privileges;
```

## 修改密码

```
ALTER USER 'root'@'%' IDENTIFIED BY 'abcd@1234';
ALTER USER 'root'@'localhost' IDENTIFIED BY 'abcd@1234';

# 需要先修改密码，才可以执行后面的 mysql_secure_installation
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'abcd@1234';

```

## 重新执行

```
mysql_secure_installation
```

# 其他设置

```
apt-get install openssh-server
apt-get install tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

```


# docker 本身 创建启动脚本

vim init.sh

```bash

#!/bin/bash
service ssh restart
service mysql restart

while true; do

echo 1
sleep 5s

done

```

# mysql 的配置，请参见

[centos/mysql/my.cnf](../../centos/mysql/my.cnf)

# mysql online document:

https://dev.mysql.com/doc/refman/8.0/en/

# 升级 upgrade mysql:

https://dev.mysql.com/doc/refman/8.0/en/upgrading.html

1. 重新根据 dpkg 的方式安装 mysql
2. `systemctl start mysql.service` 即可

# 提交镜像

```
docker commit -a "Daniel Qin" -m "MySQL 8.0.19" a671d45dcd04 ubuntu-mysql8:v2
```
