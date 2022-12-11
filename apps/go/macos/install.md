先官方下载go.dev下载golang 1.17

```
echo 'export GO111MODULE=on' >> ~/.zshrc
echo 'export GOROOT=/usr/local/go/' >> ~/.zshrc
echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.zshrc
echo 'export GOPRIVATE=git.xlab.la' >> ~/.zshrc

echo 'export GOPATH=/Users/qinxin/projects/go-modules' >> ~/.zshrc
echo 'export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"'>> ~/.zshrc
echo 'export GOROOT_BOOTSTRAP=/usr/local/go' >> ~/.zshrc

```