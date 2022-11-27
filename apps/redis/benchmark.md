使用 redis-benchmark 做基础性能测试

```
redis-benchmark -p 16379 -n 100000 -c 10000 -q
```

-n 100000 10w次请求
-c 10000 1w个并发链接

结果如下

```
PING_INLINE: 93984.96 requests per second, p50=46.783 msec
PING_MBULK: 106496.27 requests per second, p50=46.143 msec
SET: 105263.16 requests per second, p50=46.815 msec
GET: 99403.58 requests per second, p50=48.415 msec
INCR: 89365.51 requests per second, p50=58.495 msec
LPUSH: 103519.66 requests per second, p50=47.359 msec
RPUSH: 90415.91 requests per second, p50=52.671 msec
LPOP: 95693.78 requests per second, p50=48.863 msec
RPOP: 104166.67 requests per second, p50=47.039 msec
SADD: 85984.52 requests per second, p50=58.079 msec
HSET: 98911.96 requests per second, p50=49.759 msec
SPOP: 102249.49 requests per second, p50=47.551 msec
ZADD: 95877.28 requests per second, p50=48.159 msec
ZPOPMIN: 101419.88 requests per second, p50=47.679 msec
LPUSH (needed to benchmark LRANGE): 101112.23 requests per second, p50=47.199 msec
LRANGE_100 (first 100 elements): 58241.12 requests per second, p50=79.103 msec
LRANGE_300 (first 300 elements): 23651.84 requests per second, p50=213.247 msec
LRANGE_500 (first 500 elements): 15946.42 requests per second, p50=312.063 msec
LRANGE_600 (first 600 elements): 13898.54 requests per second, p50=364.287 msec
MSET (10 keys): 90826.52 requests per second, p50=87.551 msec
```


更多的使用方式参考： 

```
redis-benchmark --help
```