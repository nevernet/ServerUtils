# 更新 cli

> 请先升级 node>=8.x 和 npm>5.5.x

## 先清除全局的 ng cli

```
npm uninstall -g angular-cli
npm cache verify

npm install --g @angular/cli@1.6.8
```

# 创建新项目:

```
ng new angular-demo --style=scss --skip-install
```

# 老项目： 进入项目目录，重新安装项目目录 angular cli

```bash
npm uninstall --save-dev angular-cli
rm -rf node_modules dist

npm install --save-dev @angular/cli@1.6.8
npm install
```

# package.json 配置（不定期更新，目前这个版本对应 angular 5.2.9 和 cli 1.6.8

参见 package.json

> 说明： typescript 应该对应到 2.5.3.

# 进入项目目录

`ng version`的输出

```
Angular CLI: 1.6.8
Node: 8.10.0
OS: darwin x64
Angular: 5.2.9
... animations, common, compiler, compiler-cli, core, forms
... http, language-service, platform-browser
... platform-browser-dynamic, platform-server, router

@angular/cdk: 5.0.1
@angular/cli: 1.6.5
@angular-devkit/build-optimizer: 0.0.42
@angular-devkit/core: 0.0.29
@angular-devkit/schematics: 0.0.52
@ngtools/json-schema: 1.1.0
@ngtools/webpack: 1.9.5
@schematics/angular: 0.1.17
typescript: 2.5.3
webpack: 3.10.0
```

> 更多参见：https://github.com/angular/angular-cli
