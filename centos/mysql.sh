#!/bin/bash

wget -O mysql-5.7.rpm http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
rpm -ivh mysql-5.7.rpm

mysql_secure_installation
