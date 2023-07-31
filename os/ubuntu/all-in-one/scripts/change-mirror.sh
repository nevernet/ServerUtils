#!/bin/bash

cp /etc/apt/sources.list  /etc/apt/sources.list.bak
sed -i  "s/archive\.ubuntu\.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
sed -i  "s/security\.ubuntu\.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list

apt-get update
apt-get upgrade -y