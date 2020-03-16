# MySQL 容器跨主机架构

## 机器准备

| 主机   | 容器    | 主机 ip    | 容器 ip    | 端口 | MGR 端口 |
| ------ | ------- | ---------- | ---------- | ---- | -------- |
| 主机 1 | 容器 s1 | 10.11.1.31 | 10.0.5.60  | 3360 | 63060    |
| 主机 1 | 容器 s2 | 10.11.1.31 | 10.0.5.61  | 3361 | 63061    |
| 主机 2 | 容器 s3 | 10.11.1.10 | 10.0.10.64 | 3364 | 63064    |

## 网络配置

### 创建网桥

主机 1

```
docker network create --subnet=10.0.5.1/24 br5
```

主机 2

```
docker network create --subnet=10.0.10.1/24 br10
```

分别对应`br5`和`br10`两个网桥名字

### 设置 iptables

主机 1

```bash
# 允许容器上网
 sudo iptables -t nat -A POSTROUTING -s 10.0.5.0/24 -j SNAT --to 10.11.1.31

# 请注意，目前这个方式的端口转发依然无法满足MGR同步的需求。
# 把主机2过来的请求，转发到对应的容器上 确保主机2的数据走到主机1
iptables -t nat -I PREROUTING -p tcp -s 10.11.1.10 -d 10.11.1.31 --dport 3360 -j DNAT --to 10.0.5.60:3360
iptables -t nat -I PREROUTING -p tcp -s 10.11.1.10 -d 10.11.1.31 --dport 3361 -j DNAT --to 10.0.5.61:3361
iptables -t nat -I PREROUTING -p tcp -s 10.11.1.10 -d 10.11.1.31 --dport 63060 -j DNAT --to 10.0.5.60:63060 # mgr port
iptables -t nat -I PREROUTING -p tcp -s 10.11.1.10 -d 10.11.1.31 --dport 63061 -j DNAT --to 10.0.5.61:63061 # mgr port

# 把需要请求到10.0.10.0/24的网络，全部先转发到主机2的网卡上， 确保主机1的数据走到主机2
 sudo iptables -t nat -I PREROUTING -d 10.0.10.0/24 -j DNAT --to 10.11.1.10

```

主机 2

```bash
# 允许容器上网
sudo iptables -t nat -A POSTROUTING -s 10.0.10.0/24 -j SNAT --to 10.11.1.10

# 把主机1过来的请求，转发到对应的容器上 确保主机1的数据走到主机2
sudo iptables -t nat -I PREROUTING -p tcp -s 10.11.1.31 -d 10.11.1.10 --dport 3364 -j DNAT --to 10.0.10.64:3364
sudo iptables -t nat -I PREROUTING -p tcp -s 10.11.1.31 -d 10.11.1.10 --dport 63064 -j DNAT --to 10.0.10.64:63064 # mgr port

# 把需要请求到10.0.5.0/24的网络，全部先转发到主机1的网卡上 确保主机2的数据走到主机1
sudo iptables -t nat -I PREROUTING -d 10.0.5.0/24 -j DNAT --to 10.11.1.31
```

## 容器启动

```
docker run --network br5 --ip 10.0.5.60 -d -v /opdata2/mysql/zl_prod_db10:/opt/mysql --privileged --restart always -h ZL_SH03_PROD_DB10 --name ZL_SH03_PROD_DB10 <your private docker repo>/ubuntu-mysql8:v3 /root/init.sh
docker run --network br5 --ip 10.0.5.61 -d -v /opdata2/mysql/zl_prod_db11:/opt/mysql --privileged --restart always -h ZL_SH03_PROD_DB11 --name ZL_SH03_PROD_DB11 <your private docker repo>/ubuntu-mysql8:v3 /root/init.sh
docker run --network br10 --ip 10.0.10.64 -d -v /opdata/mysql/zl_sh01_prod_db13:/opt/mysql --privileged --restart always -h ZL_SH01_PROD_DB13 --name ZL_SH01_PROD_DB13 <your private docker repo>/ubuntu-mysql8:v3 /root/init.sh
```

这里主要是要指定`--netwrok`，根据前面创建的网桥来。
`ubuntu-mysql8:v3`是我自己私有的 MySQL 镜像

## 配置文件

MGR 的配置在文件[my.cnf](my.cnf)都有了

# 日常操作：

## 主节点

```bash
set sql_log_bin=0; # 必须设置禁止日志 避免这些操作被记录，然后被执行到其他节点

# 创建同步的用户，每个主机都要执行
create user 'replication'@'%' identified by 'yourpassword';
grant replication slave, replication client on *.* to 'replication'@'%' with grant option;
flush privileges;

# 指定 master_host 和 master_port 会 change 失败
# 修改之前，如果已经启动 gr 的，需要先 stop group_replication
CHANGE MASTER TO MASTER_USER='replication', MASTER_PASSWORD='yourpassword', MASTER_HOST='10.0.5.60', MASTER_PORT=3306 FOR CHANNEL 'group_replication_recovery';

# 最新的 change master 方式： 8.0.19
CHANGE MASTER TO MASTER_USER='replication', MASTER_PASSWORD='yourpassword' FOR CHANNEL 'group_replication_recovery';

# 第二步，主节点执行
set global group_replication_bootstrap_group=on;
start group_replication;
set global group_replication_bootstrap_group=off;

# 最后 再次开启日志
set sql_log_bin=1;
```

