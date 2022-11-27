#!/bin/bash
yum install -y ncurses-devel
yum install -y ruby ruby-devel lua lua-devel luajit luajit-devel ctags git python python-devel python3 python3-devel tcl-devel perl perl-devel perl-ExtUtils-ParseXS perl-ExtUtils-XSpp perl-ExtUtils-CBuilder perl-ExtUtils-Embed
yum install -y libX11 libX11-devel libXtst-devl libXtst libXt-devel libXt libSM-devel libSM libXpm libXpm-devel

cd ~
git clone https://github.com/vim/vim.git --depth=1
cd vim
make distclean # 清除上次的configure
./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-perlinterp --enable-luainterp --enable-gui=gtk2 --with-x --enable-cscope --prefix=/usr
make
make install

#cd ~
#git clone https://github.com/spf13/spf13-vim.git --max-depth=1 .spf13-vim-3

#cd ~
#git clone https://github.com/nevernet/spf13-vim-local.git --max-depth=1 .spf13-vim-local

#ln -s ~/.spf13-vim-local/.vimrc.local ~/.vimrc.local
#ln -s ~/.spf13-vim-local/.vimrc.before.fork ~/.vimrc.before.fork
#ln -s ~/.spf13-vim-local/.vimrc.bundles.local ~/.vimrc.bundles.local

#vim +BundleInstall! +BundleClean +q
