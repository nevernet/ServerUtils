# https://update.angular.io/

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

# 更新 rxjs， 会自动更新文件中的引用，但是不全面.

```
npm install -g rxjs-tslint
rxjs-5-to-6-migrate -p src/tsconfig.app.json
```

# 根据 angular-demo7, 更新一下文件：

```
package.json
tslint.json
tsconfig.josn
```

# 根据 angular-demo7 更新 angular.json

```
"budgets": [
    {
        "type": "initial",
        "maximumWarning": "2mb",
        "maximumError": "5mb"
    }
]

// projects-><project name> 增加prefix节点
    "prefix": "app",

// <project name>->e2e的root节点修改：
"root": "e2e/",

// 具体位置，请参考angular.json
```

# 通过编译命令，发现错误，然后逐一修复

```
ng build --prod --aot
```

# 用 xapi 1.0.7 版本生成最新的 api 文件

# 更新 base-http.ts 和 base-api.ts

# issue

-   如果碰到 globa.InitPolyfill ... no global , see https://github.com/angular/angular-cli/issues/9920
    解决办法就是吧 polyfill 里面的 import intl 删除

-   Unexpected end of JSON input while parsing near '..."npm":">= 5.5.1"},"\_h', see https://github.com/angular/angular-cli/issues/8572，考虑更换源，或者当前网络不太好。
