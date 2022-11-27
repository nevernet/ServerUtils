# 非 windows 

```
export https_proxy=http://127.0.0.1:7890 
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

source ~/.zshrc

nvm install v16.15.1
nvm install v14.19.3

nvm alias default v16.15.1 # 默认第一个下载也会设置 default

nvm use v16.15.1
nvm use v14.19.3
```

# windows 系统

下载 nvm.exe 安装即可

