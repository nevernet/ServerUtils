## systemd的配置

创建文件 `/var/lib/systemd/system/mysql63306.service`

```
[Unit]
Description=MySQL Community Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target

[Install]
WantedBy=multi-user.target

[Service]
User=mysql
Group=mysql
Type=notify
# ExecStartPre=+/usr/share/mysql-8.0/mysql-systemd-start pre
ExecStart=/usr/sbin/mysqld --defaults-file=/etc/mysql/mysql.conf.d/mysql63306.cnf --socket=/var/run/mysqld/mysqld-63306.sock
TimeoutSec=0
PermissionsStartOnly=true
LimitNOFILE =500000
Restart=on-failure
RestartPreventExitStatus=1

# Always restart when mysqld exits with exit code of 16. This special exit code
# is used by mysqld for RESTART SQL.
RestartForceExitStatus=16

# Set enviroment variable MYSQLD_PARENT_PID. This is required for restart.
Environment=MYSQLD_PARENT_PID=1
```

操作

```
systemctl daemon-reload
systemctl enable mysql63306.service && systemctl start mysql63306.service
```