# sheldon 安装与配置（替代 oh-my-zsh 插件加载）

[sheldon](https://github.com/rossmacarthur/sheldon) 是 Rust 写的 shell 插件管理器，配置为 TOML，在 `~/.zshrc` 中只需一行 `eval "$(sheldon source)"`。

本文记录：**禁用 oh-my-zsh（不卸载）** + 用 sheldon 加载 zsh 插件的一套固定配置。

**提示符**推荐使用 [Starship](starship.md)（在 `sheldon source` 之后初始化），不再在 sheldon 里挂本地 `PROMPT` 片段。

## 安装

```bash
brew install sheldon
```

确认：

```bash
which sheldon && sheldon --version
```

## 初始化配置目录

首次使用：

```bash
sheldon init --shell zsh
```

配置文件默认在：`~/.config/sheldon/plugins.toml`  
插件与锁文件：`~/.local/share/sheldon/`（含克隆的仓库）

修改 `plugins.toml` 后执行：

```bash
sheldon lock
```

（`eval "$(sheldon source)"` 在锁文件过期时会自动等价于先 lock 再 source，但显式 lock 便于检查错误。）

## 在 ~/.zshrc 中禁用 oh-my-zsh（非卸载）

保留 `~/.oh-my-zsh` 目录不动，仅注释掉原先加载 OMZ 的段落，例如：

```zsh
# ---------------------------------------------------------------------------
# oh-my-zsh 已禁用（未卸载 ~/.oh-my-zsh）。恢复时请取消下面注释并删掉 sheldon 两行。
# ---------------------------------------------------------------------------
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
# plugins=(git)
# source $ZSH/oh-my-zsh.sh

# Shell 插件：https://github.com/rossmacarthur/sheldon
eval "$(sheldon source)"
```

若使用 Starship 作为提示符，在 **`sheldon source` 之后**增加（详见 [starship.md](starship.md)）：

```zsh
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
```

说明：

- 禁用 OMZ 后，**原主题不会加载**；提示符由 Starship 或自建 `PROMPT` 负责。
- `eval "$(sheldon source)"` 建议放在原 OMZ 段的位置附近，保证在用户自定义 `alias` 等之前加载插件（可按个人习惯微调）。

## plugins.toml 结构说明（本套方案）

以下为一组已验证的加载顺序与用途摘要。

| 顺序 | 插件 | 作用 |
|------|------|------|
| 1 | `zsh-users/zsh-completions` | 增加第三方补全的 `fpath` |
| 2 | 内联 `compinit` | 执行 `autoload -Uz compinit` 与 `compinit -i`。原由 `oh-my-zsh.sh` 完成；若缺省，后续 OMZ `git` 插件里的 `compdef` 会报 `command not found` |
| 3 | `ohmyzsh/ohmyzsh` 仅 `plugins/git/git.plugin.zsh` | 等价于原先 `plugins=(git)`，不加载整份 OMZ |
| 4 | `zsh-users/zsh-autosuggestions` | 命令行自动建议 |
| 5 | `zsh-users/zsh-syntax-highlighting` | 语法高亮，**必须放在最后**（官方要求） |

### 完整 plugins.toml 参考

可将下列内容作为 `~/.config/sheldon/plugins.toml` 的起点（路径与仓库以本机为准）：

```toml
# sheldon: https://github.com/rossmacarthur/sheldon

shell = "zsh"

[plugins.zsh-completions]
github = "zsh-users/zsh-completions"

[plugins.compinit]
inline = """
autoload -Uz compinit
compinit -i
"""

[plugins.ohmyzsh-git]
github = "ohmyzsh/ohmyzsh"
use = ["plugins/git/git.plugin.zsh"]

[plugins.zsh-autosuggestions]
github = "zsh-users/zsh-autosuggestions"
use = ["{{ name }}.zsh"]

[plugins.zsh-syntax-highlighting]
github = "zsh-users/zsh-syntax-highlighting"
```

保存后执行：`sheldon lock`。

## 可选：本地 zsh 提示符（不用 Starship 时）

若**不**装 Starship，可在 sheldon 中用 **local 插件目录**挂一段 `prompt.zsh`（用 `vcs_info` + `colors` + `PROMPT_SUBST`），示例见下文。注意：**不要**与 Starship 同时启用。

sheldon 的内联插件字符串会经过模板处理，zsh 的 `PROMPT` 里若含 `}}` 等可能与模板冲突，因此**用 local 插件目录 + 单文件**更稳妥。

目录结构示例：

```text
~/.config/sheldon/snippets/prompt-robbyrussell-like/
└── prompt.zsh
```

`prompt.zsh` 内容示例：

离开 oh-my-zsh 后，原先由 OMZ 提供的 **`colors`（`$fg` / `$fg_bold` 等）不会自动加载**，且 **`PROMPT` 里写 `${vcs_info_msg_0_}` 必须开启 `PROMPT_SUBST`**，否则会把整段提示符当成纯文本打印出来。

```zsh
autoload -Uz colors && colors
setopt PROMPT_SUBST

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:*' enable git
PROMPT='%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%} %{$fg_bold[blue]%}${vcs_info_msg_0_}%{$reset_color%} '
```

并在 `plugins.toml` 的 **syntax-highlighting 之前**加入（且 **不要**在 `~/.zshrc` 里再执行 `starship init`）：

```toml
[plugins.prompt-robbyrussell-like]
local = "~/.config/sheldon/snippets/prompt-robbyrussell-like"
use = ["prompt.zsh"]
```

## 可选：sheldon 自身的 zsh 补全

若需 `sheldon` 命令补全，可从官方文档生成 `_sheldon` 并放入 `$fpath` 中某目录（Homebrew 安装时有时会自带补全，以本机为准）：

```bash
sheldon completions --shell zsh
```

## 恢复使用 oh-my-zsh

1. 在 `~/.zshrc` 中删除或注释 `eval "$(starship init zsh)"`（若已安装 Starship）。
2. 删除或注释 `eval "$(sheldon source)"`。
3. 取消注释原先的 `export ZSH`、`ZSH_THEME`、`plugins`、`source $ZSH/oh-my-zsh.sh`。
4. 新开终端或执行 `exec zsh` 验证。

## 参考链接

- sheldon 仓库：<https://github.com/rossmacarthur/sheldon>
- 同目录 Starship 说明：[starship.md](starship.md)
