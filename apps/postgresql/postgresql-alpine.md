# postgresql 最新版本

## Alpine Linux 安装方式
# 完整连接命令格式
psql -h <host> -p <port> -U <username> -d <database> -W

```
# 参数说明：
# -h, --host=HOSTNAME     指定数据库服务器主机名或IP地址
# -p, --port=PORT         指定数据库服务器端口号
# -U, --username=USERNAME 指定连接用户名
# -d, --database=DBNAME   指定要连接的数据库名
# -W, --password
```

## PostgreSQL 服务管理

### 启动和停止 PostgreSQL

#### 1. 使用 pg_ctl 命令（推荐）

```bash
# 切换到 postgres 用户
su - postgres

# 启动 PostgreSQL
pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/data/logfile start

# 停止 PostgreSQL
pg_ctl -D /var/lib/postgresql/data stop

# 重启 PostgreSQL
pg_ctl -D /var/lib/postgresql/data restart

# 查看状态
pg_ctl -D /var/lib/postgresql/data status
```

#### 2. 使用 rc-service 命令（系统服务方式）

```bash
# 启动服务
rc-service postgresql start

# 停止服务
rc-service postgresql stop

# 重启服务
rc-service postgresql restart

# 查看服务状态
rc-service postgresql status
```

#### 3. 使用 OpenRC 服务管理

```bash
# 启用服务（开机自启）
rc-update add postgresql

# 禁用服务（取消开机自启）
rc-update del postgresql

# 启动服务
rc-service postgresql start

# 停止服务
rc-service postgresql stop
```

#### 4. 直接运行 postgres 进程

```bash
# 切换到 postgres 用户
su - postgres

# 直接启动 PostgreSQL 进程
postgres -D /var/lib/postgresql/data
```

#### 5. 检查 PostgreSQL 状态

```bash
# 检查进程是否运行
ps aux | grep postgres

# 检查端口是否监听
netstat -tlnp | grep 5432

# 或者使用 ss 命令
ss -tlnp | grep 5432
```

### 注意事项

1. **权限问题**：确保以 `postgres` 用户身份运行 PostgreSQL 相关命令
2. **数据目录**：确保数据目录路径正确（通常是 `/var/lib/postgresql/data`）
3. **配置文件**：确保配置文件存在且权限正确
4. **日志文件**：启动时指定日志文件路径，便于排查问题

### 2. 使用预配置的 Dockerfile

#### 单机版部署

```bash
# 构建单机版镜像
docker build -f Dockerfile -t postgresql-alpine:latest .

# 运行单机版容器
docker run -d \
  --name postgresql-alpine \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=your_password \
  postgresql-alpine:latest
```

#### 主从复制部署

```bash
# 使用 Docker Compose 部署主从复制
docker-compose up -d

# 或者分别构建和运行
# 构建主服务器镜像
docker build -f Dockerfile.master -t postgresql-master:latest .

# 构建从服务器镜像
docker build -f Dockerfile.slave -t postgresql-slave:latest .

# 运行主服务器
docker run -d \
  --name postgresql-master \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=master_password \
  postgresql-master:latest

# 运行从服务器
docker run -d \
  --name postgresql-slave \
  -p 5433:5432 \
  -e POSTGRES_PASSWORD=slave_password \
  --link postgresql-master:postgresql-master \
  postgresql-slave:latest
```

## PostgreSQL 扩展配置

### PostGIS 和 TimescaleDB 配置

#### PostGIS 配置
PostGIS 是地理空间数据扩展，安装后需要启用：

```bash
# 连接到数据库
psql -U postgres

# 启用 PostGIS 扩展
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;

# 查看已安装的扩展
\dx
```

#### TimescaleDB 配置
TimescaleDB 是时序数据库扩展，需要特殊配置：

```bash
# 1. 编辑 postgresql.conf 文件
vi /var/lib/postgresql/data/postgresql.conf

# 2. 添加以下配置
shared_preload_libraries = 'timescaledb'

# 3. 重启 PostgreSQL 服务
pg_ctl -D /var/lib/postgresql/data restart

# 4. 连接到数据库并启用扩展
psql -U postgres
CREATE EXTENSION IF NOT EXISTS timescaledb;

# 5. 验证 TimescaleDB 安装
SELECT * FROM timescaledb_information.version;
```

## PostgreSQL 用户配置和权限管理

### 默认用户账户

PostgreSQL 与 MySQL 的主要区别：

- **PostgreSQL**: 默认超级用户是 `postgres`，不是 `root`
- **MySQL**: 默认超级用户是 `root`

**PostgreSQL 默认账户：**
```bash
# 默认超级用户
用户名: postgres
密码: 无（初始安装时）
主机: localhost (本地连接) 或 任意主机 (根据 pg_hba.conf 配置)
```

### 用户认证配置

PostgreSQL 使用 `pg_hba.conf` 文件进行用户认证配置：

