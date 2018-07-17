supervisor 相关配置

```
[program:shadowsocks-sserver]
command=/root/.pyenv/shims/ssserver --manager-address 127.0.0.1:6000 -c /etc/shadowsocks.json
autostart = true
startsecs = 5
user = root
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdoiut_logfile_backups = 5
stdout_logfile = /var/log/supervisord/shadowsocks-sserver.log

[program:ssmgr]
command= /root/shadowsocks-manager/bin/ssmgr -c /root/ssmgr.yml
autostart = true
startsecs = 5
user = root
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdoiut_logfile_backups = 5
stdout_logfile = /var/log/supervisord/ssmgr.log

[program:ssmgr-webgui]
command=/root/shadowsocks-manager/bin/ssmgr -c /root/webgui.yml
autostart = true
startsecs = 5
user = root
redirect_stderr = true
stdout_logfile_maxbytes = 20MB
stdoiut_logfile_backups = 5
stdout_logfile = /var/log/supervisord/ssmgr-webgui.log
```
