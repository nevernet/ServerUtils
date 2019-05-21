在 alpine 下面， apk add curl 使用的是 libressl，会导致跟 php 等用 openssl 发生冲突。

```
apk add openssl openssl-dev
```

下载源码：

[https://curl.haxx.se/download.html](https://curl.haxx.se/download.html)

编译:

```
./configure --with-ssl
make && make install
```

> 编译参考 [https://curl.haxx.se/docs/install.html](https://curl.haxx.se/docs/install.html)

确认是基于 OpenSSL 的, 执行:`curl --version`

```
curl 7.64.1 (x86_64-pc-linux-musl) libcurl/7.64.1 OpenSSL/1.0.2r zlib/1.2.11
Release-Date: 2019-03-27
Protocols: dict file ftp ftps gopher http https imap imaps pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: AsynchDNS HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL TLS-SRP UnixSockets
```
