-   启动 docker

```
docker run --itd --privileged -h mongo --name mongo ubuntu:18.04 /bin/bash
docker exec -it xxxxxx /bin/bash
```

-   依赖

```
apt-get install -y gnupg2
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4


echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
apt-get update
```

-   下载

```
apt-get install -y mongodb-org
```

-   清除

```
apt-get remove -y gnupg2
apt-get autoremove -y
```

-   启动 mongod

```
mkdir -p /var/lib/mongodb/27017
mv /etc/mongod.conf /etc/mongod-27017.conf
/usr/bin/mongod --config /etc/mongod-27017.conf

# 配置参考 https://docs.mongodb.com/manual/reference/configuration-options/
```

-   添加 mongod 到 init.sh

```
vim init.sh

/usr/bin/mongod --config /etc/mongod-27017.conf
```
