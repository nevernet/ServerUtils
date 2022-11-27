#!/bin/bash
iptables -F
iptables -t nat -F
modprobe ip_conntrack_ftp

#### Below are the basal iptables config, normally need not be modified #######
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p udp --source-port 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 60022 -j ACCEPT
iptables -A INPUT -p tcp -s 42.121.13.14 --destination-port 5666 -j ACCEPT
iptables -A INPUT -p udp -s 42.121.13.14 --destination-port 161 -j ACCEPT

##### Below are the Appalication related iptables config #######
iptables -A INPUT -p tcp -s 10.0.0.0/24 -j ACCEPT
iptables -A INPUT -p tcp -s 10.0.1.0/24 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -s 101.227.80.115 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp -s 218.0.0.x --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp -s 222.73.184.166 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 8100 -j ACCEPT
iptables -A INPUT -p tcp --dport 8104 -j ACCEPT

#disable 10.0.1.0 to 10.0.0.0
iptables -A FORWARD -s 10.0.1.0/24 -d 10.0.0.0/24 -j DROP
##### Docker #####
#iptables -t nat -I POSTROUTING -s 0/0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.0.1.0/24 -o em2 -j SNAT --to 101.227.80.115
iptables -t nat -I POSTROUTING -s 10.0.0.0/24 -o em2 -j SNAT --to 101.227.80.115
#########h5dev#####
######center#######
#mysql
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 63306 -j DNAT --to 10.0.1.26:63306
#ssh
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 50022 -j DNAT --to 10.0.1.26:22
#memcached
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 12050 -j DNAT --to 10.0.1.26:12050
#redis
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 15379 -j DNAT --to 10.0.1.26:15379
#authd
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 15000 -j DNAT --to 10.0.1.26:15000
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 15001 -j DNAT --to 10.0.1.26:15001
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 15002 -j DNAT --to 10.0.1.26:15002
#ssl
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 443 -j DNAT --to 10.0.1.26:443
#nsq
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 4250 -j DNAT --to 10.0.1.26:4250
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 4271 -j DNAT --to 10.0.1.26:4271
#callback
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 8888 -j DNAT --to 10.0.1.26:80
#t.dev.hdurl.me
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 18011 -j DNAT --to 10.0.1.26:18011
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 18012 -j DNAT --to 10.0.1.26:18012

iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x --dport 12345 -j DNAT --to 10.0.1.26:12345

#########h5dev#####
#####zhongwei######
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50028 -j DNAT --to 10.0.1.17:22
#####zhijie########
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50029 -j DNAT --to 10.0.1.18:22
#####huangwenai####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50030 -j DNAT --to 10.0.1.27:22
#####guanghei######
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50031 -j DNAT --to 10.0.1.28:22
#####xiaobing######
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50032 -j DNAT --to 10.0.1.29:22
#####qinxin######
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50033 -j DNAT --to 10.0.1.32:22
###################

#########king_dev#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50035 -j DNAT --to 10.0.1.31:22
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 53306 -j DNAT --to 10.0.1.31:63306
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 7000 -j DNAT --to 10.0.1.31:7000

#########king_dev2_heaven#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50036 -j DNAT --to 10.0.1.35:22
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 7002 -j DNAT --to 10.0.1.35:7002

#########xhb-fly-dev#####
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 51022 -j DNAT --to 10.0.1.166:22
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 8101 -j DNAT --to 10.0.1.166:8101
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 4171 -j DNAT --to 10.0.1.166:4171
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 33306 -j DNAT --to 10.0.1.166:63306
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 17390 -j DNAT --to 10.0.1.166:17390
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 17379 -j DNAT --to 10.0.1.166:17379
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 12010 -j DNAT --to 10.0.1.166:12010
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 12030 -j DNAT --to 10.0.1.166:12030
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 19000 -j DNAT --to 10.0.1.166:19000
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 19001 -j DNAT --to 10.0.1.166:19001
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 18000 -j DNAT --to 10.0.1.166:18000
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 18001 -j DNAT --to 10.0.1.166:18001
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 88 -j DNAT --to 10.0.1.166:88
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 89 -j DNAT --to 10.0.1.166:89

#dev-scribe
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 51023 -j DNAT --to 10.0.1.170:22
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 2463 -j DNAT --to 10.0.1.170:2463

#########castle-dev#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50037 -j DNAT --to 10.0.1.36:22
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 43306 -j DNAT --to 10.0.1.36:63306
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 873 -j DNAT --to 10.0.1.36:873

#########answer-dev#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50041 -j DNAT --to 10.0.1.41:22
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 23306 -j DNAT --to 10.0.1.41:63306
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 1873 -j DNAT --to 10.0.1.41:873

#########mongodb-dev01#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50038 -j DNAT --to 10.0.1.38:22
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 27017 -j DNAT --to 10.0.1.38:27017
iptables -t nat -I PREROUTING -p tcp -s 218.0.0.x -i em2 --dport 27018 -j DNAT --to 10.0.1.39:27017

#########wangyuanbo#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50040 -j DNAT --to 10.0.1.40:22
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 3307 -j DNAT --to 10.0.1.40:63306

#########guoyujie#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50016 -j DNAT --to 10.0.1.16:22

#########singer-dev-yetianzi#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50042 -j DNAT --to 10.0.1.42:22
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 7001 -j DNAT --to 10.0.1.42:7001
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 7004 -j DNAT --to 10.0.1.42:7004
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 8009 -j DNAT --to 10.0.1.42:8009
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 13306 -j DNAT --to 10.0.1.42:63306

#########singer#####
iptables -t nat -I PREROUTING -p tcp -i em2 --dport 50043 -j DNAT --to 10.0.1.43:22

iptables -A INPUT -j DROP
