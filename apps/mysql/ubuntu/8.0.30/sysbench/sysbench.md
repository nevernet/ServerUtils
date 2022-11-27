# 测试数据


## 安装
apt-get install -y sysbench
cd /usr/share/sysbench
ls -alh

-rwxr-xr-x   1 root root 1.5K Oct 23  2021 bulk_insert.lua*
-rw-r--r--   1 root root  15K Oct 23  2021 oltp_common.lua
-rwxr-xr-x   1 root root 1.3K Oct 23  2021 oltp_delete.lua*
-rwxr-xr-x   1 root root 2.4K Oct 23  2021 oltp_insert.lua*
-rwxr-xr-x   1 root root 1.3K Oct 23  2021 oltp_point_select.lua*
-rwxr-xr-x   1 root root 1.7K Oct 23  2021 oltp_read_only.lua*
-rwxr-xr-x   1 root root 1.8K Oct 23  2021 oltp_read_write.lua*
-rwxr-xr-x   1 root root 1.1K Oct 23  2021 oltp_update_index.lua*
-rwxr-xr-x   1 root root 1.1K Oct 23  2021 oltp_update_non_index.lua*
-rwxr-xr-x   1 root root 1.5K Oct 23  2021 oltp_write_only.lua*
-rwxr-xr-x   1 root root 1.9K Oct 23  2021 select_random_points.lua*
-rwxr-xr-x   1 root root 2.1K Oct 23  2021 select_random_ranges.lua*

sysbench --helpo


## 准备测试数据

登录数据库

```
create database sbtest;
```

准备测试数据

```
sysbench --mysql-host=10.0.10.12 \
         --mysql-port=63306 \
         --mysql-user=root \
         --mysql-password=yourpassword \
         /usr/share/sysbench/oltp_common.lua \
         --tables=10 \
         --table_size=10000 \
         prepare
```


```
sysbench --threads=100 \
         --time=30 \
         --report-interval=5 \
         --mysql-host=10.0.10.12 \
         --mysql-port=63306 \
         --mysql-user=root \
         --mysql-password=yourpassword \
         /usr/share/sysbench/oltp_read_write.lua \
         --tables=10 \
         --table_size=10000 \
         run
```

清除

```
sysbench --threads=100 \
         --time=30 \
         --report-interval=5 \
         --mysql-host=10.0.10.12 \
         --mysql-port=63306 \
         --mysql-user=root \
         --mysql-password=yourpassword \
         /usr/share/sysbench/oltp_read_write.lua \
         --tables=10 \
         --table_size=10000 \
         cleanup
```


参考：

https://www.cnblogs.com/f-ck-need-u/p/9279703.html