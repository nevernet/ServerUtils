cd ~
git clone --depth=1 https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
# for linux
env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 2.7.13
#for mac osx
#env PYTHON_CONFIGURE_OPTS="--enable-framework"

# pyenv install 2.7.13
pyenv global 2.7.13
python -V

# install library
```
pip install torndb tornado  requests supervisor pymongo redis thrift pynsq arrow python-memcached
```

# 安装msyql
# 注意，需要先安装mysql client，请参考mysql_5.7.21.sh里面的安装方式1
```
pip install MySQL-python
```