# PostgreSQL Dockerfile
# 基于 Alpine Linux 3.18

FROM alpine:3.18

# 安装 PostgreSQL 和相关工具
RUN apk add --no-cache \
    postgresql \
    postgresql-contrib \
    postgresql-client \
    bash \
    coreutils \
    postgresql-dev \
    gcc \
    musl-dev \
    make \
    && rm -rf /var/cache/apk/*

# 创建 postgres 用户
RUN adduser -D -s /bin/sh postgres

# 创建必要目录
RUN mkdir -p /var/lib/postgresql/data \
    && mkdir -p /opt/logs/postgresql \
    && chown -R postgres:postgres /var/lib/postgresql \
    && chown postgres:postgres /opt/logs/postgresql \
    && chmod 755 /opt/logs/postgresql

# 复制所有配置文件到容器
COPY conf/postgresql-master.conf /etc/postgresql/postgresql-master.conf
COPY conf/postgresql-slave.conf /etc/postgresql/postgresql-slave.conf
COPY conf/pg_hba-master.conf /etc/postgresql/pg_hba-master.conf
COPY conf/pg_hba-slave.conf /etc/postgresql/pg_hba-slave.conf
COPY conf/recovery.conf /etc/postgresql/recovery.conf

# 创建配置目录
RUN mkdir -p /etc/postgresql && chown postgres:postgres /etc/postgresql

# 安装 PostGIS 和 TimescaleDB
RUN apk add --no-cache \
    postgis \
    postgis-dev \
    geos \
    proj \
    gdal \
    && rm -rf /var/cache/apk/*

# 安装 TimescaleDB
RUN apk add --no-cache \
    timescaledb \
    && rm -rf /var/cache/apk/*

# 切换到 postgres 用户
USER postgres

# 初始化数据库
RUN initdb -D /var/lib/postgresql/data

# 复制默认配置文件（使用主服务器配置）
RUN cp /etc/postgresql/postgresql-master.conf /var/lib/postgresql/data/postgresql.conf
RUN cp /etc/postgresql/pg_hba-master.conf /var/lib/postgresql/data/pg_hba.conf

# 设置配置文件权限
RUN chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
RUN chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf
RUN chmod 600 /var/lib/postgresql/data/postgresql.conf
RUN chmod 600 /var/lib/postgresql/data/pg_hba.conf

# 修改 init.sh 文件，在 exec "$@" 之前添加 pg_ctl restart 命令
RUN sed -i '/^exec "$@"$/i pg_ctl -D /var/lib/postgresql/data restart' /root/init.sh

# 启动PostgreSQL并启用扩展
RUN pg_ctl -D /var/lib/postgresql/data start -w && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis;" && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS timescaledb;" && \
    pg_ctl -D /var/lib/postgresql/data stop

# 暴露端口
# EXPOSE 5432

# 使用 tini 作为 init 进程
ENTRYPOINT ["/sbin/tini", "--", "/root/init.sh"]
