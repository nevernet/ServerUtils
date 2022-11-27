> 主要 shaodowsocks manager 目前仅仅支持 python 和 libuv 版本

# 安装 nodejs

下载 Linux 编译好的二进制文件
wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz
tar xf node-v8.11.3-linux-x64.tar.xz
mv node-v8.11.3-linux-x64 /usr/local/nodejs

-   32 位

wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x86.tar.xz
tar xf node-v8.11.3-linux-x86.tar.xz
mv node-v8.11.3-linux-x86 /usr/local/nodejs

# 修改.bash_profile

PATH=$PATH:/usr/local/nodejs/bin

然后`source .bash_profile`

# 添加 env 环境

ln -sf /usr/local/nodejs/bin/node /usr/bin/node

# 测试

node -v
npm -v

# 安装 shadowsocks manager

git clone https://github.com/shadowsocks/shadowsocks-manager.git
cd shadowsocks-manager
npm i --unsafe-perm

# 配置

-   修改 ssserver 的启动
    在/etc/shadowsocks.json 里面增加`manager-address`

```
"manager-address": "127.0.0.1:6000"
```

具体参见 [shadowsocks.json](./shadowsocks.json)

ssmgr 是每台服务器都要配置的

-   添加 ssmgr.yml 的配置
    具体参见 [ssmgr.yml](./ssmgr.yml)

webgui 只需要一台配置即可

-   添加 webgui.yml 的配置
    具体参见 [webgui.yml](./webgui.yml)
