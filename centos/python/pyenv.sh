cd ~
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
# for linux
env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.5.0
#for mac osx
#env PYTHON_CONFIGURE_OPTS="--enable-framework"

pyenv install 2.7.13
pyenv global 2.7.13
python -V
