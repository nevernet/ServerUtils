# release 编译
`ionic cordova build android --minifyjs --minifycss --prod --release --device --optimizejs --aot`

> 如果出现Spawn error的时候，可以尝试把platforms/android/gradle* 的执行权限改成755： chmod a+x platforms/android/gradle*。 其实文件就是platforms/android/gradle和platforms/android/gradle.bat

# android的证书
`keytool -genkey -v -keystore myapp.keystore -alias myapp.keystore -keyalg RSA -validity 36500`

> 在执行过程中，会输入密码，一定要记住输入的密码. 最好找文件存储下来

```
-genkey     意味着执行的是生成数字证书操作
-v          表示将生成证书的详细信息打印出来，显示在dos窗口中
-keystore myapp.keystore    表示生成的数字证书的文件名为myapp.keystore（myapp是自己起的名称）
-alias myapp.keystore       表示证书的别名为myapp.keystore，可以不和上面的名称一样
-keyalg RSA     表示生成密钥文件所采用的算法为RSA
-validity 36500     表示该数字证书的有效期为36500天
```

# 签名
## 查看是否签名
`jarsigner -verify demo-unsigned.apk`

## 开始签名
`jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore myapp.keystore -signedjar android-release.apk android-release-unsigned.apk myapp.keystore -storepass password`

```
-verbose    表示将签名过程中的详细信息打印出来，显示在控制台窗口中
-keystore myapp.keystore    表示签名所使用的数字证书所在位置
-signedjar E:\myapp.apk E:\test\platforms\android\build\outputs\apk\android-armv7-release-unsigned.apk  表示给E盘工程目录下的android-armv7-release-unsigned.apk文件签名，签名后的文件为E盘下的myapp.apk
myapp.keystore      表示证书的别名，对应于生成数字证书时-alias参数后面的名称
-storepass 是前面keystore生成时候输入的密码
```

jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore jhc.keystore -signedjar android-release.apk android-release-unsigned.apk jhc.keystore -storepass jhc@123