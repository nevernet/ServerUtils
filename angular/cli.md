# 更新cli

> 请先升级node>=8.x和npm>5.5.x

```bash
npm uninstall -g angular-cli
npm uninstall --save-dev angular-cli
npm cache verify
```

# package.json配置（不定期更新，目前这个版本对应angular 5.2.x 和cli 1.5.x

```json
{
    "name": "admin",
    "version": "0.0.0",
    "license": "MIT",
    "scripts": {
        "ng": "ng",
        "start": "ng serve",
        "build": "ng build",
        "test": "ng test",
        "lint": "ng lint",
        "e2e": "ng e2e"
    },
    "private": true,
    "dependencies": {
        "@angular/animations": "~5.2.9",
        "@angular/common": "~5.2.9",
        "@angular/compiler": "~5.2.9",
        "@angular/compiler-cli": "~5.2.9",
        "@angular/core": "~5.2.9",
        "@angular/forms": "~5.2.9",
        "@angular/http": "~5.2.9",
        "@angular/platform-browser": "~5.2.9",
        "@angular/platform-browser-dynamic": "~5.2.9",
        "@angular/platform-server": "~5.2.9",
        "@angular/router": "~5.2.9",
        "core-js": "~2.4.1",
        "rxjs": "~5.5.6",
        "zone.js": "~0.8.19",

        "echarts": "~3.6.2",
        "jsbarcode": "~3.8.0",
        "ng-zorro-antd": "~0.6.0",
        "ng2-file-upload": "~1.2.1"
    },
    "devDependencies": {
        "@angular/cli": "1.6.5",
        "@angular/compiler-cli": "~5.2.9",
        "@angular/language-service": "~5.2.9",
        "@types/jasmine": "~2.8.3",
        "@types/jasminewd2": "~2.0.2",
        "@types/node": "~6.0.60",
        "codelyzer": "^4.0.1",
        "jasmine-core": "~2.8.0",
        "jasmine-spec-reporter": "~4.2.1",
        "karma": "~2.0.0",
        "karma-chrome-launcher": "~2.2.0",
        "karma-cli": "~1.0.1",
        "karma-coverage-istanbul-reporter": "~1.2.1",
        "karma-jasmine": "~1.1.0",
        "karma-jasmine-html-reporter": "~0.2.2",
        "protractor": "~5.1.2",
        "ts-node": "~4.1.0",
        "tslint": "~5.9.1",
        "typescript": "~2.5.3"
    }
}

```

> 说明： typescript 应该对应到2.5.3.

# 进入项目目录
`ng version`的输出

```
Angular CLI: 1.6.5
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

```bash
rm -rf node_modules dist
npm install --save-dev @angular/cli@latest
npm install
```

> 更多参见：https://github.com/angular/angular-cli