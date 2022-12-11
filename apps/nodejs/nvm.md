# 非 windows

```
export https_proxy=http://127.0.0.1:7890
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

source ~/.zshrc

nvm install v14.21.1
nvm install v16.18.1

nvm alias default v14.21.1 # 默认第一个下载也会设置 default

nvm use v16.18.1
nvm use v14.21.1
```

# windows 系统

下载 nvm.exe 安装即可

