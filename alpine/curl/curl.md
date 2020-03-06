在 alpine 下面， apk add curl 使用的是 libressl，会导致跟 php 等用 openssl 发生冲突。

```bash
apk add openssl openssl-dev
```

下载源码：

[https://curl.haxx.se/download.html](https://curl.haxx.se/download.html)

```bash
cd ~
wget https://curl.haxx.se/download/curl-7.69.0.tar.gz
tar zxf curl-7.69.0.tar.gz
cd curl-7.69.0
./configure --with-ssl
make && make install

```

编译结束后可以看到：

```
...
SSL:              enabled (OpenSSL)
...
```

> 编译参考 [https://curl.haxx.se/docs/install.html](https://curl.haxx.se/docs/install.html)

确认是基于 OpenSSL 的, 执行:`curl --version`

```bash
curl 7.69.0 (x86_64-pc-linux-musl) libcurl/7.69.0 OpenSSL/1.1.1d zlib/1.2.11
Release-Date: 2020-03-04
Protocols: dict file ftp ftps gopher http https imap imaps pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: AsynchDNS HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL TLS-SRP UnixSockets
```
