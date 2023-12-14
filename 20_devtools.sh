source config.sh

pacman -S --needed --noconfirm \
  clang clang-analyzer tcc make gdb valgrind pkg-config cmake \
  linux-headers ocl-icd \
  nginx fcgiwrap git git-lfs tig wireshark-qt apache figlet \
  lua lua-socket lua-filesystem luajit \
  go rust \
  pypy pypy3 python3 ipython \
  nodejs npm js115 php graphicsmagick imagemagick ghostscript \
  gvim geany geany-plugins scite neovim neovide \
  openconnect openvpn

usermod -a -G git ${USERNAME}
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

# set up .bashrc with some aliases
cat >> /home/${USERNAME}/.bashrc << EOBASHRC

# initialize node version manager if present
if [ -f  /usr/share/nvm/init-nvm.sh ]; then
	source /usr/share/nvm/init-nvm.sh
fi
EOBASHRC
