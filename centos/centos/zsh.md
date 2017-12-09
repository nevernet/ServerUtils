# 安装 zsh
yum -y install zsh
chsh -s /bin/zsh

# 重启
reboot

# 安装on-my-zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

# 添加下面一行
echo 'alias ll="ls -alh"' >> vim .zshrc

source .zshrc

# 使用
 - gst = git status
 - gp = git pull
 - gc -am "xx"  = git commit -am "xx"