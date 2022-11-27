wrk 是轻量级测试工具，类似 ab

# 安装

```
apt-get install -y unzip
git clone https://github.com/wg/wrk.git
cd wrk
make

cp wrk /usr/local/bin

wrk --help
```

# 使用

```
wrk -t 4 -c 1000 -d 30s --latency http://127.0.0.1/index.html
wrk -t 4 -c 50000 -d 30s --latency http://10.0.10.10/index.html

Running 30s test @ http://10.0.10.10/index.html
  4 threads and 50000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   331.53ms  243.21ms 957.17ms   79.11%
    Req/Sec    35.87k    21.97k   93.91k    76.76%
  Latency Distribution
     50%  291.05ms
     75%  430.47ms
     90%  866.57ms
     99%  928.04ms
  862454 requests in 30.10s, 204.80MB read
Requests/sec:  28656.81
Transfer/sec:      6.80MB
```

自定义脚本测试

wrk -t 4 -c 50000 -d 30s --latency --timeout 2s -s post.lua http://10.0.10.10/index.html
