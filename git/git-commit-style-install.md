# git commit style 规范化

## 初始化 package.json(非 js 项目）和全局安装

```
npm init
npm install -g commitizen conventional-changelog conventional-changelog-cli conventional-commits-detector conventional-recommended-bump  standard-version
```

## 初始化项目的的 commitizen 信息

```
commitizen init cz-conventional-changelog --save --save-exact
```

之后就可以 在提交的时候就可以使用 git cz 就可以根据提示，生成自动化的 commit message

## 安装 git commit message 的信息验证

### 安装， 在项目的根目录，并且一定是 git 初始化之后的目录

```
npm install husky validate-commit-msg --save-dev
```

### 在 package.json 中添加验证节点：

```
"husky": {
    "hooks": {
      "commit-msg": "validate-commit-msg"
    }
  }
```

## standard-version 配置，在 scripts 里面配置

```
"scripts": {
    "release-f": "standard-version -f",
    "release-major": "standard-version -r major",
    "release-minor": "standard-version -r minor",
    "release-patch": "standard-version -r patch",
    "prerelease-major": "standard-version -p major",
    "prerelease-minor": "standard-version -p minor",
    "prerelease-patch": "standard-version -p patch",
}
```

## 自动生成 CHANGELOG.md，生成之前，都必须增加版本号

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

## 汇总，日常情况下，我们只需要操作

第一次 请执行 `npm run changelog-1`

```
npm run changelog
npm run release-major
npm run release-minor
npm run release-patch
npm run prerelease-major
npm run prerelease-minor
npm run prerelease-patch
```
