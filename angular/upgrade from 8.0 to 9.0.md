# 官方升级指南

[https://update.angular.io/](https://update.angular.io/)

1. 先确保本地是最新的 8.0

```bash
ng update @angular/cli@8 @angular/core@8
npm install @angular/cli@8 --save-dev
npm update # 升级其他第三方包
```

2. 确保本地没有任何错误

```bash
ng build --prod --aot
```

3. git commit，确保 working tree 是干净的

# 准备升级：

- 升级 node 到 13+
- 删除本地的编译文件

```
rm -rf node_modules dist
rm -rf package-lock.json
```

# 安装最新的 angular cli 版本

```
npm cache clean --force # 强制清除缓存

npm install -g @angular/cli@latest # 如果全局安装过可以不用安装这个

# 在项目的目录内，安装最新的cli版本
npm install @angular/cli@latest --save-dev
```

# 更新 angular/cli

```
ng update @angular/cli
```

# 更新 Angular 核心库, 这个更新，有时候会存在依赖问题， 手动解决

```
ng update @angular/core
```
