#!/bin/bash

# https://www.linode.com/docs/networking/vpn/secure-communications-with-openvpn-on-centos-6

yum install -y openvpn easy_rsa
cp -R /usr/share/easy-rsa/ /etc/openvpn
