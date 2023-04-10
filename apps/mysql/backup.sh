#!/bin/bash
#存放目录
BackupDir=/root/mysqlbackup
#数据库库名
DataBaseName=dbname
#日期命名
DateTag=`date +%Y%m%d`
#sql脚本名字
sqltag=$DataBaseName'_'$DateTag'.'sql
#压缩文件名字
tartag=$sqltag'.'tar'.'gz
#备份
mysqldump -h localhost -u'dbname' -p'dbpwd' --opt --set-gtid-purged=OFF --column-statistics=0 --databases $DataBaseName > $BackupDir/$sqltag
#进行压缩并删除原文件
cd $BackupDir
echo "current Dir:"
pwd

tar -czf  $tartag $sqltag
rm -rf $sqltag
#定时清除文件，以访长期堆积占用磁盘空间(删除5天以前带有tar.gz文件)
find . -mtime +5 -name '*.tar.gz' -type f | xargs rm -f