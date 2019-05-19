下载

```
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.16-2.el6.x86_64.rpm-bundle.tar
tar xvf mysql-8.0.16-2.el6.x86_64.rpm-bundle.tar # 会解压出来很多 rpm 文件
```

解压出来的文件:

```
mysql-community-test-8.0.16-2.el6.x86_64.rpm
mysql-community-embedded-8.0.16-2.el6.x86_64.rpm
mysql-community-embedded-devel-8.0.16-2.el6.x86_64.rpm
mysql-community-server-8.0.16-2.el6.x86_64.rpm
mysql-community-libs-compat-8.0.16-2.el6.x86_64.rpm
mysql-community-devel-8.0.16-2.el6.x86_64.rpm
mysql-community-client-8.0.16-2.el6.x86_64.rpm
mysql-community-libs-8.0.16-2.el6.x86_64.rpm
mysql-community-common-8.0.16-2.el6.x86_64.rpm
```

查看已经安装的版本：

`rpm -qa | grep -i mysql`

按顺序删除

```
rpm -e mysql-community-embedded-devel-5.7.17-1.el6.x86_64
rpm -e mysql-community-embedded-5.7.17-1.el6.x86_64
rpm -e mysql-community-common-5.7.17-1.el6.x86_64
rpm -e mysql-community-server-5.7.17-1.el6.x86_64
rpm -e mysql-community-devel-5.7.17-1.el6.x86_64
rpm -e mysql-community-libs-compat-5.7.17-1.el6.x86_64
rpm -e mysql-community-client-5.7.17-1.el6.x86_64
rpm -e mysql-community-libs-5.7.17-1.el6.x86_64
rpm -e mysql-community-common-5.7.17-1.el6.x86_64
```

再次查看

`rpm -qa | grep -i mysql`

删除 mysql-libs- 5.1.73-5.el6_7.1

```
yum remove -y mysql-libs*
yum remove -y mariadb-libs*
```

# 安装顺序:

```
yum install -y numactl perl-JSON perl-Time-HiRes libaio initscripts
rpm -ivh mysql-community-common-8.0.16-2.el6.x86_64.rpm
rpm -ivh mysql-community-libs-8.0.16-2.el6.x86_64.rpm
rpm -ivh mysql-community-client-8.0.16-2.el6.x86_64.rpm
rpm -ivh mysql-community-devel-8.0.16-2.el6.x86_64.rpm
rpm -ivh mysql-community-libs-compat-8.0.16-2.el6.x86_64.rpm
rpm -ivh mysql-community-server-8.0.16-2.el6.x86_64.rpm
# rpm -ivh mysql-community-test-8.0.16-2.el6.x86_64.rpm
```

创建目录

```
mkdir -p /opt/mysql/innodb_file/
mkdir -p /opt/mysql/log/slow_query_log/
mkdir -p /opt/mysql/log/relay_log/
mkdir -p /opt/mysql/log/
mkdir -p /opt/mysql/data
chown -R mysql:mysql /opt/mysql/
```

复制这里的 [my.cnf](my.cnf) 到你的/etc/mysql/mysql.cnf.

1. 注意先注释掉原来的内容，包括!includedir
2. 启动 mysql 的时候，会重新初始化 mysql，因为 `datadir` 变了。

启动

```
service mysqld start
chkconfig mysqld on
```

从 vim /etc/my.cnf 找到默认的日志文件 #从 log 里面找到默认的初始密码：
`vim /var/log/mysqld.log`

安全安装，修改密码等, docker mysql 镜像默认密码 Abcd@1234

`mysql_secure_installation`

不知道密码或者重置密码等：

```
如果忘记密码或者找不到初始密码，则在`mysqld`的节点下面添加`skip-grant-tables`
然后重新启动 `service mysqld start`
在进入 `mysql -u root`
更新密码： `update mysql.user set authentication_string='*F7423DC08C0709F47ABD66B780A90A4989C80E2E' ,plugin='mysql_native_password' where user='root' and Host ='localhost';`

(这里设置的默认密码是 abcd@1234)
然后把`my.cnf`的 skip-grant-tables 去掉，再重启 mysql，就可以用上面的密码进入了.
```

创建用户

```
CREATE USER 'root'@'%' IDENTIFIED BY 'Abcd@1234'; # 这是默认密码
GRANT ALL PRIVILEGES ON *.* TO root@'%';
flush privileges;
```

修改密码

```
ALTER USER 'root'@'%' IDENTIFIED BY 'Abcd@1234';
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Abcd@1234';
```

docker 本身 创建启动脚本
`vim init.sh`

```
#!/bin/bash
service ssh restart
service mysqld restart

while true; do

echo 1
sleep 5s

done
```

mysql 的配置，请参见

[centos/mysql/my.cnf](../../centos/mysql/my.cnf)

clear os:

`yum clean all`

# MGR 集群配置

第一步 所有节点执行：

```
create user 'replication'@'%' identified by 'yourpassword';
grant replication slave, replication client on *.* to 'replication'@'%';
flush privileges;
CHANGE MASTER TO MASTER_USER='replication', MASTER_PASSWORD='yourpassword' FOR CHANNEL 'group_replication_recovery';

```

第二步：主节点执行：

```
set global group_replication_bootstrap_group=on;
start group_replication;
set global group_replication_bootstrap_group=off;

```

第三步：所有从节点执行：
(如果不小心加入了其他节点，则可以`reset master;`，在重新执行 change master 即可）

```
reset master;
CHANGE MASTER TO MASTER_USER='replication', MASTER_PASSWORD='yourpassword' FOR CHANNEL 'group_replication_recovery';
start group_replication;

```

```
start group_replication;
```

查看各种状态：
查看变量：
show global variables like 'group%';

查看状态：
`select * from performance_schema.replication_group_members;`

查看是否可写：
show global variables like 'super%';

获取当前可写节点：

```
SELECT * FROM performance_schema.replication_group_members WHERE MEMBER_ID = (SELECT VARIABLE_VALUE FROM performance_schema.global_status WHERE VARIABLE_NAME= 'group_replication_primary_member');
```
