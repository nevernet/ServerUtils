#!/bin/bash
rc-service sshd restart
rc-service crond restart
rc-service nginx restart
/usr/local/bin/redis-server /etc/redis-16379.conf
/root/.pyenv/shims/supervisord -c /etc/supervisord.conf
/usr/local/sbin/php-fpm

while true; do

echo 1
sleep 5s

done