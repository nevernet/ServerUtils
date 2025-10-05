# TimescaleDB 基础使用指南

TimescaleDB 是一个基于 PostgreSQL 的开源时序数据库，专为处理时间序列数据而优化。它提供了自动分区、压缩、连续聚合等功能。

## 目录
- [安装和配置](#安装和配置)
- [创建表（Hypertable）](#创建表hypertable)
- [数据写入](#数据写入)
- [数据查询](#数据查询)
- [数据更新](#数据更新)
- [数据删除](#数据删除)
- [高级功能](#高级功能)
- [性能优化](#性能优化)

## 安装和配置

### 1. 安装 TimescaleDB

#### 在 Alpine Linux 上安装
```bash
# 安装 TimescaleDB
apk add --no-cache timescaledb

# 或者从源码编译
apk add --no-cache postgresql-dev gcc musl-dev make
wget https://github.com/timescale/timescaledb/archive/2.11.1.tar.gz
tar -xzf 2.11.1.tar.gz
cd timescaledb-2.11.1
make && make install
```

#### 在 Ubuntu/Debian 上安装
```bash
# 添加 TimescaleDB 官方仓库
echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
sudo apt-get update

# 安装 TimescaleDB
sudo apt-get install timescaledb-2-postgresql-14
```

### 2. 配置 PostgreSQL

编辑 `postgresql.conf` 文件：
```bash
# 添加 TimescaleDB 到预加载库
shared_preload_libraries = 'timescaledb'

# 优化时序数据库性能
max_connections = 200
shared_buffers = 256MB
effective_cache_size = 1GB
maintenance_work_mem = 64MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
```

### 3. 启用 TimescaleDB 扩展

```sql
-- 连接到数据库
psql -U postgres

-- 创建数据库
CREATE DATABASE timeseries_db;

-- 连接到新数据库
\c timeseries_db

-- 启用 TimescaleDB 扩展
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- 验证安装
SELECT * FROM timescaledb_information.version;
```

## 创建表（Hypertable）

### 1. 创建普通表

首先创建一个普通的 PostgreSQL 表：

```sql
-- 创建传感器数据表
CREATE TABLE sensor_data (
    time        TIMESTAMPTZ       NOT NULL,
    sensor_id   INTEGER           NOT NULL,
    temperature DOUBLE PRECISION  NULL,
    humidity    DOUBLE PRECISION  NULL,
    pressure    DOUBLE PRECISION  NULL,
    location    TEXT              NULL
);
```

### 2. 转换为 Hypertable

将普通表转换为 TimescaleDB 的 Hypertable：

```sql
-- 将表转换为 Hypertable，按时间分区
SELECT create_hypertable('sensor_data', 'time');

-- 查看 Hypertable 信息
SELECT * FROM timescaledb_information.hypertables;
```

### 3. 创建带分区的 Hypertable

```sql
-- 创建带空间分区的表
CREATE TABLE metrics (
    time        TIMESTAMPTZ       NOT NULL,
    device_id   INTEGER           NOT NULL,
    metric_name TEXT              NOT NULL,
    value       DOUBLE PRECISION  NOT NULL
);

-- 按时间和设备ID分区
SELECT create_hypertable('metrics', 'time',
    partitioning_column => 'device_id',
    number_partitions => 4
);
```

### 4. 创建压缩表

```sql
-- 创建支持压缩的表
CREATE TABLE compressed_data (
    time        TIMESTAMPTZ       NOT NULL,
    device_id   INTEGER           NOT NULL,
    value       DOUBLE PRECISION  NOT NULL
);

-- 转换为 Hypertable
SELECT create_hypertable('compressed_data', 'time');

-- 启用压缩（保留7天的未压缩数据）
SELECT add_compression_policy('compressed_data', INTERVAL '7 days');
```

## 数据写入

### 1. 单条数据插入

```sql
-- 插入单条记录
INSERT INTO sensor_data (time, sensor_id, temperature, humidity, pressure, location)
VALUES (NOW(), 1, 23.5, 65.2, 1013.25, 'Room A');

-- 插入带时区的数据
INSERT INTO sensor_data (time, sensor_id, temperature, humidity, pressure, location)
VALUES ('2024-01-15 10:30:00+08', 2, 24.1, 63.8, 1012.80, 'Room B');
```

### 2. 批量数据插入

```sql
-- 批量插入多条记录
INSERT INTO sensor_data (time, sensor_id, temperature, humidity, pressure, location)
VALUES
    (NOW() - INTERVAL '1 hour', 1, 22.8, 67.1, 1013.50, 'Room A'),
    (NOW() - INTERVAL '30 minutes', 1, 23.2, 66.5, 1013.30, 'Room A'),
    (NOW(), 1, 23.5, 65.2, 1013.25, 'Room A'),
    (NOW(), 2, 24.1, 63.8, 1012.80, 'Room B'),
    (NOW(), 3, 21.9, 69.3, 1014.10, 'Room C');
```

### 3. 使用 COPY 命令快速插入

```sql
-- 从文件导入数据
COPY sensor_data (time, sensor_id, temperature, humidity, pressure, location)
FROM '/path/to/data.csv'
WITH (FORMAT csv, HEADER true);

-- 从标准输入导入
COPY sensor_data (time, sensor_id, temperature, humidity, pressure, location)
FROM STDIN
WITH (FORMAT csv);
```

### 4. 使用 UPSERT 操作

```sql
-- 使用 ON CONFLICT 进行 upsert
INSERT INTO sensor_data (time, sensor_id, temperature, humidity, pressure, location)
VALUES (NOW(), 1, 23.8, 64.5, 1013.15, 'Room A')
ON CONFLICT (time, sensor_id)
DO UPDATE SET
    temperature = EXCLUDED.temperature,
    humidity = EXCLUDED.humidity,
    pressure = EXCLUDED.pressure,
    location = EXCLUDED.location;
```

## 数据查询

### 1. 基础查询

```sql
-- 查询所有数据
SELECT * FROM sensor_data;

-- 查询特定时间范围的数据
SELECT * FROM sensor_data
WHERE time >= NOW() - INTERVAL '1 day';

-- 查询特定传感器的数据
SELECT * FROM sensor_data
WHERE sensor_id = 1
ORDER BY time DESC;
```

### 2. 时间序列查询

```sql
-- 查询最近1小时的数据，按5分钟聚合
SELECT
    time_bucket('5 minutes', time) AS bucket,
    sensor_id,
    AVG(temperature) as avg_temp,
    AVG(humidity) as avg_humidity,
    COUNT(*) as record_count
FROM sensor_data
WHERE time >= NOW() - INTERVAL '1 hour'
GROUP BY bucket, sensor_id
ORDER BY bucket DESC;

-- 查询每小时的平均值
SELECT
    time_bucket('1 hour', time) AS hour_bucket,
    sensor_id,
    AVG(temperature) as avg_temp,
    MIN(temperature) as min_temp,
    MAX(temperature) as max_temp
FROM sensor_data
WHERE time >= NOW() - INTERVAL '7 days'
GROUP BY hour_bucket, sensor_id
ORDER BY hour_bucket DESC;
```

### 3. 窗口函数查询

```sql
-- 计算移动平均
SELECT
    time,
    sensor_id,
    temperature,
    AVG(temperature) OVER (
        PARTITION BY sensor_id
        ORDER BY time
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) as moving_avg_5
FROM sensor_data
WHERE sensor_id = 1
ORDER BY time DESC;

-- 计算温度变化率
SELECT
    time,
    sensor_id,
    temperature,
    temperature - LAG(temperature) OVER (
        PARTITION BY sensor_id
        ORDER BY time
    ) as temp_change
FROM sensor_data
WHERE sensor_id = 1
ORDER BY time DESC;
```

### 4. 复杂查询示例

```sql
-- 查询每个传感器的异常温度（超过平均值2个标准差）
WITH sensor_stats AS (
    SELECT
        sensor_id,
        AVG(temperature) as avg_temp,
        STDDEV(temperature) as std_temp
    FROM sensor_data
    WHERE time >= NOW() - INTERVAL '7 days'
    GROUP BY sensor_id
)
SELECT
    s.time,
    s.sensor_id,
    s.temperature,
    s.location,
    st.avg_temp,
    st.std_temp
FROM sensor_data s
JOIN sensor_stats st ON s.sensor_id = st.sensor_id
WHERE s.temperature > st.avg_temp + 2 * st.std_temp
    OR s.temperature < st.avg_temp - 2 * st.std_temp
ORDER BY s.time DESC;
```

## 数据更新

### 1. 基础更新操作

```sql
-- 更新特定记录
UPDATE sensor_data
SET temperature = 24.5, humidity = 62.8
WHERE sensor_id = 1 AND time = '2024-01-15 10:30:00+08';

-- 更新时间范围内的数据
UPDATE sensor_data
SET location = 'Room A - Updated'
WHERE sensor_id = 1
    AND time >= '2024-01-15 10:00:00+08'
    AND time <= '2024-01-15 11:00:00+08';
```

### 2. 条件更新

```sql
-- 根据条件更新数据
UPDATE sensor_data
SET temperature = temperature * 1.1
WHERE temperature > 25.0
    AND time >= NOW() - INTERVAL '1 day';

-- 使用子查询更新
UPDATE sensor_data
SET location = 'High Temperature Zone'
WHERE temperature > (
    SELECT AVG(temperature) + 2 * STDDEV(temperature)
    FROM sensor_data
    WHERE time >= NOW() - INTERVAL '7 days'
);
```

### 3. 批量更新

```sql
-- 使用 JOIN 进行批量更新
UPDATE sensor_data
SET location = s.new_location
FROM (
    VALUES
        (1, 'Room A - New'),
        (2, 'Room B - New'),
        (3, 'Room C - New')
) AS s(sensor_id, new_location)
WHERE sensor_data.sensor_id = s.sensor_id;
```

## 数据删除

### 1. 基础删除操作

```sql
-- 删除特定记录
DELETE FROM sensor_data
WHERE sensor_id = 1 AND time = '2024-01-15 10:30:00+08';

-- 删除时间范围内的数据
DELETE FROM sensor_data
WHERE time < NOW() - INTERVAL '30 days';

-- 删除特定传感器的所有数据
DELETE FROM sensor_data
WHERE sensor_id = 2;
```

### 2. 条件删除

```sql
-- 删除异常数据
DELETE FROM sensor_data
WHERE temperature < -50 OR temperature > 100;

-- 删除重复数据（保留最新的）
DELETE FROM sensor_data s1
USING sensor_data s2
WHERE s1.sensor_id = s2.sensor_id
    AND s1.time < s2.time
    AND s1.temperature = s2.temperature
    AND s1.humidity = s2.humidity;
```

### 3. 使用删除策略

```sql
-- 创建数据保留策略（自动删除30天前的数据）
SELECT add_retention_policy('sensor_data', INTERVAL '30 days');

-- 查看保留策略
SELECT * FROM timescaledb_information.jobs
WHERE proc_name = 'policy_retention';

-- 删除保留策略
SELECT remove_retention_policy('sensor_data');
```

## 高级功能

### 1. 数据压缩

```sql
-- 手动压缩数据
SELECT compress_chunk(chunk_schema, chunk_name)
FROM timescaledb_information.chunks
WHERE hypertable_name = 'sensor_data'
    AND is_compressed = false;

-- 查看压缩统计
SELECT
    chunk_schema,
    chunk_name,
    is_compressed,
    compressed_bytes,
    uncompressed_bytes,
    compression_ratio
FROM timescaledb_information.chunks
WHERE hypertable_name = 'sensor_data';
```

### 2. 连续聚合

```sql
-- 创建连续聚合视图
CREATE MATERIALIZED VIEW sensor_data_hourly
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 hour', time) AS bucket,
    sensor_id,
    AVG(temperature) as avg_temp,
    MIN(temperature) as min_temp,
    MAX(temperature) as max_temp,
    AVG(humidity) as avg_humidity,
    COUNT(*) as record_count
FROM sensor_data
GROUP BY bucket, sensor_id;

-- 创建刷新策略
SELECT add_continuous_aggregate_policy('sensor_data_hourly',
    start_offset => INTERVAL '1 hour',
    end_offset => INTERVAL '1 minute',
    schedule_interval => INTERVAL '1 hour');

-- 查询连续聚合
SELECT * FROM sensor_data_hourly
WHERE bucket >= NOW() - INTERVAL '1 day'
ORDER BY bucket DESC;
```

### 3. 数据压缩策略

```sql
-- 添加压缩策略
SELECT add_compression_policy('sensor_data', INTERVAL '7 days');

-- 查看压缩策略
SELECT * FROM timescaledb_information.jobs
WHERE proc_name = 'policy_compression';

-- 手动压缩特定时间范围
SELECT compress_chunk(chunk_schema, chunk_name)
FROM timescaledb_information.chunks
WHERE hypertable_name = 'sensor_data'
    AND range_start < NOW() - INTERVAL '7 days';
```

## 性能优化

### 1. 索引优化

```sql
-- 创建复合索引
CREATE INDEX idx_sensor_data_sensor_time
ON sensor_data (sensor_id, time DESC);

-- 创建部分索引
CREATE INDEX idx_sensor_data_high_temp
ON sensor_data (time DESC)
WHERE temperature > 30.0;

-- 查看索引使用情况
SELECT * FROM pg_stat_user_indexes
WHERE relname = 'sensor_data';
```

### 2. 查询优化

```sql
-- 使用 EXPLAIN 分析查询
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM sensor_data
WHERE sensor_id = 1
    AND time >= NOW() - INTERVAL '1 day';

-- 优化查询计划
SET enable_hashjoin = off;
SET enable_mergejoin = off;
```

### 3. 分区优化

```sql
-- 查看分区信息
SELECT
    chunk_schema,
    chunk_name,
    range_start,
    range_end,
    is_compressed
FROM timescaledb_information.chunks
WHERE hypertable_name = 'sensor_data'
ORDER BY range_start;

-- 手动合并小分区
SELECT merge_chunks('sensor_data', '2024-01-01', '2024-01-02');
```

## 监控和维护

### 1. 查看数据库状态

```sql
-- 查看 TimescaleDB 版本
SELECT * FROM timescaledb_information.version;

-- 查看 Hypertable 信息
SELECT * FROM timescaledb_information.hypertables;

-- 查看分区信息
SELECT * FROM timescaledb_information.chunks;

-- 查看作业状态
SELECT * FROM timescaledb_information.jobs;
```

### 2. 性能监控

```sql
-- 查看查询统计
SELECT * FROM pg_stat_user_tables
WHERE relname = 'sensor_data';

-- 查看索引使用情况
SELECT * FROM pg_stat_user_indexes
WHERE relname = 'sensor_data';

-- 查看数据库大小
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE tablename = 'sensor_data';
```

### 3. 维护任务

```sql
-- 手动执行 VACUUM
VACUUM ANALYZE sensor_data;

-- 重建索引
REINDEX TABLE sensor_data;

-- 更新表统计信息
ANALYZE sensor_data;
```

## 多业务架构设计

### 方案对比分析

#### 方案一：单数据库 + 多表（推荐）

```sql
-- 数据库：timeseries_db
-- 表结构：
CREATE TABLE sensor_data_iot (
    time        TIMESTAMPTZ       NOT NULL,
    sensor_id   INTEGER           NOT NULL,
    temperature DOUBLE PRECISION  NULL,
    humidity    DOUBLE PRECISION  NULL,
    pressure    DOUBLE PRECISION  NULL,
    location    TEXT              NULL
);

CREATE TABLE sensor_data_industrial (
    time        TIMESTAMPTZ       NOT NULL,
    machine_id  INTEGER           NOT NULL,
    vibration   DOUBLE PRECISION  NULL,
    noise_level DOUBLE PRECISION  NULL,
    power_usage DOUBLE PRECISION  NULL,
    status      TEXT              NULL
);

CREATE TABLE sensor_data_environmental (
    time        TIMESTAMPTZ       NOT NULL,
    station_id  INTEGER           NOT NULL,
    air_quality DOUBLE PRECISION  NULL,
    wind_speed  DOUBLE PRECISION  NULL,
    rainfall    DOUBLE PRECISION  NULL,
    region      TEXT              NULL
);

-- 转换为 Hypertables
SELECT create_hypertable('sensor_data_iot', 'time');
SELECT create_hypertable('sensor_data_industrial', 'time');
SELECT create_hypertable('sensor_data_environmental', 'time');
```

**优点：**
- 资源共享，成本更低
- 统一管理，维护简单
- 跨业务查询方便
- 备份和恢复统一
- 连接池共享

**缺点：**
- 表名需要业务前缀
- 权限管理相对复杂
- 单点故障风险

#### 方案二：多数据库 + 单表

```sql
-- 数据库：iot_timeseries_db
CREATE TABLE sensor_data (
    time        TIMESTAMPTZ       NOT NULL,
    sensor_id   INTEGER           NOT NULL,
    temperature DOUBLE PRECISION  NULL,
    humidity    DOUBLE PRECISION  NULL,
    pressure    DOUBLE PRECISION  NULL,
    location    TEXT              NULL
);

-- 数据库：industrial_timeseries_db
CREATE TABLE sensor_data (
    time        TIMESTAMPTZ       NOT NULL,
    machine_id  INTEGER           NOT NULL,
    vibration   DOUBLE PRECISION  NULL,
    noise_level DOUBLE PRECISION  NULL,
    power_usage DOUBLE PRECISION  NULL,
    status      TEXT              NULL
);

-- 数据库：environmental_timeseries_db
CREATE TABLE sensor_data (
    time        TIMESTAMPTZ       NOT NULL,
    station_id  INTEGER           NOT NULL,
    air_quality DOUBLE PRECISION  NULL,
    wind_speed  DOUBLE PRECISION  NULL,
    rainfall    DOUBLE PRECISION  NULL,
    region      TEXT              NULL
);
```

**优点：**
- 业务隔离，安全性高
- 表名简洁统一
- 独立扩展和优化
- 故障隔离

**缺点：**
- 资源消耗更大
- 管理复杂度高
- 跨业务查询困难
- 备份恢复复杂

### 推荐架构方案

#### 混合方案：按业务重要性分层

```sql
-- 核心业务：独立数据库
-- 数据库：core_iot_db
CREATE TABLE sensor_data (
    time        TIMESTAMPTZ       NOT NULL,
    sensor_id   INTEGER           NOT NULL,
    -- 核心业务字段
);

-- 一般业务：共享数据库
-- 数据库：shared_timeseries_db
CREATE TABLE sensor_data_environmental (
    time        TIMESTAMPTZ       NOT NULL,
    station_id  INTEGER           NOT NULL,
    -- 环境监测字段
);

CREATE TABLE sensor_data_testing (
    time        TIMESTAMPTZ       NOT NULL,
    test_id     INTEGER           NOT NULL,
    -- 测试数据字段
);
```

### 具体实施建议

#### 1. 表命名规范

```sql
-- 推荐命名模式
{业务前缀}_{数据类型}_{具体用途}

-- 示例
iot_sensor_data          -- IoT传感器数据
industrial_machine_data  -- 工业设备数据
env_weather_data         -- 环境天气数据
test_performance_data    -- 测试性能数据
```

#### 2. 权限管理

```sql
-- 创建业务专用用户
CREATE USER iot_user WITH PASSWORD 'iot_pass';
CREATE USER industrial_user WITH PASSWORD 'industrial_pass';

-- 授予表级权限
GRANT SELECT, INSERT, UPDATE, DELETE ON sensor_data_iot TO iot_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON sensor_data_industrial TO industrial_user;

-- 创建只读用户用于跨业务查询
CREATE USER analyst_user WITH PASSWORD 'analyst_pass';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst_user;
```

#### 3. 跨业务查询方案

```sql
-- 使用视图统一查询接口
CREATE VIEW unified_sensor_data AS
SELECT
    'iot' as business_type,
    time,
    sensor_id as device_id,
    temperature,
    humidity,
    pressure,
    location
FROM sensor_data_iot
UNION ALL
SELECT
    'industrial' as business_type,
    time,
    machine_id as device_id,
    vibration as temperature,  -- 映射到统一字段
    noise_level as humidity,
    power_usage as pressure,
    status as location
FROM sensor_data_industrial;

-- 查询所有业务的数据
SELECT * FROM unified_sensor_data
WHERE time >= NOW() - INTERVAL '1 day'
ORDER BY time DESC;
```

#### 4. 数据保留策略

```sql
-- 不同业务设置不同的保留期
SELECT add_retention_policy('sensor_data_iot', INTERVAL '90 days');
SELECT add_retention_policy('sensor_data_industrial', INTERVAL '180 days');
SELECT add_retention_policy('sensor_data_environmental', INTERVAL '365 days');
```

### 选择建议

#### 选择单数据库 + 多表的情况：
- 业务规模较小（< 10个业务）
- 需要频繁跨业务查询
- 资源有限
- 团队规模较小

#### 选择多数据库 + 单表的情况：
- 业务规模较大（> 10个业务）
- 业务间完全独立
- 安全要求极高
- 需要独立扩展和优化

#### 选择混合方案的情况：
- 有核心业务和一般业务区分
- 需要平衡成本和隔离性
- 业务发展不同阶段

## 最佳实践

### 1. 表设计建议

- 始终包含时间戳列作为分区键
- 使用适当的数据类型（TIMESTAMPTZ 而不是 TIMESTAMP）
- 考虑空间分区以提高并行性
- 合理设置数据保留策略
- 使用统一的表命名规范

### 2. 查询优化建议

- 在 WHERE 子句中包含时间范围
- 使用 time_bucket() 进行时间聚合
- 利用连续聚合处理复杂查询
- 避免全表扫描
- 使用视图统一跨业务查询

### 3. 数据管理建议

- 定期清理旧数据
- 使用压缩减少存储空间
- 监控分区大小和数量
- 定期更新表统计信息
- 建立完善的权限管理体系

### 4. 架构演进建议

- 从小规模开始，逐步扩展
- 预留架构调整空间
- 建立数据迁移方案
- 定期评估架构合理性

这个指南涵盖了 TimescaleDB 的主要功能和使用方法，以及多业务场景下的架构设计建议。根据您的具体需求，可以进一步深入某个特定功能。
