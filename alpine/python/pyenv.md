# 安装 pyenv

## 更新

```
apk update
```

## 依赖

# 安装工具

```
apk add gcc make g++ sqlite-dev bzip2-dev openssl openssl-dev readline-dev zlib-dev libressl rsync
```

## 安装 pyenv

```
cd ~
git clone --depth=1 https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
```

> 如果是  用的是 zsh, 则需要修改.bash_profile 为.zshrc

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
pyenv install 2.7.18
pyenv install 3.9.1
```

设置全局的版本:

```
pyenv global 3.9.1
python -V
```

临时设置本次 shell 环境

```
pyenv shell 3.9.1
```

# 安装 python 常用的库， install library

```
pip install torndb tornado  requests supervisor pymongo redis thrift pynsq arrow python-memcached
```

# 安装 MySQL

> 注意，需要先安装 MySQL Client，请参考 [mysql_5.7.21.sh](../mysql_5.7.21.sh) 里面的安装方式 1

```
apk del openssl-dev
apk add libressl-dev mariadb-dev gcc musl-dev
pip install mysql-python
```

# 升级 pyenv

```
cd ~/.pyenv
git pull
```

# supervisor

```
mkdir -p /var/log/supervisord
cp supervisord.conf /etc/supervisord.conf # 复制supervisord.conf
/root/.pyenv/shims/supervisord -c /etc/supervisord.conf
```
