# 运行 docker

```
docker run -itd --privileged -h ubuntu_mysql8 --name ubuntu_mysql8 ubuntu:18.04 /bin/bash
```

安装

```
apt-get update
apt-get install vim wget

wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb

wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-server_8.0.11-1ubuntu18.04_amd64.deb-bundle.tar

tar -xvf mysql-server_8.0.11-1ubuntu18.04_amd64.deb-bundle.tar

apt-get install libaio1 libmecab2 libnuma1 libsasl2-2 perl psmisc dialog
apt --fix-broken install

dpkg -i mysql-common_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i libmysqlclient21_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i libmysqlclient-dev_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i mysql-community-client-core_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i mysql-community-client_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i mysql-client_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i mysql-community-server-core_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i mysql-community-server_8.0.11-1ubuntu18.04_amd64.deb
dpkg -i mysql-server_8.0.11-1ubuntu18.04_amd64.deb
```

# 启动

```
service mysql status
service mysql start
```

# 创建用户

```
CREATE USER 'root'@'%' IDENTIFIED BY 'abcd@1234';
GRANT ALL PRIVILEGES ON _._ TO root@'%';
flush privileges;
```

# 修改密码

```
ALTER USER 'root'@'%' IDENTIFIED BY 'MyNewPass';
ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';
```

# 其他设置

```
apt-get install openssh-server
apt-get install tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

# 创建启动脚本

vim init.sh

```
#!/bin/bash
service ssh restart
service mysql restart

while true; do

echo 1
sleep 5s

done
```
