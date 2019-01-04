pacman -S --needed --noconfirm \
  clang clang-analyzer make tig gdb valgrind pkg-config linux-headers \
  nginx fcgiwrap git git-lfs wireshark-gtk apache figlet \
  lua lua-socket lua-filesystem luajit \
  mono go rust \
  pypy pypy3 shedskin python3 python2 ipython python-lxml python2-lxml \
  nodejs npm js24 php graphicsmagick \
  gvim geany geany-plugins

usermod -a -G git ${USERNAME}
usermod -a -G postgres ${USERNAME}
usermod -a -G http ${USERNAME}
usermod -a -G wireshark ${USERNAME}

#set up git
git config --global user.name "${GITNAME}"
git config --global user.email "${GITEMAIL}"
git config --global core.editor "/usr/bin/vim"
git config --global merge.tool "/usr/bin/vimdiff"
git lfs install
mv /root/.gitconfig /home/${USERNAME}/
chown ${USERNAME}:users /home/${USERNAME}/.gitconfig
