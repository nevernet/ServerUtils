# 最新版 v3.3.x 支持 php7.2
cd ~
git clone --depth=1 --single-branch https://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install

# v3.2.x 版本 支持php7.1
cd ~
git clone -b v3.2.4 --depth=1 --single-branch https://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install

# v2.0.x版本
cd ~
git clone -b phalcon-v2.0.13 --depth=1 --single-branch https://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install