```bash
# pg_hba.conf 配置格式
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# 本地连接 (Unix socket)
local   all             all                                     trust
local   all             postgres                                peer

# 本地网络连接
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5

# 远程连接
host    all             all             0.0.0.0/0               md5
```

### 创建和管理用户

#### 创建新用户
```sql
-- 连接到 PostgreSQL
psql -U postgres

-- 创建普通用户
CREATE USER myuser WITH PASSWORD 'mypassword';

-- 创建超级用户
CREATE USER admin WITH PASSWORD 'adminpass' SUPERUSER;

-- 创建具有特定权限的用户
CREATE USER appuser WITH PASSWORD 'apppass' CREATEDB CREATEROLE;
```

#### 修改用户密码
```sql
-- 修改用户密码
ALTER USER myuser WITH PASSWORD 'newpassword';

-- 或者使用
ALTER USER myuser PASSWORD 'newpassword';
```

### 数据库访问权限配置

#### 授予数据库访问权限
```sql
-- 授予用户访问特定数据库的权限
GRANT CONNECT ON DATABASE mydatabase TO myuser;

-- 授予用户在数据库中的使用权限
GRANT USAGE ON SCHEMA public TO myuser;

-- 授予用户对特定表的权限
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO myuser;

-- 授予用户对特定表的权限
GRANT ALL PRIVILEGES ON TABLE mytable TO myuser;
```

```bash
# 记得重载配置文件：
SELECT pg_reload_conf();

# 或者使用 pg_ctl 命令
pg_ctl -D /var/lib/postgresql/data reload
```

#### 创建数据库并分配用户
```sql
-- 创建数据库
CREATE DATABASE myapp_db
    WITH
    ENCODING = 'UTF8'
    LC_COLLATE = 'zh_CN.utf8'
    LC_CTYPE = 'zh_CN.utf8'
    TEMPLATE = template0;

-- 创建用户
CREATE USER appuser WITH PASSWORD 'apppass';

-- 授予用户对数据库的所有权限
GRANT ALL PRIVILEGES ON DATABASE myapp_db TO appuser;

-- 连接到特定数据库
\c myapp_db

-- 授予用户对 schema 的权限
GRANT ALL ON SCHEMA public TO appuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO appuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO appuser;

# 记得重载配置文件：
SELECT pg_reload_conf();
```

### 限制用户访问特定数据库

#### 方法1: 通过 pg_hba.conf 限制
```bash
# 只允许特定用户访问特定数据库
host    myapp_db        appuser         192.168.1.0/24          md5
host    test_db         testuser        192.168.1.0/24          md5

# 拒绝其他访问
host    all             all             0.0.0.0/0               reject
```

记得重新加载配置文件：
```bash
SELECT pg_reload_conf();

# 或者使用 pg_ctl 命令
pg_ctl -D /var/lib/postgresql/data reload
```

#### 方法2: 通过数据库权限限制
```sql
-- 撤销用户对所有数据库的访问权限
REVOKE CONNECT ON DATABASE postgres FROM myuser;

-- 只授予特定数据库的访问权限
GRANT CONNECT ON DATABASE myapp_db TO myuser;
```

### 查看用户和权限

```sql
-- 查看所有用户
\du

-- 查看用户详细信息
SELECT * FROM pg_user;

-- 查看数据库权限
\l

-- 查看特定数据库的权限
\c myapp_db
\dp

-- 查看用户的角色权限
SELECT * FROM pg_roles WHERE rolname = 'myuser';
```

### 安全建议

1. **修改默认 postgres 用户密码**：
```sql
ALTER USER postgres WITH PASSWORD 'strong_password';
```

2. **限制超级用户连接**：
```bash
# 在 pg_hba.conf 中限制超级用户只能本地连接
local   all             postgres                                peer
host    all             postgres        127.0.0.1/32            md5
```

3. **使用最小权限原则**：
```sql
-- 为应用程序创建专用用户，只授予必要权限
CREATE USER appuser WITH PASSWORD 'apppass';
GRANT CONNECT ON DATABASE myapp_db TO appuser;
GRANT USAGE ON SCHEMA public TO appuser;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO appuser;
```

## PostgreSQL 配置文件

### 配置文件位置

PostgreSQL 的主要配置文件位于数据目录中：

```bash
# 主要配置文件路径
/var/lib/postgresql/data/postgresql.conf    # 主配置文件
/var/lib/postgresql/data/pg_hba.conf        # 客户端认证配置
/var/lib/postgresql/data/pg_ident.conf      # 用户映射配置
```

## 主从备份配置

### 1. 主服务器配置

#### 使用预配置的主服务器配置文件

```bash
# 复制主服务器配置文件
cp postgresql-master.conf /var/lib/postgresql/data/postgresql.conf
cp pg_hba-master.conf /var/lib/postgresql/data/pg_hba.conf

# 设置正确的权限
chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf
chmod 600 /var/lib/postgresql/data/postgresql.conf
chmod 600 /var/lib/postgresql/data/pg_hba.conf
```

#### 手动配置 (可选)

如果需要手动配置，可以编辑配置文件：

