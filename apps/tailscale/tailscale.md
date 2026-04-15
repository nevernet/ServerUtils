# Tailscale 安装 (Ubuntu 24.04 容器内)

## 什么是 Tailscale

Tailscale 是一个基于 WireGuard 的 Mesh VPN 工具，让多台设备之间建立安全的点对点连接。

### 主要用途

1. **异地组网** - 将分布在不同地区的设备组建成同一个虚拟局域网
2. **内网穿透** - 无需公网 IP 也能访问内网服务
3. **远程办公** - 安全访问公司内网资源
4. **出口节点** - 将特定设备作为网关，让其他设备通过它上网
5. **点对点直连** - 设备之间直接通信，无需经过中转服务器

### 架构原理

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   设备 A    │────▶│  控制服务器  │◀────│   设备 B    │
│ (容器/Ubuntu)│     │ (只用于协商) │     │  (手机/PC)  │
└─────────────┘     └─────────────┘     └─────────────┘
       │                                       │
       │         P2P 直连 (WireGuard)         │
       └───────────────▲─────────────────────┘
                       │
                 NAT 穿透成功
                 直接通信
```

**核心组件：**

| 组件 | 作用 |
|------|------|
| WireGuard | 数据平面，负责加密隧道 |
| DERP 服务器 | 中继服务器，当 P2P 失败时兜底 |
| 控制服务器 | 只负责设备认证和连接协商，不转发流量 |
| 用户空间 wireguard-go | 让 Tailscale 可以在没有内核模块的环境运行 |

**连接流程：**

1. 设备登录 Tailscale 账户，向控制服务器注册身份
2. 控制服务器交换两端的公网 IP、内网 IP、端口信息
3. 设备之间尝试 P2P 直连（NAT 穿透）
4. 穿透成功 → 直接通信，速度快
5. 穿透失败 → 通过 DERP 服务器中转

**NAT 穿透技术：**

Tailscale 使用多种 NAT 穿透技术提高成功率：
- UDP 打洞
- NAT 类型检测
- 端口预测

## 安装 Tailscale

### Linux (Ubuntu 容器内)

```bash
curl -fsSL https://tailscale.com/script/install-key.sh | sh
```

### Windows

下载地址：https://tailscale.com/download/windows

或者使用 winget：

```powershell
winget install tailscale
```

### macOS

下载地址：https://tailscale.com/download/mac

或者使用 Homebrew：

```bash
brew install tailscale
```

或者 Mac App Store 搜索 "Tailscale"。

### iOS

App Store 搜索 "Tailscale" 下载。

### Android

Google Play 搜索 "Tailscale" 下载，或者直接下载 APK：
https://tailscale.com/download/android

## 容器配置

容器需要添加以下参数：

```bash
docker run -d \
  --name your-server \
  --privileged \
  --network host \
  -v /dev/net/tun:/dev/net/tun \
  -v /var/lib/tailscale:/var/lib/tailscale \
  -v /run/tailscale:/run/tailscale \
  your-ubuntu24-image
```

或者使用 capabilities（更安全）：

```bash
docker run -d \
  --name your-server \
  --cap-add NET_ADMIN \
  --cap-add SYS_MODULE \
  --network host \
  -v /dev/net/tun:/dev/net/tun \
  -v /var/lib/tailscale:/var/lib/tailscale \
  your-ubuntu24-image
```

关键点：
- `--network host` - **必须使用主机网络**，否则外网无法直接访问
- `--privileged` 或 `NET_ADMIN` - 需要创建 TUN 设备

## 方式一：使用网桥模式（br30 等自定义网桥）

适用于：容器使用自定义网桥（如 br30），不需要作为出口节点，只是让其他 Tailscale 设备访问容器服务。

### 容器要求

确保容器内有 `/dev/net/tun`：

```bash
docker exec 你的容器名 ls -la /dev/net/tun
```

### 步骤 1：安装 Tailscale

```bash
# 进入容器
docker exec -it 你的容器名 bash

# 安装 Tailscale
curl -fsSL https://tailscale.com/script/install-key.sh | sh
```

### 步骤 2：启动 Tailscale

```bash
# 启动并登录
tailscale up
```

首次执行会输出一个 URL，在**宿主机**或能访问浏览器的设备上打开完成认证。

### 步骤 3：获取容器 Tailscale IP

```bash
tailscale ip -4
```

返回类似：`100.64.x.x`

### 步骤 4：开放宿主机防火墙端口

在**宿主机**上开放 Tailscale 使用的端口：

```bash
sudo ufw allow 41641/udp
sudo ufw allow 41641/tcp
```

或者如果用 iptables：

```bash
sudo iptables -A INPUT -p udp --dport 41641 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 41641 -j ACCEPT
```

### 步骤 5：外网访问

在其他设备（手机、PC）上安装 Tailscale 并登录同一账户，然后直接用容器 IP 访问：

```bash
# 访问容器 SSH
ssh user@100.64.x.x

# 访问容器 HTTP 服务
http://100.64.x.x:8080
```

### 持久化配置（可选）

让容器重启后自动连接：

```bash
# 创建启动脚本
cat > /usr/local/bin/tailscale-start.sh << 'EOF'
#!/bin/bash
tailscale up --accept-dns=false
EOF

chmod +x /usr/local/bin/tailscale-start.sh

# 写入 rc.local 或 bashrc
echo '/usr/local/bin/tailscale-start.sh' >> /etc/bash.bashrc
```

---

## 方式二：使用主机网络（host 模式）

适用于：需要让容器作为**出口节点**，所有设备流量都通过容器转发上网。

### 容器要求

必须使用 `--network host`，并且有 TUN 设备挂载。

### 步骤 1：安装 Tailscale

同方式一：

```bash
docker exec -it 你的容器名 bash
curl -fsSL https://tailscale.com/script/install-key.sh | sh
```

### 步骤 2：配置为出口节点

```bash
tailscale up --advertise-exit-node
```

### 步骤 3：开启 IP 转发

```bash
echo 'net.ipv4.ip_forward=1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding=1' | tee -a /etc/sysctl.conf
sysctl -p
```

### 步骤 4：开放端口

```bash
sudo ufw allow 41641/udp
sudo ufw allow 41641/tcp
```

### 步骤 5：外网访问（作为出口节点）

在其他设备上指定容器作为出口节点：

#### macOS

```bash
sudo tailscale up --exit-node=<容器-Tailscale-IP>
```

#### Linux

```bash
sudo tailscale up --exit-node=<容器-Tailscale-IP>
```

#### Windows

```bash
tailscale.exe up --exit-node=<容器-Tailscale-IP>
```

#### iOS / Android

在 Tailscale App 中选择容器节点，开启 **Use as Exit Node**

### 获取容器 Tailscale IP

```bash
tailscale ip -4
```

### 持久化配置

```bash
cat > /usr/local/bin/tailscale-start.sh << 'EOF'
#!/bin/bash
tailscale up --advertise-exit-node --accept-dns=false
EOF

chmod +x /usr/local/bin/tailscale-start.sh
echo '/usr/local/bin/tailscale-start.sh' >> /etc/bash.bashrc
```

---

## 常用命令

```bash
tailscale status
tailscale ip -4
tailscale logout
tailscale down
```
