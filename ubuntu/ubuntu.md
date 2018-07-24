-   基础

```
apt-get update
```

-   配置 vim

```
apt-get install -y vim

# vim ~/.vimrc

set nu # 显示行号
```

-   修改 sshd 配置

```
apt-get install -y openssh-server
vim /etc/ssh/sshd_config

# 修改如下：
ClientAliveInterval 60
ClientAliveCountMax 3
UseDNS no

service ssh restart
```

-   配置时区

```
apt-get install -y tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

-   创建启动脚本

```
vim ~/init.sh

# 输入
#!/bin/bash
service ssh restart

while true; do

echo 1
sleep 5s

done

# 修改权限

chmod +x init.sh
```
