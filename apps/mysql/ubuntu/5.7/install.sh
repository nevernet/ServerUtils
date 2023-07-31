#!/bin/bash

apt-get install -y lsb-release gnupg
wget https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb
dpkg -i mysql-apt-config_0.8.26-1_all.deb
apt-get update
apt-get install -y mysql-server mysql-client

# 提示安装的密码：
abcd@1234