# 安装 pyenv

## 依赖

```
# for centos
yum install -y gcc make sqlite3 sqlite-devel bzip2 bzip2-devel openssl openssl-devel readline readline-devel zlib zlib-devel
```

## 安装 pyenv

```
cd ~
git clone --depth=1 https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
```

> 如果是用的是 zsh, 则需要修改.bash_profile 为.zshrc

For Linux/Centos etc， 安装 python 之前

```
env PYTHON_CONFIGURE_OPTS="--enable-shared"
```

For mac osx

```
env PYTHON_CONFIGURE_OPTS="--enable-framework"
```

# 安装 python

可以通过 `pyenv install --list` 来查看有哪些提供的版本

```
pyenv install 2.7.15
```

设置全局的版本:

```
pyenv global 2.7.15
python -V
```

临时设置本次 shell 环境

```
pyenv shell 2.7.13
```

# 安装 python 常用的库， install library

```
pip install torndb tornado  requests supervisor pymongo redis thrift pynsq arrow python-memcached
```

# 安装 MySQL

> 注意，需要先安装 MySQL Client，请参考 [mysql_5.7.21.sh](../mysql_5.7.21.sh) 里面的安装方式 1

```
pip install MySQL-python
```

# 升级 pyenv

```
cd ~/.pyenv
git pull
```
