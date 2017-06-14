#!/bin/bash
# update system
yum -y update
yum -y groupinstall "Development tools"
#yum groupinstall "Additional Development"
yum install -y epel-release
yum install wget

# enable aliyun repo
sed -i.backup 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base-aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
#mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo


#open ssh server
yum install openssh-server -y
cd /etc/ssh
#generate related keys
/usr/bin/ssh-keygen -A

echo "useDNS no" >> /etc/ssh/sshd_config
systemctl enable sshd
systemctl restart sshd
# or
# /usr/sbin/sshd

# 禁用firewall-cmd
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动

# 安装iptables
yum install -y iptables-services
systemctl restart iptables.service #最后重启防火墙使配置生效
systemctl enable iptables.service #设置防火墙开机启动