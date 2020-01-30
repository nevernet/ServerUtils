# 准备工作

```
python -V
# 如果版本号不是2.7以上，则直接
pyenv global 2.7.13 # 必须先安装pyenv， 请参考 python/pyenv.sh
```

# 第一步： 创建 ssl 目录:

```
mkdir -p /etc/nginx/vhost/ssl
cd /etc/nginx/vhost/ssl
```

# 第二步： 安装 acme.sh:

因为 certbot-auto 目前不支持 alpine，所以换 acme.sh

acme.sh 官方 github: `https://github.com/Neilpang/acme.sh`

acme.sh 支持单域名和 wildcard（非常爽），并且支持很多 dns api（这里最爽的是支持 dnspod api)

安装

```
cd ~
git clone https://github.com/Neilpang/acme.sh.git
cd ./acme.sh
./acme.sh --install
echo 'alias acme.sh="~/.acme.sh/acme.sh"' >> ~/.bashrc
source .bashrc
```

测试: `acme.sh -h`

# 生成 ca

域名的方式:

```
acme.sh --issue -d example.com -w /home/wwwroot/example.com

# 如果多个域名全部配置到目录: /home/wwwroot/example.com
acme.sh --issue -d example.com -d aaa.com -d bbb.com -w /home/wwwroot/example.com

```

dns 方式：

> 支持的 dns: https://github.com/Neilpang/acme.sh/wiki/dnsapi

这里我们使用 dnspod 的 api， 所以首先要在 dnspod.cn 官网去申请自己的 appid 和 key。 然后保存在~/.acme.sh/account.conf，下面是 DNSPod.cn 的例子:

```
DP_Id=123456
DP_Key=abcdefghijklmn
```

生成 ca:

`acme.sh --issue --dns dns_dp -d example.com -d aaa.com -d bbb.com`

泛域名：

`acme.sh --issue --dns dns_dp -d '*.example.com'`

# 第四部：配置 nginx，让 ssl 生效：

```

ssl on;
ssl_certificate /root/.acme.sh/example.com/fullchain.cer;
ssl_certificate_key /root/.acme.sh/example.com/example.com.key;
#如果是泛域名:
ssl_certificate /root/.acme.sh/*.example.com/fullchain.cer;
ssl_certificate_key /root/.acme.sh/*.example.com/*.example.com.key;
```

# 第五步：配置 acme.sh 自动更新证书.

默认情况下，在安装 acme.sh 的时候，会自动添加下面的代码到 `/etc/crontabs/root`
如果没有，则通过 `crontab -e` 来添加

```
32 0 * * * /root/.acme.sh/acme.sh --cron --home "/root/.acme.sh" --reloadcmd "rc-service nginx reload" > /dev/null
```

确保启动的时候启动`crond`进程： `vim ~/init.sh`
`/usr/sbin/crond`

手动更新 ca

```
acme.sh --renew -d example.com  --force
acme.sh --renew --dns dns_dp -d '*.example.com' --force
```

去除某个域名的更新：
`acme.sh --remove -d example.com`

# acme.sh 的升级

`acme.sh --upgrade`
