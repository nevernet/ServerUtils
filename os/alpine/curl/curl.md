在 alpine 下面， apk add curl 使用的是 libressl，会导致跟 php 等用 openssl 发生冲突。

```bash
apk add openssl openssl-dev binutils
apk add linux-headers gcc g++ make cmake autoconf git wget rsync libc-dev pkgconf re2c zlib-dev libmemcached-dev
```

下载源码：

[https://curl.haxx.se/download.html](https://curl.haxx.se/download.html)

```bash
cd ~
wget https://curl.haxx.se/download/curl-7.86.0.tar.gz
tar zxf curl-7.86.0.tar.gz
cd curl-7.86.0
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
curl 7.86.0 (x86_64-pc-linux-musl) libcurl/7.86.0 OpenSSL/3.0.7 zlib/1.2.13
Release-Date: 2022-10-26
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS HSTS HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL threadsafe TLS-SRP UnixSockets
```
