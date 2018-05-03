# install
#yum install -y ruby rubygmes
yum groupinstall -y "Development tools"
yum install -y openssl openssl-devel zlib zlib-devel
wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.gz
tar zxf ruby-2.4.1.tar.gz
cd ruby-2.4.1
./configure
make && make install
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

yum install -y curl openssh-server openssh-clients postfix cronie
service postfix start # docker 启动的时候需要添加：service postfix start
chkconfig postfix on
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
yum install -y gitlab-ce

# configure
gitlab-ctl reconfigure

# 如果碰到卡在:ruby_block[supervise_redis_sleep] action run
# 则执行：/opt/gitlab/embedded/bin/runsvdir-start &
# 再执行: gitlab-ctl reconfigure
# docker 启动的时候，需要添加： /opt/gitlab/embedded/bin/runsvdir-start &

# 具体配置请参考:
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md

# 创建SSL目录
mkdir /etc/gitlab/ssl

# 修改配置文件
vim /etc/gitlab/gitlab.rb
external_url "https://git.example.com/"
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/1_git.xlab.la_bundle.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/2_git.xlab.la.key"

# 重新配置
gitlab-ctl reconfigure

# 重启nginx
gitlab-ctl restart nginx


# 升级gitlab 参考：https://about.gitlab.com/update/#centos-6

# centos 下升级
# 1. Make a backup (Optional)
# If you would like to make a backup before updating, the below command will backup data in `/var/opt/gitlab/backups` by default.

gitlab-rake gitlab:backup:create STRATEGY=copy

# 2. Update GitLab
# Update to the latest version of GitLab.

yum install -y gitlab-ce
