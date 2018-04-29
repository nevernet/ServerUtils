# 安装

```
yum install python-setuptools && easy_install pip
pip install supervisor
```

# prepare the directory which will be used.

```
mkdir -p /var/run
mkdir -p /var/log/supervisord
mkdir -p /opt/logs/supervisord

cp supervisord.conf /etc/supervisord.conf
/root/.pyenv/shims/supervisord -c /etc/supervisord.conf

```

# add to auto start when system on
`echo 'supervisord -c /etc/supervisord.conf' >> /etc/rc.d/rc.local`


# Supervisord 安装完成后有两个可用的命令行 supervisord 和 supervisorctl，命令使用解释如下：

    * supervisord，初始启动 Supervisord，启动、管理配置中设置的进程。
    * supervisorctl stop programxxx，停止某一个进程(programxxx)，programxxx 为 [program:beepkg] 里配置的值，这个示例就是 beepkg。
    * supervisorctl start programxxx，启动某个进程
    * supervisorctl restart programxxx，重启某个进程
    * supervisorctl stop groupworker: ，重启所有属于名为 groupworker 这个分组的进程(start,restart 同理)
    * supervisorctl stop all，停止全部进程，注：start、restart、stop 都不会载入最新的配置文件。
    * supervisorctl reload，载入最新的配置文件，停止原有进程并按新的配置启动、管理所有进程。
    * supervisorctl update，根据最新的配置文件，启动新配置或有改动的进程，配置没有改动的进程不会受影响而重启。

