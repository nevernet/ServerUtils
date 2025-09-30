#!/bin/bash
rc-service sshd restart
rc-service crond restart

su-exec postgres pg_ctl -D /var/lib/postgresql/data restart

# 在这里添加其他需要启动的服务
# 例如：
# /usr/local/bin/my-service --daemon
# /usr/sbin/nginx -g "daemon off;"

while true; do
    echo 1
    sleep 5s
done
