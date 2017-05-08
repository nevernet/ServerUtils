wget https://cache.ruby-china.org/pub/ruby/ruby-2.4.1.tar.gz
tar zxf ruby-2.4.1.tar.gz
cd ruby-2.4.1
./configure
make && make install

# 禁止ssl verify
vim ~/.gemrc 添加： :ssl_verify_mode: 0

# 修改源
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem sources -l

gem update --system
gem install bundle rake

# 修改bundle源
bundle config mirror.https://rubygems.org https://gems.ruby-china.org
bundle install