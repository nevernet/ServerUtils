环境：Ubuntu

# 1.停止 docker

```
service docker stop
```

# 2.创建新目录：

```
mkdir /opdata/docker
```

（/opdata 是新挂载的数据盘）

# 3.迁移原数据，

原数据存放在/var/lib/docker, 迁移命令：

```
rsync -avPHSX /var/lib/docker/ /opdata/docker/
```

注意这里绝对不能用 cp -r 来操作。

rsync 的-X 参数是用来保留原文件属性，如果属性被修改了， 将导致 docker 里面出现很多奇怪的问题。

# 4.修改原文件夹，备份。

```
mv /var/lib/docker /var/lib/docker.bak
```

# 5.修改 dockerd 的启动参数：

```bash
vim /lib/systemd/system/docker.service

# 修改这一行如下：
ExecStart=/usr/bin/dockerd -g /opdata/docker -H fd://
```

增加了-g 参数。
（注意： 这里尝试过用 \$DOCKER_OPTS 参数，但是无效。 增加了 EnvironmentFile=-/etc/default/docker，没效果）

# 6.启动：

(ubuntu 下面先执行： `systemctl daemon-reload`)

```
service docker start
```

# 7.检查原 docker 服务