```bash
# 编辑主服务器配置
vi /var/lib/postgresql/data/postgresql.conf

# 添加以下配置
wal_level = replica
max_wal_senders = 3
wal_keep_segments = 64
max_replication_slots = 3
```

```bash
# 编辑认证配置
vi /var/lib/postgresql/data/pg_hba.conf

# 添加复制用户认证
host    replication     replicator      0.0.0.0/0               md5
```

#### 创建复制用户

```bash
# 连接到主数据库
psql -U postgres

# 创建复制用户
CREATE USER replicator REPLICATION LOGIN CONNECTION LIMIT 3 ENCRYPTED PASSWORD 'replicator_password';

# 查看复制用户
\du
```

### 2. 从服务器配置

#### 停止从服务器

```bash
# 如果从服务器已运行，先停止
pg_ctl -D /var/lib/postgresql/data stop
```

#### 备份主服务器数据

```bash
# 在主服务器上创建基础备份
pg_basebackup -h 主服务器IP -D /var/lib/postgresql/data -U replicator -v -P -W
```

#### 配置从服务器

```bash
# 使用预配置的从服务器配置文件
cp postgresql-slave.conf /var/lib/postgresql/data/postgresql.conf
cp pg_hba-slave.conf /var/lib/postgresql/data/pg_hba.conf
cp recovery.conf /var/lib/postgresql/data/recovery.conf

# 修改 recovery.conf 中的主服务器地址
sed -i 's/host=postgresql-master/host=主服务器IP/g' /var/lib/postgresql/data/recovery.conf

# 设置权限
chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf
chown postgres:postgres /var/lib/postgresql/data/recovery.conf
chmod 600 /var/lib/postgresql/data/postgresql.conf
chmod 600 /var/lib/postgresql/data/pg_hba.conf
chmod 600 /var/lib/postgresql/data/recovery.conf
```

#### 手动配置从服务器 (可选)

如果需要手动配置：

```bash
# 创建 recovery.conf 文件
cat > /var/lib/postgresql/data/recovery.conf << EOF
standby_mode = 'on'
primary_conninfo = 'host=主服务器IP port=5432 user=replicator password=replicator_password'
trigger_file = '/var/lib/postgresql/data/trigger_file'
EOF

# 设置权限
chown postgres:postgres /var/lib/postgresql/data/recovery.conf
chmod 600 /var/lib/postgresql/data/recovery.conf
```

#### 启动从服务器

```bash
# 启动从服务器
pg_ctl -D /var/lib/postgresql/data start
```

### 3. 验证主从复制

#### 检查主服务器状态

```bash
# 连接到主数据库
psql -U postgres

# 查看复制状态
SELECT client_addr, state, sent_lsn, write_lsn, flush_lsn FROM pg_stat_replication;
```

#### 检查从服务器状态

```bash
# 连接到从数据库
psql -U postgres

# 查看复制状态
SELECT pg_is_in_recovery();
```

### 4. Docker 文件说明

#### 单机版 Dockerfile
- `Dockerfile` - 单机版 PostgreSQL 容器
- `start.sh` - 单机版启动脚本

#### 主从复制 Dockerfile
- `Dockerfile.master` - 主服务器容器
- `Dockerfile.slave` - 从服务器容器
- `start-slave.sh` - 从服务器启动脚本
- `docker-compose.yml` - 完整的 Docker Compose 配置

#### 使用 Docker Compose 部署

```bash
# 启动主从复制环境
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs postgresql-master
docker-compose logs postgresql-slave

# 停止服务
docker-compose down

# 停止并删除数据卷
docker-compose down -v
```

#### 手动部署主从复制

```bash
# 1. 构建镜像
docker build -f Dockerfile.master -t postgresql-master:latest .
docker build -f Dockerfile.slave -t postgresql-slave:latest .

# 2. 创建网络
docker network create postgresql-network

# 3. 启动主服务器
docker run -d \
  --name postgresql-master \
  --network postgresql-network \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=master_password \
  postgresql-master:latest

# 4. 等待主服务器启动
sleep 30

# 5. 启动从服务器
docker run -d \
  --name postgresql-slave \
  --network postgresql-network \
  -p 5433:5432 \
  -e POSTGRES_PASSWORD=slave_password \
  postgresql-slave:latest
```

### 5. 故障转移和恢复

#### 手动故障转移

```bash
# 在从服务器上创建触发文件
touch /var/lib/postgresql/data/trigger_file

# 从服务器将自动提升为主服务器
```

#### 重新同步从服务器

```bash
# 停止从服务器
pg_ctl -D /var/lib/postgresql/data stop

# 删除数据目录
rm -rf /var/lib/postgresql/data/*

# 重新创建基础备份
pg_basebackup -h 主服务器IP -D /var/lib/postgresql/data -U replicator -v -P -W

# 重新配置 recovery.conf
# ... (重复从服务器配置步骤)

# 启动从服务器
pg_ctl -D /var/lib/postgresql/data start
```