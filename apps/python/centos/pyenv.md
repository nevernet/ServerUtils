# 安装 pyenv

## 依赖

```
# for centos
yum install -y gcc make sqlite3 sqlite-devel mysql-devel bzip2 bzip2-devel openssl openssl-devel readline readline-devel zlib zlib-devel libffi-devel python-devel python3-devel
```

```
# for ubuntu
sudo apt-get install -y libffi-dev python3-dev default-libmysqlclient-dev build-essential libsqlite3-dev sqlite3
```

## 安装 pyenv

```
cd ~
git clone --depth=1 https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init --path)"' >> ~/.bash_profile
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
pyenv install 2.7.16
pyenv install 3.7.4
pyenv install 3.9.5
```

设置全局的版本:

```
pyenv global 3.9.5
python -V
```

同时设置 py2 和 py3

```
pyenv global 3.9.5 2.7.15
python -V
python2 -V

```

临时设置本次 shell 环境

```
pyenv shell 2.7.13
```

# 安装 python 常用的库， install library

```
pip install tornado requests supervisor pymongo redis arrow python-memcached mysqlclient pynsq pysqlite3 django SQLAlchemy
```

# 安装 MySQL

> 注意，需要先安装 MySQL Client，请参考 [mysql_5.7.21.sh](../mysql_5.7.21.sh) 里面的安装方式 1

注意：此包太老了， 只支持 MySQL 5.x 和 Python 2

```
pip install MySQL-python
```

# 升级 pyenv

```
cd ~/.pyenv
git pull
```
