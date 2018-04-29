# install
`npm install -g nativescript`
`tns --version`
`tns --help`

# create project
`tns create test-demo --ng --appid test.zhiliao.io`

# run
`tns run android`
`tns run ios`


# 其他
```
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

solution:
```
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

> 参考：https://github.com/nodejs/node-gyp/issues/569