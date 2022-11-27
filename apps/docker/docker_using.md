install docker on ubuntu:
`https://docs.docker.com/engine/installation/linux/ubuntu/`

创建一个网络 ，自定义一个网路叫 br0, 网段 10.0.2.x

```
docker network create --subnet=10.0.2.1/24 --opt "com.docker.network.bridge.name"="br2" br2
```

镜像：使用 centos 6 镜像，目前最新的是 centos 6.8

```
docker pull centos:6
```

运行 docker

```
docker run --network br0 --ip 10.0.2.10 -d --privileged=true -h centos_v2_base --name centos_v2_base centos:v2
```

进入已经运行的容器：

```
docker exec -i -t 7b82b02cb825 /bin/bash
```

# centos 7 创建容器操作

```bash
#创建本机目录，用于单独存放容器的文件, test_management_os表示容器的名字
mkdir -p /opdata/test_management_os

# 获取镜像
docker pull centos:7

# 创建容器
docker run -d --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup \
 -v /opdata/test_management_os:/opt \
 --restart always \
 -h test_management_os \
 --name test_management_os \
 -p 80:80 -p 443:443 -p 3306 -p 11211 -p 6379 \
 centos:7 /usr/sbin/init

# 其中 `-v /opdata/test_management_os:/opt` 表示把宿主机目录/opdata/test_management_os映射到容器的/opt目录。

# 查看创建的容器，获取容器id: container id
docker ps -a


# 进入容器
docker exec -it <容器id> /bin/bash

# 容器的centos是一个极简的系统，安装工具，比如：
yum install -y wget
yum groupinstall -y "Development Tools"

# 更多其他工具根据需求安装

# 安装项目软件，所有的软件文件等都安装在/opt目录下
# ...

# 退出容器
exit

# 在宿主机，停止容器
docker stop 容器id

# 在宿主机，删除容器
docker rm 容器id

# 导出容器，先停止容器再导出
cd /root
docker export 容器id > test_management_os.tar

# 导入： 复制 test_management_os.tar 到其他服务器目录： /root，
cd /root
docker import test_management_os.tar test_management_os:v1
# 本机测试的时候，直接 docker import，不用复制

# 其中 `test_management_os:v1`是镜像名字，通过下面命令：
docker images

# 通过 test_management_os:v1 创建容器
docker run -d --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup \
 -v /opdata/test_management_os:/opt \
 --restart always \
 -h test_management_os \
 --name test_management_os \
 -p 80:80 -p 443:443 -p 3306 -p 11211 -p 6379 \
 test_management_os:v1 /usr/sbin/init

```
