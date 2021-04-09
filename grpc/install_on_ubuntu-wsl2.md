# Protobuf 和 GRPC

在 Ubuntu 或者 WSL2 上安装

## 安装 protobuf

```
cd ~
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.15.8/protobuf-all-3.15.8.tar.gz
tar zxf protobuf-all-3.15.8.tar.gz
cd protobuf-all-3.15.8
./confirgure
make
sudo make install

# 在.bashrc或者.zshrc里面添加，取决于你的shell环境
export LD_LIBRARY_PATH='/usr/local/lib'
# 重新加载
source ~/.bashrc
# 或者
source ~/.zshrc

# 查看版本
protoc --version

# 目前应该是3.15版本，当你看到这个时候，请确认自己的版本，主要是保证protobuf的版本和grpc的版本要对应

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

> 具体说明在这里： https://github.com/grpc/grpc/tree/master/src/php

想要使用 php grpc 插件，需要满足如下 3 个条件

- protoc: the protobuf compiler binary to generate PHP classes for your messages and service definition.
- protobuf.so: the protobuf extension runtime library.
- grpc_php_plugin: a plugin for protoc to generate the service stub classes.

`protoc`和`protobuf.so`前面已经安装了，这里安装 `grpc_php_plugin` 插件

先安装 `cmake`

```
sudo apt-get install cmake
```

```
git clone -b v1.37.0 https://github.com/grpc/grpc
cd grpc
git submodule update --init  # 这一步有时候需要代理，才能保证下载成功
mkdir -p cmake/build
cd cmake/build
cmake ../..
make grpc_php_plugin
```

`grpc_php_plugin`会生成在当前的`cmake/build`目录下。 迁移到 /usr/local/bin 里面

```
sudo cp grpc_php_plugin /usr/local/bin
```

根据.proto 文件生成 pb 文件和 grpc 客户端文件

```
protoc --proto_path=examples/protos \
  --php_out=examples/php \
  --grpc_out=examples/php \
  --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin \
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
