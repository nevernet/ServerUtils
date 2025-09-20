# PostgreSQL 单机版 Dockerfile
# 基于 Alpine Linux 3.18

FROM alpine:3.18

# 安装 PostgreSQL 和相关工具
RUN apk add --no-cache \
    postgresql \
    postgresql-contrib \
    postgresql-client \
    bash \
    && rm -rf /var/cache/apk/*

# 创建 postgres 用户
RUN adduser -D -s /bin/sh postgres

# 创建必要目录
RUN mkdir -p /var/lib/postgresql/data \
    && chown -R postgres:postgres /var/lib/postgresql

# 切换到 postgres 用户
USER postgres

# 初始化数据库
RUN initdb -D /var/lib/postgresql/data

# 配置 PostgreSQL
RUN echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/data/pg_hba.conf
RUN echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

# 暴露端口
EXPOSE 5432

# 启动脚本
COPY --chown=postgres:postgres start.sh /start.sh
USER root
RUN chmod +x /start.sh

# 启动 PostgreSQL
CMD ["/start.sh"]
