source config.sh

# base-devel covers automake autoconf flex bison make sudo etc.
pacman -S --needed --noconfirm \
  base-devel bc elfutils gdb \
  clang clang-analyzer lldb tcc valgrind pkg-config cmake \
  ocl-icd hyperfine \
  nginx fcgiwrap git git-lfs tig wireshark-cli apache figlet \
  lua lua-socket lua-filesystem luajit \
  go rust meson \
  python3 ipython cython \
  nodejs npm js115 php \
  neovim vim

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --noconfirm --needed pypy pypy3
fi

usermod -a -G git,http,wireshark       ${USERNAME}

#set up git
sudo --user ${USERNAME} git config --global user.name   "${GITNAME}"
sudo --user ${USERNAME} git config --global user.email  "${GITEMAIL}"
sudo --user ${USERNAME} git config --global core.editor "/usr/bin/nvim"
sudo --user ${USERNAME} git config --global merge.tool  "/usr/bin/nvim -d"
git lfs install

