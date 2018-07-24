# 启动 docker

```
docker run --itd --privileged -h mongo --name mongo alpine:v2.1 /bin/bash
docker exec -it xxxxxx /bin/bash

apk update
```

# 下载

cd ~
wget -O mongodb-src-r4.0.0.tar.gz https://fastdl.mongodb.org/src/mongodb-src-r4.0.0.tar.gz?_ga=2.37634976.1266381918.1532313217-1714087571.1532179156
tar zxf mongodb-src-r4.0.0.tar.gz
cd mongodb-src-r4.0.0

apk add python py-pip
pip install typing cheetah pyyaml

apk add scons gcc g++ curl-dev linux-headers openssl-dev
scons all

# 编译不通过，废弃
