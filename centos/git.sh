#!/bin/bash
yum install -y perl-devjel perl-APCN curl-devel zilb-devel perl-ExtUtils-MakeMaker asciidoc xmlto openssl-devel
yum install -y wget
yum install -y unzip
cd ~
wget -O git-master.zip https://github.com/git/git/archive/master.zip
unzip git-master.zip
cd git-master
make configure
./configure --prefix=/usr/local
make
make install

git config --global push.default simple

#change to your real name and email
git config --global user.name "Daniel Qin"
git config --global user.email "xin.qin@qinx.org"
