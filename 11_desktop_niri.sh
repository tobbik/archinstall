source config.sh
source helper.sh

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  # portals require pipewire ...
  PORTALPACKAGES="xdg-desktop-portal-gnome"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  PORTALPACKAGES=""
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  niri mako xwayland-satellite xdg-desktop-portal-gtk \
  fuzzel swaybg swaylock ${PORTALPACKAGES}

AUR_PACKAGES=(
  sfwbar
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/niri"

sed -i ${USERHOME}/.config/niri/config.kdl \
    -e "s|__USERHOME__|${USERHOME}|"
