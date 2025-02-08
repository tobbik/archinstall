source config.sh
source build_aur_pkg.sh

if [ x"${USERNAME}" == "x" ]; then
  USERNAME=tobias
fi
if [ x"${AURBUILDDIR}" == "x" ]; then
  AURBUILDDIR=/home/tobias/aur_pks
fi

pacman -S --needed --noconfirm \
  wlroots extra-cmake-modules qt6-tools glibmm gtkmm3 \
  doctest doxygen iio-sensor-proxy libdbusmenu-gtk3 \
  nlohmann-json glm gobject-introspection libliftoff \
  pipewire-pulse scour ddcutil tllist glib2-devel boost \
  ttf-font gtk4 libadwaita libyaml

# needed to build yambar
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 5BBD4992C116573F
# needed for wlr-randr ?
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 0FDE7BE0E88F5E48
#

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

if [ ! -d ${AURBUILDDIR}/labwc-menu-generator-git ]; then
  prepare_aur_pkg       ${USERNAME} ${AURBUILDDIR} labwc-menu-generator-git
  sed -i ${AURBUILDDIR}/labwc-menu-generator-git/PKGBUILD -e "/^check/,+3 d"
  create_aur_pkg        ${USERNAME} ${AURBUILDDIR} labwc-menu-generator-git
fi

PACKAGES=(
  #wf-config-git
  #wayfire-git
  #wf-shell-git
  wayfire-plugins-extra-git
  wcm-git
  #libsfdo                    # moved to extra
  #labwc                      # moved to extra
  #labwc-menu-generator-git
  labwc-tweaks-git
  luminance
  tofi
  sfwbar
  yambar
  wlopm
  wlr-randr
  wlr-which-key
  wlrctl
  #wdisplays
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done

