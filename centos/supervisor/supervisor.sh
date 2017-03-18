#!/bin/bash
yum install python-setuptools && easy_install pip
pip install supervisor

# prepare the directory which will be used.
mkdir -p /var/run
mkdir -p /var/log/supervisord
mkdir -p /opt/logs/supervisord

cp supervisord.conf /etc/supervisord.conf
supervisord -c /etc/supervisord.conf

# add to auto start when system on
echo 'supervisord -c /etc/supervisord.conf' >> /etc/rc.d/rc.local
