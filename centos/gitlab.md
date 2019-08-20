# install

```
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
```

# configure

`gitlab-ctl reconfigure`

```
# 如果碰到卡在:ruby_block[supervise_redis_sleep] action run
# 则执行：/opt/gitlab/embedded/bin/runsvdir-start &
# 再执行: gitlab-ctl reconfigure
# docker 启动的时候，需要添加： /opt/gitlab/embedded/bin/runsvdir-start &

# 具体配置请参考:
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md
```

# 创建 SSL 目录

`mkdir /etc/gitlab/ssl`

# 修改配置文件

```
vim /etc/gitlab/gitlab.rb
external_url "https://git.example.com/"
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/1_git.xlab.la_bundle.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/2_git.xlab.la.key"
```

# 重新配置

`gitlab-ctl reconfigure`

# 重启 nginx

```
gitlab-ctl restart nginx
gitlab-ctl restart unicorn
```

升级 gitlab 参考：https://about.gitlab.com/update/#centos-6

centos 下升级

-   1. Make a backup (Optional)
-   2. If you would like to make a backup before updating, the below command will backup data in `/var/opt/gitlab/backups` by default.

`gitlab-rake gitlab:backup:create STRATEGY=copy`

# 2. Update GitLab

> Update to the latest version of GitLab.

`yum install -y gitlab-ce`

> 升级过程需要根据大版本来。 不能跨越大版本
> https://docs.gitlab.com/ee/policy/maintenance.html#upgrade-recommendations

> 如果需要升级到当前大版本的最新版本，则可以通过 `https://packages.gitlab.com/gitlab/gitlab-ce` 来查找对应的版本号。

# 修改源。 原始的 gitlab.com 的源下载很慢

`vim /etc/yum.repos.d/gitlab-ce.repo`

# 修改 baseurl 为下面地址：

`https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el$releasever/`

如果找不到 respond.xml.asc 则需要修改 repo_gpgcheck=0

# gitlab 基础操作

```
gitlab-ctl status
gitlab-ctl restart
gitlab-ctl tail # 可以一直查看所有的错误信息
```

# gem 更新用清华的

```
# 添加 TUNA 源并移除默认源
gem sources --add https://mirrors.tuna.tsinghua.edu.cn/rubygems/ --remove https://rubygems.org/
# 列出已有源
gem sources -l
# 应该只有 TUNA 一个
```

> 参考： https://mirror.tuna.tsinghua.edu.cn/help/rubygems/

# 错误信息

错误信息一直提示 error adding listener addr=/var/opt/gitlab/gitlab-rails/sockets/gitlab.socket

解决办法:

```
gitlab-ctl stop
# 进入 /var/opt/gitlab/gitlab-rails/sockets/
# 删除原来的gitlab.socket文件
# 重启：
gitlab-ctl start
```
