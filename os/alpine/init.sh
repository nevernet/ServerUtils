#!/bin/bash

# SSH服务管理函数
restart_ssh() {
    echo "重启SSH服务..."
    # 杀死现有的SSH进程
    pkill -f "sshd -D" 2>/dev/null || true
    sleep 1
    # 重新启动SSH服务
    /usr/sbin/sshd -D -e &
    echo "SSH服务已重启"
}

start_ssh() {
    echo "启动SSH服务..."
    /usr/sbin/sshd -D -e &
    echo "SSH服务已启动"
}

# 检查并生成SSH密钥
check_ssh_keys

# 直接启动SSH服务（不依赖OpenRC）
start_ssh

# 启动cron服务
echo "启动Cron服务..."
/usr/sbin/crond -f &

# 检查服务状态
echo "检查服务状态..."
ps aux | grep -E "(sshd|crond)"

# 检查端口监听
echo "检查端口监听..."
netstat -tlnp

# 在这里添加其他需要启动的服务
# 例如：
# /usr/local/bin/my-service --daemon
# /usr/sbin/nginx -g "daemon off;"

echo "容器启动完成，保持运行状态..."
while true; do
    # 定期检查SSH服务状态
    if ! pgrep sshd > /dev/null; then
        echo "SSH服务异常，尝试重启..."
        restart_ssh
    fi
    sleep 30
done