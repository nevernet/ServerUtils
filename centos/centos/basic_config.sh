# centos 基础配置

vi /etc/resolv.conf
nameserver 223.5.5.5
nameserver 223.6.6.6

vi /etc/sysconfig/network
添加:
HOSTNAME=ZLDEV

# ip配置
cd /etc/sysconfig/network-scripts
vi ifcfg-eth0里面的：
ONBOOT=yes

# 静态ip配置
vi ifcfg-eth0
BOOTPROTO=static
ONBOOT=yes
IPADDR=10.0.10.10
NETMASK=255.255.255.0
NETWORK=10.0.10.1

# 重启网络
service network restart
