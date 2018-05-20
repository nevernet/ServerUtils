# https://update.angular.io/

```
rm -rf node_modules dist
rm -rf package-lock.json

# 安装最新的angular cli版本
npm install -g @angular/cli@latest
npm install @angular/cli@latest

# 把.angular-cli.json转换成angular.json
ng update @angular/cli

# 这个更新，有时候会存在依赖问题
ng update @angular/core

# 更新rxjs， 会自动更新文件中的引用，但是不全面.
npm install -g rxjs-tslint
rxjs-5-to-6-migrate -p src/tsconfig.app.json
```

# 通过编译命令，发现错误，然后逐一修复

```
ng build --prod --aot
```

# 用 xapi 1.0.7 版本生成最新的 api 文件

# 更新 base-http.ts 和 base-api.ts
