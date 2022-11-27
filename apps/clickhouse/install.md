# ClickHouse

## 安装

```
apt-get install -y apt-transport-https ca-certificates dirmngr
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8919F6BD2B48D754

echo "deb https://packages.clickhouse.com/deb stable main" | tee /etc/apt/sources.list.d/clickhouse.list
apt-get update

apt-get install -y clickhouse-server clickhouse-client

sudo service clickhouse-server start
clickhouse-client # or "clickhouse-client --password" if you've set up a password.
```

安装过程默认创建文件

```
/etc/clickhouse-server/config.xml
/etc/clickhouse-server/users.xml
# 日志目录
/var/log/clickhouse-server/
/var/log/clickhouse-server/clickhouse-server.log
/var/log/clickhouse-server/clickhouse-server.err.log

# 数据目录
/var/lib/clickhouse/

# PID
/var/run/clickhouse-server

# 默认的密码：
LyO^ZR%4$Qp5STW (不要有&符号)
# 默认密码文件： /etc/clickhouse-server/users.d/default-password.xml
# 删除该文件可以重置密码
```

### 修改密码

```
vim /etc/clickhouse-server/users.xml
# 找到 <password></password> 节点修改密码即可，然后重启 clickhouse-server
```

### 开启default 用户的 access_management， 这样才可以用来创建其他用户

```
vim /etc/clickhouse-server/users.xml
<access_management>1</access_management>
```