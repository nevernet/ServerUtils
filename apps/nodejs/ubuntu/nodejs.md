# install node 14.x

```
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
```

install dependency

```
sudo apt-get install -y gcc g++ make nodejs npm
```

修改源模式

```
#修改源： 永久模式
npm config set registry https://registry.npmmirror.com
npm config get registry
npm info express
```
