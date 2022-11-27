# 所有项目都会使用该镜像地址：

先清除缓存

```
composer clearcache
rm -rf vendor
```

设置镜像

```
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
```

取消配置：

```
composer config -g --unset repos.packagist
```

# 项目配置

仅修改当前工程配置，仅当前工程可使用该镜像地址：

```
composer config repo.packagist composer https://mirrors.aliyun.com/composer/
```

取消配置：

```
composer config --unset repos.packagist
```

# 调试

composer 命令增加 -vvv 可输出详细的信息，命令如下：

```
composer -vvv require alibabacloud/sdk
```

# 检查全局的 `composer.json`

```
~/.composer/config.json
```

看看是否包含原始的站点， repositories 里面应该只有下面的内容

```
{
  "config": {
    "secure-http": false,
    "github-protocols": ["https", "ssh"]
  },
  "repositories": {
    "packagist": {
      "type": "composer",
      "url": "https://mirrors.aliyun.com/composer/"
    }
  }
}
```

# 安装最新版本的 composer，具体参见 `install-composer.sh`

```
#!/usr/bin/env zsh

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# 安装到 /usr/local/bin/composer
# mv composer.phar /usr/local/bin/composer

```

## composer 国内下载：

```
cd ~
wget https://mirrors.aliyun.com/composer/composer.phar
mv composer.phar /usr/local/bin/composer
```
