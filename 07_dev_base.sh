source config.sh

# base-devel covers automake autoconf flex bison make sudo etc.
pacman -S --needed --noconfirm \
  base-devel bc elfutils gdb valgrind \
  clang clang-analyzer lldb lld \
  tcc pkg-config cmake uasm \
  ocl-icd hyperfine \
  nginx fcgiwrap git git-lfs tig wireshark-cli apache figlet \
  lua lua-socket lua-filesystem luajit \
  go rust meson \
  python3 ipython cython \
  nodejs npm js115 php \
  neovim vim \
  tree-sitter-bash tree-sitter-python tree-sitter-javascript tree-sitter-rust tree-sitter-query


if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --noconfirm --needed pypy pypy3
fi

usermod -a -G git,http,wireshark       ${USERNAME}

#set up git
OWD=$(pwd)
cd /home/${USERNAME}
sudo --user ${USERNAME} git config --global user.name   "${GITNAME}"
sudo --user ${USERNAME} git config --global user.email  "${GITEMAIL}"
sudo --user ${USERNAME} git config --global core.editor "/usr/bin/nvim"
sudo --user ${USERNAME} git config --global merge.tool  "/usr/bin/nvim -d"
sudo --user ${USERNAME} git lfs install
cd ${OWD}

if ! grep -q 'alias nv=' /home/${USERNAME}/.bashrc ; then
  echo "alias nv='nvim'"         >> /home/${USERNAME}/.bashrc
  echo "alias nvd='nvim -d'"     >> /home/${USERNAME}/.bashrc
  echo "alias nvdiff='nvim -d'"  >> /home/${USERNAME}/.bashrc
fi
