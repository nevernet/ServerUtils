# git commit style 规范化

## 1 初始化 package.json(非 js 项目）

```
npm init
```

安装依赖

```
npm install commitizen conventional-changelog conventional-changelog-cli conventional-commits-detector conventional-recommended-bump  standard-version --save-dev
```

### 1.1 初始化项目的的 commitizen 信息

```
commitizen init cz-conventional-changelog --save --save-exact
```

之后就可以 在提交的时候就可以使用 git cz 就可以根据提示，生成自动化的 commit message

## 2 安装 git commit message 的信息验证

### 2.1 安装， 在项目的根目录，并且一定是 git 初始化之后的目录

```
npm install husky validate-commit-msg --save-dev
```

## 3 standard-version 配置，在 scripts 里面配置.

同时复制 `.versionrc.json`到项目里面

```
"scripts": {
    "first": "standard-version -f",
    "major": "standard-version -r major",
    "minor": "standard-version -r minor",
    "patch": "standard-version -r patch",
    "pmajor": "standard-version -p major",
    "pminor": "standard-version -p minor",
    "ppatch": "standard-version -p patch",
}
```

### 3.1 自动生成 CHANGELOG.md，生成之前，都必须增加版本号

```
# 全新生成
conventional-changelog -p angular -i CHANGELOG.md -s -r 0

# 只生成最新的
conventional-changelog -p angular -i CHANGELOG.md -s
```

配置到 `scripts`里面

```
"scripts": {
    "changelog-1": "conventional-changelog -p angular -i CHANGELOG.md -s -r 0",
    "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s",
}
```

## 4 汇总，日常情况下，我们只需要操作

第一次 请执行 `npm run changelog-1`

```
npm run changelog
npm run major
npm run minor
npm run patch
npm run pmajor
npm run pminor
npm run ppatch
```
