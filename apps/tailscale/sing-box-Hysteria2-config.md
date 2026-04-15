# Sing-box / Hysteria2 配置备忘

## 连接

```bash
ssh root@YOUR_SERVER_IP
```

> **安全**：root 密码请勿提交到 Git；优先改用 **SSH 公钥登录** 并关闭密码登录。本文件在仓库中若为未跟踪状态，合并进主分支前请脱敏或加入 `.gitignore`。

---

## 一、Ubuntu 基础优化（摘要）

与仓库内 [`os/ubuntu/ubuntu-base.md`](../os/ubuntu/ubuntu-base.md) 一致，按需执行：

1. **镜像**：将 `archive.ubuntu.com` / `security.ubuntu.com` 换为国内镜像（如中科大），`apt update && apt upgrade -y`。
2. **时区**：`Asia/Shanghai`；安装 `ntpdate` 或启用 `systemd-timesyncd` 校时。
3. **SSH**：`ClientAliveInterval`、`UseDNS no`；确认 `Port` 与防火墙一致。
4. **防火墙**：仅开放必要端口（如 22、以及下文 Sing-box 端口）；可用 `ufw` 或自建 `iptables` 脚本（见 `ubuntu-base.md`）。

可选：仓库 [`os/ubuntu/all-in-one/all-in-one.sh`](../os/ubuntu/all-in-one/all-in-one.sh) 中的分步脚本（镜像、时区、网络、`sshd` 等）可按需选用。

---

## 二、安装 Sing-box

