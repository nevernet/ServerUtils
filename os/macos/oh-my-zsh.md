# oh-my-zsh 安装

## 安装 zsh，并设置 zsh 为默认 shell

```
brew install zsh
sudo chsh -s /bin/zsh
```

## 下载 oh-my-zsh

镜像更新不及时。。。，还是走官方
```
cd ~
curl -O https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
```

打开 `vim install.sh`， 找到：

```
# Default settings
ZSH=${ZSH:-~/.oh-my-zsh}
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}
```

把

```
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
```

修改成：

```
REPO=${REPO:-mirrors/oh-my-zsh}
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}
```

```
chmod +x install.sh
```

保存后， 然后执行 `./install.sh`

## 配置未来的更新

```
cd ~/.oh-my-zsh
git remote set-url origin https://gitee.com/mirrors/oh-my-zsh.git
git pull
```
