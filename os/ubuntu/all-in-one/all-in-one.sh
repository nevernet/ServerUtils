#!/bin/bash

echo 'll="ls -alh"' >> ~/.bashrc
source ~/.bashrc

ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service

./scripts/change-mirror.sh
./scripts/vim.sh
./scripts/sshd.sh
./scripts/timezone.sh


./scripts/clean.sj