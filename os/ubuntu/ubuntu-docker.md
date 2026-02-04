# 容器相关配置

## 创建启动脚本

```bash
chmod +x init.sh
docker cp ./init.sh 容器id:/root/init.sh
docker exec 容器id chmod +x /root/init.sh
```
