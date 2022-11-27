高并发优化配置

一、系统层面

查看系统最大允许值：

```
cat /proc/sys/fs/nr_open

1048576
```

1、打开文件 `/etc/security/limits.conf`

```
root soft nofile 1000000
root hard nofile 1000000
* soft nofile 1000000
* hard nofile 1000000
```


2、在/etc/sysctl.conf中加入：

```
# 一个端口最大监听TCP连接队列的长度
net.core.somaxconn = 500000

# 系统同时持有的最大timewait套接字数。如果超过此数量，则等待时间插座将立即销毁并打印警告。此限制的存在只是为了防止简单的DoS攻击，不建议人为地降低了极限，而是增加它（可能，增加安装的内存后），如果网络条件需要超过默认值。
net.ipv4.tcp_max_tw_buckets = 5000

# 用于设置内核放弃TCP连接之前向客户端发送SYN+ACK包的数量，设置的是TCP三次握手中的第二次握手，一般设置为1.
net.ipv4.tcp_synack_retries = 2
# 开启这个参数后，我们的TCP拥塞窗口会在一个RTO时间空闲之后重置为初始拥塞窗口(CWND)大小，这无疑大幅的减少了长连接的优势。
net.ipv4.tcp_slow_start_after_idle = 0

# 当 interface 接收到的数据包数量比内核处理速度的快的时候， 设置 input 队列最大的 packets 数量值。数据包速率比内核处理快时,送到队列的数据包上限
net.core.netdev_max_backlog = 20000

# net.core.rmem_default = 262144
# net.core.wmem_default = 262144
# net.core.rmem_max = 16777216
# net.core.wmem_max = 16777216
# net.ipv4.tcp_rmem = 4096 4096 16777216
# net.ipv4.tcp_wmem = 4096 4096 16777216
# net.ipv4.tcp_mem = 786432 2097152 3145728

# 是否允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0 关闭
net.ipv4.tcp_tw_reuse = 1
# 是否开启TCP连接中TIME-WAIT sockets的快速回收，默认为0 关闭，默认回收等待时间120秒，根据实际情况开启 4.14以下的内核才可以
# net.ipv4.tcp_tw_recycle = 0

# 队列的最大长度, 第一次握手的连接参数过大可能也会遭受syn flood攻击
net.ipv4.tcp_max_syn_backlog = 65535

net.ipv4.tcp_fin_timeout = 5
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_max_orphans = 131072

# 大量请求可能会触发洪水攻击，这里暂时开启，根据实际情况来关闭
net.ipv4.tcp_syncookies = 1

# 端口返回，默认是32768~60999
net.ipv4.ip_local_port_range = 15000 65000

net.ipv4.ip_forward = 1

fs.file-max = 1000000
```

简单版本
```
net.core.somaxconn = 500000
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_slow_start_after_idle = 0
net.core.netdev_max_backlog = 20000
# net.core.rmem_default = 262144
# net.core.wmem_default = 262144
# net.core.rmem_max = 16777216
# net.core.wmem_max = 16777216
# net.ipv4.tcp_rmem = 4096 4096 16777216
# net.ipv4.tcp_wmem = 4096 4096 16777216
# net.ipv4.tcp_mem = 786432 2097152 3145728

net.ipv4.tcp_tw_reuse = 1
# net.ipv4.tcp_tw_recycle = 0 # 4.14以下的内核才可以
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_fin_timeout = 5
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_max_orphans = 131072
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_local_port_range = 15000 65000

net.ipv4.ip_forward = 1

fs.file-max = 1000000
```

使用：sysctl -p 生效

```
sysctl -p
```