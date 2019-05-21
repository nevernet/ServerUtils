-   基础

```
apt-get update
```

-   配置 vim

```
apt-get install -y vim

# vim ~/.vimrc

set nu # 显示行号
# 中文支持
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set nu
```

-   修改 sshd 配置

```
apt-get install -y openssh-server
vim /etc/ssh/sshd_config

# 修改如下：
ClientAliveInterval 60
ClientAliveCountMax 3
UseDNS no

service ssh restart
```

-   配置时区

```
apt-get install -y tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

-   创建启动脚本

```
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

`sudo apt-get install net-tools`
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
