# 创建开机启动的脚本
```bash
rc-update add local default
```

服务的脚本以.start结尾， 结束的脚本.stop结尾，比如xx.start, xx.stop
文件需要放到 `/etc/local.d/` 目录下面

比如创建一个开机启动的脚本，内容如下：`rc.start`
```bash
#!/bin/bash
/usr/local/bin/redis-server /etc/redis-16379.conf
/root/.pyenv/shims/supervisord -c /etc/supervisord.conf
/usr/local/sbin/php-fpm
```

修改权限

```bash
chmod +x rc.start
```
