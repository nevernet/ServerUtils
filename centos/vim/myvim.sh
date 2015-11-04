#!/bin/bash

cd ~
git clone https://github.com/nevernet/spf13-vim-local.git --max-depth=1 .spf13-vim-local

ln -s ~/.spf13-vim-local/.vimrc.local ~/.vimrc.local
ln -s ~/.spf13-vim-local/.vimrc.before.fork ~/.vimrc.before.fork
ln -s ~/.spf13-vim-local/.vimrc.bundles.local ~/.vimrc.bundles.local

# re install plugin
