# MySQL 容器跨主机架构

## 机器准备

| 主机   | 容器    | 主机 ip    | 容器 ip    | 端口 | MGR 端口 |
| ------ | ------- | ---------- | ---------- | ---- | -------- |
| 主机 1 | 容器 s1 | 10.0.10.12 | 10.0.10.12  | 63306 | 33306    |
| 主机 1 | 容器 s2 | 10.0.10.13 | 10.0.10.13  | 63307 | 33307    |
| 主机 2 | 容器 s3 | 10.0.10.13 | 10.0.10.13  | 63308 | 33308    |

## 配置文件

MGR 的配置在文件[cnf/my.cnf](cnf/mysql63306.cnf)都有了

# 日常操作：

## 主节点

```bash
# 必须设置禁止日志 避免这些操作被记录，然后被执行到其他节点
set sql_log_bin=0; 

# 创建同步的用户，
create user 'replication'@'%' identified by 'yourpassword';
grant replication slave, replication client on *.* to 'replication'@'%' with grant option;
flush privileges;

change replication source to source_user='replication', source_password='yourpassword' for channel 'group_replication_recovery';


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
change replication source to source_user='replication', source_password='yourpassword' for channel 'group_replication_recovery';

# 第二步， 从节点执行：
start group_replication;

# 最后 再次开启日志
set sql_log_bin=1;
```

## 新增节点

一般情况下，我们的 binlog 日志并不会保存太久，比如我只保存一天， 所以超过一天后，无法直接从 binlog 里面恢复所有的数据，这个时候需要先从 MGR 集群里面获取一份完整的备份，然后导入到最新的机器。这里的导出关闭了`gtid_purged`的导出，在后面单独设置

```sql
mysqldump -u root -p -h 10.0.10.12 -P 63306 --opt --all-databases --single-transaction --triggers --routines --events --set-gtid-purged=OFF > all.sql
mysql -u root -p -P 63306 < all.sql
```

查询最新的同步节点

在主服务器上面，查看 `show global variables like 'gtid%';`

| Variable_name                    | Value                                                                              |
| -------------------------------- |-------------------------------------------    ------ |
| gtid_executed                    | 0a48e8de-29d5-11ed-b0b7-00163e063210:1-10,
89108c2d-bb34-430e-a988-2fee8232e9d4:1-7 |
| gtid_executed_compression_period | 1000                                                                               |
| gtid_mode                        | ON                                                                                 |
| gtid_owned                       |                                                                                    |
| gtid_purged                      | 7f5100de-26a4-11e8-b467-0ed5f89f718b:1-26,8f88c596-6137-11ea-88e3-02420a00053c:1-3 |

找到`gtid_executed`的数值，然后在新的`slave`服务器上面:

```sql
set sql_log_bin=0;
stop group_replication;
reset master;
set @@GLOBAL.GTID_PURGED = '0a48e8de-29d5-11ed-b0b7-00163e063210:1-10,89108c2d-bb34-430e-a988-2fee8232e9d4:1-7';

# 添加节点
set global group_replication_group_seeds='10.0.20.100:33406,10.0.20.101:33407,10.0.20.101:33408';

# 在所有服务器的配置文件
group_replication_group_seeds = '10.0.20.100:33406,10.0.20.101:33407,10.0.20.101:33408' # 真实机器修改这里配置

start group_replication;
set sql_log_bin=1;
```

可能碰到问题

```bash
# 因为之前启动过同步集群，且失败了，所以mysql被自动修改成只读模式，这个时候需要重启一下就好
ERROR 1290 (HY000) at line 33: The MySQL server is running with the --super-read-only option so it cannot execute this statement
# 因为之前启动过同步集群，导致同步的数据节点不一致，重置一下master即可
ERROR 3546 (HY000) at line 26: @@GLOBAL.GTID_PURGED cannot be changed: the added gtid set must not overlap with @@GLOBAL.GTID_EXECUTED
```


## 修复节点同步数据
有时候从服务器的同步节点跟主服务器不一致，特别刚开始的时候。 可以考虑强制设置同步节点。 

> 为了确保数据一致，也可以 把 主服务的数据导出来，然后再同步到从服务器，再执行下面的过程

查询最新的同步节点, 在主服务器上面，查看 `show global variables like 'gtid%';`

| Variable_name                    | Value                                                                              |
| -------------------------------- |-------------------------------------------    ------ |
| gtid_executed                    | 0a48e8de-29d5-11ed-b0b7-00163e063210:1-10,
89108c2d-bb34-430e-a988-2fee8232e9d4:1-7 |
| gtid_executed_compression_period | 1000                                                                               |
| gtid_mode                        | ON                                                                                 |
| gtid_owned                       |                                                                                    |
| gtid_purged                      | 7f5100de-26a4-11e8-b467-0ed5f89f718b:1-26,8f88c596-6137-11ea-88e3-02420a00053c:1-3 |

找到`gtid_executed`的数值，然后在新的`slave`服务器上面:

```sql
set sql_log_bin=0;
stop group_replication;
reset master;
set @@GLOBAL.GTID_PURGED = '0a48e8de-29d5-11ed-b0b7-00163e063210:1-10,89108c2d-bb34-430e-a988-2fee8232e9d4:1-7';
start group_replication;
set sql_log_bin=1;
```

## 其他操作

```bash
# 查看变量：
show global variables like 'group%';

# 查看状态：
select * from performance_schema.replication_group_members ;
select * from performance_schema.replication_group_member_stats;
select * from performance_schema.replication_connection_status;
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


# 参考

https://dev.mysql.com/doc/refman/8.0/en/group-replication-deploying-in-single-primary-mode.html