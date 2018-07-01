# 安装 go

yum install -y wget git
wget https://dl.google.com/go/go1.10.3.linux-386.tar.gz # 如果是 64 位机器，则下载 64 的
tar zxf go1.10.3.linux-386.tar.gz
mv go /usr/local

# 修改 .bash_profile

PATH=$PATH:/usr/local/go/bin

# 测试

go version

# 安装 shadowsocks

go get -u -v github.com/shadowsocks/go-shadowsocks2

默认安装到当前用户目录：`~/go/bin` 下面

# 添加~/go/bin 到 PATH 里面

PATH=$PATH:/root/go/bin

# 测试命令：

go-shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:your_password@:8488' -verbose

# 安装 supervisor，来自动管理

-   安装 python 相关: [pyenv.md](../python/pyenv.md)
-   安装 superviosr [supervisor.md](../supervisor/supervisor.md)
    根据 supervisor 的配置，把 `go-shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:your_password@:8488'`加入即可。

# 本机（客户端）配置

> go 安装同之前的步骤。

go get -u -v github.com/shadowsocks/go-shadowsocks2

创建本机执行文件: shadowsocks.sh

#!/bin/bash
nohup go-shadowsocks2 -c 'ss://AEAD_CHACHA20_POLY1305:your_password@[server_addres]:8488' \
 -verbose -socks :7070 -u -udptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 \
 -tcptun :8053=8.8.8.8:53,:8054=8.8.4.4:5 </dev/null >/dev/null 2>&1 &

chmod a+x shadowsocks.sh

# 启动

./shadowsocks.sh
