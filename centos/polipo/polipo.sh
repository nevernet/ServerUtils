#!/bin/bash

yum install texinfo -y

git clone --depth=1 https://github.com/jech/polipo.git
cd polipo
make
make install

# 复制 polipo.config

# 启动脚本
killall polipo
nohup polipo -c /shadowsocks/polipo.config &

# shell env 修改
export http_proxy=http://127.0.0.1:8123
export https_proxy=http://127.0.0.1:8123
