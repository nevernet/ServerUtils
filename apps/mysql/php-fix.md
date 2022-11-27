如果 php5, php7 等连接不上 mysql8, MySQL8 需要做如下配置：

```
[client]
default-character-set=utf8mb4

[mysql]
default-character-set=utf8mb4

[mysqld]
default-authentication-plugin = mysql_native_password # 启用老版本的密码验证，保证兼容第三方组件和老的5.x的客户端连接
character-set-server=utf8mb4
collation-server = utf8mb4_unicode_ci
```

确保字符集设置和代码里面保持一致。
