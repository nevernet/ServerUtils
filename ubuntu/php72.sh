# install dependecy
apt-get install -y build-essential
apt-get install -y \
autoconf \
curl libcurl4-openssl-dev \
libssl-dev openssl libcurl4-openssl-dev \
gd libgd-dev \
gettext libgettext-ocaml-dev \
mhash libmhash-dev \
libxslt libxslt1-dev \
icu libicu libicu-dev \
libmcrypt libmcrypt-dev \
readline libreadline-dev \
libedit libedit-dev \
libtidy libtidy-dev \
libvpx libvpx-dev \
libzip libzip-dev \
libxpm libxpm-dev \
gmp libgmp-dev \
libmemcached-dev \
libxml2 libxml2-dev

# install freetype
cd ~
wget https://download.savannah.gnu.org/releases/freetype/freetype-2.10.3.tar.gz
tar zxf freetype-2.10.3.tar.gz
cd freetype-2.10.3/
./configure
make && make install

cd ~
wget https://www.php.net/distributions/php-7.2.34.tar.gz -O php-source.tar.gz
tar zxf php-source.tar.gz
# 请注意，这个版本的configure里面，没有配置freetype，目前freetype在ubuntu下的安装还有问题，会提示找不到ft2build.h文件
cd php-7.2.34
./configure --prefix=/usr/local  \
    --with-config-file-path=/etc  \
    --enable-fpm \
    --enable-bcmath \
    --enable-calendar \
    --enable-exif \
    --enable-ftp \
    --enable-intl \
    --enable-mbstring \
    --enable-wddx \
    --enable-zip \
    --with-openssl  \
    --with-zlib  \
    --with-curl \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-gettext \
    --with-gmp  \
    --with-mhash \
    --with-mysql-sock \
    --with-mysqli \
    --with-zlib-dir \
    --enable-opcache \
    --enable-pcntl \
    --with-pdo-mysql \
    --with-libedit \
    --with-readline \
    --enable-sockets \
    --with-tidy \
    --with-xmlrpc \
    --with-pear

make && make install

cp php.ini-development /etc/php.ini
cd /usr/local/etc
cp php-fpm.conf.default php-fpm.conf

echo "/usr/local/bin/php-fpm" >> /etc/rc.local


# 升级扩展
pecl install igbinary
pecl install mongodb

#redis
# 请参见./php/redis.php

# memcached
pecl uninstall memcached
pecl install memcached

pecl uninstall imagick
pecl install imagick
pecl install protobuf

# phalconphp
# 参见./php/phalconphp.sh


mkdir -p /opt/logs/
mkdir -p /opt/logs/php
mkdir -p /opt/www/
mkdir -p /opt/files/


groupadd www
useradd -g www www

chown -R www:www /opt/logs/php/
chown -R www:www /opt/www
chown -R www:www /opt/files
