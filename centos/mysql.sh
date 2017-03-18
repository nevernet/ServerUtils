#!/bin/bash

# 安装mysql repo源
# wget -O mysql-5.7.rpm http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
wget -O mysql-5.7.rpm https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm
rpm -ivh mysql-5.7.rpm

yum install -y mysql-community-server

# 启动
service mysqld start
chkconfig mysqld on

#从vim /etc/my.cnf找到默认的日志文件
#从log里面找到默认的初始密码：
vim /var/log/mysqld.log

# 安全配置
mysql_secure_installation
