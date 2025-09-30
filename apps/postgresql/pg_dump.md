是的，PostgreSQL 有类似的命令！PostgreSQL 提供了 `pg_dump` 和 `pg_dumpall` 命令来备份数据库，功能类似于 MySQL 的 `mysqldump`。

## 主要备份命令

### 1. pg_dump - 备份单个数据库

```bash
# 基本语法
pg_dump -h <host> -p <port> -U <username> -d <database> [options]

# 常用示例
pg_dump -h localhost -p 5432 -U postgres -d mydatabase > backup.sql

# 备份为压缩格式
pg_dump -h localhost -p 5432 -U postgres -d mydatabase | gzip > backup.sql.gz

# 备份为自定义格式（推荐）
pg_dump -h localhost -p 5432 -U postgres -d mydatabase -Fc > backup.dump

# 备份为目录格式
pg_dump -h localhost -p 5432 -U postgres -d mydatabase -Fd backup_dir/
```

### 2. pg_dumpall - 备份所有数据库

```bash
# 备份所有数据库和全局对象
pg_dumpall -h localhost -p 5432 -U postgres > all_databases.sql

# 只备份全局对象（用户、角色等）
pg_dumpall -h localhost -p 5432 -U postgres -g > globals.sql

# 只备份数据
pg_dumpall -h localhost -p 5432 -U postgres -a > data_only.sql
```

## 常用选项

```bash
# 基本选项
pg_dump -h localhost -p 5432 -U postgres -d mydatabase \
    --verbose \          # 详细输出
    --no-password \      # 不提示密码
    --clean \            # 包含DROP语句
    --create \           # 包含CREATE DATABASE语句
    --if-exists \        # 使用IF EXISTS
    --format=custom \    # 自定义格式
    --file=backup.dump   # 输出文件

# 数据选项
pg_dump -h localhost -p 5432 -U postgres -d mydatabase \
    --data-only \        # 只备份数据
    --schema-only \      # 只备份结构
    --table=users \      # 只备份指定表
    --exclude-table=logs # 排除指定表

# 高级选项
pg_dump -h localhost -p 5432 -U postgres -d mydatabase \
    --jobs=4 \           # 并行备份（目录格式）
    --compress=9 \       # 压缩级别
    --blobs \            # 包含大对象
    --no-owner \         # 不包含所有权信息
    --no-privileges      # 不包含权限信息
```

## 恢复命令

### 1. psql - 恢复SQL格式备份

```bash
# 恢复SQL格式的备份
psql -h localhost -p 5432 -U postgres -d mydatabase < backup.sql

# 或者
psql -h localhost -p 5432 -U postgres -f backup.sql
```

### 2. pg_restore - 恢复自定义格式备份

```bash
# 恢复自定义格式备份
pg_restore -h localhost -p 5432 -U postgres -d mydatabase backup.dump

# 恢复为新的数据库
pg_restore -h localhost -p 5432 -U postgres -C -d postgres backup.dump

# 并行恢复
pg_restore -h localhost -p 5432 -U postgres -d mydatabase -j 4 backup.dump

# 只恢复结构
pg_restore -h localhost -p 5432 -U postgres -d mydatabase -s backup.dump

# 只恢复数据
pg_restore -h localhost -p 5432 -U postgres -d mydatabase -a backup.dump
```

## 实际使用示例

```bash
# 1. 完整备份和恢复
pg_dump -h localhost -p 5432 -U postgres -d mydatabase -Fc > backup.dump
pg_restore -h localhost -p 5432 -U postgres -d mydatabase backup.dump

# 2. 备份特定表
pg_dump -h localhost -p 5432 -U postgres -d mydatabase -t users -t orders > tables.sql

# 3. 备份到压缩文件
pg_dump -h localhost -p 5432 -U postgres -d mydatabase | gzip > backup.sql.gz
gunzip -c backup.sql.gz | psql -h localhost -p 5432 -U postgres -d mydatabase

# 4. 远程备份
pg_dump -h remote-server -p 5432 -U postgres -d mydatabase | psql -h local-server -p 5432 -U postgres -d mydatabase

# 5. 定时备份脚本
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump -h localhost -p 5432 -U postgres -d mydatabase -Fc > /backup/mydatabase_$DATE.dump
```

## 与 mysqldump 的对比

| 功能           | MySQL (mysqldump)            | PostgreSQL (pg_dump)    |
| -------------- | ---------------------------- | ----------------------- |
| 备份单个数据库 | `mysqldump dbname`           | `pg_dump -d dbname`     |
| 备份所有数据库 | `mysqldump --all-databases`  | `pg_dumpall`            |
| 只备份结构     | `mysqldump --no-data`        | `pg_dump --schema-only` |
| 只备份数据     | `mysqldump --no-create-info` | `pg_dump --data-only`   |
| 压缩备份       | `mysqldump                   | gzip`                   | `pg_dump | gzip` |
| 恢复           | `mysql < backup.sql`         | `psql < backup.sql`     |

PostgreSQL 的备份工具功能非常强大，支持多种格式和选项，可以满足各种备份需求。