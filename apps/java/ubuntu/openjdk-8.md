# 安装 JDK 8

apt-cache search openjdk-8
apt-get install -y openjdk-8-jdk

# 配置JAVA_HOME
```
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/' >> ~/.bashrc
source ~/.bashrc
echo $JAVA_HOME
```