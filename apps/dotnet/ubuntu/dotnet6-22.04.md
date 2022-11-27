```
cd ~
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb  -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
```

```
sudo touch /etc/apt/preferences
```

添加内容
```
Package: *
Pin: origin "packages.microsoft.com"
Pin-Priority: 1001
```

安装

```
apt-get update && apt-get -y install dotnet-sdk-6.0
```