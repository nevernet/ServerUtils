#install dependency
pecl install igbinary

cd ~
wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar zxf  libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure
make
make install


cd ~
git clone https://github.com/php-memcached-dev/php-memcached.git --depth=1
cd php-memcached
make clean
make distclean
phpize
./configure --enable-memcached-igbinary --disable-memcached-sasl
make && make install
