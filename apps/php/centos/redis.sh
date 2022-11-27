#install dependency
pecl install igbinary

cd ~
git clone --depth=1 --single-branch https://github.com/phpredis/phpredis.git
cd phpredis
phpize
./configure --enable-redis-igbinary
make && make install
