#!/bin/bash

wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto

# ubuntu下面，很可能会碰到 https://github.com/certbot/certbot/issues/2883
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

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

# 更新
./certbot-auto renew --quiet
# 国内的源由于补全，在更新的时候，可以暂时禁止国内的源，即:
# mv ~/.pip/pip.conf ~/.pip/pip.conf.bak

# 定时更新
vim /etc/crontab
0 0 15 */3 * root /root/certbot-auto renew --quiet
30 1 15 */3 * root /root/certbot-auto renew --quiet
30 2 15 */3 * root /root/certbot-auto renew --quiet

