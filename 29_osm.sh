source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  jdk-openjdk

if [ ! -d ${AURBUILDDIR}/osmconvert ]; then
  aur_prepare_pkg       ${USERNAME} ${AURBUILDDIR} osmconvert
  local OLDDIR=$(pwd)
  cd ${AURBUILDDIR}/osmconvert
  OSMCONVSHASUM=$(makepkg -g)
  cd ${OLDDIR}
  sed -i ${AURBUILDDIR}/osmconvert/PKGBUILD \
      -e "s|^sha256sum.*$|${OSMCONVSHASUM}|"
  aur_create_pkg        ${USERNAME} ${AURBUILDDIR} osmconvert
fi

AUR_PACKAGES=(
  #osmconvert
  splitter
  mkgmap
)

aur_install_packages "${AUR_PACKAGES[@]}"
