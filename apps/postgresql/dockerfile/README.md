# PostgreSQL Docker 配置

本目录包含了简化的 PostgreSQL Docker 配置，提供基础的 PostgreSQL 环境。

## 文件说明

- `Dockerfile` - PostgreSQL 基础环境，包含所有配置文件

## 设计理念

1. **简化容器**: 容器只提供 PostgreSQL 环境，不包含自动配置逻辑
2. **手动控制**: 所有配置和复制操作都需要手动进行，提供更好的控制性
3. **配置分离**: 所有配置文件都复制到容器的 `/etc/postgresql/` 目录中
4. **灵活部署**: 可以根据需要选择不同的配置和部署方式

## 使用方法

### 构建镜像

```bash
# 构建镜像
docker build -f dockfile/Dockerfile -t postgresql .
```

### 运行容器

```bash
# 运行容器（默认使用主服务器配置）
docker run -d --name postgresql \
  -p 5432:5432 \
  -v postgresql_data:/var/lib/postgresql/data \
  postgresql
```

### 配置说明

容器启动时已经：
1. 初始化了数据库
2. 使用主服务器配置作为默认配置
3. 设置了正确的文件权限

### 手动配置（可选）

如果需要修改配置或设置主从复制：

#### 1. 修改配置文件

```bash
# 进入容器
docker exec -it postgresql bash

# 停止PostgreSQL
pg_ctl stop -D /var/lib/postgresql/data

# 选择不同的配置文件（例如从服务器配置）
cp /etc/postgresql/postgresql-slave.conf /var/lib/postgresql/data/postgresql.conf
cp /etc/postgresql/pg_hba-slave.conf /var/lib/postgresql/data/pg_hba.conf

# 设置权限
chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf
chmod 600 /var/lib/postgresql/data/postgresql.conf
chmod 600 /var/lib/postgresql/data/pg_hba.conf

# 启动PostgreSQL
postgres -D /var/lib/postgresql/data
```

#### 2. 配置主从复制

**主服务器配置**：
```bash
# 容器默认已经是主服务器配置，只需要创建复制用户
docker exec -it postgresql psql -c "CREATE USER replicator REPLICATION LOGIN PASSWORD 'replicator_password';"
```

**从服务器配置**：
```bash
# 停止PostgreSQL
docker exec -it postgresql pg_ctl stop -D /var/lib/postgresql/data

# 从主服务器创建基础备份
docker exec -it postgresql pg_basebackup -h postgresql-master -D /var/lib/postgresql/data -U replicator -v -P -W

# 使用从服务器配置
docker exec -it postgresql cp /etc/postgresql/postgresql-slave.conf /var/lib/postgresql/data/postgresql.conf
docker exec -it postgresql cp /etc/postgresql/pg_hba-slave.conf /var/lib/postgresql/data/pg_hba.conf
docker exec -it postgresql cp /etc/postgresql/recovery.conf /var/lib/postgresql/data/recovery.conf

# 修改recovery.conf中的主服务器地址
docker exec -it postgresql sed -i 's/host=postgresql-master/host=postgresql-master/g' /var/lib/postgresql/data/recovery.conf

# 启动PostgreSQL
docker exec -it postgresql postgres -D /var/lib/postgresql/data
```

## 配置文件

确保以下配置文件存在于 `conf/` 目录中：

- `conf/postgresql-master.conf` - 主服务器配置
- `conf/postgresql-slave.conf` - 从服务器配置
- `conf/pg_hba-master.conf` - 主服务器认证配置
- `conf/pg_hba-slave.conf` - 从服务器认证配置
- `conf/recovery.conf` - 从服务器恢复配置

所有配置文件都会复制到容器的 `/etc/postgresql/` 目录中，可以根据需要选择使用。

## 构建方法

### 使用构建脚本（推荐）

```bash
# 进入项目目录
cd apps/postgresql/

# 构建镜像
./dockfile/build.sh

# 或者构建所有版本（现在只有一个版本）
./dockfile/build.sh all
```

### 手动构建

```bash
# 在 apps/postgresql/ 目录下执行
docker build -f dockfile/Dockerfile -t postgresql .
```

## 注意事项

1. **默认配置**: 容器启动时已经使用主服务器配置初始化
2. **数据持久化**: 建议使用数据卷挂载 `/var/lib/postgresql/data` 目录
3. **配置文件**: 所有配置文件都在 `/etc/postgresql/` 目录中，可根据需要切换
4. **用户权限**: 容器使用 `postgres` 用户运行
5. **主从复制**: 需要手动配置复制用户和从服务器连接
6. **网络连接**: 确保容器间网络连接正常（用于主从复制）
7. **配置修改**: 如需修改配置，需要停止PostgreSQL，替换配置文件，然后重启
