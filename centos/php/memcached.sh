# 编译方式：

#install dependency
pecl install igbinary

cd ~
wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar zxf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure
make
make install


# for php 5.6
pecl install memcached-2.2.0
# cd ~
# git clone -b 2.2.0 --depth=1 --single-branch https://github.com/php-memcached-dev/php-memcached.git
# cd php-memcached
# make clean
# make distclean
# phpize
# ./configure --enable-memcached-igbinary --disable-memcached-sasl
# make && make install

# for php 7.1.x
pecl install memcached

#下面方式 暂不确定是否稳定。
cd ~
git clone -b v3.0.3 --depth=1 --single-branch https://github.com/php-memcached-dev/php-memcached.git
cd php-memcached
make clean
make distclean
phpize
./configure --enable-memcached-igbinary --disable-memcached-sasl
make && make install
