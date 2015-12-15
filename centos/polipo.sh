#!/bin/bash

yum install texinfo -y

git clone https://github.com/jech/polipo.git
cd polipo
make
make install

