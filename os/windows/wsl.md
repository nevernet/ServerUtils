安装中文语言包

`sudo apt install language-pack-zh-hans`

运行 dpkg-reconfigure locales

`sudo dpkg-reconfigure locales`

选择 en_US.UTF-8 和 zh_CN.UTF-8, 选择 zh_CN.UTF-8 为默认语言

安装字体管理工具 fontconfig

`sudo apt install fontconfig`

安装 Windows 字体
创建/etc/fonts/local.conf 文件

```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>/mnt/c/Windows/Fonts</dir>
</fontconfig>
```

或者复制 windows 的字体到/usr/share/fonts/下

`sudo cp -r /mnt/c/Windows/Fonts /usr/share/fonts/windows`

或者安装 ttf-mscorefonts-installer
`sudo apt-get install --reinstall ttf-mscorefonts-installer`

刷新字体缓存

`fc-cache -f -v`

退出重进 wsl

`wsl --shutdown`

附：修改时区命令：

`dpkg-reconfigure tzdata`
