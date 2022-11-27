```
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL http://mirrors.tencentyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] http://mirrors.tencentyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce
```
