> 主要 shaodowsocks manager 目前仅仅支持 python 和 libuv 版本

# 安装 nodejs

下载 Linux 编译好的二进制文件
wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz
tar xf node-v8.11.3-linux-x64.tar.xz
mv node-v8.11.3-linux-x64.tar.xz /usr/local/nodejs

# 修改.bash_profile

PATH=$PATH:/usr/local/nodejs/bin

# 测试

node -v
npm -v

# 安装 shadowsocks manager

npm install sqlite3 --save --unsafe-perm

git clone https://github.com/shadowsocks/shadowsocks-manager.git
cd shadowsocks-manager
npm i

# 启动

node server.js
