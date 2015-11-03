#!/bin/bash
# update system
yum -y update
yum -y groupinstall "Development tools"
yum install wget

# enable aliyun repo
sed -i.backup 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base-aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#php
yum install -y php php-devel php-fpm
