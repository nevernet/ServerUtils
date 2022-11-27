# 容器相关配置

## 创建启动脚本

```bash
vim ~/init.sh

# 输入
#!/bin/bash
service ssh restart

while true; do

echo 1
sleep 5s

done

# 修改权限

chmod +x init.sh
```