# Ubuntu 基础

```
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y systemd
```

# nodejs 升级

```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

# taiga 安装

https://taigaio.github.io/taiga-doc/dist/setup-production.html#_introduction

管理后台： http://taiga.yoursiteurl.com/admin/ (notice the last /)

## python 更新

```
sudo apt-get update
sudo apt-get install -y python3.9 python3.9-venv python3.9-dev
sudo apt-get install -y libxml2-dev libxslt-dev
sudo apt-get install -y libssl-dev libffi-dev
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1
sudo update-alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip3 1
sudo update-alternatives --install /usr/bin/pip3.9 pip3.9 /usr/local/bin/pip3.9 1
sudo update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip 1

```

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

# mkvirtualenv -p /usr/bin/python3 taiga

python3 -m venv .venv --prompt taiga-back
source .venv/bin/activate

# python 执行路径应该是： /home/taiga/taiga-back/.venv/bin/python

# pip install git+https://github.com/kaleidos-ventures/taiga-contrib-protected.git@6.0.0#egg=taiga-contrib-protected

python -m pip install -r requirements.txt
```

```
# python manage.py migrate --noinput
# python manage.py compilemessages
# python manage.py collectstatic --noinput

DJANGO_SETTINGS_MODULE=settings.config python manage.py migrate --noinput
DJANGO_SETTINGS_MODULE=settings.config python manage.py compilemessages
DJANGO_SETTINGS_MODULE=settings.config python manage.py collectstatic --noinput

```

## taiga-events

```
cd ~
git clone https://github.com/kaleidos-ventures/taiga-events.git taiga-events
cd taiga-events
git checkout stable

npm install # node 要v12以上

cp .env.example .env

RABBITMQ_URL="amqp://rabbitmquser:rabbitmqpassword@rabbitmqhost:5672/taiga"
SECRET="taiga-back-secret-key"
WEB_SOCKET_SERVER_PORT=8888
APP_PORT=3023
```

## taiga-protected

```
cd ~
git clone https://github.com/kaleidos-ventures/taiga-protected.git taiga-protected
cd taiga-protected
git checkout stable

python3 -m venv .venv --prompt taiga-protected
source .venv/bin/activate
(taiga-protected) pip install --upgrade pip wheel
(taiga-protected) pip install -r requirements.txt
(taiga-protected) cp env.sample env
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

运行：
目前 supervisor 基于 taiga 安装，放在/home/taiga 下

```
/home/taiga/.local/bin/supervisord -c supervisord.conf
```
