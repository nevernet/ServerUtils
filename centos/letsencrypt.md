# 准备工作

```
python -V
# 如果版本号不是2.7以上，则直接
pyenv global 2.7.13 # 必须先安装pyenv， 请参考 python/pyenv.sh
```

# 第一步： 创建 ssl 目录:

```
mkdir -p /etc/nginx/vhost/ssl
cd /etc/nginx/vhost/ssl
```

# 第二部： 安装 certbot:

```
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
```

# ubuntu 下面，很可能会碰到 https://github.com/certbot/certbot/issues/2883

```
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
```

# 第三步： 生成对应的域名证书（注意：这里需要网站可以通过 http 访问，所以必须先配置所有站点可以访问）

# 把同一个域名的多个站点，生成到一个证书里面.

```
./certbot-auto certonly --email user@example.com  --agree-tos --no-eff-email --webroot \
-w /opt/www/study.example.com/dist/ -d study.example.com \
-w /opt/www/study-api.example.com/public/api/ -d study-api.example.com \
-w /opt/www/study-api.example.com/public/sapi/ -d study-teacher-api.example.com \
-w /opt/www/study-teacher.example.com/dist/ -d study-teacher.example.com \
-w /opt/www/study-admin.example.com/dist/ -d study-admin.example.com \
-w /opt/www/study-api.example.com/public/adminapi/ -d study-admin-api.example.com \
-w /opt/www/www.example.com/dist/ -d www.example.com \
-w /opt/www/api.example.com/public/api -d api.example.com
```

```
# 先安装部分
./certbot-auto

# 已有网站使用wwwroot的插件来生成证书
./certbot-auto certonly --webroot -w /opt/certs/example/ -d f.dev1.example.cn
# 当没有webroot的时候：
./certbot-auto certonly -d f.dev1.example.cn
# 会提示临时生成一个webserver来验证

# 多个网站
./certbot-auto certonly --webroot -w /opt/certs/example/ -d f.dev1.example.cn -w /opt/www/api.dev1.example.com -d api.dev1.example.com -w /opt/www/admin.dev1.example.com -d admin.dev1.example.com

# 默认情况下，let's encripty 会把pem文件生成到/etc/letsencript/live/domain下面
```

# 第四部：配置 nginx，让 ssl 生效：

```
ssl on;
ssl_certificate /etc/letsencrypt/live/api.example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/api.example.com/privkey.pem;
```

# 第五步：配置 certbot 自动更新证书.

```
/etc/nginx/vhost/ssl/certbot-auto renew --quite --post-hook "/etc/init.d/nginx reload"
```

配置自动执行（需要先安装 crontab: yum install cronie)：

```
0 2 * * * root /etc/nginx/vhost/ssl/certbot-auto renew --post-hook "/etc/init.d/nginx reload"
0 10 * * * root /etc/nginx/vhost/ssl/certbot-auto renew --post-hook "/etc/init.d/nginx reload"
0 18 * * * root /etc/nginx/vhost/ssl/certbot-auto renew --post-hook "/etc/init.d/nginx reload”
```

说明： 配置 3 个时间点，每天 2 点，10 点， 18 点执行一次。

重启 crontab:
`service crond restart`

# 国内的源由于不全，在更新的时候，可以暂时禁止国内的源，即:

`mv ~/.pip/pip.conf ~/.pip/pip.conf.bak`
