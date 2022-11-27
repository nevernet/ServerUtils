nginx 高并发优化配置

修改nginx配置文件，nginx.conf

增加work_rlimit_nofile和worker_connections数量，并禁用keepalive_timeout。

```bash

# 根据cpu核心数基本保持一致
worker_processes  4;

# cpu 启用配置 对应4核
worker_cpu_affinity 01 10 01 10;

# 这个指令是指当一个nginx进程打开的最多文件描述符数目，
# 理论值应该是最多打开文件数（ulimit -n）与nginx进程数相除，
# 但是nginx分配请求并不是那么均匀，所以最好与ulimit -n的值保持一致。
worker_rlimit_nofile 1000000;

events {
    use epoll;

    # 每个worker最大连接数，一般
    # worker_processes * worker_connections = worker_rlimit_nofile
    worker_connections 250000;
    # 设置一个进程可同时接受多个网络连接
    multi_accept on;

    # 关闭网络连接序列化，当其设置为开启的时候，将会对多个 Nginx 进程接受连接进行序列化，防止多个进程对连接的争抢。当服务器连接数不多时，开启这个参数会让负载有一定程度的降低。但是当服务器的吞吐量很大时，为了效率，请关闭这个参数；并且关闭这个参数的时候也可以让请求在多个 worker 间的分配更均衡。
    accept_mutex off;
}

http {
    # 注意，.gzip压缩器需要在用户态进行，因此无法和sendfile共存，
    # 如果gizp设置为on，那么sendfile就会失去作用
    sendfile        on;

    # 设置数据包会累积一下再一起传输，可以提高一些传输效率。
    # tcp_nopush 必须和 sendfile 搭配使用
    tcp_nopush     on;

    # 小的数据包不等待直接传输。默认为 on。看上去是和 tcp_nopush 相反的功能，
    # 但是两边都为 on 时 nginx 也可以平衡这两个功能的使用。
    tcp_nodelay     on;

    # 默认2m, 限制最大sendfile的文件大小，防止过大的文件占据整个工作进程
    sendfile_max_chunk 1m;

    # http链接即时关闭
    # keepalive_timeout 0;
    keepalive_timeout  65;
    keepalive_requests 5000;
    client_header_buffer_size    4k; # 默认请求包头信息的缓存
    large_client_header_buffers  4 32k; #大请求包头部信息的缓存个数与容量

    # 为了快速处理数据的静态集合，像域名、映射指令的值、MIME类型、
    # 请求头的字符串名一类的数据，nginx使用了hash表。

    # 在启动和重配置时，nginx会为hash表尽可能选用最小的值，

    # 这样存储具有同类哈希值的键的桶的大小不会超过设置的参数值（hash bucket size 哈希桶大小）。

    # 表的大小使用bucket表示，在hash表大小超过最大参数值之前，会持续调整。

    # 大多数hash都有对应的指令，用来调整这些参数。例如：

    # 域名hash 对应的指令是  server_names_hash_max_size 和 server_names_hash_bucket_size

    # 设置hash桶大小的参数和处理器的缓存行大小的倍数有关，
    # 通过减少内存访问次数，可以提高现代处理器在hash中搜索密钥的速度。

    # 如果一个哈希桶的大小等于一个处理器的缓存行的大小，那么在最坏的情况下，
    # 搜索key时会访问两次内存： 第一次是计算哈希桶的位置，
    # 其次是在哈希桶中搜索key时。如果nginx发出请求增加
    # 最大哈希值( hash max size ) 和 哈希桶的大(hash bucket size) 的消息，
    # 那么首选应该增加 最大哈希值( hash max size )
    server_names_hash_max_size      1024;
    server_names_hash_bucket_size   512;

    client_max_body_size 100m;

    open_file_cache max=102400 inactive=40s;
    open_file_cache_valid 50s;
    open_file_cache_min_uses 1;
    open_file_cache_errors on;

    upstream  BACKEND {
        server   192.168.0.1：8080  weight=1 max_fails=2 fail_timeout=30s;
        server   192.168.0.2：8080  weight=1 max_fails=2 fail_timeout=30s;

        # 设置到upstream服务器的空闲keepalive连接的最大数量 当这个数量被突破时，最近使用最少的连接将被关闭 特别提醒：keepalive指令不会限制一个nginx worker进程到upstream服务器连接的总数量
        keepalive 300;
    }
}
```

 重启nginx

```
/usr/local/nginx/sbin/nginx -s reload
```

使用ab压力测试

```
ab -c 10000 -n 150000 http://127.0.0.1/index.html
```