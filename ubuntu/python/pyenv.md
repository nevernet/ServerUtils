# 安装 pyenv

## 依赖

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
pyenv shell 2.9.5
```

# 安装 python 常用的库， install library

```
pip install tornado requests supervisor pymongo redis arrow python-memcached mysqlclient pynsq pysqlite3 django SQLAlchemy
```

# 升级 pyenv

```
cd ~/.pyenv
git pull
```
