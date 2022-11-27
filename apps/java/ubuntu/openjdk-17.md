# 安装 JDK 17

apt-cache search openjdk-17
apt-get install -y openjdk-17-jdk

# 配置JAVA_HOME
```
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/' >> ~/.bashrc
source ~/.bashrc
echo $JAVA_HOME
```
