
# 安装

## 系统需求
系统： ubuntu 22.04
MySQL 版本： 8.0.30

提前关闭 apparmor

```
systemctl stop apparmor && systemctl disable apparmor
ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld
aa-status
```

重启系统

```bash
apt-get update
apt-get install -y vim wget

```

## 具体安装

通过 dpkg -l | grep mysql 查看已经安装的mysql和安装的包名

### 方法1：

下载最新的apt配置文件： https://dev.mysql.com/downloads/repo/apt/

```
apt-get install -y lsb-release gnupg
wget https://dev.mysql.com/get/mysql-apt-config_0.8.23-1_all.deb
dpkg -i mysql-apt-config_0.8.23-1_all.deb
# 选择 MySQL Server & Cluster (Currently selected: mysql-8.0)
apt-get update
apt-get install -y mysql-server mysql-client
```


### 方法 2：

采用dpkg的方式安装

```
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-server_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
# 如果下载慢，可以在其他地方下载完成，然后复制到容器里面 docker cp src_path container:dest_path

tar -xvf mysql-server_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar

apt --fix-broken install -y
apt-get install -y libaio1 libmecab2 libnuma1 libsasl2-2 perl psmisc libjson-perl mecab-ipadic-utf8 apt-utils

dpkg-preconfigure mysql-community-server_*.deb

// 安装过程默认密码：Abcd@1234

dpkg -i mysql-{common,community-client-plugins,community-client-core,community-client,client,community-server-core,community-server,server}_*.deb

// 删除安装包
dpkg --purge mysql-testsuite
dpkg --purge mysql-community-test
dpkg --purge mysql-server
dpkg --purge mysql-community-server
dpkg --purge mysql-client
dpkg --purge mysql-community-server-core
dpkg --purge mysql-community-client
dpkg --purge mysql-community-client-core
dpkg --purge libmysqlclient21
dpkg --purge libmysqlclient-dev
dpkg --purge mysql-community-client-plugins
dpkg --purge mysql-common

#
# dpkg -i mysql-community-server-debug_8.0.30-1ubuntu22.04_amd64.deb
# dpkg -i mysql-community-test-debug_8.0.30-1ubuntu22.04_amd64.deb

```

### 增加MySQL基础目录和权限修改

```
mkdir -p /opt/mysql/63307/innodb_file/
mkdir -p /opt/mysql/63307/log/slow_query_log/
mkdir -p /opt/mysql/63307/log/relay_log/
mkdir -p /opt/mysql/63307/log/
mkdir -p /opt/mysql/63307/data
mkdir -p /opt/mysql/63308/innodb_file/
mkdir -p /opt/mysql/63308/log/slow_query_log/
mkdir -p /opt/mysql/63308/log/relay_log/
mkdir -p /opt/mysql/63308/log/
mkdir -p /opt/mysql/63308/data
chown -R mysql:mysql /opt/mysql/
chmod 750 /opt/mysql/63307
chmod 750 /opt/mysql/63307/data
chmod 750 /opt/mysql/63308
chmod 750 /opt/mysql/63308/data
```

### 创建 systemd 服务文件

```
cd /usr/lib/systemd/system
cp mysql.service mysql63307.service
cp mysql.service mysql63308.service

systemctl daemon-reload
```
具体参考 [systemd.md](../systemd.md)


## 修改配置内容

### 停用原来的默认mysql.service
```
systemctl stop mysql.service && systemctl disable mysql.service
```

### 初始化MySQL

必须先禁用plugin(group_replication等参数才可以初始化成功), 会生成随机密码，需要记录下来

```
/usr/sbin/mysqld --defaults-file=/etc/mysql/mysql.conf.d/mysql63307.cnf --initialize --user=mysql
/usr/sbin/mysqld --defaults-file=/etc/mysql/mysql.conf.d/mysql63308.cnf --initialize --user=mysql
```

### 启动
```
systemctl enable mysql63307.service && systemctl start mysql63307.service
systemctl enable mysql63308.service && systemctl start mysql63308.service
```

### 执行安全修改密码
```
mysql_secure_installation --socket /var/run/mysqld/mysqld-63307.sock
mysql_secure_installation --socket /var/run/mysqld/mysqld-63308.sock
```

登录 mysql
```
mysql -u root -p -P 63307 --socket /var/run/mysqld/mysqld-63307.sock
mysql -u root -p -P 63308 --socket /var/run/mysqld/mysqld-63308.sock
```

分别修改密码(MGR安装不需要这个)
```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'abcd@1234';
```

### 下面的步骤，MGR 从服务器可以不用操作

创建远程 root 用户
```
CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'yourpassword';
GRANT ALL PRIVILEGES ON *.* TO root@'%';
flush privileges;
```