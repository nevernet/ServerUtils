# 官方升级指南

[https://update.angular.io/](https://update.angular.io/)

1. 先确保本地是最新的 9.0，然后执行

```bash
ng update @angular/core @angular/cli
```

2. 确保本地没有任何错误

```bash
ng build --prod --aot
```

如果编译没有错误，升级完成。 如果有错误，根据实际情况修改即可。
