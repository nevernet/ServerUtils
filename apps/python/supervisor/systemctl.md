配置成 systemctl 服务：

进入目录 `/usr/lib/systemd/system/`，增加文件 `supervisord.service`，来使得机器启动的时候启动 supervisor，文件内容

```
# supervisord service for systemd (CentOS 7.0+)

# by ET-CS (https://github.com/ET-CS)

[Unit]
Description=Supervisor daemon

[Service]
Type=forking
ExecStart=/root/.pyenv/shims/supervisord -c /etc/supervisord.conf
ExecStop=/root/.pyenv/shims/supervisorctl $OPTIONS shutdown
ExecReload=/root/.pyenv/shims/supervisorctl $OPTIONS reload
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

根据自己的实际情况修改`supervisord`和`supervisorctl`路径

```
systemctl daemon-reload
systemctl enable supervisord
systemctl start supervisord
systemctl stop supervisord
systemctl reload supervisord
```
