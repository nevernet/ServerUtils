# alpine 升级流程

首先更新 repositories
`vi /etc/apk/repositories`

> 切记不要跨版本升级，最好就是一个版本一个版本升级上来

```
#http://dl-cdn.alpinelinux.org/alpine/v3.11/main
#http://dl-cdn.alpinelinux.org/alpine/v3.11/community

# 推荐中科大
https://mirrors.ustc.edu.cn/alpine/v3.14/main
https://mirrors.ustc.edu.cn/alpine/v3.14/community

# 阿里云， 有点慢
https://mirrors.aliyun.com/alpine/v3.14/main
https://mirrors.aliyun.com/alpine/v3.14/community

```

更新 apk index: `apk update --update-cache --no-cache --allow-untrusted`

执行升级：
```
apk add alpine-base
apk upgrade --available
sync
```


如果有错误可以尝试： `apk fix` 或者 `apk -sv fix`
如果 有 php，需要重新安装 `curl` 具体编译参见：[../curl/curl.md](../curl/curl.md)，否则导致 libcurl 不正确

执行重启：

```
sync
reboot
```

查看新版本:

```
cat /etc/alpine-release.apk-new
cat /etc/issue.apk-new
cat /etc/os-release.apk-new

mv /etc/alpine-release.apk-new /etc/alpine-release
mv /etc/issue.apk-new /etc/issue
mv /etc/os-release.apk-new /etc/os-release
```
