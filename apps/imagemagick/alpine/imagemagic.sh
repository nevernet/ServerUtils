# 源码 7.x版本安装 alpine
# 依赖安装
apk update
apk add bzip2-dev
apk add freetype-dev
apk add jpeg-dev
apk add libpng-dev
apk add tiff-dev
apk add giflib-dev
apk add zlib-dev
apk add djvulibre-dev # 3.13开始才有这个包
apk add libwmf-dev
# apk add libjasper-dev # 暂时没有这个包
apk add libltdl libtool
apk add lcms2-dev
apk add libxml2-dev
apk add librsvg-dev
apk add openexr

# 如果无法下载，考虑先下载到本地，再打包上传
git clone https://github.com/ImageMagick/ImageMagick.git ImageMagick-7.0.11
cd ImageMagick-7.0.11
./configure --with-modules
make
make install

# 可选
sudo ldconfig /usr/local/lib

# 测试
convert --version

# 输出
