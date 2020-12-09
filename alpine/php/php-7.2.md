# 安装工具

```bash
apk add linux-headers gcc g++ make cmake autoconf git wget rsync libc-dev pkgconf re2c zlib-dev libmemcached-dev
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
apk add openssl openssl-dev gd gd-dev gettext gettext-dev libxslt libxslt-dev icu icu-dev libmcrypt libmcrypt-dev readline readline-dev libedit libedit-dev libvpx libvpx-dev libjpeg-turbo libjpeg-turbo-dev libzip libzip-dev freetype freetype-dev gmp gmp-dev libxml2 libxml2-dev tidyhtml tidyhtml-dev libxpm libxpm-dev
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
wget https://www.php.net/distributions/php-7.2.34.tar.gz
tar zxf php-7.2.34.tar.gz
cd php-7.2.34

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
    --with-gd \
    --with-iconv \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir  \
    --with-freetype-dir \
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
    --enable-wddx  \
    --with-xmlrpc \
    --with-xsl \
    --enable-zip  \
    --with-pear \
    --with-tidy \
    --with-xpm-dir
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
php-fpm
```

# 安装 image magick

先安装 djvulibre， 这个在 apk 里面还没有

```bash
# install djvulibre
cd ~
wget http://downloads.sourceforge.net/djvu/djvulibre-3.5.27.tar.gz
tar zxf djvulibre-3.5.27.tar.gz
cd djvulibre-3.5.27
./configure
make
make install

```

> Imagemagick 7.x 版本跟 pecl 的 imagick 3.4.3 不兼容

```bash
# imagemagick 依赖
apk add bzip2-dev freetype-dev libjpeg-turbo-dev libpng-dev tiff-dev giflib-dev zlib-dev ghostscript-dev libwmf-dev jasper-dev libltdl libx11-dev libxext-dev libxt-dev lcms-dev libxml2-dev librsvg-dev openexr openexr-dev

cd ~
wget https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-45.tar.gz
tar zxf ImageMagick-6.9.10-45.tar.gz
cd ImageMagick-6.9.10-45
./configure
make && make install

```

# 检查：

```
convert --version
```

# 安装 libmemcached

```bash
apk add libmemcached libmemcached-dev
```

# pecl 安装

```bash
pecl install igbinary
pecl install msgpack
pecl install memcached
pecl install imagick
pecl install mongodb
pecl install grpc
pecl install protobuf
```

# 安装 phalconPHP

```bash
cd ~
git clone -b v3.4.3 --depth=1 --single-branch https://github.com/phalcon/cphalcon.git
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

```bash
extension=igbinary.so
extension=imagick.so
extension=memcached.so
extension=mongodb.so
extension=phalcon.so
extension=redis.so
extension=grpc.so
extension=protobuf.so
```

# 其他

grpc 和 protobuf 也可以使用 composer 版本

```
composer require grpc/grpc google/protobuf
```

# issues

`fatal error: linux/futex.h: No such file or directory`
修复： `apk add linux-headers`
