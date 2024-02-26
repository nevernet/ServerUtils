# acme.sh 安装和使用汇总

## 准备工作, python 环境

```
python -V
```

如果版本号不是 2.7 以上，则直接

```
pyenv global 2.7.13
```

必须先安装 pyenv， 请参考 [python/pyenv.sh](python/pyenv.sh)

## 安装

### 第一步： 创建 ssl 目录:

```
mkdir -p /etc/nginx/vhost/ssl
cd /etc/nginx/vhost/ssl
```

### 第二步： 安装 acme.sh:

因为 certbot-auto 目前不支持 alpine，所以换 acme.sh

acme.sh 官方 github: `https://github.com/Neilpang/acme.sh`

acme.sh 支持单域名和 wildcard（非常爽），并且支持很多 dns api（这里最爽的是支持 dnspod api)

安装

```
apk add openssl
cd ~
git clone --depth=1 https://github.com/acmesh-official/acme.sh.git
git clone --depth=1 https://gitcode.net/mirrors/acmesh-official/acme.sh.git
cd ./acme.sh
./acme.sh --install

cd ~/.acme.sh
echo "export DOH_USE=3" >> acme.sh.env
source ~/acme.sh.env

```

测试: `acme.sh -h`

注册账号：

```
acme.sh --register-account -m my@example.com
```

有时候，我们同一个 dns 下，可能有多个不同的账号，那么解决办法有几种：

- acme.sh 是基于账号的，可以在 linux 下创建多账号，然后分别安装 acme.sh
- 采用 `--config-home` 或者 `--accountconf` 参数来区分不同的账号
- 还有一种 [https://github.com/acmesh-official/acme.sh/wiki/DNS-alias-mode](DNS Alias Mode) 方式，点击链接查看具体详情

这里举例如果采用 `--accountconf` 的方式：

默认的配置文件在 `/root/.acme.sh/account.conf`, 这里我们新建一个配置文件 `/root/.acme.sh/account_dev.example.com.conf` 文件，用来单独存放 `dev.example.com` 的配置。

这里用 dnspod 的 dns 来举例: `vim /root/.acme.sh/account_dev.example.com.conf`，内容如下

```
SAVED_DP_Id='123456'
SAVED_DP_Key='aaabbbcccdddeee'
```

生成 CA

```
/root/.acme.sh/acme.sh --issue --dns dns_dp --accountconf '/root/.acme.sh/account_dev.example.com.conf' --debug -d '*.dev.example.com'
```

zerossl 有时候崩溃，可以切换回 letencrypt

```
acme.sh --set-default-ca --server letsencrypt
```

## 使用

### 域名验证的方式:

```
acme.sh --issue -d example.com -w /home/wwwroot/example.com

# 如果多个域名全部配置到目录: /home/wwwroot/example.com
acme.sh --issue -d example.com -d aaa.com -d bbb.com -w /home/wwwroot/example.com

```

### dns 方式：

> 支持的 dns: https://github.com/Neilpang/acme.sh/wiki/dnsapi

这里我们使用 dnspod 的 api， 所以首先要在 dnspod.cn 官网去申请自己的 appid 和 key。 然后保存在~/.acme.sh/account.conf，下面是 DNSPod.cn 的例子:

```
DP_Id=123456
DP_Key=abcdefghijklmn
```

最新版本需要导出全局变量: `vim ~/.bashrc`

```
export DP_Id="123456"
export DP_Key="abcdefghijklmn"
```

生成 ca:

`acme.sh --issue --dns dns_dp -d example.com -d aaa.com -d bbb.com`

泛域名：

`acme.sh --issue --dns dns_dp -d '*.example.com'`

## 配置 nginx，让 ssl 生效：

```

ssl on;
ssl_certificate /root/.acme.sh/example.com/fullchain.cer;
ssl_certificate_key /root/.acme.sh/example.com/example.com.key;
#如果是泛域名:
ssl_certificate /root/.acme.sh/*.example.com/fullchain.cer;
ssl_certificate_key /root/.acme.sh/*.example.com/*.example.com.key;
```

## 配置 acme.sh 自动更新证书.

默认情况下，在安装 acme.sh 的时候，会自动添加下面的代码到 `/etc/crontabs/root`
如果没有，则通过 `crontab -e` 来添加

```
0 */4 * * * "/root/.acme.sh"/acme.sh --cron --accountconf "/root/.acme.sh/account.conf" --home "/root/.acme.sh" --reloadcmd "rc-se    rvice nginx restart" > /dev/null

15 */4 * * * "/root/.acme.sh"/acme.sh --cron --accountconf "/root/.acme.sh/account_dev.example.com.conf" --home "/root/.acme.sh" --    reloadcmd "rc-service nginx restart" > /dev/null

0 4 * * * "/root/.acme.sh"/acme.sh  --upgrade > /dev/null
```

请注意 `--accountconf`参数，用来指定不同的账号

确保启动的时候启动`crond`进程： `vim ~/init.sh`
`/usr/sbin/crond`

手动更新 ca

```
acme.sh --renew -d example.com  --force --debug
acme.sh --renew --dns dns_dp -d '*.example.com' --force
/root/.acme.sh/acme.sh --renew-all --renew-hook "/etc/init.d/nginx restart"
/root/.acme.sh/acme.sh --renew-all --force --renew-hook "/etc/init.d/nginx restart"
```

指定letencrypt的服务器

```
acme.sh --server letsencrypt --renew --force --dns dns_dp -d '*.example.com' --debug

```

去除某个域名的更新：
`acme.sh --remove -d example.com`

## acme.sh 的升级

`acme.sh --upgrade`
