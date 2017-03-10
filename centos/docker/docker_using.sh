#!/bin/bash

#install docker on ubuntu:
https://docs.docker.com/engine/installation/linux/ubuntu/

#创建一个网络 ，自定义一个网路叫br0, 网段10.0.2.x
docker network create --subnet=10.0.2.1/24 br0

#镜像：使用centos 6镜像，目前最新的是centos 6.8
docker pull centos:6

#运行docker
docker run --network br0 --ip 10.0.2.10 -i -t -d --privileged -h centos_v2_base --name centos_v2_base centos:v2 /bin/bash

# 进入已经运行的容器：
docker exec -i -t 7b82b02cb825 /bin/bash
