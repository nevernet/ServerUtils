# 运行 docker

```
docker run -itd --privileged -h ubuntu_mysql8 --name ubuntu_mysql8 ubuntu:18.04 /bin/bash
```

安装

```
apt-get update
apt-get install -y vim wget

# 通过 dpkg -l | grep mysql 查看已经安装的mysql和安装的包名

# 方法1： 下载最新的apt配置文件： https://dev.mysql.com/downloads/repo/apt/
apt-get install -y lsb-release gnupg
wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb
dpkg -i mysql-apt-config_0.8.13-1_all.deb # 选择 MySQL Server & Cluster (Currently selected: mysql-8.0)
apt-get update
apt-get install -y mysql-server mysql-client

# 方法2：
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-server_8.0.16-2ubuntu18.04_amd64.deb-bundle.tar

tar -xvf mysql-server_8.0.16-2ubuntu18.04_amd64.deb-bundle.tar

apt --fix-broken install -y
apt-get install libaio1 libmecab2 libnuma1 libsasl2-2 perl psmisc

dpkg -i mysql-common_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i libmysqlclient21_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i libmysqlclient-dev_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-community-client-core_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-community-client_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-client_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-community-server-core_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-community-server_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-server_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-testsuite_8.0.16-2ubuntu18.04_amd64.deb
dpkg -i mysql-community-test_8.0.16-2ubuntu18.04_amd64.deb

```

# 更新配置和创建目录

## 创建目录

```
mkdir -p /opt/mysql/innodb_file/
mkdir -p /opt/mysql/log/slow_query_log/
mkdir -p /opt/mysql/log/relay_log/
mkdir -p /opt/mysql/log/
mkdir -p /opt/mysql/data
chown -R mysql:mysql /opt/mysql/
```

## 复制这里的 [my.cnf](my.cnf) 到你的/etc/mysql/mysql.cnf.

1. 注意先注释掉原来的内容，包括!includedir
2. 启动 mysql 的时候，会重新初始化 mysql，因为 `datadir` 变了。

# 启动

```
service mysql status
service mysql start
```

如果提示 mysql 服务无法识别或者不存在，则复制启动脚本[init.d/mysql](init.d/mysql) 到 ubuntu 系统的`/etc/init.d/`里面

重启后，默认是 root 用户，空密码，用下面的方式添加用户或者修改密码

如果忘记密码或者找不到初始密码，则在`mysqld`的节点下面添加`skip-grant-tables`
然后重新启动 `service mysql start`
在进入 `mysql -u root`
更新密码： `update mysql.user set authentication_string='*F7423DC08C0709F47ABD66B780A90A4989C80E2E' ,plugin='mysql_native_password' where user='root' and Host ='localhost';`

(这里设置的默认密码是 abcd@1234)
然后把`my.cnf`的 skip-grant-tables 去掉，再重启 mysql，就可以用上面的密码进入了.

# 创建用户

```
CREATE USER 'root'@'%' IDENTIFIED BY 'abcd@1234'; // 这是默认密码
GRANT ALL PRIVILEGES ON *.* TO root@'%';
flush privileges;
```

# 修改密码

```
ALTER USER 'root'@'%' IDENTIFIED BY 'abcd@1234';
ALTER USER 'root'@'localhost' IDENTIFIED BY 'abcd@1234';

```

# 重新执行

`mysql_secure_installation`

# 其他设置

```
apt-get install openssh-server
apt-get install tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

# 目前存在问题

1. service mysql stop 会 time out，需要采用 mysqladmin -u root -p shutdown 来关闭.
2. 启动的时候会报错

# docker 本身 创建启动脚本

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

# mysql 的配置，请参见

[centos/mysql/my.cnf](../../centos/mysql/my.cnf)

# mysql online document:

https://dev.mysql.com/doc/refman/8.0/en/

# 升级 upgrade mysql:

https://dev.mysql.com/doc/refman/8.0/en/upgrading.html

### 具体步骤 apt 方式

1. 停止服务
   `mysqladmin -u root -p shutdown` (输入默认密码:abcd@1234)
2. 执行 `apt-get update`
3. 升级

```

apt-get install mysql-community-server libmysqlclient-dev libmysqlclient21

```

4. `mysqladmin -u root -p start` 启动

mysql 日志文件: vim /var/log/mysql/error.log
