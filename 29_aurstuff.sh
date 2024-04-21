source config.sh
source build_aur_pkg.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

pacman -S --needed --noconfirm \
  qt5-webengine qt5-remoteobjects \
  intltool \
  patchelf \
  fltk \
  meson scdoc gtk4 qrencode vte3 \
  seatd tllist xcb-util xcb-util-cursor ddcutil \
  rust xdg-utils libnotify jdk-openjdk

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
)

# ... no ARM packages :-(
if [ x$(uname -m) = x"x86_64" ]; then
PACKAGES+=(
  masterpdfeditor
  zoom
  slack-desktop
)
fi

# .. used on the Thinkpad X13s
if [ x$(uname -m) = x"aarch64" ] && [ ! -f /boot/config.txt ] ; then
PACKAGES+=(
  qmic-git
  qrtr-git
  pd-mapper-git
)
fi

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done

# set up .bashrc to invoke nvm properly
if ! grep -q 'init-nvm' /home/${USERNAME}/.bashrc ; then
  cat >> /home/${USERNAME}/.bashrc << EOBASHRC

# initialize node version manager if present
if [ -f  /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi
EOBASHRC
fi
