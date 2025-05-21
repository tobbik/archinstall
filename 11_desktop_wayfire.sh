source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wlroots extra-cmake-modules glibmm gtkmm3 \
  doctest doxygen iio-sensor-proxy yyjson boost \
  libdbusmenu-gtk3 nlohmann-json glm \
  scour glib2-devel boost libyaml \
  vulkan-headers

AUR_PACKAGES=(
  wf-config-git
  wayfire-git
  wf-shell-git
  wayfire-plugins-extra-git
  wcm-git
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/wayfire.ini" ".config/wf-shell.ini"

