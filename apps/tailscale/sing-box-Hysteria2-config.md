# Sing-box / Hysteria2 配置备忘

## 给 Agent 的说明

本文档是 **在目标 Ubuntu 服务器上安装并配置 Sing-box（含可选 Hysteria2）的操作说明**。当 **Agent（自动化助手 / 编程 Agent）** 在上下文中看到本文件且用户意图包含部署、装机或「按文档执行」时，应：

1. **按章节顺序执行**：从 **「一、Ubuntu 基础优化」** 起，根据实际环境**按需选用**小节（不必执行全部可选项），再进入 **「二、安装 Sing-box」**及后续与用户需求相关的章节。
2. **在可登录的宿主机上操作**：默认通过 SSH 在目标机上运行文中的 shell 命令；占位符（如 `YOUR_SERVER_IP`、`YOUR_SERVER_DOMAIN`）须在执行前替换为真实值或向用户确认。
3. **注意安全与不可逆操作**：修改 `sshd_config`、防火墙、`systemd`、证书与代理密码前，确认已备份；勿将真实密码写入仓库；敏感步骤可先说明再执行。
4. **客户端配置**：Clash 等**本机配置**见 **「四、客户端连接」**及 `clash-all-in-one.yaml.template` 说明；若任务仅限于服务端，可跳过客户端章节。
5. **交付物（含客户端时）**：在已填入真实域名、IP、账号密码等内容后，应**输出一份可用于导入 Clash 的成品 YAML**，并命名为 **`{VPS 公网 IPv4}_clash-all-in-one.yaml`**（文件名中的 IP 与点分十进制一致即可，例如 `203.0.113.10_clash-all-in-one.yaml`）。该文件含敏感信息，**不得提交 Git**（见仓库 `.gitignore` 中对 `*_clash-all-in-one.yaml` 的忽略规则）。

人类读者亦可按同一顺序手动操作；Agent 应将本文视为可执行的 **runbook**，而非纯参考文摘。

---

## 连接

```bash
ssh root@YOUR_SERVER_IP
```

> **安全**：root 密码请勿提交到 Git；优先改用 **SSH 公钥登录** 并关闭密码登录。本文件在仓库中若为未跟踪状态，合并进主分支前请脱敏或加入 `.gitignore`。

---

## 一、Ubuntu 基础优化（完整备忘）

说明：以下基础项可在本文独立执行；部署 Sing-box / 防火墙时务必让 **SSH 端口** 与 **ufw / 安全组** 一致。

### 1.1 Shell 别名

```bash
echo 'll="ls -alh"' >> ~/.bashrc
source ~/.bashrc
```

### 1.2 APT 更新与升级

```bash
apt-get update
apt-get upgrade -y
```

### 1.3 Vim

```bash
apt-get install -y vim
echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> ~/.vimrc
echo "set termencoding=utf-8" >> ~/.vimrc
echo "set encoding=utf-8" >> ~/.vimrc
echo "set nu" >> ~/.vimrc
```

（也可用手工编辑 `~/.vimrc`，与上述项相同。）

### 1.4 OpenSSH（sshd）

向 `/etc/ssh/sshd_config` **追加**配置（**重复执行会重复追加**，首次建议先备份该文件）：

```bash
apt-get install -y openssh-server openssh-client
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes # 根据实际情况开启root登录" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
service ssh restart

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N '' -q <<<y >/dev/null 2>&1
```

手工编辑时可直接 `vim /etc/ssh/sshd_config`，重点包括：`Port 22`（或你的端口，须与防火墙一致）、`ClientAliveInterval 60`、`ClientAliveCountMax 3`、`PermitRootLogin`、`UseDNS no`，然后 `service ssh restart` 或 `systemctl restart ssh`。

### 1.5 时区与校时

```bash
apt-get install -y tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 或使用：dpkg-reconfigure tzdata

apt-get install -y ntpdate
ntpdate ntp.sjtu.edu.cn
```

### 1.6 包缓存清理

```bash
apt-get clean
apt-get autoclean
apt-get autoremove --purge
```

可选：再次全量升级并清理缓存：

```bash
apt update
apt upgrade -y
apt-get clean
apt-get autoclean
apt-get autoremove --purge
```

### 1.7 hostname 与 hosts（示例）

