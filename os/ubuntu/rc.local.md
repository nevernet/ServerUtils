1.实现原理
systemd 默认会读取 /etc/systemd/system 下的配置文件，该目录下的文件会链接 /lib/systemd/system/ 下的文件。一般系统安装完 /lib/systemd/system/ 下会有 rc-local.service 文件，即我们需要的配置文件。

2.将 /lib/systemd/system/rc-local.service 链接到 /etc/systemd/system/ 目录下面来

```
ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service
```


修改文件，末尾添加
```
vim /etc/systemd/system/rc-local.service
``


```
[Install]
WantedBy=multi-user.target
Alias=rc-local.service
```

完整内容如下：

```
[Unit]
Description=/etc/rc.local Compatibility
Documentation=man:systemd-rc-local-generator(8)
ConditionFileIsExecutable=/etc/rc.local
After=network.target

[Service]
Type=simple
ExecStart=/etc/rc.local
TimeoutSec=0
RemainAfterExit=yes
GuessMainPID=no

[Install]
WantedBy=multi-user.target
Alias=rc-local.service
```

`vim /etc/rc.local`  文件

```
#!/bin/sh

# 写入自己的启动项
# 注意：不要使用 -e 参数，避免单个命令失败导致整个脚本退出

exit 0
```

## 添加执行权限
```
chmod +x /etc/rc.local
```

配置默认启动
```
# 重新加载配置文件
systemctl daemon-reload && systemctl enable rc-local && systemctl start rc-local
```