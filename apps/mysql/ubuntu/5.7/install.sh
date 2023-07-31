#!/bin/bash

# apt 安装
apt-get install -y lsb-release gnupg
wget https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb
dpkg -i mysql-apt-config_0.8.26-1_all.deb
apt-get update
apt-get install -y mysql-server mysql-client

# 提示安装的密码：
abcd@1234

# dpkg 安装
# 默认密码： OCE@!KTuF8HGOCt9
# 通过本机上传deb包到服务器
# mysql-server_5.7.42-1ubuntu18.04_amd64.deb-bundle.tar
apt -y --fix-broken install
apt-get install -y libaio1 libmecab2 libnuma1 libsasl2-2 perl psmisc libjson-perl mecab-ipadic-utf8 apt-utils

tar xvf mysql-server_5.7.42-1ubuntu18.04_amd64.deb-bundle.tar
dpkg -i libmysql*.deb
dpkg -i mysql-{common,community-client,client,community-server,server}_*.deb

# /var/log/mysql/error.log 查询默认密码
# 如果找不到密码：
# 1 在/etc/my.cnf 添加:
# skip-grant-tables，重启MySQL
# 2 登录MySQL，然后在修改默认密码：
# update mysql.user set authentication_string=password('new_password') where user='root' and Host ='localhost';
#（注意修改where条件）
# 3 从/etc/my.cnf里面移除: skip-grant-tables，重启mysql
# 4 再执行mysql_secure_installation初始化


# 重新执行
mysql_secure_installation

# 修改配置文件
# vim /etc/mysql/mysql.conf.d/mysqld.cnf，不然远程无法访问
bind-address=0.0.0.0

# 创建远程用户
CREATE USER 'root'@'%' IDENTIFIED BY 'OCE@!KTuF8HGOCt9';
alter user 'root'@'%' IDENTIFIED BY 'OCE@!KTuF8HGOCt9';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
flush privileges;