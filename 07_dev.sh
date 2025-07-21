source config.sh
source helper.sh

pacman -Rc --noconfirm vim-runtime

# base-devel covers automake autoconf flex bison make sudo etc.
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  base-devel bc elfutils gdb valgrind \
  clang clang-analyzer lldb lld llvm openmp \
  tcc pkg-config cmake uasm \
  ocl-icd hyperfine \
  git git-lfs tig lazygit wireshark-cli figlet \
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

# set up git
INSTALLERDIR=$(pwd)
cd ${USERHOME}
sudo --user ${USERNAME} git config --global user.name   "${GITNAME}"
sudo --user ${USERNAME} git config --global user.email  "${GITEMAIL}"
sudo --user ${USERNAME} git config --global core.editor "/usr/bin/nvim"
sudo --user ${USERNAME} git config --global merge.tool  "/usr/bin/nvim -d"
sudo --user ${USERNAME} git lfs install
cd ${INSTALLERDIR}

# enable php jit by default
sed -i /etc/php/php.ini \
    -e "s/^.*zend_extension.*opcache.*$/zend_extension=opcache/" \
    -e "s/^.*opcache.enable.*$/opcache.enable=1/" \
    -e "s/^.*opcache.enable_cli.*$/opcache.enable_cli=1/" \
    -e "s/^.*opcache.lockfile_path.*$/\0\nopcache.jit_buffer_size=128M\nopcache.jit=tracing\n/"

# after removing vim provide aliases
add_alias "vi"       "nvim"
add_alias "vim"      "nvim"
add_alias "vimdiff"  "nvim -d"

AUR_PACKAGES=(
  wrk
)

install_aur_packages "${AUR_PACKAGES[@]}"

