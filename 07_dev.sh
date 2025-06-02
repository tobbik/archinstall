source config.sh
source helper.sh

pacman -Rc --noconfirm vim-runtime

# base-devel covers automake autoconf flex bison make sudo etc.
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  base-devel bc elfutils gdb valgrind \
  clang clang-analyzer lldb lld \
  tcc pkg-config cmake uasm \
  ocl-icd hyperfine \
  git git-lfs tig wireshark-cli figlet \
  lua lua-socket lua-filesystem luajit \
  go rust meson scdoc \
  python3 ipython cython \
  nodejs npm nvm js128 php \
  tree-sitter-bash  tree-sitter-python \
  tree-sitter-javascript tree-sitter-rust

if [ $(uname -m) == 'x86_64' ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    pypy pypy3
fi

usermod -a -G git,http,wireshark       ${USERNAME}

# set up .bashrc to invoke nvm properly
if ! grep -q 'init-nvm' ${USERHOME}/.bashrc ; then
  cat >> ${USERHOME}/.bashrc << EOBASHRC

# initialize node version manager if present
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

EOBASHRC
fi

sed -i /etc/php/php.ini \
  -e "s:^.*\(zend_extension=opcache\).*$:\1:"

#set up git
INSTALLERDIR=$(pwd)
cd ${USERHOME}
sudo --user ${USERNAME} git config --global user.name   "${GITNAME}"
sudo --user ${USERNAME} git config --global user.email  "${GITEMAIL}"
sudo --user ${USERNAME} git config --global core.editor "/usr/bin/nvim"
sudo --user ${USERNAME} git config --global merge.tool  "/usr/bin/nvim -d"
sudo --user ${USERNAME} git lfs install
cd ${INSTALLERDIR}


# after removing vim provide aliases
add_alias "vi"       "nvim"
add_alias "vim"      "nvim"
add_alias "vimdiff"  "nvim -d"

AUR_PACKAGES=(
  wrk
)

install_aur_packages "${AUR_PACKAGES[@]}"

