# 基础

```
apt-get update
```

## 配置 vim

```bash
apt-get install -y vim

# vim ~/.vimrc

set nu # 显示行号
# 中文支持
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set nu
```

## 修改 sshd 配置

```bash
apt-get install -y openssh-server openssh-client
vim /etc/ssh/sshd_config

# 修改如下：
ClientAliveInterval 60
ClientAliveCountMax 3
PermitRootLogin yes # 根据实际情况开启是否允许密码登录
UseDNS no

service ssh restart
```

## 配置时区

```bash
apt-get install -y tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

## 修改 hostname

```
vim /etc/hostname
```

## 创建启动脚本

```bash
vim ~/init.sh

# 输入
#!/bin/bash
service ssh restart

while true; do

echo 1
sleep 5s

done

# 修改权限

chmod +x init.sh
```

# 安装 net tools

```
sudo apt-get install net-tools iputils-ping telnet
```

之后就可以使用 ifconfig -a

# 升级和清理系统

```
sudo apt update
sudo apt upgrade
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove --purge
```

# ubuntu 主机禁止 rp_filter 校验：

如果没有 eth1 就去掉
`for ifn in all default eth0 eth1; do echo 0 > /proc/sys/net/ipv4/conf/\$ifn/rp_filter; done`

查看
`sysctl -a | grep rp_filter`

# 18.04 修改/etc/resolv.conf

默认情况下， /etc/resolv.conf 是链接到 `/run/systemd/resolve/stub-resolv.conf`,需要修改成： `/run/systemd/resolve/resolv.conf`

`ln -sf /run/systemd/resolve/resolv.conf /etc/resolve.conf`

## 添加辅助 ip:

```bash
# vim /etc/network/interfaces
# 添加固定入口的ip地址
auto eth0
iface eth0 inet static
address 10.0.0.10
netmask 255.255.255.0
gateway 10.0.0.1


# vim /etc/network/interfaces
# 添加别名不要填gateway

auto eth0:0
iface eth0:0 inet static
address 10.0.0.21
netmask 255.255.255.0
```

保存退出
然后启用这个网卡：

```bash
ifdown eth0:0 && ifup eth0:0
#如果不行，则用:
ifconfig eth0:0 down && ifconfig eth0:0 up
#如果还不行则 (ubuntu 下)
service networking restart
```

可能需要安装：`apt install -y ifupdown ifupdown2 netscript-2.4`

## 添加多网卡

因为已经有网卡，且有网关，所以新网卡不要添加网关. 先用`ifconfig`查看新绑定的网卡， 这里是`eth1`
开始配置：

```
auto eth1
iface eth1 inet static
address 10.11.2.2
netmask 255.255.255.0
```

重启：

```
/etc/init.d/networking restart
```

配置路由：

```
echo "20 t2" >> /etc/iproute2/rt_tables
```

添加 ip 策略：

```
ip route add default dev eth1 via 10.11.2.1 table 20
ip rule add from 10.11.2.2 table 20
```

为了保证重启网卡还有效，需要添加到 `/etc/rc.local`

```
vim /etc/rc.local
ip route add default dev eth1 via 10.11.2.1 table 20
ip rule add from 10.11.2.0/24 table 20
ip rule add from 10.0.22.0/24 table 20
```
