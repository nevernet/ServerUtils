# 矫正时间

echo "yes" | cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


# 安装 以下脚本基于 centos 7操作
wget https://install.direct/go.sh
sudo bash go.sh
sudo systemctl start v2ray
sudo systemctl enable v2ray

# macos包下载：
https://github.com/v2ray/v2ray-core/releases

# 服务器配置文件
vim /etc/v2ray/config.json

# 更多配置请参考

https://toutyrater.github.io/advanced/mkcp.html
