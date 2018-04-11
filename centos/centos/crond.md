yum install cronie


判定是否启动：
service crond restart

检查是否自动启动：
chkconfig —list crond
设置成自动启动：
chkconfig crond on

查看当前任务：
crontab -l

添加任务：
vim /etc/crontab
或者
crontab -e

