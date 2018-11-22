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

# for php 7.0+
pecl install memcached

# 源码安装
cd ~
git clone -b v3.0.4 --depth=1 --single-branch https://github.com/php-memcached-dev/php-memcached.git
cd php-memcached
git checkout -b v3.0.4
make clean
make distclean
phpize
./configure --enable-memcached-igbinary --disable-memcached-sasl
make && make install

# mac mac安装，如果提示找不到zlib的时候，需要把lib和include目录做一个软连接到系统目录：
# 注意这里不要使用 -f参数，避免覆盖已经存在的文件。
ln -s /usr/local/opt/zlib/lib/* /usr/local/lib
ln -s /usr/local/opt/zlib/include/* /usr/local/include
