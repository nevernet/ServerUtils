#!/bin/bash
yum install python-setuptools && easy_install pip
pip install shadowsocks

pip install supervisor

cp supervisord.conf /etc/supervisord.conf
supervisord -c /etc/supervisord.conf