官方文档：[Package Manager](https://sing-box.sagernet.org/installation/package-manager/)

### APT 源安装（推荐，Ubuntu/Debian）

```bash
sudo mkdir -p /etc/apt/keyrings &&
  sudo curl -fsSL https://sing-box.app/gpg.key -o /etc/apt/keyrings/sagernet.asc &&
  sudo chmod a+r /etc/apt/keyrings/sagernet.asc &&
  echo '
Types: deb
URIs: https://deb.sagernet.org/
Suites: *
Components: *
Enabled: yes
Signed-By: /etc/apt/keyrings/sagernet.asc
' | sudo tee /etc/apt/sources.list.d/sagernet.sources &&
  sudo apt-get update &&
  sudo apt-get install -y sing-box
```

或一键脚本（与官方一致）：

```bash
curl -fsSL https://sing-box.app/install.sh | sh
```

安装后常见配置文件路径：`/etc/sing-box/config.json`（若不存在，可从 `/usr/share/doc/sing-box/` 或示例自建）。

校验配置：

```bash
sudo sing-box check -c /etc/sing-box/config.json
```

---

## 三、服务端配置示例（HTTP + SOCKS5 混合入站，需账号密码）

适用于「个人 VPS 上开代理，本机浏览器 / 客户端填服务器 IP + 端口 + 账号密码」。**明文传输**（无 TLS），公网暴露时务必：

- 使用**强密码**，并限制来源 IP（安全组 / `ufw` / `iptables`），或
- 后续改为 **TLS / Reality** 等方案（见 [官方配置](https://sing-box.sagernet.org/configuration/)）。

将下列保存为 `/etc/sing-box/config.json`（**请修改** `listen_port`、`username`、`password`）：

```json
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "::",
      "listen_port": 2080,
      "users": [
        {
          "username": "CHANGE_ME_USER",
          "password": "CHANGE_ME_STRONG_PASSWORD"
        }
      ]
    }
  ],
  "outbounds": [
    { "type": "direct", "tag": "direct" },
    { "type": "block", "tag": "block" }
  ]
}
```

开放防火墙端口（示例端口 `2080`，按你实际修改）：

```bash
# ufw 示例
sudo ufw allow 2080/tcp
sudo ufw reload
```

启用并启动服务：

```bash
sudo systemctl enable sing-box
sudo systemctl restart sing-box
sudo systemctl status sing-box
sudo journalctl -u sing-box -f
```

---

## 四、客户端连接

- **SOCKS5**：服务器 `YOUR_SERVER_IP`，端口 `2080`（与配置一致），用户名/密码与 `users` 中一致。
- **HTTP 代理**：同上主机与端口，代理类型选 HTTP，带用户名密码。

浏览器可用 SwitchyOmega 等；命令行可设置 `ALL_PROXY=socks5://user:pass@YOUR_SERVER_IP:2080`（注意特殊字符需 URL 编码）。

---

## BestTrace（IPIP 17mon 回程）

[IPIP](https://www.ipip.net/) 提供的 Linux 版路由追踪工具，用于从**本机（VPS）向目标 IP** 看回程路径与延迟（与从你家宽 `mtr` 到 VPS 的「去程」方向相反）。

### 安装（本机已部署路径：`/root`）

需 `wget`、`unzip`：

```bash
apt-get update && apt-get install -y wget unzip
cd /root
wget -O besttrace4linux.zip "https://cdn.ipip.net/17mon/besttrace4linux.zip"
unzip -o besttrace4linux.zip
chmod +x /root/besttrace
```

解压后 64 位可执行文件为 **`/root/besttrace`**（同目录还有 `besttrace32`、`besttracearm` 等，按需选用）。说明文本：`besttrace4linux.txt`。

### 基本用法

```text
/root/besttrace <目标主机或 IP> [探测包长度，可选]
```

示例（测试到目标 IP 的回程，将 `TARGET_IP` 换成你要探测的地址）：

```bash
/root/besttrace TARGET_IP
```

每跳只发 1 个探测包（略快，结果波动可能更大）：

```bash
/root/besttrace -q 1 TARGET_IP
```

### 常用参数

| 参数 | 说明 |
|------|------|
| `-g cn` / `-g en` | 界面语言（中文 / 英文） |
| `-q N` | 每跳探测包数量，默认 `3` |
| `-m N` | 最大跳数（TTL 上限），默认 `30` |
| `-w N` | 等待响应秒数，默认 `3` |
| `-n` | 不解析主机名 |
| `-l` | 不显示地理位置映射 |
| `-a` | 不显示 AS 映射 |
| `-T` | 使用 TCP SYN 探测（部分环境比 ICMP 更易通） |
| `-6` | IPv6 |
| `-L` | 查看 LICENSE / token 状态 |
| `-V` | 版本 |

完整帮助：

```bash
/root/besttrace -h
```

### Token / `besttrace.lic`

若启动时提示 **`Token miss`**：基础 traceroute 仍可用；要在输出中显示 IPIP 的线路库信息（ASN、归属地等），需在运行目录或指定位置放置 **`besttrace.lic`** 并写入官方提供的 token，详情见 `/root/besttrace -L` 与包内 `besttrace4linux.txt`。

### 说明

- 途中部分跳显示 `*` 多为中间设备不回应 ICMP 或被限速，属常见情况。
- 二进制来自第三方 CDN，仅作网络诊断；敏感环境请自行校验来源与完整性。

---

## 五、本次部署过程小结

| 项目 | 内容 |
|------|------|
| 系统 | Ubuntu 24.04.4 LTS (GNU/Linux 6.8.0-100-generic x86_64) |
| 基础优化 | 时区：Asia/Shanghai ✓ / 防火墙：ufw ✓（22, 2080） |
| Sing-box 版本 | 1.13.5 |
| 监听 | 地址 `::`，端口 `2080`，协议 mixed（HTTP+SOCKS5） |
| 防火墙 | ufw：22/tcp, 2080/tcp ✓ |
| 验证 | ✅ `systemctl status sing-box` - active (running) |

### 代理账号信息（TLS 版本）

| 配置项 | 值 |
|--------|-----|
| 服务器 | `YOUR_SERVER_DOMAIN`（或 `YOUR_SERVER_IP`） |
| 端口 | 2080 |
| 协议 | HTTP / SOCKS5 (mixed) over TLS |
| 用户名 | singproxy |
| 密码 | （不在本文档；见服务器 `/etc/sing-box/config.json` 或本地已忽略的 Clash 文件） |
| TLS | ✅ 已启用 |
| 证书 | ZeroSSL ECC DV SSL CA 2（有效期至 2026-07-02） |

**⚠️ 安全提醒**：
- ✅ 已启用 TLS 加密传输
- ✅ 使用 ZeroSSL 证书（有效期 90 天）
- 证书自动续期：acme.sh 已配置 Cron Job
- 凭据勿写入 Git；本地完整 Clash 示例可自建 `clash-all-in-one.yaml` 等文件并列入 `.gitignore`

### TLS 证书信息

| 项目 | 内容 |
|------|------|
| 证书类型 | ZeroSSL ECC DV SSL |
| 域名 | `YOUR_SERVER_DOMAIN` |
| 证书路径 | /etc/sing-box/certs/server.crt |
| 私钥路径 | /etc/sing-box/certs/server.key |
| 续期命令 | `~/.acme.sh/acme.sh --renew -d YOUR_SERVER_DOMAIN` |
| 自动续期 | ✅ 已配置 Cron Job |

---

## 七、Hysteria2 配置（适用于 Cursor 等开发工具）

### 服务端配置

**Hysteria2 版本**：v2.8.1

**配置文件**：`/etc/hysteria/config.yaml`

```yaml
auth:
  type: password
  password: <见服务器 /etc/hysteria/config.yaml，勿粘贴到仓库>

tls:
  cert: /etc/sing-box/certs/server.crt
  key: /etc/sing-box/certs/server.key

listen: :8443
```

**服务管理**：
```bash
# 查看状态
systemctl status hysteria

# 启动服务
systemctl start hysteria

# 重启服务
systemctl restart hysteria

# 查看日志
journalctl -u hysteria -f
```

**防火墙**：
```bash
ufw allow 8443/udp
ufw allow 8443/tcp
```

### 代理账号信息（Hysteria2）

| 配置项 | 值 |
|--------|-----|
| 服务器 | `YOUR_SERVER_DOMAIN` |
| 端口 | 8443 |
| 协议 | Hysteria2 (QUIC) |
| 密码 | （不在本文档；见服务器 `/etc/hysteria/config.yaml`） |
| TLS | ✅ 已启用 |

### Clash Verge Hysteria2 配置

配置文件示例：`clash-hysteria2.yaml`（本地自建，勿提交含密码的副本）

```yaml
proxies:
  - name: "hysteria2-tls"
    type: hysteria2
    server: YOUR_SERVER_DOMAIN
    port: 8443
    password: <见服务器 /etc/hysteria/config.yaml>
    skip-cert-verify: false
```

### Hysteria2 优势

- ✅ **极速传输**：基于 QUIC 协议，理论速度可达 1Gbps+
- ✅ **抗干扰强**：UDP 协议，不易被 TCP 阻断
- ✅ **低延迟**：支持 0-RTT 快速连接
- ✅ **智能拥塞控制**：自动适应网络状况
- ✅ **适合开发工具**：Cursor、Git、npm 等更稳定

---

## 六、参考链接

- [sing-box 官方文档](https://sing-box.sagernet.org/)
- [inbound / mixed](https://sing-box.sagernet.org/configuration/inbound/mixed/)
- [systemd 服务说明](https://sing-box.sagernet.org/installation/package-manager/#service-management)
