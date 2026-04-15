# Starship 安装与配置（提示符）

[Starship](https://github.com/starship/starship) 是跨 Shell 的提示符程序，与 [sheldon](sheldon.md) 分工不同：**sheldon 管插件**（补全、高亮、git 别名等），**Starship 只管提示符**。二者可同时使用：先 `eval "$(sheldon source)"`，再 `eval "$(starship init zsh)"`。

## 安装（Homebrew）

```bash
brew install starship
```

确认：

```bash
which starship && starship --version
```

Homebrew 会把 zsh 补全装到 `/opt/homebrew/share/zsh/site-functions`（若该路径已在 `fpath` / 系统默认里，开箱可用）。

## 在 ~/.zshrc 中启用（zsh）

**必须**放在 `eval "$(sheldon source)"` **之后**，否则本地若再通过 sheldon 设置 `PROMPT` 会与 Starship 冲突。

```zsh
eval "$(sheldon source)"

# 提示符：https://github.com/starship/starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
```

新开终端或执行 `exec zsh` 生效。

## 配置文件

主配置路径：

```text
~/.config/starship.toml
```

未创建该文件时，Starship 使用**内置默认**样式。

### 换「整套」样式：官方预设（preset）

`starship preset` **必须带预设名**，不能直接单独运行。

**列出全部预设名：**

```bash
starship preset -l
# 或
starship preset --help
```

（帮助里的 `possible values` 即为可选名称。）

**把某一预设写入配置文件（常用）：**

```bash
# 示例：Tokyo Night 主题
starship preset tokyo-night -o ~/.config/starship.toml
```

其他预设示例（名称与 `starship preset -l` 输出一致）：`pastel-powerline`、`catppuccin-powerline`、`gruvbox-rainbow`、`pure-preset`、`nerd-font-symbols`、`no-nerd-font` 等。

**先看某预设会生成什么配置（打印到终端）：**

```bash
starship preset tokyo-night
```

确认无误后再用 `-o` 写入文件。

### 微调样式：手改 `starship.toml`

预设只是生成一份 TOML。之后可直接编辑 `~/.config/starship.toml`，按模块开关或排序（如 `git`、`directory`、`nodejs`）。字段说明见官方文档：

- 配置说明：<https://starship.rs/config/>

### 其他命令

```bash
# 在编辑器中打开配置文件（依赖 $EDITOR）
starship config

# 解释当前配置里某项的含义（子命令以 --help 为准）
starship explain
```

官方文档：<https://starship.rs/>

## 与 sheldon 里「本地 prompt」二选一

若曾按 [sheldon.md](sheldon.md) 使用 `~/.config/sheldon/snippets/prompt-robbyrussell-like/` 作为提示符，启用 Starship 后应从 `plugins.toml` 中**移除**该插件，只保留 Starship；否则两套提示符会互相覆盖或表现异常。

## 参考链接

- Starship 仓库：<https://github.com/starship/starship>
- 文档站点：<https://starship.rs/>
