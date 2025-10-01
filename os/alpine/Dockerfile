# Alpine Linux 定制镜像 Dockerfile
# 基于 alpine:latest 镜像构建，动态匹配版本
FROM alpine:latest

# 设置维护者信息
LABEL maintainer="Daniel Qin"
LABEL description="Customized Alpine Linux image with bash, SSH, and common tools"

# 设置环境变量
ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8

# 替换软件源为国内镜像源
# 动态获取 Alpine 版本号
RUN ALPINE_VERSION=$(cat /etc/alpine-release | cut -d. -f1,2) && \
    echo "# 使用国内镜像源" > /etc/apk/repositories && \
    echo "# https://mirrors.ustc.edu.cn/alpine/v${ALPINE_VERSION}/main" >> /etc/apk/repositories && \
    echo "# https://mirrors.ustc.edu.cn/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
    echo "# https://mirrors.aliyun.com/alpine/v${ALPINE_VERSION}/main" >> /etc/apk/repositories && \
    echo "# https://mirrors.aliyun.com/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
    echo "# http://mirrors.tencentyun.com/alpine/v${ALPINE_VERSION}/main" >> /etc/apk/repositories && \
    echo "# http://mirrors.tencentyun.com/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
    echo "https://mirrors.cloud.tencent.com/alpine/v${ALPINE_VERSION}/main" >> /etc/apk/repositories && \
    echo "https://mirrors.cloud.tencent.com/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories

# 更新包索引并升级系统
RUN apk update && apk upgrade

# 安装基础工具和 bash
RUN apk add --no-cache \
    bash \
    bash-completion \
    openrc \
    openssh-server \
    openssh-client \
    rsync \
    openssh-sftp-server \
    busybox-openrc \
    git \
    wget \
    netcat-openbsd \
    ca-certificates \
    tzdata \
    busybox-extras \
    vim \
    procps \
    net-tools

# 确保 bash-completion 文件存在并创建符号链接
RUN if [ -f /usr/share/bash-completion/bash_completion ]; then \
        ln -sf /usr/share/bash-completion/bash_completion /etc/profile.d/bash_completion.sh; \
    fi

# 配置 openrc
RUN mkdir -p /run/openrc && \
    touch /run/openrc/softlevel

# 配置时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 配置网络接口
RUN echo -e "auto lo\niface lo inet loopback\n\nauto eth0\niface eth0 inet dhcp" > /etc/network/interfaces

# 配置 bash
RUN echo 'alias update="apk update && apk upgrade"' >> /root/.bashrc && \
    echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> /root/.bashrc && \
    echo 'export PS1="\u@\h:\W \$ "' >> /root/.bashrc && \
    echo 'alias l="ls -CF"' >> /root/.bashrc && \
    echo 'alias la="ls -A"' >> /root/.bashrc && \
    echo 'alias ll="ls -alF"' >> /root/.bashrc && \
    echo 'alias ls="ls --color=auto"' >> /root/.bashrc && \
    echo '# 检查并加载 bash completion（如果存在）' >> /root/.bashrc && \
    echo 'if [ -f /etc/profile.d/bash_completion.sh ]; then' >> /root/.bashrc && \
    echo '    source /etc/profile.d/bash_completion.sh' >> /root/.bashrc && \
    echo 'elif [ -f /usr/share/bash-completion/bash_completion ]; then' >> /root/.bashrc && \
    echo '    source /usr/share/bash-completion/bash_completion' >> /root/.bashrc && \
    echo 'fi' >> /root/.bashrc && \
    echo 'export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "' >> /root/.bashrc

# 配置 .profile 自动加载 .bashrc
RUN echo 'source .bashrc' > /root/.profile

# 修改 root 用户默认 shell 为 bash
RUN sed -i 's|/bin/ash|/bin/bash|g' /etc/passwd

# 配置 vim
RUN echo -e "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936\nset termencoding=utf-8\nset encoding=utf-8\nset nu" > /root/.vimrc

# 安装 tini 作为 init 进程
RUN apk add --no-cache tini

# 配置 openrc 服务（注释掉，避免cgroup问题）
# RUN rc-update add sshd default && \
#     rc-update add crond default && \
#     rc-update add networking default

# 生成 SSH 主机密钥（强制执行并覆盖）
RUN ssh-keygen -A && \
    chmod 600 /etc/ssh/ssh_host_*_key && \
    chmod 644 /etc/ssh/ssh_host_*_key.pub

# 创建.ssh目录并设置权限
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys 2>/dev/null || true

# 复制SSH配置文件
COPY sshd_config /etc/ssh/sshd_config

# 复制 init.sh 脚本
COPY init.sh /root/init.sh
RUN chmod +x /root/init.sh

# 创建示例：如何为自定义服务创建 openrc 脚本
RUN echo '#!/sbin/openrc-run' > /etc/init.d/example-service && \
    echo 'command="/usr/local/bin/example-service"' >> /etc/init.d/example-service && \
    echo 'command_args="--daemon"' >> /etc/init.d/example-service && \
    echo 'pidfile="/var/run/example-service.pid"' >> /etc/init.d/example-service && \
    echo 'description="Example custom service"' >> /etc/init.d/example-service && \
    chmod +x /etc/init.d/example-service

# 暴露 SSH 端口
# EXPOSE 22

# 使用 tini 作为 init 进程，并设置启动命令
# init.sh 总是会被执行，无法被覆盖
ENTRYPOINT ["/sbin/tini", "--", "/root/init.sh"]
