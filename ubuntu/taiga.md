# taiga 安装

https://taigaio.github.io/taiga-doc/dist/setup-production.html#_introduction

管理后台： http://taiga.yoursiteurl.com/admin/ (notice the last /)

# 基础操作

```
groupadd taiga # 创建用户组
useradd -m -g taiga taiga # 创建用户， -m 表示创建 home 目录（/home/taiga)， -g 是添加用户.

sudo service postgresql restart
sudo service rabbitmq-server restart
sudo service redis-server restart
sudo service circusd restart
sudo service nginx restart
```

重启 taiga 等

```
circusctl reload taiga
circusctl reload taiga-celery
```

# taiga 更新

https://taigaio.github.io/taiga-doc/dist/upgrades.html

## 切换到 taiga 用户

```
su taiga
cd ~
```

## 更新前端

```
cd ~/taiga-front-dist
git checkout stable
git pull
```

## 更新后端

```
cd ~/taiga-back
git checkout stable
workon taiga
git pull
pip install -r requirements.txt
```

```
python manage.py migrate --noinput
python manage.py compilemessages
python manage.py collectstatic --noinput
```

我们使用`circus`作为进程管理(4.0 以下。)

```
circusctl reload taiga
circusctl reload taiga-celery
```

4.0+ 推荐使用 systemd 管理，我们暂时没有用 systemd

# Debug 问题

在`/home/taiga/taigai-back/settings/local.py`里面启用`Debug=True`。 重新请求后，可以查看更多的信息

## 问题 1： redis 无法连接的问题

修改`/etc/redis/redis.conf`的 bind 为：

```
bind 127.0.0.1
```

也就是把`::1`给去掉了。ipv6 无法启动绑定

## 问题 2： 所有老的 issue 等，如果有无法评论回复或者修改状态的

可以先删除所有的 watcher 后再操作，
这个问题是因为服务器默认屏蔽了 25 端口， 所以在 taiga-back/settings/local.py 里面的邮件配置，需要更新配置。
腾讯云默认屏蔽 25 端口，配置里面需要修改启用 SSL, smtp 的端口改成 465, 同时腾讯云的企业邮箱（exmail)默认针对客户端登录启用专用密码，所以需要单独生成来使用。
