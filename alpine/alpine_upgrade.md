# alpine 升级流程

首先更新 repositories
`vi /etc/apk/repositories`

```
#http://dl-cdn.alpinelinux.org/alpine/v3.11/main
#http://dl-cdn.alpinelinux.org/alpine/v3.11/community

https://mirrors.ustc.edu.cn/alpine/v3.14/main
https://mirrors.ustc.edu.cn/alpine/v3.14/community

```

更新 apk index: `apk update --update-cache`

执行升级： `apk upgrade --available`

如果有错误可以尝试： `apk fix` 或者 `apk -sv fix`
如果 有 php，需要重新安装 `curl` 具体编译参见：[../curl/curl.md](../curl/curl.md)，否则导致 libcurl 不正确

执行重启：

```
sync
reboot
```

查看新版本:

```
cat /etc/alpine-release
```
