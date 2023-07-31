#!/bin/bash

apt-get install -y openssh-server openssh-client
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes # 根据实际情况开启root登录" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
service ssh restart

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N '' -q <<<y > /dev/null 2>&1
