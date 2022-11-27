# centos 6已经停止维护

1. 需要修改centos6为vault源，也可以直接用腾讯云的vault源
2. 修改gitlab-ce的源为： 
```
[gitlab_gitlab-ce]
name=gitlab_gitlab-ce
baseurl=https://packages.gitlab.com/gitlab/gitlab-ce/el/6/$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
gpgkey=https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey
       https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey/gitlab-gitlab-ce-3D645A26AB9FBD22.pub.gpg
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[gitlab_gitlab-ce-source]
name=gitlab_gitlab-ce-source
baseurl=https://packages.gitlab.com/gitlab/gitlab-ce/el/6/SRPMS
repo_gpgcheck=1
gpgcheck=1
enabled=1
gpgkey=https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey
       https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey/gitlab-gitlab-ce-3D645A26AB9FBD22.pub.gpg
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
```

然后执行： 
```
sudo yum -q makecache -y --disablerepo='*' --enablerepo='gitlab_gitlab-ce'
```


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
nginx['ssl_certificate'] = "/etc/gitlab/ssl/1_git.example.com_bundle.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/2_git.example.com.key"
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

- 1. Make a backup (Optional)
- 2. If you would like to make a backup before updating, the below command will backup data in `/var/opt/gitlab/backups` by default.

`gitlab-rake gitlab:backup:create STRATEGY=copy`

一定要根据 `https://docs.gitlab.com/ee/update/` 这里的版本一步一步来

```
8.11.Z -> 8.12.0 -> 8.17.7 -> 9.5.10 -> 10.8.7 -> 11.11.8 -> 12.0.12 -> 12.1.17 -> 12.10.14 -> 13.0.14 -> 13.1.11 -> 13.8.8 -> 13.12.15 -> 14.0.12 -> 14.9.0 -> 14.10.Z -> 15.0.Z -> latest 15.Y.Z
```

# 2. Update GitLab

> Update to the latest version of GitLab.

`yum upgrade -y gitlab-ce`

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

# 如果碰到提示 postgrsql 版本不一致，则重启一下：

```
gitlab-ctl restart postgresql
```

# gitlab 默认需要 4 核 8G 以上的配置，如果是共享的机器，则需要调整配置，以避免 gitlab 占用过多的内存和 cpu 资源

```bash
sidekiq['concurrency'] = 16 # 默认25， 改成16并发

unicorn['worker_processes'] = 5 # 内核数+1。按照我这个配置，默认耗费内存最小 5*50M = 250M, 最大5*300M=1500M(1.5G)
# 单个进程从最小的50M，到最大300M。 默认是200M到600M
unicorn['worker_memory_limit_min'] = "50 * 1 << 20"
unicorn['worker_memory_limit_max'] = "300 * 1 << 20"

# pg
postgresql['shared_buffers'] = "256MB"

```

备份：

```
2.1 备份文件
gitlab-rake gitlab:backup:create
备份文件会在目录/var/opt/gitlab/backups里面

2.2 复制到新的服务器
通过scp命令复制备份的文件到目标服务器

cd /var/opt/gitlab/backups/
scp root@xxx.xx.xx.xx:/var/opt/gitlab/backups/1613634657_2020_02_18_13.8.4_gitlab_backup.tar ./   #xxx.xxx.xxx.xx为旧服务器ip地址，然后输入你的密码就可以
2.3 新服务器恢复
首先设置权限，避免权限问题失败

chmod 777 1613634657_2020_02_18_13.8.4_gitlab_backup.tar
停止数据连接服务

gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq
文件恢复

gitlab-rake gitlab:backup:restore BACKUP=备份文件编号
备份文件编号规则为，比如我上面的文件1613634657_2020_02_18_13.8.4_gitlab_backup.tar 文件编号就是1613634657_2020_02_18_13.8.4

2.4 重启GITLAB
gitlab-ctl start
查看数据。
```