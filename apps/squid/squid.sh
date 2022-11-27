#!/bin/bash
#reference: https://www.linode.com/docs/networking/squid/squid-http-proxy-centos-6-4

yum install -y squid
yum install -y httpd-tools
cp -f squid.conf /etc/squid/squid.conf 

firewall-cmd --zone=public --add-port=3128/tcp --permanent
firewall-cmd --reload

touch /etc/squid/squid_passwd
chown squid /etc/squid/squid_passwd

# 添加用户
echo "
123456
123456
" | htpasswd /etc/squid/squid_passwd demouser

systemctl enable squid
systemctl start squid

