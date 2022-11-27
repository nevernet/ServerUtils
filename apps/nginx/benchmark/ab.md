ab 是轻量级测试工具

# 安装

```
apt install -y httpd-utils
```

# 使用

```
ab -c 1000 -n 10000 http://127.0.0.1/index.html
```

# 使用post方式

```
vim postfile.txt
# 输入json格式的内容
```


```
ab -c 100 -n 500 -p postfile.txt -T "application/json" -H "auth-token: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ7XCJ1c2V************ql2xSP2QFNRe4yhjQSgDwBmX9HwrJjXIzBOgymfSh4FmiXEA" http://www.example.com/index/init
```