# Protobuf 和 GRPC

安装之前先更新本机的 brew 和 brew 安装的包：

```
brew update
brew upgrade
```

## 安装 protobuf

```
brew install protobuf
# 查看版本
protoc --version

# 目前应该是3.14版本，当你看到这个时候，请确认自己的版本，主要是保证protobuf的版本和grpc的版本要对应

```

## golang 使用

### 插件安装

```
export GO111MODULE=on  # Enable module mode
go get -u github.com/golang/protobuf/protoc-gen-go
go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
```

根据.proto 生成对应 golang 文件

```
protoc --go_out=. --go-grpc_out=. protos/lux.proto
```

--go_out 是生成 pb 文件, --go-grpc_out 是生成对应的 grpc 文件，包含 grpc 的 client 和 server

## PHP 使用

### 安装 php grpc 插件

```
brew upgrade protobuf
# 或者
brew install protobuf

git clone -b v1.34.0 https://github.com/grpc/grpc
cd grpc
git submodule update --init  # 这一步有时候需要代理，才能保证下载成功
make grpc_php_plugin
```

根据.proto 文件生成 pb 文件和 grpc 客户端文件

```
protoc --proto_path=examples/protos \
  --php_out=examples/php \
  --grpc_out=examples/php \
  --plugin=protoc-gen-grpc=/Users/xx/projects/github/grpc/bins/opt/grpc_php_plugin \
  ./examples/protos/helloworld.proto
```

### 项目 web 服务器要安装 grpc 的 php 扩展

```
pecl install protobuf
```

然后在 php.ini 里面启用 `extension=protobuf.so`

老版本的情况，可以使用 composer 方式，在项目的根目录（也就是 composer.json)存在的目录

```
composer require google/protobuf # 可选
composer require grpc/grpc # 必须有
```

具体参考代码，本文档等待完善