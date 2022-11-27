# Protobuf 和 GRPC

在 Ubuntu/WSL2/macOS monterey 上安装

目前版本对应：

```
golang version: 1.17.*
protobuf(protoc): v3.19.1
protoc-gen-go: v1.28.0
protoc-gen-go-grpc: v1.2.0
grpc(grpc_php_plugin): v1.41.1
grpc(grpc_python_plugin): v1.41.1

pecl install protobuf@3.19.1
pecl install grpc@1.41.0
```

切记不要随意升级，因为涉及到 client 和 server 代码，单独一端升级，容易导致问题。

## 安装 protobuf

```
cd ~
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protobuf-all-3.19.1.tar.gz
tar zxf protobuf-all-3.19.1.tar.gz
cd protobuf-3.19.1
./configure
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

# 目前应该是3.19版本，当你看到这个时候，请确认自己的版本，主要是保证protobuf的版本和grpc的版本要对应

```

## golang 使用

### 插件安装

```
export GO111MODULE=on  # Enable module mode
# 使用google.golang.org替代
# go install github.com/golang/protobuf/protoc-gen-go
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```

根据.proto 生成对应 golang 文件

```
protoc --go_out=. --go-grpc_out=. protos/lux.proto
```

--go_out 是生成 pb 文件, --go-grpc_out 是生成对应的 grpc 文件，包含 grpc 的 client 和 server

## PHP, python 使用

### 安装 php/python grpc 插件

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
git clone -b v1.41.1 --depth=1 https://github.com/grpc/grpc
cd grpc
git checkout tags/v1.41.1 -b v1.41.1
git submodule update --init  # 这一步有时候需要代理，才能保证下载成功
mkdir -p cmake/build
cd cmake/build
cmake ../..
make grpc_php_plugin
make grpc_python_plugin
make grpc_node_plugin #  不建议，目前 nodejs 支持的方式不再静态支持，更好的使用动态加载的方式
make grpc_csharp_plugin
make grpc_cpp_plugin
```

> 这里其实支持编译 node, csharp, cpp 等插件

`grpc_php_plugin`， `grpc_python_plugin`会生成在当前的`cmake/build`目录下。 迁移到 /usr/local/bin 里面

```
sudo cp grpc_php_plugin /usr/local/bin
sudo cp grpc_python_plugin /usr/local/bin
sudo cp grpc_node_plugin /usr/local/bin
sudo cp grpc_csharp_plugin /usr/local/bin
sudo cp grpc_cpp_plugin /usr/local/bin
```

根据.proto 文件生成 pb 文件和 grpc 客户端文件

```
protoc --proto_path=examples/protos \
  --php_out=examples/php \
  --grpc_out=examples/php \
  --python_out=examples/py \
  --grpc_python_out=examples/py \
  --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin \
  --plugin=protoc-gen-grpc_python=/usr/local/bin/grpc_python_plugin \
  ./examples/protos/helloworld.proto
```

### 项目 web 服务器要安装 grpc 的 php 扩展

```
pecl install protobuf@3.19.1
pecl install grpc@1.41.0
```

然后在 php.ini 里面启用 `extension=protobuf.so`

老版本的情况，可以使用 composer 方式，在项目的根目录（也就是 composer.json)存在的目录

```
composer require google/protobuf@3.19.1 # 可选
composer require grpc/grpc@1.41.0 # 必须有
```

具体参考代码，本文档等待完善

## java 的使用

下载代码

```
cd ~/projects/github.com/grpc
git clone git@github.com:grpc/grpc-java.git
```

切换到我们需要的 tag

```
git checkout tags/v1.41.1 -b v1.41.1
```

编译 java grpc 插件

```
cd compiler
../gradlew -PskipAndroid=true java_pluginExecutable
```

其中 `-PskipAndroid=true` 表示跳过 Android SDK 要求

编译完成后复制二进制文件到`/usr/local/bin`里面

```
sudo cp build/exe/java_plugin/protoc-gen-grpc-java /usr/local/bin
```

根据.proto 文件生成 pb 文件和 grpc 客户端文件

```
protoc --proto_path=examples/protos \
  --php_out=examples/php \
  --grpc_out=examples/php \
  --java_out=examples/java \
  --grpc_java_out=examples/java \
  --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin \
  --plugin=protoc-gen-grpc_java=/usr/local/bin/protoc-gen-grpc-java \
  ./examples/protos/helloworld.proto
```
