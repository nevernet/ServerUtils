# 修改dns
默认情况下， /etc/resolv.conf 是链接到 `/run/systemd/resolve/stub-resolv.conf`, 需要修改成： `/run/systemd/resolve/resolv.conf`

`ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf`



# 其他方式
停用系统dns解析

```
systemctl stop systemd-resolved
systemctl disdable systemd-resolved
```


/etc/resolv.conf中设置dns之后每次重启Ubuntu Server时该文件会被覆盖，针对这种情况找了一些个解决方法

防止/etc/resolv.conf被覆盖的方法

方法一

1.需要创建一个文件/etc/resolvconf/resolv.conf.d/tail

```
sudo vi /etc/resolvconf/resolv.conf.d/tail
```

2.在该文件中写入自己需要的dns服务器，格式与/etc/resolv.conf相同

```
nameserver 8.8.8.8
```

3.重启下resolvconf程序

```
sudo /etc/init.d/resolvconf restart
```

再去看看/etc/resolv.conf文件,可以看到自己添加的dns服务器已经加到该文件中

方法二

在/etc/network/interfaces中

```
###interfaces中#######
auto eth0
iface eth0 inet static
address 192.168.3.250
netmask 255.255.255.0                  #子网掩码
gateway 192.168.3.1                      #网关
dns-nameservers 8.8.8.8 8.8.4.4    #设置dns服务器
```