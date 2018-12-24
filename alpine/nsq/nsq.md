# 下载

```
wget https://s3.amazonaws.com/bitly-downloads/nsq/nsq-1.0.0-compat.linux-amd64.go1.8.tar.gz
wget https://s3.amazonaws.com/bitly-downloads/nsq/nsq-1.1.0.linux-amd64.go1.10.3.tar.gz
tar zxf nsq-1.1.0.linux-amd64.go1.10.3.tar.gz
mv nsq-1.1.0.linux-amd64.go1.10.3 nsq
cd nsq/bin

# 把相关nsq的二进制文件复制到/usr/local/bin
mv nsq* /usr/local/bin
mv to_nsq /usr/local/bin
```

# 配置， 参见

```
mkdir -p /opt/logs/supervisord/nsq/
mkdir -p /opt/nsq/nsqdata
```
