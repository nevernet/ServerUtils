# alpine 安装相关

替换源:

```
vi /etc/apk/repositories
# 把原来的注释掉
#http://dl-cdn.alpinelinux.org/alpine/v3.7/main
#http://dl-cdn.alpinelinux.org/alpine/v3.7/community
# 添加新的国内源
https://mirrors.ustc.edu.cn/alpine/v3.7/main
https://mirrors.ustc.edu.cn/alpine/v3.7/community
```

执行: `apk update`

# 安装 openrc, 提供命令：rc-service, rc-update, rc-status 等

```
apk add openrc
touch /run/openrc/softlevel
```

# 安装 openssh-server

```
apk add openssh-server openssh-client
rc-update add sshd default
rc-service sshd restart
rc-status

# 配置文件修改：
vim /etc/ssh/sshd_config
```

# 安装

```
apk add git wget bash bash-completion
```

# 基础设置

```
# https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-dns

vi /etc/network/interfaces
# 添加：
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
```

# 修改/etc/passwd

```
vi /etc/passwd
```

# docker run demo

```
docker run  -itd --privileged alpine:latest /bin/bash
```
