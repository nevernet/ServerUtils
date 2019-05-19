# 安装工具

```
apk add gcc g++ make cmake autoconf git wget rsync
```

# 安装 mhash

```
wget https://jaist.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz
tar zxf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9
./configure
make
make install
```

# 安装 php 依赖的其他包

```
apk add curl curl-dev openssl openssl-dev gd gd-dev gettext gettext-dev libxslt libxslt-dev icu icu-dev libmcrypt libmcrypt-dev readline readline-dev libedit libedit-dev libvpx libvpx-dev libjpeg-turbo libjpeg-turbo-dev libzip libzip-dev freetype freetype-dev gmp gmp-dev libxml2 libxml2-dev tidyhtml tidyhtml-dev libxpm libxpm-dev
```

# 未确认的包：

这些包来自以前 centos 下，但是在 alpine 里面没发现

```
python-devel gcc-c++

# 不需要t1lib了， 不过要考虑其他系统的兼容性，对应php函数： imagepstext, 可以用freetype2替代。 函数： imagefttext
t1lib t1lib-devel
```

# 下载，安装 PHP

```
wget https://www.php.net/distributions/php-7.2.18.tar.gz
tar zxf php-7.2.18.tar.gz
cd php-7.2.18

./configure --prefix=/usr/local  --with-config-file-path=/etc  --enable-fpm --with-openssl  --with-zlib  --enable-bcmath --enable-calendar --with-curl --enable-exif --enable-ftp  --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir  --with-freetype-dir --enable-gd-native-ttf --with-gettext --with-gmp  --with-mhash  --enable-intl  --enable-mbstring --with-mcrypt  --with-mysql-sock --with-mysqli --with-zlib-dir  --enable-opcache --enable-pcntl  --with-pdo-mysql   --with-libedit --with-readline --enable-sockets --enable-wddx  --with-xmlrpc --with-xsl --enable-zip  --with-pear --with-tidy --with-xpm-dir
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

```
# install djvulibre
wget http://downloads.sourceforge.net/djvu/djvulibre-3.5.27.tar.gz
tar zxf djvulibre-3.5.27.tar.gz
cd djvulibre-3.5.27
./configure
make
make install
```

> Imagemagick 7.x 版本跟 pecl 的 imagick 3.4.3 不兼容

```
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

```
apk add libmemcached libmemcached-dev
```

# pecl 安装

```
pecl install igbinary
pecl install memcached
pecl install imagick
pecl install mongodb
```

# 安装 phalconPHP

```
cd ~
git clone -b v3.4.3 --depth=1 --single-branch https://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install
```

# 安装 redis

```
cd ~
git clone --depth=1 --single-branch https://github.com/phpredis/phpredis.git
cd phpredis
phpize
./configure --enable-redis-igbinary
make && make install
```

# 添加到 /etc/php.ini

extension=igbinary.so
extension=imagick.so
extension=memcached.so
extension=mongodb.so
extension=phalcon.so
extension=redis.so
