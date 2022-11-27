在powershell里面执行

```
set-executionpolicy remotesigned -scope currentuser
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
scoop help

scoop search git
scoop install git
```