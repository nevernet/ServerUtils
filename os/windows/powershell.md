```ps
 [Environment]::SetEnvironmentVariable('https_proxy', 'http://127.0.0.1:7073')

 curl -vv https://www.google.com # 测试下载，没问题就ok

```

# 安装

```ps
Install-Module oh-my-posh -Scope CurrentUser -AllowPrerelease

# 修改 $PROFILE

code $PROIFLE

# 添加如下内容

Import-Module oh-my-posh
Set-PoshPrompt -Theme zash

```

官方安装参考：

https://ohmyposh.dev/docs/installation
