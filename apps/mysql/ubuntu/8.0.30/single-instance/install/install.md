# 安装

## 系统需求

系统： ubuntu 22.04
MySQL 版本： 8.0.30

提前关闭 apparmor

```
systemctl stop apparmor && systemctl disable apparmor
ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld
aa-status
```

重启系统

```bash
apt-get update
apt-get install -y vim wget

```

## 具体安装

通过 dpkg -l | grep mysql 查看已经安装的mysql和安装的包名

###  方法1：

下载最新的apt配置文件： https://dev.mysql.com/downloads/repo/apt/

```
apt-get install -y lsb-release gnupg
wget https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb
dpkg -i mysql-apt-config_0.8.26-1_all.deb
# 选择 MySQL Server & Cluster (Currently selected: mysql-8.0)
apt-get update
apt-get install -y mysql-server mysql-client
```


### 方法 2：

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

## 更新配置和创建目录

### 创建目录

```bash
mkdir -p /opt/mysql/innodb_file/
mkdir -p /opt/mysql/log/slow_query_log/
mkdir -p /opt/mysql/log/relay_log/
mkdir -p /opt/mysql/log/
mkdir -p /opt/mysql/data
chown -R mysql:mysql /opt/mysql/
chmod 750 /opt/mysql
chmod 750 /opt/mysql/data
```

### 增加配置文件

复制这里的 [my.cnf](./cnf/my.cnf) 到你的 `/etc/mysql/mysql.conf.d/mysql63306.cnf`

1. `vim /etc/mysql/mysql.cnf` 注意先注释掉原来的内容，包括!includedir
2. 启动 mysql 的时候，会重新初始化 mysql，因为 `datadir` 变了。


### 配置启动脚本

```
cd /usr/lib/systemd/system/
cp mysql.service mysql63306.service
```

修改 `mysql63306.service`内容如下
```
[Unit]
Description=MySQL Community Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target

[Install]
WantedBy=multi-user.target

[Service]
User=mysql
Group=mysql
Type=notify
# ExecStartPre=+/usr/share/mysql-8.0/mysql-systemd-start pre
ExecStart=/usr/sbin/mysqld --defaults-file=/etc/mysql/mysql.conf.d/mysql63306.cnf
TimeoutSec=0
PermissionsStartOnly=true
LimitNOFILE=500000
Restart=on-failure
RestartPreventExitStatus=1

# Always restart when mysqld exits with exit code of 16. This special exit code
# is used by mysqld for RESTART SQL.
RestartForceExitStatus=16

# Set enviroment variable MYSQLD_PARENT_PID. This is required for restart.
Environment=MYSQLD_PARENT_PID=1
```

重新加载配置文件

```
systemctl daemon-reload

# 禁用原来的mysql.service
systemctl stop mysql.service && systemctl disable mysql.service

```

### 初始化MySQL

```

# 初始化，必须先禁用plugin(group_replication等参数才可以初始化成功)
/usr/sbin/mysqld --defaults-file=/etc/mysql/mysql.conf.d/mysql63306.cnf --initialize --user=mysql

# 配置新的mysql63306服务
systemctl enable mysql63306.service && systemctl start mysql63306.service

# 执行
mysql_secure_installation
```

mysql初始化文档参考：

https://dev.mysql.com/doc/refman/8.0/en/data-directory-initialization.html


### 修改配置文件，启用MGR配置
```
vim /etc/mysql/mysql.conf.d/mysql63306.conf
```

## 日常管理

```
systemctl start|stop|restart|status mysql63306.service
```

从 vim /etc/my.cnf 找到默认的日志文件 #从 log 里面找到默认的初始密码：
`vim /var/log/mysqld.log`


- 如果提示 mysql 服务无法识别或者不存在，则复制启动脚本[init.d/mysql](init.d/mysql) 到 ubuntu 系统的`/etc/init.d/`里面

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
