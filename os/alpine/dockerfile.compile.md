基于您的 Dockerfile，这里是编译镜像的命令：

## **基本编译命令：**

```bash
# 进入 Dockerfile 所在目录
cd /Users/qinxin/workspaces/zl/zl/serverutils/os/alpine

# 编译镜像（基本命令）
docker build -t alpine:custom .

# 编译镜像（带版本标签）
docker build -t alpine:custom-3.22 .

# 编译镜像（带完整标签）
docker build -t alpine:custom-3.22-latest .
```

## **推荐的编译命令：**

```bash
# 推荐：带版本和描述信息
docker build \
  -f Dockerfile \
  --tag alpine:custom-3.22 \
  --label "version=3.22" \
  --label "build-date=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
  .
```

## **高级编译选项：**

```bash
# 带构建参数和缓存优化
docker build \
  --tag alpine:custom-3.22 \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --progress=plain \
  --no-cache \
  .
```

## **验证编译结果：**

```bash
# 查看编译的镜像
docker images | grep alpine

# 运行容器测试
docker run -d --name test-alpine -p 2222:22 alpine:custom-3.22

# 进入容器验证
docker exec -it test-alpine /bin/bash

# 检查 Alpine 版本
docker exec test-alpine cat /etc/alpine-release

# 清理测试容器
docker rm -f test-alpine
```

## **推送到镜像仓库（可选）：**

```bash
# 标记镜像
docker tag alpine:custom-3.22 your-registry.com/alpine:custom-3.22

# 推送到仓库
docker push your-registry.com/alpine:custom-3.22
```

## **完整的编译和测试流程：**

```bash
# 1. 编译镜像
cd /Users/qinxin/workspaces/zl/zl/serverutils/os/alpine
docker build -t alpine:custom-3.22 .

# 2. 运行容器
docker run -d --name alpine-test -p 2222:22 alpine:custom-3.22

# 3. 验证服务
docker exec alpine-test rc-status
docker exec alpine-test ps aux

# 4. 测试 SSH（如果需要）
ssh root@localhost -p 2222

# 5. 清理
docker rm -f alpine-test
```

**推荐使用第一个基本命令开始：**

```bash
docker build -t alpine:custom-3.22 .
```

这会基于当前的 Alpine 3.22 版本编译一个包含所有配置的自定义基础镜像。
