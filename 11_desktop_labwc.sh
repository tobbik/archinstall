source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  labwc swaylock swayidle swaybg wlsunset gammastep \
  gtklock gtklock-playerctl-module \
  gtklock-powerbar-module gtklock-userinfo-module \
  qt6-base qt6-tools

AUR_PACKAGES=(
  labwc-menu-generator-git
  labwc-tweaks-git
  sfwbar
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/labwc" ".config/sfwbar" \
  ".config/gammastep" \
  ".config/swayidle" ".config/swaylock" ".config/gtklock"

sed -i ${USERHOME}/.config/gammastep/config.ini \
  -e "s:^\(adjustment-method\)=.*$:\1=wayland:"

enable_service gammastep.service ${USERNAME}
