## 添加辅助 ip:

```bash
# vim /etc/network/interfaces
# 添加固定入口的ip地址
auto eth0
iface eth0 inet static
address 10.0.0.10
netmask 255.255.255.0
gateway 10.0.0.1
#dns-nameservers 114.114.114.114 8.8.8.8


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

可能需要安装：`apt-get install -y ifupdown`

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
