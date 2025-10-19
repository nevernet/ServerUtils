# 手动安装 Node.js 20

## 方法1: 使用 apk 添加 Node.js 官方仓库

```bash
# 添加 Node.js 官方仓库密钥
wget -qO- https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub | tee /etc/apk/keys/sgerrand.rsa.pub

# 添加 Node.js 20 仓库
echo 'https://alpine-pkgs.sgerrand.com/alpine/v3.16/main' >> /etc/apk/repositories

# 安装 Node.js 20 和 npm
apk update
apk add nodejs-current npm

# 验证安装
node --version
npm --version
```

## 方法2: 直接下载二进制文件

```bash
# 下载 Node.js 20.x 的 Alpine Linux 二进制文件
NODE_VERSION=20.18.0
wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz

# 解压到 /usr/local
tar -xf node-v${NODE_VERSION}-linux-x64.tar.xz
mv node-v${NODE_VERSION}-linux-x64 /usr/local/nodejs

# 添加到 PATH
export PATH=/usr/local/nodejs/bin:$PATH

# 或者添加到系统环境变量
echo 'export PATH=/usr/local/nodejs/bin:$PATH' >> /etc/profile

# 验证安装
node --version
npm --version
```

## 方法3: 使用 nvm 安装

```bash
# 安装依赖
apk add curl bash git

# 下载并安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm@v0.39.0/install.sh | bash
curl -o- https://gitee.com/mirrors/nvm/raw/v0.39.0/install.sh | bash

# 重新加载环境
source ~/.bashrc

# 安装 Node.js 20
nvm install 20
nvm use 20

# 验证安装
node --version
npm --version
```

## 解决 puppeteer 等包的依赖问题

对于需要额外系统依赖的包（如 puppeteer），需要安装对应的 Alpine 包：

```bash
# 安装 Chromium 和相关依赖（puppeteer 需要）
apk add chromium nss freetype harfbuzz ttf-freefont

# 设置 puppeteer 使用的 Chromium 路径
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
```

## 常用 Alpine 依赖包

```bash
# 基础开发依赖
apk add python3 make g++ git curl

# 常用工具
apk add vim nano htop

# 网络工具
apk add wget curl
```

> 注意：Alpine Linux 是基于 musl libc 的，与 glibc 不同。有些 Node.js 包可能需要特定的构建配置或系统依赖。遇到问题时，建议查看官方文档或社区解决方案。
