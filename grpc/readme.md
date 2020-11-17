install protobuf

```
brew install protobuf
# 查看版本
protoc --version
```

install go plunins:

```
export GO111MODULE=on  # Enable module mode
go get -u github.com/golang/protobuf/protoc-gen-go
go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
```

具体参考代码，本文档等待完善
