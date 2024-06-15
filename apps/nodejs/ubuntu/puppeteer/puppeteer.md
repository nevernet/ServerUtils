# 依赖

## 安装基础依赖
```
apt-get install -y wget gnupg
```

## 安装字体依赖

```
apt-get install -y fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1
```

## 复制 windows 的部分字体到 ubuntu 字体目录

可以参见本目录下的 `fonts` 目录

fonts.tar.gz 在微盘里面，gitlab里面这里放不下

```
scp ~/fonts/fonts.tar.gz xx_server:/root
ssh xx_server:/root
mv fonts.tar.gz /usr/local/share/fonts
cd /usr/local/share/fonts
tar zxf fonts.tar.gz
fc-cache -f -v
```

其他 mkfontscale && mkfontdir 已经废弃了，直接 fc-cache即可

## 安装其他依赖
```
apt-get install -y libnss3-dev libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libcups2-dev libdrm2 libxkbcommon0 gconf-service libasound2 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libgbm1
```

#

官方参考连接
[https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker](https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker)