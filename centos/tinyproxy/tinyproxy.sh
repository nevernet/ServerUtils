#!/bin/bash
# tinyproxy doesn't support authentication, droped it.
# dependecy
yum install asciidoc
wget -O tinyproxy.tar.bz2 https://download.banu.com/tinyproxy/1.8/tinyproxy-1.8.3.tar.bz2
tar jxf tinyproxy.tar.bz2
cd tinyproxy
./configure
make
make install
