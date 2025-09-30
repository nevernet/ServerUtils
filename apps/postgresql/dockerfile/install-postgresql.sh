#!/bin/bash
# PostgreSQL 手动安装脚本
# 基于 Alpine Linux 环境

set -e

echo "=== PostgreSQL 手动安装脚本 ==="

# 1. 安装 PostgreSQL 和相关工具
echo "1. 安装 PostgreSQL 和相关工具..."
apk add --no-cache \
    postgresql \
    postgresql-contrib \
    postgresql-client \
    postgresql-dev \
    gcc \
    musl-dev \
    make \
    su-exec \
    postgis \
    geos \
    proj \
    gdal \
    libxml2 \
    json-c \
    protobuf-c \
    timescaledb

# 2. 确保 postgres 用户存在
echo "2. 确保 postgres 用户存在..."
id -u postgres &>/dev/null || adduser -D -s /bin/sh postgres

# 3. 创建必要目录
echo "3. 创建必要目录..."
mkdir -p /var/lib/postgresql/data \
    && mkdir -p /opt/logs/postgresql \
    && mkdir -p /run/postgresql \
    && chown -R postgres:postgres /var/lib/postgresql \
    && chown postgres:postgres /opt/logs/postgresql \
    && chown postgres:postgres /run/postgresql \
    && chmod 755 /opt/logs/postgresql \
    && chmod 755 /run/postgresql

# 4. 创建配置目录
echo "4. 创建配置目录..."
mkdir -p /etc/postgresql && chown postgres:postgres /etc/postgresql


# 5. 切换到 postgres 用户
su postgres

# 6. 切换到 postgres 用户并初始化数据库
echo "6. 初始化数据库..."
initdb -D /var/lib/postgresql/data

# 从外部手动复制配置文件


# 7. 设置配置文件权限
echo "7. 设置配置文件权限..."
cp /etc/postgresql/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp /etc/postgresql/pg_hba.conf  /var/lib/postgresql/data/pg_hba.conf
chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf
chmod 600 /var/lib/postgresql/data/postgresql.conf
chmod 600 /var/lib/postgresql/data/pg_hba.conf


# 8. 启动PostgreSQL并启用扩展
echo "10. 启动PostgreSQL并启用扩展..."
pg_ctl -D /var/lib/postgresql/data start -w

# 等待PostgreSQL完全启动
sleep 3

# 启用PostGIS和TimescaleDB扩展
echo "9. 启用PostgreSQL扩展..."
psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis;"
psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"
psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;"
psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;"
psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS timescaledb;"

# 停止PostgreSQL
echo "10. 停止PostgreSQL..."
pg_ctl -D /var/lib/postgresql/data stop

# 退出 postgres 用户
exit


# 13. 修改 init.sh 文件
echo "13. 修改 init.sh 文件..."
# 在 init.sh 文件的倒数第二行添加
# su-exec postgres pg_ctl -D /var/lib/postgresql/data restart
# 执行传入的命令
# exec "$@"

# 退出容器
exit

# commit 镜像
docker commit -a "Daniel Qin" -m "PostgreSQL 16" 03f6801fc2b6 docker.private.repo/postgresql:16

echo "=== PostgreSQL 安装完成 ==="
echo "现在可以测试启动："
docker run -it docker.private.repo/postgresql:16 /bin/bash
docker run -d docker.private.repo/postgresql:16
