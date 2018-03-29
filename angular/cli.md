# 更新cli

> 请先升级node>=8.x和npm>5.5.x

```bash
npm uninstall -g angular-cli
npm uninstall --save-dev angular-cli
npm cache verify
```

# package.json配置（不定期更新，目前这个版本对应angular 5.2.9 和cli 1.6.8
参见package.json
> 说明： typescript 应该对应到2.5.3.

# 重新安装angular cli
```bash
rm -rf node_modules dist
npm install --g @angular/cli@1.6.8
npm install --save-dev @angular/cli@1.6.8
npm install
```

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