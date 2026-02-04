# 腾讯云指定镜像获取

## 拉取镜像
docker pull mirror.ccs.tencentyun.com/library/ubuntu:24.04

## 创建容器
docker run -itd --network br30 --privileged mirror.ccs.tencentyun.com/library/ubuntu:24.04 /bin/bash

## 进入容器
docker exec -it -w /root c74120714b2d /bin/bash
## 提交镜像
docker commit -a "Daniel Qin" -m "base ubuntu 24.04" c74120714b2d ubuntu-base:24.04

## tag 镜像
docker tag ubuntu-base:24.04 <customer.com>/ubuntu-base:24.04
## 推送镜像
docker push <customer.com>/ubuntu-base:24.04