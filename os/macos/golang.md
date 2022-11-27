先官方下载go.dev下载golang 1.17

```
vim ~/.zshrc

echo 'export GOROOT=/usr/local/go/' >> ~/.zshrc
echo 'export GO111MODULE=on' >> ~/.zshrc
echo 'export GOPRIVATE=git.xlab.la' >> ~/.zshrc
echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.zshrc
```