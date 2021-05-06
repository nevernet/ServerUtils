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


# 源码 7.x版本安装 ubuntu
# 依赖安装
sudo apt-get update
sudo apt-get install -y libbz2-dev
sudo apt-get install -y libfreetype-dev
sudo apt-get install -y libjpeg-dev
sudo apt-get install -y libpng-dev
sudo apt-get install -y libtiff-dev
sudo apt-get install -y libgif-dev
sudo apt-get install -y zlib1g-dev
sudo apt-get install -y libdjvulibre-dev
sudo apt-get install -y libwmf-dev
# sudo apt-get install -y libjasper-dev # 暂时没有这个包
sudo apt-get install -y libltdl-dev
sudo apt-get install -y liblcms2-dev
sudo apt-get install -y libxml2-dev
sudo apt-get install -y librsvg2-dev
sudo apt-get install -y libopenexr-dev

git clone https://github.com/ImageMagick/ImageMagick.git ImageMagick-7.0.11
cd ImageMagick-7.0.11
./configure --with-modules
make
sudo make install

# 可选
sudo ldconfig /usr/local/lib

# 测试
convert --version

# 输出
Version: ImageMagick 7.0.11-12 Q16 x86_64 2021-05-04 https://imagemagick.org
Copyright: (C) 1999-2021 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC HDRI Modules OpenMP(4.5)
Delegates (built-in): bzlib djvu fontconfig freetype jbig jng jpeg lcms ltdl lzma openexr png tiff wmf x xml zip zlib
