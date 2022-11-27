# Apache JMeter

参考：https://octoperf.com/blog/2017/10/12/optimize-jmeter-for-large-scale-tests/
基础用法：https://www.cnblogs.com/stulzq/p/8971531.html

## 下载：

```
https://jmeter.apache.org/download_jmeter.cgi
```

可以下载windows或tgz（Linux）版本。

## 使用：

先根据基础用法，配置好jmx文件。

Windows：

```
.\jmeter -n -t .\art-demo.jmx -l .\report\art-demo.txt -e -o .\report\art-demo-report
```

Linux下：

单个测试

```
mkdir -p report

HEAP="-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m" ./jmeter -n -t ./demo.jmx -l ./report/result.txt -e -o ./report/demo
```

批量脚本：

```
cc=15
api="getdtails"
ct=$(date +"%Y%m%d%H%M%S")

target="demo-$api-${cc}k-$ct"
folder="./report/$target"

rm -rf $folder
mkdir -p $folder
HEAP="-Xms2g -Xmx2g -XX:MaxMetaspaceSize=512m" ./jmeter -n -t ./yg-"$api"-"$cc"k.jmx -l ./report/"$target"/result.txt -e -o $folder

cd ./report
tar czf "$target.tar.gz" $target
```
