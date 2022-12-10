# 依赖参见具体的 os


## 安装 pyenv

```
cd ~
git clone --depth=1 https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/shims:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc

```

macos下安装：
```
cd ~
git clone --depth=1 https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/shims:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc
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
pyenv install 2.7.18
pyenv install 3.10.9

-- 如果下载不了，用这个方式，从淘宝镜像下载
export v=3.10.9; \
export PYTHON_BUILD_CACHE_PATH="$PYENV_ROOT/cache"; \
wget https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz -P $PYENV_ROOT/cache/; \
pyenv install $v

```

如果下载不了，还可以直接修改pyenv安装文件

```
cd /root/.pyenv/plugins/python-build/share/python-build
cat 3.10.9

# 修改下载地址如下：
prefer_openssl11
export PYTHON_BUILD_CONFIGURE_WITH_OPENSSL=1
install_package "openssl-1.1.1n" "https://www.openssl.org/source/openssl-1.1.1n.tar.gz#40dceb51a4f6a5275bde0e6bf20ef4b91bfc32ed57c0552e2e8e15463372b17a" mac_openssl --if has_broken_mac_openssl
install_package "readline-8.1" "https://ftpmirror.gnu.org/readline/readline-8.1.tar.gz#f8ceb4ee131e3232226a17f51b164afc46cd0b9e6cef344be87c65962cb82b02" mac_readline --if has_broken_mac_readline
if has_tar_xz_support; then
  install_package "Python-3.9.13" "https://npm.taobao.org/mirrors/python/3.9.13/Python-3.9.13.tar.xz#125b0c598f1e15d2aa65406e83f792df7d171cdf38c16803b149994316a3080f" standard verify_py39 copy_python_gdb ensurepip
else
  install_package "Python-3.9.13" "https://npm.taobao.org/mirrors/python/3.9.13/Python-3.9.13.tgz#829b0d26072a44689a6b0810f5b4a3933ee2a0b8a4bfc99d7c5893ffd4f97c44" standard verify_py39 copy_python_gdb ensurepip
fi
```

下载地址还可以直接指定为本地路径
```
prefer_openssl11
export PYTHON_BUILD_CONFIGURE_WITH_OPENSSL=1
install_package "openssl-1.1.1n" "https://www.openssl.org/source/openssl-1.1.1n.tar.gz#40dceb51a4f6a5275bde0e6bf20ef4b91bfc32ed57c0552e2e8e15463372b17a" mac_openssl --if has_broken_mac_openssl
install_package "readline-8.1" "https://ftpmirror.gnu.org/readline/readline-8.1.tar.gz#f8ceb4ee131e3232226a17f51b164afc46cd0b9e6cef344be87c65962cb82b02" mac_readline --if has_broken_mac_readline
if has_tar_xz_support; then
  install_package "Python-3.9.13" "/root/.pyenv/cache/Python-3.9.13.tar.xz" standard verify_py39 copy_python_gdb ensurepip
else
  install_package "Python-3.9.13" "/root/.pyenv/cache/Python-3.9.13.tgz" standard verify_py39 copy_python_gdb ensurepip
fi
```

设置全局的版本:

```
pyenv global 3.10.9
python -V
```

临时设置本次 shell 环境

```
pyenv shell 3.10.9
```

# 安装 python 常用的库， install library

```
pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com torndb tornado  requests supervisor pymongo redis thrift pynsq arrow python-memcached  mysqlclient pysqlite3 django SQLAlchemy

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
mkdir -p /var/run
mkdir -p /var/log/supervisord
mkdir -p /opt/logs/supervisord

cp supervisord.conf /etc/supervisord.conf # 复制supervisord.conf
/root/.pyenv/shims/supervisord -c /etc/supervisord.conf
```
