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
