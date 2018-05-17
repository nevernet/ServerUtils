# install dependecy
yum install -y python-devel gcc gcc-c++ wget curl curl-devel openssl openssl-devel gd gd-devel gettext gettext-devel mhash mhash-devel libxslt libxslt-devel icu libicu libicu-devel libmcrypt libmcrypt-devel readline readline-devel libedit libedit-devel libtidy libtidy-devel libvpx libvpx-devel libjpeg-turbo libjpeg-turbo-devel libzip libzip-devel libXpm libXpm-devel freetype freetype-devel t1lib t1lib-devel gmp gmp-devel

# install libxml2
# reference: http://www.linuxfromscratch.org/blfs/view/svn/general/libxml2.html
cd ~
wget  http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz
tar zxf libxml2-2.9.2.tar.gz
cd libxml2-2.9.2
./configure
#./configure --prefix=/usr --disable-static --with-history
# --disable-static: This switch prevents installation of static versions of the libraries.
#--with-history: This switch enables Readline support when running xmlcatalog or xmllint in shell mode.
make && make install
# will be installed to /usr/local/lib

cd ~
wget https://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
tar -zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --prefix=/usr/local
make
make install

# install dependecy
yum install -y curl curl-devel openssl openssl-devel gd gd-devel gettext gettext-devel mhash mhash-devel libxslt libxslt-devel icu libicu libicu-devel libmcrypt libmcrypt-devel readline readline-devel libedit libedit-devel libtidy libtidy-devel libvpx libvpx-devel libjpeg-turbo libjpeg-turbo-devel libzip libzip-devel libXpm libXpm-devel freetype freetype-devel t1lib t1lib-devel gmp gmp-devel

cd ~
wget http://cn.php.net/distributions/php-7.2.3.tar.gz -O php-source.tar.gz
tar zxf php-source.tar.gz
cd php-7.2.3
./configure --prefix=/usr/local  --with-config-file-path=/etc  --enable-fpm --with-openssl  --with-zlib  --enable-bcmath --enable-calendar --with-curl --enable-exif --enable-ftp  --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir  --with-xpm-dir  --with-freetype-dir --enable-gd-native-ttf --with-gettext --with-gmp  --with-mhash  --enable-intl  --enable-mbstring --with-mcrypt  --with-mysql-sock --with-mysqli --with-zlib-dir  --enable-opcache --enable-pcntl  --with-pdo-mysql   --with-libedit --with-readline --enable-sockets  --with-tidy --enable-wddx  --with-xmlrpc --with-xsl --enable-zip  --with-pear
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

# phalconphp
# 参见./php/phalconphp.sh
