# 基础

启用阿里云的镜像

更换 中科大镜像，其他几个清华，阿里云等公网速度都很慢

```
cp /etc/apt/sources.list  /etc/apt/sources.list.bak
sed -i  "s/archive\.ubuntu\.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
sed -i  "s/security\.ubuntu\.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list

apt-get update
apt-get upgrade -y
```

## 配置 vim

```bash
apt-get install -y vim

# vim ~/.vimrc

# 中文支持
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set nu
```

## iptables 配置，修改开放 ssh, web,等端口

```
vim /root/iptables.sh
```

把 `/root/iptables.sh` 添加到 `/etc/rc.local`，确保开机启动

## 修改 sshd 配置

```bash
apt-get install -y openssh-server openssh-client
vim /etc/ssh/sshd_config

# 修改如下：
Port 22 # 修改成自己的端口
ClientAliveInterval 60
ClientAliveCountMax 3
PermitRootLogin yes # 根据实际情况开启root登录
UseDNS no

service ssh restart
```

## 配置时区

```bash
apt-get install -y tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 或者重新配置时间
dpkg-reconfigure tzdata
```


## 同步时间

```
sudo apt-get install ntpdate
sudo ntpdate ntp.sjtu.edu.cn # 交大时间服务器
```

## 修改 hostname 和 hosts

```
vim /etc/hostname
ZL-SH-SVR01
```

修改`vim /etc/hosts`，添加

```
echo "127.0.0.1 ZL-SH-SVR01" >> /etc/hosts
```

同时添加到 `/etc/rc.local`，这样开机启动的时候，自动就添加了

# 安装 net tools

```
sudo apt-get install -y net-tools iputils-ping telnet
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
`for ifn in all default eth0 eth1; do echo 0 > /proc/sys/net/ipv4/conf/$ifn/rp_filter; done`

查看
`sysctl -a | grep rp_filter`
