# 非 windows

## 安装方式

### 方式1：使用代理（原有方式）
```
export https_proxy=http://127.0.0.1:7890
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
```

### 方式2：使用国内镜像（推荐）

#### GitLab 镜像（推荐）
```bash
export NVM_SOURCE=https://gitlab.com/mirrorx/nvm.git
curl -o- https://gitlab.com/mirrorx/nvm/-/raw/master/install.sh | bash
```

或使用 wget：
```bash
export NVM_SOURCE=https://gitlab.com/mirrorx/nvm.git
wget -qO- https://gitlab.com/mirrorx/nvm/-/raw/master/install.sh | bash
```

#### jsDelivr CDN 镜像
```bash
curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm@v0.39.2/install.sh | bash
```

#### Gitee 镜像
```bash
git clone https://gitee.com/github-mirror-repos/nvm.git ~/.nvm
cd ~/.nvm
git checkout v0.39.2
```

source ~/.zshrc

## 配置 Node.js 和 npm 下载镜像（加速下载）

编辑 `~/.zshrc` 或 `~/.bashrc`，添加：
```bash
# Node.js 镜像（阿里云）
export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node

# npm 下载镜像（阿里云）- 用于 nvm 安装 npm 时
export NVM_NPM_MIRROR=https://npmmirror.com/mirrors/npm
```

然后执行：
```bash
source ~/.zshrc
```

## 配置 npm registry 镜像（npm 包下载加速）

安装 Node.js 后，配置 npm 包下载镜像：

### 方式1：使用 npm 命令配置（推荐）
```bash
# 设置阿里云镜像
npm config set registry https://registry.npmmirror.com

# 查看当前镜像
npm config get registry

# 恢复官方镜像
npm config set registry https://registry.npmjs.org
```

### 方式2：使用 cnpm（淘宝镜像）
```bash
# 安装 cnpm
npm install -g cnpm --registry=https://registry.npmmirror.com

# 使用 cnpm 代替 npm
cnpm install [package-name]
```

### 方式3：临时使用镜像
```bash
# 单次安装使用镜像
npm install [package-name] --registry=https://registry.npmmirror.com
```

### 常用国内镜像源
- **阿里云（推荐）**：`https://registry.npmmirror.com`
- **腾讯云**：`https://mirrors.cloud.tencent.com/npm/`
- **华为云**：`https://repo.huaweicloud.com/repository/npm/`
- **淘宝**：`https://registry.npmmirror.com`（已迁移到阿里云）

## 使用 nvm

```bash
nvm install v14.21.1
nvm install v16.18.1

nvm alias default v14.21.1 # 默认第一个下载也会设置 default

nvm use v16.18.1
nvm use v14.21.1
```

# windows 系统

下载 nvm.exe 安装即可

