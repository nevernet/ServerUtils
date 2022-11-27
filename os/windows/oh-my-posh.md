
参考文档： https://ohmyposh.dev/docs

# 安装
```
scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json

# 获取路径
(Get-Command oh-my-posh).Source

# 得到
C:\Users\never\scoop\apps\oh-my-posh\current\bin\oh-my-posh.exe
```

# 配置到 profile
```
notepad $PROFILE
oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/jandedobbeleer.omp.json | Invoke-Expression

. $PROFILE # 重新 reload
```

# 字体安装 

以管理员身份打开windows terminal
```
oh-my-posh font install
```

选择 `JetBrainsMono` 安装
配置到windows terminal里面

如果无法自动安装，则打开 `https://github.com/ryanoasis/nerd-fonts/releases/tag/v2.2.1` 手动改下载

然后复制到windows fonts目录


# 更新
```
scoop update oh-my-posh
```