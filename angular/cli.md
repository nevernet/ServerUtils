# 更新cli

> 请先升级node>=8.x和npm>5.5.x

```bash
npm uninstall -g angular-cli
npm uninstall --save-dev angular-cli
npm cache verify
```

# package.json配置（不定期更新，目前这个版本对应angular 5.0.x 和cli 1.5.x

```json
{
  "name": "xs",
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
    "@angular/animations": "^5.0.0",
    "@angular/common": "^5.0.0",
    "@angular/compiler": "^5.0.0",
    "@angular/core": "^5.0.0",
    "@angular/forms": "^5.0.0",
    "@angular/http": "^5.0.0",
    "@angular/platform-browser": "^5.0.0",
    "@angular/platform-browser-dynamic": "^5.0.0",
    "@angular/router": "^5.0.0",
    "core-js": "^2.4.1",
    "rxjs": "^5.5.2",
    "zone.js": "^0.8.14",
    "ng2-file-upload": "^1.2.1"
  },
  "devDependencies": {
    "@angular/cli": "^1.6.0",
    "@angular/compiler-cli": "^5.0.0",
    "@angular/language-service": "^5.0.0",
    "@types/jasmine": "~2.5.53",
    "@types/jasminewd2": "~2.0.2",
    "@types/node": "~6.0.60",
    "codelyzer": "~3.2.0",
    "jasmine-core": "~2.6.2",
    "jasmine-spec-reporter": "~4.1.0",
    "karma": "~1.7.0",
    "karma-chrome-launcher": "~2.1.1",
    "karma-cli": "~1.0.1",
    "karma-coverage-istanbul-reporter": "^1.2.1",
    "karma-jasmine": "~1.1.0",
    "karma-jasmine-html-reporter": "^0.2.2",
    "protractor": "~5.1.2",
    "ts-node": "~3.2.0",
    "tslint": "~5.7.0",
    "typescript": "^2.6.1"
  }
}


```

> 说明： typescript 本应该对应到2.5.3， 但是我使用了2.6.1.

# 进入项目目录
```bash
rm -rf node_modules dist
npm install --save-dev @angular/cli@latest
npm install
```

> 更多参见：https://github.com/angular/angular-cli