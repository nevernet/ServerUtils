找到 pg_hba.conf 路径

运行

```
ps ax | grep postgres | grep -v postgres:
```

得到

```
25653 pts/0    S+     0:00 /usr/lib/postgresql/9.3/bin/psql -h 192.168.10.10 -p 5432 -U postgres -W
26679 ?        S      0:00 /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf
26924 pts/7    R+     0:00 grep --color=auto postgres
```

注意结果中有一个 config_file,而 `config_file=/etc/postgresql/9.3/main/`就是我们配置所在地

无密码 postgres 登录
修改 pg_hba.confg

#原来是

```
host all all 127.0.0.1/32 md5

# IPv6 local connections:

host all all ::1/128 md5 #改成
host all all 127.0.0.1/32 trust

# IPv6 local connections:

host all all ::1/128 md5

```

重启 postgresql 服务

```
sudo service postgresql restart
```

登录

```
psql -h 127.0.0.1 -U postgres
```

登录修改密码
修改密码

```
alter user postgres with password 'YOUR 　 PASSWORD'
```

最后将 pg_hba 修改回去，再重启就好啦
