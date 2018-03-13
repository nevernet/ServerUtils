yum install -y libevent-devel wget gcc gcc-c++

wget http://memcached.org/latest
tar -zxvf memcached-1.x.x.tar.gz
cd memcached-1.x.x
./configure && make && make install

brew install php72-intl
brew install php72-mcrypt
brew install php72-memcached
brew install php72-mongodb
brew install php72-msgpack
brew install php72-opcache
brew install php72-pcntl
brew install php72-redis
brew install php72-tidy
brew install php72-yac
brew install php72-yaf