```bash
# 示例主机名
echo "ZL-SH-SVR01" > /etc/hostname
hostnamectl set-hostname ZL-SH-SVR01 2>/dev/null || true

grep -q '127.0.0.1 ZL-SH-SVR01' /etc/hosts || echo "127.0.0.1 ZL-SH-SVR01" >> /etc/hosts
```

### 1.8 常用网络工具

```bash
apt-get install -y net-tools iputils-ping telnet
# 可使用：ifconfig -a
```

### 1.9 关闭 rp_filter（多网卡 / 特殊路由场景）

若无 `eth1` 可从循环中去掉；按需执行：

```bash
for ifn in all default eth0 eth1; do echo 0 > /proc/sys/net/ipv4/conf/$ifn/rp_filter; done
sysctl -a | grep rp_filter
```

### 1.10 建议执行顺序

推荐顺序：**apt 更新与升级 → vim → sshd → 时区校时 → 清理**；**1.1**（Shell 别名）可在登录后任选时机执行；**1.7～1.9** 按实际需求追加。

1. **1.2**（`apt update` / `upgrade`）→ **1.3**（vim）→ **1.4**（sshd）→ **1.5**（时区校时）→ **1.6**（清理）  
2. 配置 **ufw**（或与云厂商 **安全组** 一致），仅开放必要端口（如 SSH、2080、8443 等）。

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

- 使用**强密码**，并限制来源 IP（安全组 / `ufw`），或
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

### Clash Verge Rev：使用 `clash-all-in-one` 模板

仓库内提供 **可提交的占位模板**：`/Users/qinxin/workspaces/zl/zl/serverutils/apps/tailscale/clash-all-in-one.yaml.template`（无真实公网 IP、域名或密码；同目录下也可用相对路径 `clash-all-in-one.yaml.template` 打开）。

**成品文件名（Agent / 自动化交付）**：将占位符**全部替换为真实值**后的文件，应保存为 **`{VPS 公网 IPv4}_clash-all-in-one.yaml`**（例如 `203.0.113.10_clash-all-in-one.yaml`），便于按机器区分；与模板同目录或用户指定目录均可。**勿提交此文件**（已列入 `.gitignore`）。

**推荐操作流程：**

1. 以 `clash-all-in-one.yaml.template` 为底稿，另存为上述 **`{IP}_clash-all-in-one.yaml`**，或先复制为 `clash-all-in-one.yaml` 再于完成后重命名（`apps/tailscale/clash-all-in-one.yaml` 亦已在 `.gitignore` 中）。
2. 在成品文件中**全局替换**占位符（与本文服务端一致）：
   - `YOUR_SERVER_DOMAIN`：与 VPS 上 TLS 证书、`sing-box` / Hysteria2 配置的域名一致。
   - `YOUR_SINGBOX_USERNAME`、`YOUR_SINGBOX_PASSWORD`：对应 `/etc/sing-box/config.json` 里 mixed 入站的账号与密码。
   - `YOUR_HYSTERIA2_PASSWORD`：对应 `/etc/hysteria/config.yaml` 里 `auth.password`。
3. 若你常用 **公网 IP** 直连该 VPS，在 `rules` 里找到「自身服务器直连」注释块，**取消注释** `IP-CIDR,.../32` 一行，并把示例地址换成你的公网 IP；仅用域名连接时可保持该行注释。
4. 在 **Clash Verge Rev** 中：新建或导入配置 Profile，指向该 **`{IP}_clash-all-in-one.yaml`**，启用后按需要使用「规则模式」及（可选）TUN；节点与规则已包含 **Sing-box HTTP/TLS（2080）** 与 **Hysteria2（8443）** 两套代理及国内/分流规则。

占位符含义亦写在模板文件头部注释中，可按注释逐项核对。

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
- 凭据勿写入 Git；完整 Clash 以 `clash-all-in-one.yaml.template` 为模板生成 **`{VPS 公网 IP}_clash-all-in-one.yaml`**（见「四、客户端连接」）；`apps/tailscale/*_clash-all-in-one.yaml` 与 `clash-all-in-one.yaml` 已在 `.gitignore`

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

仅 Hysteria2 时可用最小片段；**完整 Sing-box + Hysteria2 + 分流规则**请用上文 **「Clash Verge Rev：使用 clash-all-in-one 模板」** 中的 `clash-all-in-one.yaml.template`。

另可自建 `clash-hysteria2.yaml`（勿提交含密码的副本）：

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
