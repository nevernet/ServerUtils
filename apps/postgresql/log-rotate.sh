#!/bin/bash
# 极简版
dir="/opt/logs/postgresql"
days=7

[ -d "$dir" ] && find "$dir" -maxdepth 1 -name "postgresql-*.log" -mtime +$days -delete