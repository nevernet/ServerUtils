# install
#yum install -y ruby rubygmes
yum groupinstall -y "Development tools"
wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.0.tar.gz
tar zxf ruby-2.4.0.tar.gz
cd ruby-2.4.0
./configure
make && make install
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

yum install -y curl openssh-server openssh-clients postfix cronie
service postfix start
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
yum install gitlab-ce -y

# configure
gitlab-ctl reconfigure

# 如果碰到卡在:ruby_block[supervise_redis_sleep] action run
# 则执行：/opt/gitlab/embedded/bin/runsvdir-start &
# 再执行: gitlab-ctl reconfigure

# 具体配置请参考:
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md