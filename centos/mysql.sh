#!/bin/bash

# 安装方式一： 安装mysql repo源
# wget -O mysql-5.7.rpm http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
wget -O mysql-5.7.rpm https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm
rpm -ivh mysql-5.7.rpm

yum install -y mysql-community-server

# 安装方式二： 如果yum安装速度很慢，则可以通过下载bundle.tar文件来安装，这个是把所有rpm包打包后的文件
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.17-1.el6.x86_64.rpm-bundle.tar
tar xvf mysql-5.7.17-1.el6.x86_64.rpm-bundle.tar # 会解压出来很多rpm文件
# 解压出来的文件:
# mysql-community-test-5.7.17-1.el6.x86_64.rpm
# mysql-community-embedded-5.7.17-1.el6.x86_64.rpm
# mysql-community-embedded-devel-5.7.17-1.el6.x86_64.rpm
# mysql-community-server-5.7.17-1.el6.x86_64.rpm
# mysql-community-libs-compat-5.7.17-1.el6.x86_64.rpm
# mysql-community-devel-5.7.17-1.el6.x86_64.rpm
# mysql-community-client-5.7.17-1.el6.x86_64.rpm
# mysql-community-libs-5.7.17-1.el6.x86_64.rpm
# mysql-community-common-5.7.17-1.el6.x86_64.rpm

# 删除mysql-libs- 5.1.73-5.el6_7.1
yum remove -y mysql-libs*
# 安装顺序:
yum install -y numactl perl-JSON perl-Time-HiRes libaio initscripts
rpm -ivh mysql-community-common-5.7.17-1.el6.x86_64.rpm
rpm -ivh mysql-community-libs-5.7.17-1.el6.x86_64.rpm
rpm -ivh mysql-community-client-5.7.17-1.el6.x86_64.rpm
rpm -ivh mysql-community-devel-5.7.17-1.el6.x86_64.rpm
rpm -ivh mysql-community-libs-compat-5.7.17-1.el6.x86_64.rpm
rpm -ivh mysql-community-server-5.7.17-1.el6.x86_64.rpm
rpm -ivh mysql-community-embedded-5.7.17-1.el6.x86_64.rpm mysql-community-embedded-devel-5.7.17-1.el6.x86_64.rpm

# 启动
service mysqld start
chkconfig mysqld on

#从vim /etc/my.cnf找到默认的日志文件
#从log里面找到默认的初始密码：
vim /var/log/mysqld.log

# 安全配置
mysql_secure_installation


docker run --network br0 --ip 10.0.20.103 -itd --privileged -h mysql --name mysql centos:6 /bin/bash