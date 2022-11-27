# alpine 安装 go 编译环境

```
wget https://go.dev/dl/go1.16.13.linux-amd64.tar.gz
tar zxf go1.16.13.linux-amd64.tar.gz
mv go /usr/local/go
```

设置 go 环境变量

```
export GOROOT=/usr/local/go
export GOPATH=/opt/go-modules
export GOPROXY="https://goproxy.cn,direct"
export GOPRIVATE="git.example.com"
export PATH=$PATH:$GOROOT/bin
```

source ~/.bashrc

git 访问GOPRIVATE

```
git config --global url."ssh://git@git.example.com/".insteadOf "https://git.example.com/"
```
这个的前提是ssh方式下必须可以访问git私有仓库


安装编译相关的依赖:

```
apk --no-cache add build-base tzdata ca-certificates libc6-compat libgcc libstdc++
```

libc6-compat libgcc libstdc++ 等是为了支持 CGO 编译

进入项目目录：

```
go mod tidy
CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o build/linux-client
# 或者
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o build/linux-client
```