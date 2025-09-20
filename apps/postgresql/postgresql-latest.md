# postgresql 最新版本

## 直接安装方式

```
apt-get install -y postgresql-16 postgresql-contrib-16
```

# 启动

```
service postgresql start
```

## Docker 容器安装方式

### 1. 创建 Dockerfile

```dockerfile
FROM ubuntu:20.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV POSTGRES_VERSION=16

# 更新包列表并安装必要的依赖
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# 添加 PostgreSQL 官方 APT 仓库
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# 安装 PostgreSQL 最新稳定版本
RUN apt-get update && apt-get install -y \
    postgresql-${POSTGRES_VERSION} \
    postgresql-client-${POSTGRES_VERSION} \
    postgresql-contrib-${POSTGRES_VERSION} \
    && rm -rf /var/lib/apt/lists/*

# 创建数据目录
RUN mkdir -p /var/lib/postgresql/data
RUN chown -R postgres:postgres /var/lib/postgresql

# 切换到 postgres 用户
USER postgres

# 初始化数据库
RUN /usr/lib/postgresql/${POSTGRES_VERSION}/bin/initdb -D /var/lib/postgresql/data

# 配置 PostgreSQL
RUN echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/data/pg_hba.conf
RUN echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

# 暴露端口
EXPOSE 5432

# 启动 PostgreSQL
CMD ["/usr/lib/postgresql/16/bin/postgres", "-D", "/var/lib/postgresql/data"]
```

### 2. 构建镜像

```bash
# 构建镜像
docker build -t postgresql-ubuntu20:latest .

# 查看构建的镜像
docker images | grep postgresql-ubuntu20
```

### 3. 运行容器

```bash
# 运行容器
docker run -d \
  --name postgresql-container \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=your_password \
  postgresql-ubuntu20:latest

# 查看容器状态
docker ps

# 查看容器日志
docker logs postgresql-container
```

### 4. 连接到数据库

```bash
# 进入容器
docker exec -it postgresql-container bash

# 切换到 postgres 用户
su - postgres

# 连接数据库
psql -U postgres
```

## 推荐方式评估

### 当前 Docker 方式的优缺点

**优点：**
- 环境隔离，避免系统污染
- 便于版本管理和回滚
- 可以快速部署到不同环境
- 便于备份和迁移

**缺点：**
- 需要手动配置 PostgreSQL
- 缺少数据持久化配置
- 没有健康检查机制
- 安全性配置不完整

### 更好的推荐方式

#### 方案一：使用官方 PostgreSQL Docker 镜像

```dockerfile
FROM postgres:16

# 复制自定义配置
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

# 复制初始化脚本
COPY init.sql /docker-entrypoint-initdb.d/

# 设置环境变量
ENV POSTGRES_DB=mydb
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
```

#### 方案二：使用 Docker Compose

```yaml
version: '3.8'
services:
  postgresql:
    image: postgres:16
    container_name: postgresql-server
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgresql.conf:/etc/postgresql/postgresql.conf
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser -d mydb"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  postgres_data:
```

#### 方案三：使用 Helm Chart (Kubernetes)

```yaml
# values.yaml
postgresql:
  auth:
    postgresPassword: "mypassword"
    username: "myuser"
    password: "mypassword"
    database: "mydb"
  primary:
    persistence:
      enabled: true
      size: 8Gi
  metrics:
    enabled: true
```

## Alpine Linux 安装方式

### 1. 直接安装到 Alpine

```bash
# 更新包索引
apk update

# 安装 PostgreSQL 和必要组件
apk add postgresql postgresql-contrib postgresql-client

# 创建 postgres 用户和组
adduser -D -s /bin/sh postgres

# 创建数据目录
mkdir -p /var/lib/postgresql/data
chown postgres:postgres /var/lib/postgresql/data

# 切换到 postgres 用户
su - postgres

# 初始化数据库
initdb -D /var/lib/postgresql/data

# 启动 PostgreSQL
pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/data/logfile start
```

### 2. Alpine 版本的 Dockerfile

```dockerfile
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
```

### 3. 启动脚本 (start.sh)

```bash
#!/bin/bash
set -e

# 启动 PostgreSQL
exec postgres -D /var/lib/postgresql/data
```

### 4. 构建和运行 Alpine 版本

```bash
# 构建镜像
docker build -t postgresql-alpine:latest .

# 运行容器
docker run -d \
  --name postgresql-alpine \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=your_password \
  postgresql-alpine:latest
```

### Alpine 安装 PostgreSQL 的优缺点

**优点：**
- 🐧 **极小的镜像大小**：Alpine 基础镜像只有 5MB，最终镜像通常 < 50MB
- ⚡ **启动速度快**：轻量级系统，容器启动更快
- 🔒 **安全性高**：最小化攻击面，只包含必要的包
- 💰 **资源消耗低**：内存和 CPU 使用更少
- 🚀 **适合微服务**：非常适合容器化和云原生部署

**缺点：**
- 📚 **文档较少**：相比 Ubuntu/Debian，Alpine 的 PostgreSQL 文档相对较少
- 🔧 **调试复杂**：缺少一些调试工具和包
- 📦 **包管理不同**：使用 apk 而不是 apt，语法略有不同
- 🐛 **兼容性问题**：某些第三方扩展可能不兼容 musl libc

### 最终推荐

1. **开发环境**：使用 Docker Compose 方案
2. **生产环境**：使用官方 PostgreSQL 镜像 + Kubernetes Helm Chart
3. **学习目的**：当前的自定义 Dockerfile 方案可以接受
4. **资源敏感环境**：推荐使用 Alpine 版本（镜像小、启动快）
5. **企业环境**：推荐使用官方镜像（稳定性更好、文档更全）