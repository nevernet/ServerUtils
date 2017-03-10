#!/bin/bash

# for ubuntu
sudo apt-get remove docker docker-engine
sudo apt-get update

# install extra packages
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

# install required packages
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# verify
sudo apt-key fingerprint 0EBFCD88

# add repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install docker-ce

docker version
