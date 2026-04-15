# Headscale 私有部署指南

## 什么是 Headscale

Headscale 是 Tailscale 控制服务器的开源实现，可以自建 Tailscale 私有网络，摆脱官方限制。

## 架构

```
┌─────────────────────────────────────────────────────────┐
│                    Headscale 服务器                       │
│                  (你搭建的 control server)               │
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  用户管理    │  │   ACL 策略   │  │  节点注册   │     │
│  │  (Namespace) │  │  (权限控制)  │  │  (设备认证) │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
         ▲               ▲               ▲
         │               │               │
    ┌────┴────┐    ┌────┴────┐    ┌────┴────┐
    │ 员工 A   │    │ 员工 B   │    │  服务器   │
    │ macOS   │    │  iPhone │    │  (Ubuntu)│
    └─────────┘    └─────────┘    └─────────┘
```

## 环境要求

| 项目 | 要求 |
|------|------|
| 服务器 | 具有公网 IP 的 Linux 服务器（建议 Ubuntu 22.04+） |
| 端口 | 443（HTTPS）、9999（Headscale） |
| 域名 | 建议配置域名（可选） |
| 证书 | 如果用 HTTPS，需要 SSL 证书（可选） |

## 安装 Headscale

### 方式一：二进制安装（推荐）

```bash
# 下载最新版本
curl -fsSL https://github.com/juanfont/headscale/releases/download/v0.22.0/headscale_0.22.0_linux_amd64 -o /usr/local/bin/headscale

# 设置权限
chmod +x /usr/local/bin/headscale

# 创建配置目录
mkdir -p /etc/headscale
```

### 方式二：DEB 包安装

```bash
# 下载 deb 包
wget https://github.com/juanfont/headscale/releases/download/v0.22.0/headscale_0.22.0_linux_amd64.deb

# 安装
sudo dpkg -i headscale_0.22.0_linux_amd64.deb
```

## 配置 Headscale

### 创建配置文件

```bash
sudo vim /etc/headscale/config.yaml
```

```yaml
server_url: https://你的域名或IP:9999

listen_addr: 0.0.0.0:9999

metrics_listen_addr: 0.0.0.0:9090

grpc_listen_addr: 0.0.0.0:50443

grpc_allow_insecure: false

prefixes:
  v4: 100.64.0.0/10
  v6: fd7a:115c:a1e0::/52

derp:
  server:
    enabled: false

tls_letsencrypt:
  hostname: ""
  challenge_type: ""
  listen_port: 80

tls_cert_path: ""
tls_key_path: ""

log:
  format: text
  level: info

dns:
  magic_dns: true
  base_domain: headscale.local
  nameservers:
    - 114.114.114.114
    - 8.8.8.8

unix_socket: /var/run/headscale/headscale.sock

unix_socket_permission: "0770"

logtail:
  enabled: false

randomize_client_port: false
```

### 创建 systemd 服务

```bash
sudo vim /etc/systemd/system/headscale.service
```

```ini
[Unit]
Description=headscale controller
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/headscale serve
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### 启动服务

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now headscale
sudo systemctl status headscale
```

## 配置防火墙

```bash
# Ubuntu
sudo ufw allow 9999/tcp
sudo ufw allow 9999/udp
sudo ufw allow 443/tcp

# 或者 iptables
sudo iptables -A INPUT -p tcp --dport 9999 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 9999 -j ACCEPT
```

---

## 多人使用配置

### 创建用户（Namespace）

```bash
# 创建用户命名空间
headscale users create engineering
headscale users create sales
headscale users create default

# 查看用户列表
headscale users list
```

### 创建注册密钥（Pre-auth Key）

```bash
# 为指定用户创建密钥
headscale preauthkeys create --user engineering --expiration 720h

# 为所有用户创建密钥
headscale preauthkeys create --user default --expiration 720h
```

密钥格式类似：`a2bd538966bbe17fe41ba49f175c50f2d4be33131893bae9`

### 客户端注册

员工在自己的设备上安装 Tailscale，然后使用密钥注册：

```bash
tailscale up --login-server=http://你的服务器IP:9999 --authkey=密钥
```

如果是 HTTPS：

```bash
tailscale up --login-server=https://你的域名:9999 --authkey=密钥
```

---

## ACL 权限控制

### 创建 ACL 策略文件

```bash
sudo vim /etc/headscale/policy.json
```

