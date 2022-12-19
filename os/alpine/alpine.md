# alpine 安装相关

## 一、用最新版本的 alpine 制作 docker 镜像：

1. 更新 alpine 到最新版本
   `docker pull alpine:latest`

2. 重新制作镜像(osx)

```bash
   docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup --privileged=true -h alpine-image --name alpine-image alpine:latest /bin/ash
```

```bash
# 3.15
docker run -d --privileged=true -h alpine-image315 --name alpine-image315 alpine:3.15 /bin/ash
```

第一次执行的时候只有`/bin/ash`

### docker run demo

```bash
docker run  -d --privileged=true -h demo --name demo alpine:latest /bin/bash
```

有的时候会报错误：`/lib/rc/sh/openrc-run.sh: line 273: can't create /sys/fs/cgroup/freezer/tasks: Read-only file system`

```bash
docker run  -d -v /sys/fs/cgroup:/sys/fs/cgroup --privileged=true -h demo --name demo alpine:latest /bin/bash
```

第一次进入容器：

```bash
docker exec -it 63647824ac06 /bin/ash
```

当配置好`bash`后则可以：

```
docker exec -it 63647824ac06 /bin/bash
```

## 二、配置和安装软件

替换源:

```bash
vi /etc/apk/repositories
# 把原来的注释掉
#http://dl-cdn.alpinelinux.org/alpine/v3.7/main
#http://dl-cdn.alpinelinux.org/alpine/v3.7/community

# 添加新的国内源
https://mirrors.ustc.edu.cn/alpine/v3.14/main
https://mirrors.ustc.edu.cn/alpine/v3.14/community

https://mirrors.aliyun.com/alpine/v3.14/main
https://mirrors.aliyun.com/alpine/v3.14/community

https://mirrors.aliyun.com/alpine/v3.15/main
https://mirrors.aliyun.com/alpine/v3.15/community

http://mirrors.tencentyun.com/alpine/v3.17/main
http://mirrors.tencentyun.com/alpine/v3.15/community

```

执行: `apk update`
升级： `apk upgrade`

### 安装 bash

```
apk add bash bash-completion

vi ~/.bashrc

alias update='apk update && apk upgrade'
export HISTTIMEFORMAT="%d/%m/%y %T "
export PS1='\u@\h:\W \$ '
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
source /etc/profile.d/bash_completion.sh
export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "
```

### 修改/etc/passwd `vi /etc/passwd`

确保 `root` 的登录是: `/bin/bash`

### 默认加载 `.bashrc`

```
vi .profile

source .bashrc
```

### 安装 openrc, 提供命令：rc-service, rc-update, rc-status 等

```bash
apk add openrc
mkdir -p /run/openrc
touch /run/openrc/softlevel
```

### 安装 openssh-server

```bash
apk add openssh-server openssh-client rsync openssh-sftp-server
rc-update add sshd default
rc-service sshd restart
rc-status

# 配置文件修改：
vi /etc/ssh/sshd_config
```

`openssh-sftp-server` 安装后，可以支持 sftp 目录。 默认安装目录在/usr/lib/ssh/sftp-server

### 安装系统启动脚本

```
# 老版本
apk add busybox-initscripts
v3.17
apk add busybox-openrc

# 添加crond的启动
rc-update add crond default && rc-service crond start
```

### 安装软件

```bash
apk add git wget netcat-openbsd ca-certificates
```

### 网络设置

```bash
#https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-dns

vi /etc/network/interfaces

# 添加：
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
```

### 时区设置

```bash
apk add tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
```

### vi ~/.vimrc

中文支持和行号

```bash
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set nu
```

# 提交到镜像

```
docker commit -m="alpine 3.11镜像" -a="Daniel Qin" 63647824ac06 alpine:v3

docker commit -m="alpine 3.15镜像" -a="Daniel Qin" bbcb201fea34 alpine:3.15
docker tag alpine:3.15 docker.example.com/alpine:3.15
docker push docker.example.com/alpine:3.15
```

通过`docker images`查看，就有了`alpine v3`的镜像
