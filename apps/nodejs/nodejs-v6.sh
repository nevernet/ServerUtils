# install nodejs 6.x

curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -


yum install -y gcc-c++ make
yum install -y nodejs

npm install -g typescript
npm install -g @angular/cli


# 测试
node -v
npm -v
tsc -v
ng help

#修改源： 临时模式
npm --registry https://registry.npm.taobao.org info express

#修改源： 永久模式
npm config set registry https://registry.npm.taobao.org
npm config get registry
npm info express

#cnpm安装
npm install -g cnpm --registry=https://registry.npm.taobao.org

# 源码安装
yum install -y gcc gcc-c++ # 安装依赖
