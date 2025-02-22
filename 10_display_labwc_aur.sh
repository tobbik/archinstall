source config.sh
source build_aur_pkg.sh

if [ x"${USERNAME}" == "x" ]; then
  USERNAME=tobias
fi
if [ x"${AURBUILDDIR}" == "x" ]; then
  AURBUILDDIR=/home/${USERNAME}/pkgs
fi

pacman -S --needed --noconfirm \
  pipewire-pulse scour ddcutil tllist glib2-devel boost \
  ttf-font gtk4 libadwaita libyaml qt6-base

# needed to build yambar
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 5BBD4992C116573F
# needed for wlr-randr ?
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 0FDE7BE0E88F5E48
#

PACKAGES=(
  labwc-menu-generator-git
  labwc-tweaks-git
  luminance
  tofi
  sfwbar
  yambar
  wlopm
  wlr-which-key
  wlrctl
  wdisplays
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done
