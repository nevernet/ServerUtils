# 安装

## 准备
ubuntu 24.04
nodejs >= 22.0.0
MiniMax M2.1 key
telegram bot key 或者 feishu bot key

## 安装
curl -fsSL https://openclaw.ai/install.sh | bash
> 我大概等待了5-10分钟

Updated ~/.openclaw/openclaw.json
Workspace OK: ~/.openclaw/workspace
Sessions OK: ~/.openclaw/agents/main/sessions

Gateway target: ws://127.0.0.1:18789
Source: local loopback
Config: /root/.openclaw/openclaw.json
Bind: loopback

Web UI: http://127.0.0.1:18789/
Web UI (with token): http://127.0.0.1:18789/?token=a2e6a07ff2xxxxxx
Gateway WS: ws://127.0.0.1:18789
Gateway: not detected (gateway closed (1006 abnormal closure (no close frame)): no close reason)
Docs: https://docs.openclaw.ai/web/control-ui

Back up your agent workspace.
Docs: https://docs.openclaw.ai/concepts/agent-workspace

Docs:
https://docs.openclaw.ai/gateway/health
https://docs.openclaw.ai/gateway/troubleshooting

Security
Running agents on your computer is risky — harden your setup:
https://docs.openclaw.ai/security


## 运行
前端运行，可以实时查看错误信息
openclaw gateway

### telegram 配置
vim ~/.openclaw/openclaw.json
找到 channel 配置，在telegram里面输入:
"proxy": "http://127.0.0.1:7890"

openclaw pairing approve telegram <your code>

## 安装pm2
因为容器里面，没有systemctl，用pm2管理
npm install pm2 -g
pm2 start "openclaw gateway" --name openclaw-gateway
pm2 save
pm2 startup