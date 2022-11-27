echo "[nginx]" > /etc/yum.repos.d/nginx.repo
echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
echo "baseurl=http://nginx.org/packages/centos/6/\$basearch/" >> /etc/yum.repos.d/nginx.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo "enabled=1" >> /etc/yum.repos.d/nginx.repo


yum repolist && yum install nginx

创建基础的目录： 

```
mkdir -p /opt/logs/nginx
mkdir -p /opt/etc/nginx
mkdir -p /opt/logs/
mkdir -p /opt/logs/php
mkdir -p /opt/www/
mkdir -p /opt/files/
```
