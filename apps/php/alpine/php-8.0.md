# 启动 php 8.0 镜像容器

```bash
docker run --network br10 -itd --privileged --restart always -h php801 --name php801 docker.example.com/alpine-python:v4 /sbin/init /bin/bash

# 进入容器
docker exec -it 4720d3018066 /bin/bash

```

# 安装工具

```bash
apk update && apk upgrade
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
具体编译参见：[../../../os/alpine/curl/curl.md](../../../os/alpine/curl/curl.md)

## 安装 curl
```bash
cd ~
wget https://curl.haxx.se/download/curl-7.86.0.tar.gz
tar zxf curl-7.86.0.tar.gz
cd curl-7.86.0
./configure --with-ssl
make && make install

# 修复cert.pem
cd ~
wget http://curl.haxx.se/ca/cacert.pem
cp cacert.pem /opt/openssl-1.1.1u/bin/ssl/cert.pem
chmod 644 /opt/openssl-1.1.1u/bin/ssl/cert.pem
```

通过 `php -r "print_r(openssl_get_cert_locations());"` 查看证书路径

## 安装 openssl 1.x 版本
php 8.0(含)以下都不支持libssl 3+

不要直接安装 `openssl openssl-dev`，因为这个是 3.x 版本，会跟 php 的 openssl 冲突。 如果已经安装需要 `apk del openssl openssl-dev`


```bash
cd ~
wget https://www.openssl.org/source/openssl-1.1.1u.tar.gz
tar zxf openssl-1.1.1u.tar.gz
cd openssl-1.1.1u
mkdir -p /opt/openssl-1.1.1u/bin
./Configure --prefix=/opt/openssl-1.1.1u/bin -fPIC -shared linux-x86_64
make -j 8
make install
```


```bash
apk add gd gd-dev gettext gettext-dev libxslt libxslt-dev icu icu-dev libmcrypt libmcrypt-dev readline readline-dev libedit libedit-dev libvpx libvpx-dev libjpeg-turbo libjpeg-turbo-dev libzip libzip-dev freetype freetype-dev gmp gmp-dev libxml2 libxml2-dev tidyhtml tidyhtml-dev libxpm libxpm-dev sqlite sqlite-dev oniguruma oniguruma-dev
```

```bash
python-devel gcc-c++

# 不需要t1lib了， 不过要考虑其他系统的兼容性，对应php函数： imagepstext, 可以用freetype2替代。 函数： imagefttext
t1lib t1lib-devel
```

# 下载，安装 PHP

```bash
cd ~
wget https://www.php.net/distributions/php-8.0.30.tar.gz
tar zxf php-8.0.30.tar.gz
cd php-8.0.30

export PKG_CONFIG_PATH=/opt/openssl-1.1.1u/bin/lib/pkgconfig

./configure --prefix=/usr/local  \
    --with-config-file-path=/etc  \
    --enable-fpm \
    --build=x86_64-linux-musl \
    build_alias=x86_64-linux-musl \
    --with-zlib  \
    --with-openssl=/opt/openssl-1.1.1u/bin \
    --with-openssl-dir=/opt/openssl-1.1.1u/bin \
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

# 安装 libmemcached

```
apk add libmemcached libmemcached-dev
```

> 目前的 pecl channel有问题，一直无法链接  ssl://pecl.php.net:443

# pecl 安装

```
pecl install igbinary
pecl install msgpack
pecl install memcached
pecl install mongodb
pecl install grpc
pecl install protobuf
```

# 安装 phalconPHP

```bash
cd ~
git clone --depth=1 https://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install
```

# 安装swoole 5.0.3
```bash
cd ~
git clone  --branch v5.0.3 --depth=1 --single-branch https://github.com/swoole/swoole-src.git
cd swoole-src
phpize
./configure
make && make install
```

# 安装igbinary

```bash
cd ~
wget https://github.com/igbinary/igbinary/archive/refs/tags/3.2.14.tar.gz -O igbinary.3.2.14.tar.gz
tar zxf igbinary.3.2.14.tar.gz
cd igbinary.3.2.14
phpize
./configure
make && make install
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

# 安装 memcached

```bash
cd ~
wget https://github.com/php-memcached-dev/php-memcached/archive/refs/tags/v3.2.0.tar.gz -O php-memcached.v3.2.0.tar.gz
tar zxf php-memcached.v3.2.0.tar.gz
cd php-memcached.v3.2.0
phpize
./configure
make && make install
```

# 安装 mongodb

```bash
cd ~
git clone  --depth=1 --single-branch https://github.com/mongodb/mongo-php-driver.git
cd mongo-php-driver-1.16.2
git submodule update --init
phpize
./configure
make && make install
```



# 添加到 /etc/php.ini

```
extension=mongodb.so
extension=igbinary.so
extension=memcached.so
extension=phalcon.so
extension=redis.so
extension=swoole.so
```

未安装：

```
extension=grpc.so
extension=protobuf.so
```