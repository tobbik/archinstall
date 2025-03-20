source config.sh
source helper.sh

# base-devel covers automake autoconf flex bison make sudo etc.
pacman -S ${PACMANFLAGS} \
  base-devel bc elfutils gdb valgrind \
  clang clang-analyzer lldb lld \
  tcc pkg-config cmake uasm \
  ocl-icd hyperfine \
  git git-lfs tig wireshark-cli figlet \
  lua lua-socket lua-filesystem luajit \
  go rust meson \
  python3 ipython cython \
  nodejs npm nvm js115 php \
  neovim \
  tree-sitter-bash tree-sitter-python tree-sitter-javascript tree-sitter-rust tree-sitter-query

pacman -Rc --noconfirm vim-runtime

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S ${PACMANFLAGS} \
    pypy pypy3
fi

usermod -a -G git,http,wireshark       ${USERNAME}

# set up .bashrc to invoke nvm properly
if ! grep -q 'init-nvm' /home/${USERNAME}/.bashrc ; then
  cat >> /home/${USERNAME}/.bashrc << EOBASHRC

# initialize node version manager if present
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

EOBASHRC
fi

#set up git
INSTALLERDIR=$(pwd)
cd /home/${USERNAME}
sudo --user ${USERNAME} git config --global user.name   "${GITNAME}"
sudo --user ${USERNAME} git config --global user.email  "${GITEMAIL}"
sudo --user ${USERNAME} git config --global core.editor "/usr/bin/nvim"
sudo --user ${USERNAME} git config --global merge.tool  "/usr/bin/nvim -d"
sudo --user ${USERNAME} git lfs install
cd ${INSTALLERDIR}

add_alias "nv"     "nvim"
add_alias "nvd"    "nvim -d"
add_alias "nvdiff" "nvim -d"

# after removing vim provide aliases
add_alias "vi"     "nvim"
add_alias "vim"    "nvim"

add_dotfiles ".config/nvim" ".vim" ".vimrc"
