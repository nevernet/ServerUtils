#!/bin/bash
apt-get install -y vim
echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> ~/.vimrc
echo "set termencoding=utf-8" >> ~/.vimrc
echo "set encoding=utf-8" >> ~/.vimrc
echo "set nu" >> ~/.vimrc

