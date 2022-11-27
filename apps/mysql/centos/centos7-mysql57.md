# 安装

```
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum install mysql-community-server
```

# 下载 mysql.server 到 /etc/init.d/mysql

```
cp mysql.server /etc/init.d/mysql
chmod +x /etc/init.d/mysql
```

# 启动
/usr/sbin/mysqld --user=mysql --daemonize

# 停止直接 kill

