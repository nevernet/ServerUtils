#!/bin/bash
set -e

# PostgreSQL 单机版启动脚本

echo "Starting PostgreSQL Server..."

# 启动 PostgreSQL
exec postgres -D /var/lib/postgresql/data
