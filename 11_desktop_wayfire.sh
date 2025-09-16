source config.sh
source helper.sh

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  # portals require pipewire ...
  PORTALPACKAGES="xdg-desktop-portal-gtk"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  PORTALPACKAGES=""
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wlroots0.19 extra-cmake-modules glibmm gtkmm3 \
  doctest doxygen iio-sensor-proxy yyjson boost \
  libdbusmenu-gtk3 nlohmann-json glm \
  scour glib2-devel boost libyaml \
  vulkan-headers ${PORTALPACKAGES}

AUR_PACKAGES=(
  wf-config-git
  wayfire-git
  wf-shell-git
  wayfire-plugins-extra-git
  wcm-git
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/wayfire.ini" ".config/wf-shell.ini"

