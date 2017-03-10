yum install -y epel-release
yum repolist

yum install -y pkg-config openssl-devel cyrus-sasl-devel
yum install -y libbson mongo-c-driver




#install libbson
cd ~
wget https://github.com/mongodb/libbson/releases/download/1.6.0/libbson-1.6.0.tar.gz
tar -xzf libbson-1.6.0.tar.gz
cd libbson-1.6.0/
./configure --prefix=/usr/local
make
make install

# install  mongoc driver
cd ~
wget https://github.com/mongodb/mongo-c-driver/releases/download/1.6.0/mongo-c-driver-1.6.0.tar.gz
tar xzf mongo-c-driver-1.6.0.tar.gz
cd mongo-c-driver-1.6.0
./configure --disable-automatic-init-and-cleanup
make
make install


pecl install mongodb
