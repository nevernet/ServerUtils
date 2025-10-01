# docker-deamon.json

腾讯云官方地址配置：
https://cloud.tencent.com/document/product/1207/45596

vim /etc/docker/daemon.json

```json
{
    "registry-mirrors": [
        "https://mirror.ccs.tencentyun.com"
    ]
}
```

重启 docker 服务：

```bash
systemctl restart docker
service docker restart
```

查看 docker 服务状态：

```bash
docker info
```