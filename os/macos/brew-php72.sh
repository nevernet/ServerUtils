```
brew tap shivammathur/php
brew update
brew install shivammathur/php/php@7.2
brew install shivammathur/php/php@7.4
```

安装路径在：
```
/opt/homebrew/etc/php/7.2/
echo 'export PATH="/opt/homebrew/opt/php@7.2/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/opt/php@7.2/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc

for compilers
export LDFLAGS="-L/opt/homebrew/opt/php@7.2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@7.2/include"
```

php 7.4 路径
```
/opt/homebrew/etc/php/7.4/
/opt/homebrew/opt/php@7.4/bin/php
```