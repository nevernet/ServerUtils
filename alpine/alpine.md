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
apk add openssh-server openssh-client rsync
rc-update add sshd default
rc-service sshd restart
rc-status

# 配置文件修改：
vim /etc/ssh/sshd_config
```

# 安装

```
apk add git wget bash bash-completion netcat-openbsd
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

# 时区设置

```
apk add tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

# 修改/etc/passwd `vi /etc/passwd`

确保 `root` 的登录是: `/bin/bash`

# 修改 `vi ~/.bashrc`

确保有：

```
source /etc/profile.d/bash_completion.sh
```

# docker run demo

```
docker run  -itd --privileged -h demo --name demo alpine:latest /bin/bash
```

有的时候会报错误：`/lib/rc/sh/openrc-run.sh: line 273: can't create /sys/fs/cgroup/freezer/tasks: Read-only file system`

```
docker run  -itd -v /sys/fs/cgroup:/sys/fs/cgroup --privileged -h demo --name demo alpine:latest /bin/bash
```

# vi ~/.vimrc

中文支持和行号

```
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set nu
```

# 默认加载 `.bashrc`

```
cd ~
vi .profile
# 添加内容
source .bashrc
```
