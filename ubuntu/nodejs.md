# install node 14.x

```
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
```

install dependency

```
sudo apt-get install -y gcc g++ make
sudo apt-get install -y nodejs
```

修改源模式

```
#修改源： 永久模式
npm config set registry https://registry.npm.taobao.org
npm config get registry
npm info express
```
