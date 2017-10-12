pacman -S --needed --noconfirm \
  clang clang-analyzer make tig gdb valgrind pkg-config linux-headers \
  nginx fcgiwrap git wireshark-gtk \
  lua lua-socket lua-filesystem luajit ipython python3 python2 figlet \
  jre8-openjdk-headless mono go rust \
  nodejs npm \
  gvim geany geany-plugins scite

usermod -a -G git ${USERNAME}
usermod -a -G postgres ${USERNAME}
usermod -a -G http ${USERNAME}
usermod -a -G wireshark ${USERNAME}

#set up git
git config --global user.name "${GITNAME}"
git config --global user.email "${GITEMAIL}"
git config --global core.editor "/usr/bin/vim"
git config --global merge.tool "/usr/bin/vimdiff"
mv /root/.gitconfig /home/${USERNAME}/
chown ${USERNAME}:users /home/${USERNAME}/.gitconfig
