source config.sh

pacman -S --needed --noconfirm \
  clang clang-analyzer tcc make gdb valgrind pkg-config pkgconf cmake \
  bc elfutils flex bison lldb \
  ocl-icd hyperfine \
  nginx fcgiwrap git git-lfs tig wireshark-cli apache figlet \
  lua lua-socket lua-filesystem luajit \
  go rust meson \
  python3 ipython cython \
  nodejs npm js115 php \
  neovim vim

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --noconfirm linux-headers pypy pypy3
elif [ $(uname -m) = 'aarch64' ]; then
  pacman -S --noconfirm linux-aarch64-headers
fi

usermod -a -G git       ${USERNAME}
usermod -a -G http      ${USERNAME}
usermod -a -G wireshark ${USERNAME}

#set up git
sudo --user ${USERNAME} git config --global user.name   "${GITNAME}"
sudo --user ${USERNAME} git config --global user.email  "${GITEMAIL}"
sudo --user ${USERNAME} git config --global core.editor "/usr/bin/nvim"
sudo --user ${USERNAME} git config --global merge.tool  "/usr/bin/nvim -d"
git lfs install