```json
{
  "tagOwners": {
    "tag:production": ["group:engineering"],
    "tag:staging": ["group:engineering"],
    "tag:office": ["group:engineering"]
  },
  "groups": {
    "group:engineering": ["user1@headscale.local", "user2@headscale.local"],
    "group:sales": ["user3@headscale.local"],
    "group:it": ["admin@headscale.local"]
  },
  "acls": [
    {
      "action": "accept",
      "src": ["group:engineering"],
      "dst": ["tag:production:22", "tag:production:80", "tag:production:443"]
    },
    {
      "action": "accept",
      "src": ["group:engineering"],
      "dst": ["tag:staging:22", "tag:staging:80", "tag:staging:443"]
    },
    {
      "action": "accept",
      "src": ["group:sales"],
      "dst": ["tag:production:80", "tag:production:443"]
    },
    {
      "action": "accept",
      "src": ["group:it"],
      "dst": ["*:*"]
    },
    {
      "action": "accept",
      "src": ["group:engineering"],
      "dst": ["group:engineering:*"]
    }
  ],
  "ssh": [
    {
      "action": "accept",
      "src": ["group:engineering"],
      "dst": ["tag:production"],
      "users": ["root", "ubuntu"]
    }
  ]
}
```

### 应用 ACL 策略

```bash
# 方式一：通过配置文件
sudo vim /etc/headscale/config.yaml

# 添加以下内容
policy:
  mode: file
  path: /etc/headscale/policy.json

# 重启服务
sudo systemctl restart headscale
```

### 常用 ACL 示例

```json
{
  "acls": [
    { "action": "accept", "src": ["*"], "dst": ["*:*"] },
    { "action": "accept", "src": ["group:engineering"], "dst": ["*:22", "*:80", "*:443"] },
    { "action": "accept", "src": ["group:sales"], "dst": ["*:80", "*:443"] },
    { "action": "accept", "src": ["group:engineering"], "dst": ["group:sales"] },
    { "action": "accept", "src": ["group:engineering"], "dst": ["tag:server"] }
  ]
}
```

---

## 客户端配置

### Linux

```bash
# 安装 Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# 连接到 Headscale
tailscale up --login-server=http://你的服务器IP:9999 --authkey=密钥

# 查看状态
tailscale status
```

### macOS

```bash
# 使用 Homebrew
brew install tailscale

# 连接到 Headscale
tailscale up --login-server=http://你的服务器IP:9999 --authkey=密钥
```

### Windows

下载安装后，使用命令行：

```powershell
tailscale.exe up --login-server=http://你的服务器IP:9999 --authkey=密钥
```

### iOS / Android

需要在 Tailscale App 中手动配置服务器地址：

1. 打开 Tailscale
2. 设置 → 登录服务器
3. 输入：`https://你的域名:9999`
4. 使用密钥登录

---

## 常用命令

### 用户管理

```bash
# 创建用户
headscale users create 用户名

# 查看用户列表
headscale users list

# 删除用户
headscale users destroy 用户名
```

### 节点管理

```bash
# 查看节点列表
headscale nodes list

# 删除节点
headscale nodes delete -i 节点ID

# 重命名节点
headscale nodes rename 新名称 -i 节点ID
```

### 密钥管理

```bash
# 创建密钥
headscale preauthkeys create --user 用户名

# 查看密钥
headscale preauthkeys list --user 用户名

# 撤销密钥
headscale preauthkeys revoke --user 用户名 --key 密钥
```

---

## 配置 DERP 中继服务器（可选）

Headscale 内置了 DERP，可以启用：

```yaml
derp:
  server:
    enabled: true
    region_id: 999
    region_code: "self"
    region_name: "Self-hosted"
  urls:
    - https://controlplane.tailscale.com/derpmap/default
  auto_update_enabled: true
  update_frequency: 24h
```

---

## HTTPS 配置（可选）

### 使用自签名证书

```yaml
tls_cert_path: "/etc/headscale/cert.pem"
tls_key_path: "/etc/headscale/key.pem"
```

### 使用 Let's Encrypt

```yaml
tls_letsencrypt:
  hostname: your-domain.com
  challenge_type: HTTP-01
  listen_port: 80
```

---

## 常见问题

### Q: 客户端无法连接

检查：
1. 服务器防火墙是否开放 9999 端口
2. 服务器是否可以访问互联网
3. 密钥是否过期

### Q: 节点之间无法 P2P 通信

确保服务器开启了 NAT 穿透相关端口，或者使用 DERP 中继。

### Q: 如何迁移到新服务器

1. 导出旧服务器数据：`headscale nodes export`
2. 迁移到新服务器
3. 导入数据：`headscale nodes import`
