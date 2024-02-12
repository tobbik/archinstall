source config.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"
sudo --user ${USERNAME} mkdir -p ${AURBUILDDIR}
cd ${AURBUILDDIR}

pacman -S --needed --noconfirm \
  qt5-webengine \
  intltool \
  patchelf \
  fltk \
  meson scdoc gtk4 qrencode vte3 \
  seatd tllist xcb-util xcb-util-cursor ddcutil \
  rust xdg-utils

PACKAGES=(
  osmconvert
  splitter
  mkgmap
  nvm
  wrk
  visual-studio-code-bin
  xdiskusage
  iwgtk
  neovim-gtk
  #redshift-minimal
)

# wayland related
if pacman -Q wlroots ; then
PACKAGES+=(
  labwc-menu-generator-git
  labwc-tweaks-git
  luminance
  sfwbar
  yambar
  wlopm
  wlr-randr
  wdisplays
)
  # needed to build yambar
  sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 5BBD4992C116573F
  # needed for wlr-randr ?
  #sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 0FDE7BE0E88F5E48
fi

# ... no ARM packages :-(
if [ x$(uname -m) = x"x86_64" ]; then
PACKAGES+=(
  masterpdfeditor
  zoom
  slack-desktop
)
fi

# .. used on the Thinkpad X13s
if [ x$(uname -m) = x"x86_64" ]; then
PACKAGES+=(
  qmic-git
  qrtr-git
  pd-mapper-git
)
fi


for PKG in ${PACKAGES[@]}; do
  echo "_______________################# Creating ${PKG} #######################"
  cd ${AURBUILDDIR}
  curl ${BASEURL}/${PKG}.tar.gz -O && sudo --user ${USERNAME} tar xzf ${PKG}.tar.gz
  rm ${PKG}.tar.gz && cd ${PKG}
  if ! grep -q '^arch.*any' PKGBUILD ; then
    sed -i "s:^\(arch=.*\)):\1 'aarch64'):" PKGBUILD
  fi
  sudo --user ${USERNAME} makepkg
  if grep -q '^arch.*any' PKGBUILD ; then
    pacman -U --needed --noconfirm ${PKG}-*any.pkg.tar.*
  else
    pacman -U --needed --noconfirm ${PKG}-*$(uname -m).pkg.tar.*
  fi
  rm -rf src pkg
done

cd ${OLDDIR}


# set up .bashrc to invoke nvm properly
cat >> /home/${USERNAME}/.bashrc << EOBASHRC

# initialize node version manager if present
if [ -f  /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi
EOBASHRC
