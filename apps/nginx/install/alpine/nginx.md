# 安装

```
apk update && apk add nginx
```

查看： nginx -v


创建基础的目录：

```
mkdir -p /opt/logs/php

mkdir -p /opt/logs/nginx
mkdir -p /opt/etc/nginx
mkdir -p /opt/logs/
mkdir -p /opt/www/
mkdir -p /opt/files/
```


启动
```
rc-update add nginx default
rc-service nginx restart
rc-status
```

修改 init.sh
```
rc-service nginx restart
```