# 采用yum安装，版本不一定ok
yum install -y ImageMagick ImageMagick-devel

# install from source
# yum -y groupinstall 'Development Tools'
yum -y install bzip2-devel freetype-devel libjpeg-devel libpng-devel libtiff-devel giflib-devel zlib-devel ghostscript-devel djvulibre-devel libwmf-devel jasper-devel libtool-ltdl-devel libX11-devel libXext-devel libXt-devel lcms-devel libxml2-devel librsvg2-devel OpenEXR-devel

# Imagemagick 7.x版本跟pecl的imagick 3.4.3不兼容
# wget http://www.imagemagick.org/download/ImageMagick.tar.gz
tar xvzf ImageMagick.tar.gz

# 源码安装 6.9.x版本
cd ~
wget https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-60.tar.gz
tar -zxf ImageMagick-6.9.10-60.tar.gz
cd ImageMagick*

./configure
make
make install

# 检查：
convert --version
