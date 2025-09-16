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
  labwc qt6-base qt6-tools ${PORTALPACKAGES}

AUR_PACKAGES=(
  labwc-menu-generator-git
  labwc-tweaks-git
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/labwc"

