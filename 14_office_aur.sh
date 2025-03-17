source config.sh
source build_aur_pkg.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

pacman -S --needed --noconfirm \
  qt5-webengine qt5-remoteobjects \
  patchelf \
  fltk \
  xcb-util xcb-util-cursor

PACKAGE=(
  xdiskusage
  visual-studio-code-bin
)

# ... no ARM packages :-(
if [ x$(uname -m) = x"x86_64" ]; then
PACKAGES+=(
  masterpdfeditor
  zoom
  slack-desktop
)
fi

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done
