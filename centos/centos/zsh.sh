#!/bin/bash
yum -y install zsh
chsh -s /bin/zsh

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
# 添加下面一行
echo 'alias ll="ls -alh"' >> vim .zshrc

# source .zshrc
# 重启
reboot