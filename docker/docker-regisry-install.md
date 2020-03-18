# 自建 docker registry

## 创建存储目录

```
mkdir -p /opdata2/zl_registry
mkdir -p /opdata2/zl_registry_web
```

## 拉取最新的 registry 镜像

`docker pull registry:2`

## 创建容器

docker run --network br5 --ip 10.0.5.200 -d -v /opdata2/zl_registry:/var/lib/registry --restart=always -h ZL_REGISTRY --name ZL_REGISTRY registry:2

## 创建 docker registry 前端 nginx

docker run --network br5 --ip 10.0.5.202 -d -v /opdata2/zl_registry_web:/opt/etc/nginx --privileged --restart always -h ZL_DOCKER_WEB --name ZL_DOCKER_WEB docker.zhiliaotech.cn/alpine-nginx:v2 /root/init.sh
(
插曲：
需要安装: yum install -y httpd-tools
用 htpasswd -c /opt/etc/nginx/docker-registry.htpasswd docker 创建 docker 用户，密码: <your password>

其他地方使用：
docker login https://docker.<your domain>.cn/ ,输入用户:docker， 输入密码：<your password>
然后拉取：
docker pull docker.<your domain>.cn/centos:v2

注意： docker registry 的完整配置：
http://seanlook.com/2014/11/13/deploy-private-docker-registry-with-nginx-ssl/
)
