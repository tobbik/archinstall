source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  niri mako xwayland-satellite xdg-desktop-portal-gtk \
  fuzzel swaybg swaylock

AUR_PACKAGES=(
  sfwbar
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/niri"

sed -i ${USERHOME}/.config/niri/config.kdl \
    -e "s|__USERHOME__|${USERHOME}|"
