#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
test zy ddns python script
@author: Daniel Qin (ysixin@gmail.com)
@since: 2014.01.26
'''
import os
import urllib2
import re
import requests
import time
import datetime

DNSPOD_APIURL = 'https://dnsapi.cn/Record.Modify'
LAST_IP_TMP_FILE = '/home/qinxin/dnspod_ip'


class ZYDDNS:

    def __init__(self):
        self.username = ""
        self.password = ""

        self.domains = [
            ["domain_id", "record_id", "subdomain"],
            ["domain_id", "record_id", "subdomain"],
        ]

    def getLastIp(self):
        if(os.path.exists(LAST_IP_TMP_FILE) == False):
            f1 = open(LAST_IP_TMP_FILE, 'w')
            f1.write("")
            f1.close()

            return ""

        f = open(LAST_IP_TMP_FILE, 'r')
        ip = f.read()
        f.close()
        return ip

    def getCurrentIp(self):
        ip138 = 'http://iframe.ip138.com/ic.asp'
        ip138Content = urllib2.urlopen(ip138).read()
        m = re.search('\[(.*?)\]', ip138Content)
        if m:
            return m.group(1)

        return ""

    def saveCurrentIp(self, ip):
        ip = ip.strip()
        f = open(LAST_IP_TMP_FILE, 'w')
        f.write(ip)
        f.close()

    def date(self, unixtime, format='%Y-%m-%d'):
        d = datetime.datetime.fromtimestamp(unixtime)
        return d.strftime(format)

    def log(self, data):
        currentDate = self.date(time.time())
        filename = '/root/' + currentDate
        f = open(filename, 'a')
        data = currentDate + ':' + data + "\n"
        f.write(data)
        f.close()

    def run(self):
        currentIp = self.getCurrentIp()
        lastIp = self.getLastIp()
        if currentIp == lastIp or currentIp == '':
            data = 'the ip address is same as before, or cannot get ip this time.'
            self.log(data)
            return

        for domain in self.domains:
            result = self.saveRecord(
                domain[0], domain[1], domain[2], currentIp)
            self.log(result)

        self.saveCurrentIp(currentIp)

    def saveRecord(self, domainId, recordId, subDomain, ip=''):
        # "format=json&login_email=$email&login_password=$password
        # &domain_id=$domain_id&record_id=$record_id&sub_domain=$sub_domain&record_line=默认"
        recordData = {
            'format': 'json',
            'login_email': self.username,
            'login_password': self.password,
            'domain_id': domainId,
            'record_id': recordId,
            'sub_domain': subDomain,
            'record_line': '默认',

            # if you use Record.Ddns interface, no need to specify following 4
            # paramters.
            'record_type': 'A',
            'value': ip,
            'mx': 1,
            'ttl': 10
        }

        r = requests.post(DNSPOD_APIURL, data=recordData)
        return r.text

zyddns = ZYDDNS()
zyddns.log('test')