## 从节点

```bash
set sql_log_bin=0; # 必须设置禁止日志 避免这些操作被记录，然后被执行到其他节点

# 创建同步的用户，每个主机都要执行
create user 'replication'@'%' identified by 'yourpassword';
grant replication slave, replication client on *.* to 'replication'@'%' with grant option;
flush privileges;

# 仅仅”从"节点执行
reset master;

# 指定 master_host 和 master_port 会 change 失败
# 修改之前，如果已经启动 gr 的，需要先 stop group_replication
CHANGE MASTER TO MASTER_USER='replication', MASTER_PASSWORD='yourpassword', MASTER_HOST='10.0.5.60', MASTER_PORT=3306 FOR CHANNEL 'group_replication_recovery';

# 最新的 change master 方式： 8.0.19
CHANGE MASTER TO MASTER_USER='replication', MASTER_PASSWORD='yourpassword' FOR CHANNEL 'group_replication_recovery';

# 第二步， 从节点执行：
start group_replication;

# 最后 再次开启日志
set sql_log_bin=1;
```

## 新增节点

一般情况下，我们的 binlog 日志并不会保存太久，比如我只保存一天， 所以超过一天后，无法直接从 binlog 里面恢复所有的数据，这个时候需要先从 MGR 集群里面获取一份完整的备份，然后导入到最新的机器。这里的导出关闭了`gtid_purged`的导出，在后面单独设置

```sql
mysqldump -u root -p -h 10.0.5.60 -P 3360 --opt --all-databases --single-transaction --triggers --routines --events --set-gtid-purged=OFF > all.sql
mysql -u root -p -P 3364 < all.sql
```

在主服务器上面，查看`show global variables like 'gtid%';`

| Variable_name                    | Value                                                                              |
| -------------------------------- | ---------------------------------------------------------------------------------- |
| gtid_executed                    | 7f5100de-26a4-11e8-b467-0ed5f89f718b:1-47,8f88c596-6137-11ea-88e3-02420a00053c:1-3 |
| gtid_executed_compression_period | 1000                                                                               |
| gtid_mode                        | ON                                                                                 |
| gtid_owned                       |                                                                                    |
| gtid_purged                      | 7f5100de-26a4-11e8-b467-0ed5f89f718b:1-26,8f88c596-6137-11ea-88e3-02420a00053c:1-3 |

找到`gtid_executed`的数值，然后在新的`slave`服务器上面:

```sql
reset master;
set @@GLOBAL.GTID_PURGED = '7f5100de-26a4-11e8-b467-0ed5f89f718b:1-47,8f88c596-6137-11ea-88e3-02420a00053c:1-3';
```

为了保证上面的操作成功，我们需要先停止本机的`stop group_replication`和并且`reset master`;
可能会碰到类似下面的问题：

```bash
# 因为之前启动过同步集群，且失败了，所以mysql被自动修改成只读模式，这个时候需要重启一下就好
ERROR 1290 (HY000) at line 33: The MySQL server is running with the --super-read-only option so it cannot execute this statement
# 因为之前启动过同步集群，导致同步的数据节点不一致，重置一下master即可
ERROR 3546 (HY000) at line 26: @@GLOBAL.GTID_PURGED cannot be changed: the added gtid set must not overlap with @@GLOBAL.GTID_EXECUTED
```

```sql
set sql_log_bin=0;
-- 确定是否已经创建了同步的用户，如果没有创建则根据上面的创建用于复制的用户

-- 重新设置复制起始节点
start group_replication;

-- 原有集群修改group seeds，在原来集群的每台机器上面都执行，请修改ip地址为真实的ip地址端口
set global group_replication_group_seeds='10.0.20.100:33406,10.0.20.101:33407,10.0.20.101:33408';
set sql_log_bin=1;

-- 原有集群的每台机器的/etc/my.cnf的配置里面都修改group_replication_group_seeds，这样重启的时候才有新的集群节点数据
loose-group_replication_group_seeds = '10.0.20.100:33406,10.0.20.101:33407,10.0.20.101:33408' # 真实机器修改这里配置

-- 新节点的/etc/my.cnf默认配置好上面的group seeds，然后开启同步
set sql_log_bin=0;
start group_replication;
set sql_log_bin=1;

```

## 其他操作

```bash
# 查看变量：
show global variables like 'group%';

# 查看状态：
select * from performance_schema.replication_group_members ;
select * from performance*schema.replication_group_member_stats;
select * from performance*schema.replication_connection_status;
select * from performance_schema.replication_applier_status;
select * from performance_schema.global_status;

# 查看是否可写：
show global variables like 'super%';

# 获取当前可写节点：
SELECT * FROM performance_schema.replication_group_members
    WHERE MEMBER_ID = (SELECT VARIABLE_VALUE
                        FROM performance_schema.global_status
                        WHERE VARIABLE_NAME= 'group_replication_primary_member'
                        );
```
