source config.sh
source helper.sh
source build_aur_pkg.sh

REMOVABLES=(
  wdisplays       # part of wcm-git
)

for PACKAGE in ${REMOVABLES[@]}; do
  yes | pacman -Rc ${PACKAGE}
  rm -rf ${AURBUILDDIR}/${PACKAGE}
done

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wlroots extra-cmake-modules glibmm gtkmm3 \
  doctest doxygen iio-sensor-proxy \
  libdbusmenu-gtk3 nlohmann-json glm \
  scour glib2-devel boost libyaml \
  ttf-dejavu ttf-dejavu-nerd gtk4 libadwaita

handle_aur_pkg        ${USERNAME} ${AURBUILDDIR} wf-config-git

if [ ! -d ${AURBUILDDIR}/wayfire-git ]; then
  prepare_aur_pkg       ${USERNAME} ${AURBUILDDIR} wayfire-git
  sed -i ${AURBUILDDIR}/wayfire-git/PKGBUILD \
      -e "s: 'wlroots' 'wlr: 'wlroots=0.17' 'wlr:" \
      -e "s: 'wlroots-git'): 'wlroots'\0:"
  pacman -Rdd --noconfirm wlroots
  create_aur_pkg        ${USERNAME} ${AURBUILDDIR} wayfire-git
fi

if [ ! -d ${AURBUILDDIR}/wf-shell-git ]; then
  prepare_aur_pkg       ${USERNAME} ${AURBUILDDIR} wf-shell-git
  sed -i ${AURBUILDDIR}/wf-shell-git/PKGBUILD \
      -e "s:^\(depends=.*\)):\1 libdbusmenu-gtk3):" \
      -e "s:^\(conflicts=.*\)):\1 wdisplays):" \
      -e "s:^\(provides=.*\)):\1 wdisplays):"
  create_aur_pkg        ${USERNAME} ${AURBUILDDIR} wf-shell-git
fi

PACKAGES=(
  wf-config-git
  wayfire-git
  wf-shell-git
  wayfire-plugins-extra-git
  wcm-git
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done

add_dotfiles ".config/wayfire.ini" ".config/wf-shell.ini"

