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

## 新增节点，假定新增节点的 ip 是 10.0.20.102

```bash
# 需要先从MGR集群里面获取一份完整的备份，然后到最新的机器

# 重新设置复制起始节点

# 原有集群修改group seeds，在原来集群的每台机器上面都执行
set sql_log_bin=0;
set global group_replication_group_seeds='10.0.20.100:33406,10.0.20.101:33407,10.0.20.101:33408';
set sql_log_bin=1;

# 原有集群的每台机器的/etc/my.cnf的配置里面都修改group_replication_group_seeds，这样重启的时候才有新的集群节点数据
loose-group_replication_group_seeds = '10.0.20.100:33406,10.0.20.101:33407,10.0.20.101:33408' # 真实机器修改这里配置

# 新节点的/etc/my.cnf默认配置好上面的group seeds，然后开启同步
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
