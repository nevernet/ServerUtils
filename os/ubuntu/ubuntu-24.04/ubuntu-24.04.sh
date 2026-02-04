#!/usr/bin/env bash

# 修改镜像
cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
sed -i  "s/archive\.ubuntu\.com/mirrors.tencentyun.com/g" /etc/apt/sources.list.d/ubuntu.sources
sed -i  "s/security\.ubuntu\.com/mirrors.tencentyun.com/g" /etc/apt/sources.list.d/ubuntu.sources
# sed -i  "s/archive\.ubuntu\.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list.d/ubuntu.sources
# sed -i  "s/security\.ubuntu\.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list.d/ubuntu.sources

apt-get update
apt-get upgrade -y

# 安装网络软件
apt-get install -y net-tools iputils-ping telnet wget curl
# 安装ssh
apt-get install -y openssh-server openssh-client
# 安装时间同步软件
apt-get install -y tzdata ntpdate
# 安装vim
apt-get install -y vim
# 安装 cron
apt-get install -y cron

# 基础配置
echo 'll="ls -alh"' >> ~/.bashrc
source ~/.bashrc

# 配置ssh
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes # 根据实际情况开启root登录" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
service ssh restart
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N '' -q <<<y > /dev/null 2>&1


# 时区配置
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 交大时间服务器
ntpdate ntp.sjtu.edu.cn

# vim 配置
echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> ~/.vimrc
echo "set termencoding=utf-8" >> ~/.vimrc
echo "set encoding=utf-8" >> ~/.vimrc
echo "set nu" >> ~/.vimrc

# 安装 pyenv
apt-get install -y git
cd ~
# git clone --depth=1 https://github.com/yyuu/pyenv.git ~/.pyenv
git clone --depth 1 https://gitee.com/mirrors/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/shims:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'export PYTHON_BUILD_MIRROR_URL="https://registry.npmmirror.com/-/binary/python"' >> ~/.bashrc
source ~/.bashrc

sudo apt-get install -y libffi-dev python3-dev default-libmysqlclient-dev build-essential libsqlite3-dev sqlite3 libbz2-dev libncurses-dev libreadline-dev lzma-dev make  libssl-dev zlib1g-dev llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev  liblzma-dev git

# 列出所有可以安装的版本
pyenv install --list
pyenv install 3.13.11
pyenv global 3.13.11
pyenv version
python -V

# 安装 pip 镜像源配置
mkdir -p ~/.pip
echo "[global]" > ~/.pip/pip.conf
echo "index-url = https://mirrors.tencentyun.com/pypi/simple/" >> ~/.pip/pip.conf
echo "trusted-host = mirrors.tencentyun.com" >> ~/.pip/pip.conf
# 安装 常用的python库
pip install torndb tornado  requests supervisor pymongo redis thrift pynsq arrow python-memcached pysqlite3 django SQLAlchemy


# 安装nvm 和 nodejs
wget -qO- https://gitlab.com/mirrorx/nvm/-/raw/master/install.sh | bash
source ~/.bashrc
nvm install 22
nvm alias default 22
node -v
# 设置 npm 镜像源
npm config set registry https://registry.npmmirror.com

# 配置shell crash
apt install -y iproute2 nftables
bash <(curl -fsSL https://raw.githubusercontent.com/juewuy/ShellCrash/dev/install.sh)
source ~/.bashrc
# 默认安装名字：crash，运行即可配置