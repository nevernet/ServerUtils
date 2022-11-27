yum install -y vsftpd pam_mysql
yum install -y db4 db4-utils

/etc/init.d/vsftpd start
chkconfig vsftpd on

groupadd vsftpd
useradd -G vsftpd -s /bin/false -d /home/vsftpd vsftpd

# 修改
vim /etc/vsftpd/vsftpd.conf
nopriv_user=vsftpd
list_port=40021

#创建用户密码文本，注意奇行是用户名，偶行是密码
vi /etc/vsftpd/vuser_passwd.txt

test
123456

#生成虚拟用户认证的db文件
db_load -T -t hash -f /etc/vsftpd/vuser_passwd.txt /etc/vsftpd/vuser_passwd.db

#编辑认证文件，全部注释掉原来语句，再增加以下两句
vi /etc/pam.d/vsftpd

auth required pam_userdb.so db=/etc/vsftpd/vuser_passwd
account required pam_userdb.so db=/etc/vsftpd/vuser_passwd

#创建虚拟用户配置文件
mkdir /etc/vsftpd/vuser_conf/
#文件名等于vuser_passwd.txt里面的账户名，否则下面设置无效
vi /etc/vsftpd/vuser_conf/test

#虚拟用户根目录,根据实际情况修改
local_root=/ftpdata/public
write_enable=YES
guest_enable=YES
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES

#最新的vsftpd要求对主目录不能有写的权限所以ftp为755，主目录下面的子目录再设置777权限
mkdir /ftpdata/public
chmod -R 755 /ftpdata
chmod -R 777 /ftpdata/public

#建立限制用户访问目录的空文件
touch /etc/vsftpd/chroot_list

#如果启用vsftpd日志需手动建立日志文件
touch /var/log/xferlog
touch /var/log/vsftpd.log


#打开/etc/vsftpd/vsftpd.conf，在末尾添加

#开启PASV模式
pasv_enable=YES
#最小端口号
pasv_min_port=40000
#最大端口号
pasv_max_port=40080
pasv_promiscuous=YES
pasv_address=<外网ip地址> # 如果ftp服务器在防火墙后面需要这个配置

# reference: https://wsgzao.github.io/post/vsftpd/