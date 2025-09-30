# PostgreSQL Dockerfile
# 基于自定义 Alpine Linux 镜像

FROM alpine:3.19

# 安装 PostgreSQL 和相关工具
RUN apk add --no-cache \
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
    timescaledb \
    && rm -rf /var/cache/apk/*

# 确保 postgres 用户存在
RUN id -u postgres &>/dev/null || adduser -D -s /bin/sh postgres

# 创建必要目录
RUN mkdir -p /var/lib/postgresql/data \
    && mkdir -p /opt/logs/postgresql \
    && mkdir -p /run/postgresql \
    && chown -R postgres:postgres /var/lib/postgresql \
    && chown postgres:postgres /opt/logs/postgresql \
    && chown postgres:postgres /run/postgresql \
    && chmod 755 /opt/logs/postgresql \
    && chmod 755 /run/postgresql

# 创建配置目录
RUN mkdir -p /etc/postgresql && chown postgres:postgres /etc/postgresql

# 复制所有配置文件到容器
COPY conf/postgresql-master.conf /etc/postgresql/postgresql-master.conf
COPY conf/postgresql-slave.conf /etc/postgresql/postgresql-slave.conf
COPY conf/pg_hba-master.conf /etc/postgresql/pg_hba-master.conf
COPY conf/pg_hba-slave.conf /etc/postgresql/pg_hba-slave.conf
COPY conf/recovery.conf /etc/postgresql/recovery.conf

# 复制 init.sh 文件并设置权限
COPY init.sh /root/init.sh
RUN chmod +x /root/init.sh

# 切换到 postgres 用户
USER postgres

# 初始化数据库
RUN initdb -D /var/lib/postgresql/data

# 复制配置文件到数据目录（按照 install-postgresql.sh 的逻辑）
RUN cp /etc/postgresql/postgresql-master.conf /var/lib/postgresql/data/postgresql.conf
RUN cp /etc/postgresql/pg_hba-master.conf /var/lib/postgresql/data/pg_hba.conf

# 设置配置文件权限
RUN chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
RUN chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf
RUN chmod 600 /var/lib/postgresql/data/postgresql.conf
RUN chmod 600 /var/lib/postgresql/data/pg_hba.conf

# 启动PostgreSQL并启用扩展
RUN pg_ctl -D /var/lib/postgresql/data start -w && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis;" && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;" && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;" && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;" && \
    psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS timescaledb;" && \
    pg_ctl -D /var/lib/postgresql/data stop

# 使用 tini 作为 init 进程
USER root
ENTRYPOINT ["/sbin/tini", "--", "/root/init.sh"]