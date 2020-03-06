# 启动 php 7.4 镜像容器

```bash
docker run -itd -v /sys/fs/cgroup:/sys/fs/cgroup --privileged -h php74 --name php74 alpine:v3 /bin/bash

# 进入容器
docker exec -it 4720d3018066 /bin/bash

```

# 安装工具

```bash
apk add gcc g++ make cmake autoconf git wget rsync libc-dev pkgconf re2c zlib-dev libmemcached-dev
```

# 安装 mhash

```bash
cd ~
wget https://jaist.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz
tar zxf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9
./configure
make
make install

```

# 安装 php 依赖的其他包

必须手动编译 curl， libcurl，因为 alpine 下的 curl 默认是基于 libressl 的，会到跟 php 的 openssl 冲突，
具体编译参见：[../curl/curl.md](../curl/curl.md)

```bash
apk add openssl openssl-dev gd gd-dev gettext gettext-dev libxslt libxslt-dev icu icu-dev libmcrypt libmcrypt-dev readline readline-dev libedit libedit-dev libvpx libvpx-dev libjpeg-turbo libjpeg-turbo-dev libzip libzip-dev freetype freetype-dev gmp gmp-dev libxml2 libxml2-dev tidyhtml tidyhtml-dev libxpm libxpm-dev sqlite sqlite-dev oniguruma oniguruma-dev
```

# 未确认的包：

这些包来自以前 centos 下，但是在 alpine 里面没发现

```bash
python-devel gcc-c++

# 不需要t1lib了， 不过要考虑其他系统的兼容性，对应php函数： imagepstext, 可以用freetype2替代。 函数： imagefttext
t1lib t1lib-devel
```

# 下载，安装 PHP

```bash
cd ~
wget https://www.php.net/distributions/php-7.4.3.tar.gz
tar zxf php-7.4.3.tar.gz
cd php-7.4.3

./configure --prefix=/usr/local  \
    --with-config-file-path=/etc  \
    --enable-fpm \
    --build=x86_64-linux-musl \
    build_alias=x86_64-linux-musl \
    --with-zlib  \
    --with-openssl \
    --enable-bcmath \
    --enable-calendar \
    --with-curl \
    --enable-exif \
    --enable-ftp  \
    --with-iconv \
    --with-zlib-dir  \
    --with-gettext \
    --with-gmp  \
    --with-mhash  \
    --enable-intl  \
    --enable-mbstring \
    --with-mysql-sock \
    --with-mysqli \
    --with-zlib-dir  \
    --enable-opcache \
    --enable-pcntl \
    --enable-sockets  \
    --with-pdo-mysql   \
    --with-libedit \
    --with-readline \
    --with-xmlrpc \
    --with-xsl \
    --with-pear \
    --with-tidy
make && make install

# 等安装完成后
cp php.ini-development /etc/php.ini
# cp php.ini-production /etc/php.ini
cd /usr/local/etc
cp php-fpm.conf.default php-fpm.conf
cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf

mkdir -p /opt/logs/
mkdir -p /opt/logs/php
mkdir -p /opt/www/
mkdir -p /opt/files/

# 根据情况修改/etc/php.ini和php-fpm.conf的配置

# 创建用户和修改目录权限
addgroup www
adduser -G www www

chown -R www:www /opt/logs/php/
chown -R www:www /opt/www
chown -R www:www /opt/files

# 启动
/usr/local/sbin/php-fpm
```

# 安装 image magick

先安装 djvulibre， 这个在 apk 里面还没有

```bash
# install djvulibre
cd ~
wget https://nchc.dl.sourceforge.net/project/djvu/DjVuLibre/3.5.27/djvulibre-3.5.27.tar.gz
tar zxf djvulibre-3.5.27.tar.gz
cd djvulibre-3.5.27
./configure
make
make install

```

> Imagemagick 7.x 版本跟 pecl 的 imagick 3.4.3 不兼容

```bash
# imagemagick 依赖
apk add bzip2-dev freetype-dev libjpeg-turbo-dev libpng-dev tiff-dev giflib-dev zlib-dev ghostscript-dev libwmf-dev libltdl libx11-dev libxext-dev libxt-dev lcms-dev libxml2-dev librsvg-dev openexr openexr-dev

cd ~
wget https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-97.tar.gz
tar zxf ImageMagick-6.9.10-97.tar.gz
cd ImageMagick-6.9.10-97/
./configure
make && make install

```

# 检查：

```
convert --version
```

输出内容：

```
Version: ImageMagick 6.9.10-97 Q16 x86_64 2020-03-06 https://imagemagick.org
Copyright: © 1999-2020 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC OpenMP(4.5)
Delegates (built-in): bzlib djvu fontconfig freetype jng jpeg lzma openexr png tiff wmf x xml zlib
```

# 安装 libmemcached

```
apk add libmemcached libmemcached-dev
```

> 目前的 pecl 有问题，还没升级好

# pecl 安装

```
pecl install igbinary
pecl install msgpack
pecl install memcached
pecl install imagick
pecl install mongodb
```

# 安装 phalconPHP

```bash
cd ~
git clone -b v3.4.5 --depth=1 --single-branch https://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install
```

# 安装 redis

```bash
cd ~
git clone --depth=1 --single-branch https://github.com/phpredis/phpredis.git
cd phpredis
phpize
./configure --enable-redis-igbinary
make && make install
```

# 添加到 /etc/php.ini

```
extension=igbinary.so
extension=imagick.so
extension=memcached.so
extension=mongodb.so
extension=phalcon.so
extension=redis.so
```
