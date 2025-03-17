source config.sh
source build_aur_pkg.sh

pacman -S --needed --noconfirm \
  jdk-openjdk

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
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done
