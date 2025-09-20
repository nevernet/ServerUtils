#!/bin/bash
set -e

# PostgreSQL 从服务器启动脚本

echo "Starting PostgreSQL Slave Server..."

# 等待主服务器启动
echo "Waiting for master server to be ready..."
sleep 10

# 检查主服务器是否可用
while ! pg_isready -h postgresql-master -p 5432 -U replicator; do
    echo "Waiting for master server..."
    sleep 2
done

echo "Master server is ready, creating base backup..."

# 从主服务器创建基础备份
pg_basebackup -h postgresql-master -D /var/lib/postgresql/data -U replicator -v -P -W

echo "Base backup completed, configuring slave..."

# 复制配置文件
cp /postgresql-slave.conf /var/lib/postgresql/data/postgresql.conf
cp /pg_hba-slave.conf /var/lib/postgresql/data/pg_hba.conf
cp /recovery.conf /var/lib/postgresql/data/recovery.conf

# 修改 recovery.conf 中的主服务器地址
sed -i 's/host=postgresql-master/host=postgresql-master/g' /var/lib/postgresql/data/recovery.conf

# 设置权限
chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf
chown postgres:postgres /var/lib/postgresql/data/recovery.conf
chmod 600 /var/lib/postgresql/data/postgresql.conf
chmod 600 /var/lib/postgresql/data/pg_hba.conf
chmod 600 /var/lib/postgresql/data/recovery.conf

echo "Starting PostgreSQL slave server..."

# 启动 PostgreSQL
exec postgres -D /var/lib/postgresql/data
