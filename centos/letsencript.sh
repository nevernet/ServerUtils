#!/bin/bash

wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto

# ubuntu下面，很可能会碰到 https://github.com/certbot/certbot/issues/2883
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# 先安装部分
./certbot

# 已有网站使用wwwroot的插件来生成证书
./certbot-auto certonly --webroot -w /opt/cents/example/ -d f.dev1.example.cn

# 多个网站
./certbot-auto certonly --webroot -w /opt/cents/example/ -d f.dev1.example.cn -w /opt/www/api.dev1.example.com -d api.dev1.example.com -w /opt/www/admin.dev1.example.com -d admin.dev1.example.com

# 默认情况下，let's encripty 会把pem文件生成到/etc/letsencript/live/domain下面

