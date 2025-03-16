source config.sh
source build_aur_pkg.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

pacman -S --needed --noconfirm \
  qt5-webengine qt5-remoteobjects \
  intltool \
  patchelf \
  fltk \
  seatd tllist xcb-util xcb-util-cursor ddcutil \
  xdg-utils libnotify jdk-openjdk

if [ ! -d ${AURBUILDDIR}/osmconvert ]; then
  prepare_aur_pkg       ${USERNAME} ${AURBUILDDIR} osmconvert
  local OLDDIR=$(pwd)
  cd ${AURBUILDDIR}/osmconvert
  OSMCONVSHASUM=$(makepkg -g)
  cd ${OLDDIR}
  sed -i ${AURBUILDDIR}/osmconvert/PKGBUILD \
      -e "s|^sha256sum.*$|${OSMCONVSHASUM}|"
  create_aur_pkg        ${USERNAME} ${AURBUILDDIR} osmconvert
fi

PACKAGES=(
  #osmconvert
  splitter
  mkgmap
  visual-studio-code-bin
  xdiskusage
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
