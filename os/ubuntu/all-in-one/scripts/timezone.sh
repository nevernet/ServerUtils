#!/bin/bash
apt-get install -y tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
apt-get install -y ntpdate
ntpdate ntp.sjtu.edu.cn # 交大时间服务器