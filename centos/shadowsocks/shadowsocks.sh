#!/bin/bash
yum install python-setuptools && easy_install pip
pip install shadowsocks

cp shadowsocks.json /etc/shadowsocks.json

# for centos 7
firewall-cmd --zone=public --add-port=12050/tcp --permanent
firewall-cmd --reload

# 体验
#ssserver -c /etc/shadowsocks.json -d start
#ssserver -c /etc/shadowsocks.json -d stop


# 集成到supervisor
echo "
[program:shadowsocks]
command=ssserver -c /etc/shadowsocks.json
autostart = true
startsecs = 5
user = root
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdoiut_logfile_backups = 5
stdout_logfile = /var/log/supervisord/shadowsocks.log
" >> /etc/supervisord.conf

supervisorctl update
supervisorclt restart shadowsocks

# 启动脚本：
nohup sslocal -s x.x.x.x -p 12050 -l 7070 -k "password" -m aes-256-cfb &
