source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  labwc qt6-base qt6-tools

AUR_PACKAGES=(
  labwc-menu-generator-git
  labwc-tweaks-git
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/labwc"

