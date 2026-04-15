# Kiro CLI：自动补全与行内建议

官方文档：[Completions & autocomplete](https://kiro.dev/docs/cli/autocomplete/)

[Kiro CLI](https://kiro.dev/) 在终端里提供两类 **AI 辅助**（彼此独立，可同时使用）：

| 能力 | 说明 | 典型操作 |
|------|------|----------|
| **下拉补全（Autocomplete dropdown）** | 输入时在光标附近出现**图形菜单**，列出子命令、参数等 | **方向键**选择 → **Tab** 或 **Enter** 确认 |
| **行内建议（Inline suggestions）** | 光标后出现**灰色「幽灵文字」**，预测后续输入 | **右方向键**或 **Tab** 接受；继续打字可忽略 |

支持大量常见工具（如 `git`、`docker`、`npm`、`kubectl` 等），详见官方「Supported tools」章节。

## 行内建议开关

```bash
# 启用
kiro-cli inline enable

# 关闭
kiro-cli inline disable

# 查看状态
kiro-cli inline status
```

进阶（一般可跳过）：

```bash
kiro-cli inline show-customizations
# kiro-cli inline set-customization [ARN]
```

## 下拉补全相关设置

安装 Kiro CLI 后，下拉补全一般会**自动启用**。若需显式控制：

```bash
# 启用下拉补全
kiro-cli settings autocomplete.disable false

# 关闭下拉补全
kiro-cli settings autocomplete.disable true
```

主题（影响下拉 UI 观感）：

```bash
kiro-cli theme dark
kiro-cli theme light
kiro-cli theme system

kiro-cli theme              # 当前主题
kiro-cli theme --list       # 可用主题列表
```

## 使用方式（摘要）

1. **下拉菜单**：照常输入命令；出现菜单后用方向键与 Tab/Enter 选择。  
2. **行内灰色建议**：输入过程中若出现灰色补全，用 **右箭头** 或 **Tab** 采纳，或直接继续输入以忽略。

## 不生效时排查

1. 确认已安装：`kiro-cli --version`  
2. 确认未误关：`kiro-cli settings autocomplete.disable`、`kiro-cli inline status`  
3. **重启终端**或换终端模拟器再试  
4. 若仍异常，可尝试其他 Shell（bash / zsh / fish）以排除兼容问题  

## 与 Shell 集成的关系

若 `~/.zshrc` 中存在 Kiro 注入的 `zshrc.pre.zsh` / `zshrc.post.zsh`（由 Kiro/IDE 环境生成），属于 Shell 侧钩子；**自动补全与行内建议**仍以官方 `kiro-cli` 命令与上述设置为准。以 [官方文档](https://kiro.dev/docs/cli/autocomplete/) 为准。

## 参考链接

- 自动补全与行内建议：<https://kiro.dev/docs/cli/autocomplete/>
