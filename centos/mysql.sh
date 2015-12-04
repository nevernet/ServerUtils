#!/bin/bash

wget -O mysql-5.7.rpm http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
rpm -ivh msyql-5.7.rpm

mmysql_secure_installation
