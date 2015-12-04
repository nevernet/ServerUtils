#!/bin/bash
yum install -y perl-devjel perl-APCN curl-devel zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto openssl-devel
yum install -y wget
yum install -y unzip
cd ~
#wget -O git-master.zip https://github.com/git/git/archive/master.zip
#unzip git-master.zip
#cd git-master
rm -rf git-master git-master.zip
git clone https://github.com/git/git --depth=1 git-master
cd git-master
make configure
./configure --prefix=/usr/local
make
make install

git config --global push.default simple
git config --global core.editor "/usr/bin/vim"

#change to your real name and email
git config --global user.name "Daniel Qin"
git config --global user.email "xin.qin@qinx.org"
